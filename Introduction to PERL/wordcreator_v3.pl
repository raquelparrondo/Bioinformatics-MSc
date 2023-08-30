#!/usr/bin/perl
#
# USAGE: worderator.pl inputfile.tbl
#
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
use Getopt::Std; 

#
## VARS section

my $USAGE = <<'EOF';
USAGE:

	wordcreator.pl [options] inputfile.tbl

DESCRIPTION:

	Loads pairs of words in order to reconstruct sentences, 
	based on a graph.
	
OPTIONS:

	-v 
	  Be verbose, send run messages to STDERR.
	-d 
	  Set debug flag.
	-h
	  Print this help message...
		
BLAH, BLAH, BLAH...
EOF

# Checking from command-line switches, using the unix-like one-letter code "-h"
# Getop::Std now requires "our" intead of "my"
# to declare the variables that will be linked to commmand-line switches
our ($opt_v, $opt_h, $opt_d) = (0,0,0); 
getopts("vhd");
	# set the values for $opt_v, $opt_h, $opt_d
$opt_h && 
	die($USAGE);

# "global" vars for the script
my %pairs = ();
my %sriap = ();
my @timestamp = new Benchmark;

# start program by reading and checking
# arguments provided by user at command-line
scalar(@ARGV) == 1 ||
    die("### ARGV ERROR ###\n\n".$USAGE); # reusing help text from $USAGE

print STDERR "# Input file is: $ARGV[0]\n" if $opt_v;

# reading arguments
my $inputfile = shift @ARGV;

# other vars
my $fileprefix = $inputfile;
$fileprefix =~ s/\.tbl$//;

print STDERR "# Output files prefix is: $fileprefix\n" if $opt_v;

#
## MAIN PROGRAM
#

print STDERR "## Running $0 -- $ENV{USER} -- PID $$\n" if $opt_v;

#
# STEP 1.- Reading the pairs form a file into a graph.
#          We will use a hash to build the graph data structure.

if (-e $inputfile) {
    print STDERR "$inputfile is there!!!\n" if $opt_v;
} else {
    print STDERR "### ERROR ### $inputfile NOT FOUND!!!\n" if $opt_v;
    exit(1);
};

open(WORDS, $inputfile) ||
    die("### ERROR ### Cannot open file $inputfile\n");

print STDERR "## Reading data from $inputfile\n" if $opt_v;

my @words;
while (<WORDS>) {
    # when using diamond operator, lines are stored
    # in the anonymous scalar variable $_

    chomp;                     # 'enough power\n' -> 'enough power'
    @words = split /\s+/, $_;  # 'enough power'   -> ( 'enough', 'power' )
    
    print STDERR "$. : $words[0] -> $words[1]\n" if $opt_v;
    
    # this is an example of autovivification
    $pairs{$words[0]}{$words[1]}++; # this is the parents to childs hash
    ## above command is equivalent to:
    # exists($pairs{$words[0]}) || ($pairs{$words[0]} = {});
    # exists($pairs{$words[0]}{$words[1]}) || ($pairs{$words[0]}{$words[1]} = 0);
    # $pairs{$words[0]}{$words[1]}++;
    
    $sriap{$words[1]}{$words[0]}++; # this is the childs to parents hash

}; # while WORDS

close(WORDS);

print STDERR Data::Dumper->Dump([ \%pairs, \%sriap ],
								[ qw/ *PARENTS *CHILDS / ]),
								"\n" if $opt_d; # now we have a debug "-d" command-line switch

#
# STEP 2.- Processing the graph (hash-based data structure)

#
# Saving word pairs relations as a graph
# we will use the DOT language notation
# as defined by the GraphViz project:
#    https://graphviz.org/documentation/
#

my $dotfile = $fileprefix . ".dot";

print STDERR "# Saving word pairs as graph elements into dot file $dotfile\n" 
			if $opt_v;

open(DOTFILE, "> $dotfile") ||
    die("### ERROR ### Cannot open dot file: $dotfile\n");

print DOTFILE "digraph G {\n".
              "\tnode [ style=filled fillcolor=\"white\" ];\n";

my %colored = ();
my $p = 0;
foreach my $parent (keys %pairs) { 
	
	foreach my $child (keys %{ $pairs{$parent} } ) { 
		
		if (($parent =~ /^\./ || $parent =~ /\.\.\.$/)
			&& !exists($colored{$parent})) {
				$colored{$parent} = 1;
				print DOTFILE "\t\"$parent\" [fillcolor=\"darkolivegreen1\"];\n";
		};
		if (($child =~ /^\./ || $child =~ /\.\.\.$/ || $child =~ /\.\.\.\.$/)
			&& !exists($colored{$child})) {
				$colored{$child} = 1;
				print DOTFILE "\t\"$child\" [fillcolor=\"darkolivegreen1\"];\n";
		};
		if (($pairs{$parent} =~ /^\./ || $pairs{$parent} =~ /\.\.\.$/)
			&& !exists($colored{$pairs{$parent}})) {
				$colored{$pairs{$parent}} = 1;
				print DOTFILE "\t\"$child\" [fillcolor=\"darkolivegreen1\"];\n";
		};
		if ($parent =~ /[^\.]\.\.$/
			&& !exists($colored{$parent})) {
				$colored{$parent} = 1;
				print DOTFILE "\t\"$parent\" [fillcolor=\"palegoldenrod\"];\n";
		};

		# printing the edge relationship (now labeled)
		print DOTFILE "\t\"$parent\" -> \"$child\" [label=\"".++$p."\"]\n";
		
	}; # foreach $child
    
}; # foreach $parent

