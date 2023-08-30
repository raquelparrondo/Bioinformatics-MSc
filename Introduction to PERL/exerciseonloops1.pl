#!usr/bin/perl
use strict;
use warnings;

# initialize the ball and walls
my $wall = "|";
my $ball = "O";
my $distance = 10;

# remove the space between the two walls and the ball itself
my $realdistance = $distance - 3;

# define the number of iterations 
print STDERR "Number of iterations: ";

my $iterations = <STDIN>; # reading the number of iterations from the input stream

print STDOUT "Number of iterations: $iterations";

# iterate the loop i times
for (my $i = 1; $i <= $iterations; $i++) {

	# making the ball run to the right
	for (my $position = 0; $position <= $realdistance; $position++) {
		
		my $prespace = " " x $position;
		my $postspace = " " x ($realdistance - $position);
		my $line = $wall . $prespace . $ball . $postspace . $wall;
		
		print STDOUT "$line\n"; # saving the ball movement in an output file
		print STDERR "$line\r"; # showing the ball movement in terminal 
		
		sleep 1;

	};
	# making the ball run to the left 
	for (my $position = $realdistance; $position >= 0; $position--) {
		
		my $prespace = " " x $position;
		my $postspace = " " x ($realdistance - $position);
		my $line = $wall . $prespace . $ball . $postspace . $wall;
		
		print STDOUT "$line\n"; # saving the ball movement in an output file 
		print STDERR "$line\r"; # showing the ball movement in terminal 
		
		sleep 1;
		
	}

}

print STDERR "\n";
