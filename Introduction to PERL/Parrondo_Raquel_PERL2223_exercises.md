**PERL EXERCISES --- MBI2223**
==============================
*by* PARRONDO PIZARRO, Raquel

# 0. [INSTRUCTIONS](https://aulaglobal.upf.edu/mod/assign/view.php?id=945968)

You have to submit this [MarkDown](http://daringfireball.net/projects/markdown/syntax#link) file with your answers to the different exercises. First, [download the template from this link](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/docs/Surname_Name_PERL2223_exercises.md) ([Surname_Name_PERL2223_exercises.md](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/docs/Surname_Name_PERL2223_exercises.md)), then rename it using your *surname* and *name*. You must change the "`SURNAME, Name`" string within this document too (see line 3). Each exercise has a section with a special comment inside that says "`# ... YOUR ANSWER HERE ...`", just replace that string with your `Perl` code. You can add some comments outside the code bloc defined by the triple backticks lines. You must [submit the modified MarkDown text file through this Aula Global link](https://aulaglobal.upf.edu/mod/assign/view.php?id=945968), you do not need to compile it; if you want to try anyway, see code below that requires `pandoc` and some `LaTeX` packages installed in your system. Just check the exercise description on the Aula Global for late anouncements or changes on those given instructions.

Document compiled with: 
```{.sh}
#
# Ensure you have pandoc > 2.0 installed on your system (see below)
#
pandoc -f markdown+tex_math_dollars        \
       -t latex                            \
       --variable papersize:a4paper        \
       --variable geometry:margin=1.5cm    \
       --variable fontsize=11pt            \
       --highlight-style=pygments          \
       -o Surname_Name_PERL2223_exercises.pdf \
          Surname_Name_PERL2223_exercises.md

## The latest installer versions of pandoc are available
#    at: https://github.com/jgm/pandoc/releases/latest
#
## To install pandoc on a Debian based Linux system (Debian, Ubuntu, Mint) 
#    you can run the following commands:
wget https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-1-amd64.deb;
sudo dpkg -i pandoc-2.14.2-1-amd64.deb;
#
## To install pandoc on a MacOS system you can run the following commands:
wget https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-macOS.pkg;
sudo installer -verbose -pkg pandoc-2.19.2-macOS.pkg -target /;
#
# On MacOS you can also use conda or brew... (please, avoid mixing installers on your system)
# For instance, using brew pn a MacOS you have to run this:
sudo brew install pandoc pandoc-citeproc \
                  librsvg python homebrew/cask/basictex;
sudo tlmgr install collection-fontsrecommended;
```

\newpage

# 1. [PERL Basic Exercises](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlBasic/#EXS)

## Exercise 1.A
What happens if we set the condition of a `while` to `1`, like in the following code:
```{.perl .numberLines}
while (1) {
    print $i++,"\n";
};
```

```{.perl .numberLines}
If we set the condition of a 'while' to '1', the loop will be executed indefinitely until the program crashes or we order it to stop. 
```


## Exercise 1.B
Can you write a short script that will print a countdown on the terminal ?
**A tip:** you can use `sleep(10)`; within the countdown loop to get it readable. You can also use the "`\r`" character instead of "`\n`", and see what happens...


```{.perl .numberLines}
print "COUNTDOWN... \n";

# Initialize variable 
my $i = 10;

# Testing condition
until ($i == 0) {
	# Statement 
	print STDOUT "... $i \n";
	# Decrement counter
	$i--; 
	sleep(10);
}; # until
```


## Exercise 1.C
Write a script that will keep reading your input from the terminal. It should print back "`Tell me more...`" every time the user ends a line with `<RETURN>`. 

```{.perl .numberLines}
print STDOUT "Tell me something...\n";

while (my $line = <STDIN>) {
	chomp($line);
	print STDOUT "Tell me more...\n";
}; # while
```


# 2. [PERL Scalar Vars Exercises](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlScalarVars/#EXS)

## Exercise 2.A
Using the "`$line = <STDIN>;`" instruction, write a short script that computes the factorial of a number, $f(x) = x!$, provided by the user.

```{.perl .numberLines}
my $fact = 1;

print STDOUT "Enter a number: ";

for (my $line = <STDIN>) { # take a number from the terminal
	chomp($line);
	$line = int($line);
	for (my $i = 1; $i <= $line; $i++) {
		# compute the factorial of the entered number
		$fact *= $i;
	}; 
	print STDOUT "The factorial of $line is $fact \n";
}; # for 
```


## Exercise 2.B
Can you modify the [previous section script](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlScalarVars/#SEQ), which counts the frequencies of nucleotides for a given sequence, in order to count the observed frequency of a given dinucleotide, for instance "`TT`".

```{.perl .numberLines}
#!/usr/bin/perl
use strict;
use warnings;

# declaring some variables
my ($dna_seq,$TT);

# initializing variables
$dna_seq  = "ATGCATTGGGGAACCCTGTGCGGATTCTTGTGGCTTTGGCCCTATCTTTTCTATGTCCAAGCTG".
            "TGCCCATCCAAAAAGTCCAAGATGACACCAAAACCCTCATCAAGACAATTGTCACCAGGATCAA";

$TT = 0;

# Looping throught the sequence
my $seqlen = length($dna_seq);

for (my $i = 0; $i < $seqlen; $i++) {
    my $char;
    $char = uc(substr($dna_seq,$i,2));
	($char eq 'TT') && ($TT++);
};

# Printing results
print STDOUT "Total TT = $TT\n";
```


## Exercise 2.C
The exercise above can be extended easily to print all the nucleotide positions where the given dinucleotide was found, remember that we are talking about "`TT`". 

```{.perl .numberLines}
#!/usr/bin/perl
use strict;
use warnings;

# declaring some variables
my ($dna_seq, $TT, $TT_positions);

# initializing variables
$dna_seq  = "ATGCATTGGGGAACCCTGTGCGGATTCTTGTGGCTTTGGCCCTATCTTTTCTATGTCCAAGCTG".
            "TGCCCATCCAAAAAGTCCAAGATGACACCAAAACCCTCATCAAGACAATTGTCACCAGGATCAA";

$TT = 0;

$TT_positions = "";

# Looping throught the sequence
my $seqlen = length($dna_seq);

for (my $i = 0; $i < $seqlen; $i++) {
    my $char;
    $char = uc(substr($dna_seq,$i,2));
    my $position;
    $position = $i + 1;
	($char eq 'TT') && ($TT++, $TT_positions .= " $position ");
};

# Printing results
print STDOUT "Total TT = $TT\n";
print STDOUT "Nucleotide positions of TT = $TT_positions\n";
```


# 3. [PERL Array Vars Exercises](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlArrayVars/#EXS)

## Exercise 3.A
Write a short script that reads a set of numbers from the terminal, pushes them into an array, then it has to compute the median for that set, that is the middle value when a set of data is arranged in order of increasing magnitude (second quartile, 50%).

```{.perl .numberLines}
# Initialize variables
my (@stringarray, $num, @numarray, $length, @sortedarray, $median);

print STDOUT "Enter a set of numbers (separated by commas):";

for (my $line = <STDIN>) { # take a set of numbers from the terminal
	chomp($line);
	@stringarray = split(', ', $line);
	# put the entered set of numbers into an array
	foreach $num (@stringarray) {
		$num = int($num);
		push(@numarray, $num);
	}; # foreach
}; # for

# Print the set of numbers
print STDOUT "Set of numbers: @numarray\n";

# Compute the median 
@sortedarray = sort { $a <=> $b } @numarray;
$length = @sortedarray;
$length % 2 ? $median = $sortedarray[int($length/2)]: $median = ($sortedarray[int($length/2)-1] + $sortedarray[int($length/2)])/2;

# Print the result
print STDOUT "The median of that set is: $median\n";
```


## Exercise 3.B
Encode the following matrix into a Perl variable:
```
  1  2  3
  5  7 12
 10 12 13
```
then calculate a new matrix where each $X'_{i,j} = X_{j,i}$. Print the resulting matrix and its diagonal vector (**do NOT use `Data::Dumper` module**).

```{.perl .numberLines}
# Initialize variables
my (@matrix, @transpose);

# Declare variables
@matrix = ( [ 1, 2, 3 ],
		    [ 5, 7, 12 ],
		    [ 10, 12, 13 ] );

# Compute the matrix transpose	   
for (my $i = 0; $i < scalar(@matrix); $i++) {
	for (my $j = 0; $j < scalar(@{$matrix[0]}); $j++) {
		$transpose[$i][$j] = $matrix[$j][$i];
	};
};

# Print the resulting matrix
print STDOUT "The resulting trasposed matrix is: \n"; 

for (my $i = 0; $i < scalar(@transpose); $i++) {
	for (my $j = 0; $j < scalar(@{$transpose[0]}); $j++) {
		print STDOUT $transpose[$i][$j], " ";  
 	}; # loop through columns
 	print STDOUT "\n"; 
}; # loop through rows

print STDOUT "\n"; 

# Print the diagonal vector
print STDOUT "Its diagonal vector is: \n"; 

for (my $i = 0; $i < scalar(@transpose); $i++) {
	for (my $j = 0; $j < scalar(@{$transpose[0]}); $j++) {
		($i == $j) && (print STDOUT $transpose[$i][$j], " ");  
 	}; # loop through columns
}; # loop through rows

print STDOUT "\n";  
```


## Exercise 3.C
Take a set of integers from the terminal and push them into a Perl array. For every pair of elements, say here $x_n$ and $x_{n+1}$, on that array, calculate the aritmetic mean, $(x_n + x_{n+1}) / 2$, and insert the corresponding value between the two elements of that array (**hint:** you can use `splice` function or an auxiliary array). Print out the resulting list of numbers in a single line, using single whitespaces as output field separator. 

```{.perl .numberLines}
# Initialize variables
my (@stringarray, $num, @numarray, $sum, $mean, @meanarray);

print STDOUT "Enter a set of integers (separated by commas):";

for (my $line = <STDIN>) { # take a set of integers from the terminal
	chomp($line);
	@stringarray = split(', ', $line);
	# put the entered set of intergers into an array
	foreach $num (@stringarray) {
		$num = int($num);
		push(@numarray, $num);
	}; # foreach
}; # for

# Print the set of numbers
print STDOUT "Set of numbers: @numarray\n";

# Compute the aritmetic mean for every pair of numbers and insert the corresponding value in the array between them
for (my $i = 0; $i < scalar(@numarray)-1; $i++) {
	$sum = $numarray[$i]+$numarray[$i+1];
	$mean = $sum/2;
	$i == 0 ? push @meanarray, $numarray[$i], $mean, $numarray[$i+1] : push @meanarray, $mean, $numarray[$i+1];
}; # for

# Print the resulting list of numbers
print STDOUT "The resulting list of numbers after the transformations is: @meanarray\n";
```


# 4. [PERL Hash Vars Exercises](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlHashVars/#EXS)

## Exercise 4.A
Gene features can be easily grouped in GFF format thanks to the ninth column, which often contains a gene identifier. From the [GFF file available from this link](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlHashVars/feats.gff), write a script to count every feature found for each gene. **As a hint**, you can use the gene identifier (the ninth column) as a primary key, and the feature field (the third column) as a secondary key; then you can increment the value assigned to the secondary key, remember to initialize to 0, each time you find that feature.

```{.perl .numberLines}
use Data::Dumper;

# Warning
warn("WARNING: The proper command to run this prorgam is: >>> perl PERL2223_exercises.pl < <GFFinputfile>");

# Initialize variables
my (@gene, $feature, $geneid);

# Initialize the hash 
my %genefeatures = ();

while(<STDIN>) { 
	chomp;
	@gene = split('\t', $_);
	$feature = $gene[2];
	$geneid = $gene[8];
	if(exists($genefeatures{$geneid}{$feature})) {
		$genefeatures{$geneid}{$feature} += 1;
	} else {
		$genefeatures{$geneid}{$feature} = 1;
	};
}; # while

# Print the result
print STDOUT Data::Dumper->Dump( [ %genefeatures ], [qw / *HASH OF GENE FEATURES / ]), "\n";		
```


## Exercise 4.B
Imagine you have two files in tabular format; both having the same kind of data: just an identifier on the first column, and a numeric value on the second. Write a script that merges the two files into a single output having three columns: the identifier, the value for that id from file 1, and the corresponding value from file 2. Where no value is present on one of the two files, just return the "`NA`" string (for instance, check if the corresponding key is defined, then return the value, otherwise return the *Not-Available* value). Here you can find the links for two example files: [fileA.tbl](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlHashVars/fileA.tbl) and [fileB.tbl](https://compgen.bio.ub.edu/~jabril/teaching/MBI2223_PER/PerlHashVars/fileB.tbl)

```{.perl .numberLines}
use Data::Dumper;;

# Initialize variables 
my (@token1, @token2, $key, $value1, $value2, $header, $line);

# Initialize the hash
my %output= ();

# Warning
warn("WARNING: The proper command to run this prorgam is: >>> perl PERL2223_exercises.pl <inputfile1> <inputfile2> > <outputfile>");


# Open input file 1
open(FILE1, $ARGV[0]);

# Loading input file 1 records
while(<FILE1>) {
	chomp;
	@token1 = split(' ', $_);
	$key = $token1[0] + 0;
	$value1 = $token1[1] + 0;
	@{$output{$key}} = $value1,
}; # while

# Close input file 1
close(FILE1);

# Open input file 2
open(FILE2, $ARGV[1]);

# Loading input file 2 records
while(<FILE2>) {
	chomp;
	@token2 = split(' ', $_);
	$key = $token2[0] + 0;
	$value2 = $token2[1] + 0;
	exists($output{$key}) ? push @{$output{$key}}, $value2 : push @{$output{$key}}, "Not-Available", $value2;
}; # while

foreach $key (keys %output) {
	if(scalar @{$output{$key}} == 1) {
		push @{$output{$key}}, "Not-available";
	};
}; # foreach

# Close input file 2
close(FILE2);

# Write the output file
$header = "IDENTIFIER\tVALUE 1\tVALUE 2\n";
print STDOUT $header;
	
foreach $key (sort {$a <=> $b} keys %output) {
	$line = "$key\t$output{$key}[0]\t$output{$key}[1]\n";
	print STDOUT $line;
}; # foreach
```