print DOTFILE "}\n";

close(DOTFILE);

#
# STEP 3.- Run another tool to plot the graph

#
# Now, we are going to run the command-line program
# from the GraphViz distribution to convert
# the dot file in a graphical representation
# of the pairs of words graph as a PNG image.
#
# If you do not have graphviz installed
# you can run this on Linux:
#
#    sudo apt-get install graphviz
#
# Or the following on a MacOS with brew:
#
#    brew install graphviz
# 
# Further details to install from source
# or other into systems can be found at:
#    https://graphviz.org/download/
#
# On the command-line, one should run something like this:
#
#   dot -v -Tpng pairs_of_words_short.dot \
#              > pairs_of_words_short.png
#
# In Perl we can run other programs with system function...

print STDERR "# Drawing graph structure with GraphViz dot\n" if $opt_v;

system("dot -v -Tpng $dotfile " .
                  "> $fileprefix.png " .
                 "2> $dotfile.log");
    
#
# STEP 4.- Look for topmost paraents in the graph
#

print STDERR "# Looking for topmost parents\n" if $opt_v;

my $topmostparentsfile = "$fileprefix.parents.tbl";

my @topmostparents = ();

foreach my $child (keys %sriap) {
	
	foreach my $parents (keys %{ $sriap{$child} }) {
		
		exists($sriap{$parents}) || do {
			# if parent is not child is topmost one
			push @topmostparents, $parents;
		};
	
	}; # foreach $parents
	
}; # foreach $child

open(TOPPARENT, "> $topmostparentsfile") ||
	die("### ERROR ### Cannot open topmost parents file: $topmostparentsfile\n");
print TOPPARENT join ("\n", @topmostparents), "\n";
close(TOPPARENT);

#
# STEP 5.- Reconstruct sentences form paths in the graph,
#		   starting from parentmost nodes

foreach my $word (@topmostparents) {
	
	my @nodes = ();
	my $lvl = 0;
	
	&get_word_path(\%pairs, $word, \@nodes, $lvl);
	
	print "# $word PATH:\n".
		   join (" ", @nodes), "\n";
	
}; # foreach $word

#
# STEP 6.- Look for topmost children in the graph
#

print STDERR "# Looking for topmost children\n" if $opt_v;

my $topmostchildrenfile = "$fileprefix.children.tbl";

my @topmostchildren = ();

foreach my $parent (keys %pairs) {
	
	foreach my $children (keys %{ $pairs{$parent} }) {
		
		exists($pairs{$children}) || do {
			# if child is not parent then is bottomest one
			push @topmostchildren, $children;
		};
		
	}; # foreach $children

}; # foreach $parent

open(TOPCHILD, "> $topmostchildrenfile")  ||
	die("### ERROR ### Cannot open topmost children file: $topmostchildrenfile\n");
print TOPCHILD join("\n", @topmostchildren), "\n";
close(TOPCHILD);
	
#
# STEP 7.- Reconstruct sentenced from path in the graph,
#		   starting from childmost nodes

foreach my $word (@topmostchildren) {
	
	my @nodes = ();
	my $lvl = 0;
	
	&get_word_path(\%sriap, $word, \@nodes, $lvl);
	
	print "# $word PATH: \n",
		  join(" ", reverse(@nodes)), "\n"; # reverse the array to read the setence in the correct order

}; # foreach $word

# 

push @timestamp, new Benchmark;

print STDERR "## $0 has finished - took ",
             timestr(timediff($timestamp[1], $timestamp[0])),
             "\n" if $opt_v;

exit(0); ### END OF PROGRAM ###

#
## MY FUNCTIONS SECTION

sub get_word_path() {
	
	my ($pairshsh, $word, $nodesary, $lvl) = @_; 
	# wer are working with all the main program variables
	# but using references to keep their structure
	
	push @{ $nodesary }, $word;
	# adding a node to the array of words storing current sentence
	
	exists($pairshsh->{$word}) || return;
	# exit recursion if current key corresponds to a terminal node
	
	my @childs = keys %{ $pairshsh->{$word} }; 
			
	print STDERR "# -> $lvl $word -> @childs\n" if $opt_v;
	
	my $child = $childs[0];

	$pairshsh->{$word}{$child} == 0 && return;
	# exit recursion if node has been already visited 
    
	$pairshsh->{$word}{$child} = 0;

	&get_word_path($pairshsh, $child, $nodesary, ++$lvl);
	# recursion, the function calls itself with new level parameters
	
}; # get_word_path
