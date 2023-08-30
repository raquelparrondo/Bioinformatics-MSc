#!usr/bin/perl
use strict;
use warnings;

# import higher time reslution for sleep ()
use Time::HiRes;
use Data::Dumper;

# using colours https://en.wikipedia.org/wiki/ANSI_escape_code
my $blueon = "\033[01;34m"; 
my $greenon = "\033[01;32m"; 
my $redon = "\033[01;91m"; 
my $coloroff = "\033[00m"; 
my $backseven = "\r\033[7F"; 

# initialize the ball and walls
my $floor = $redon . "-" . $coloroff;
my $wall = $redon . "|" . $coloroff;
my $ball = $greenon . "O" . $coloroff;
my $distance = 50;
my $ball_speed = 0.1;
my $trips = 100 ;
my $height = 5;

# print a ruler to verify the distance run
for (my $i = 0; $i < $distance; $i++) {
	
	printf "%d", ($i+1) % 10; 

}
print "\n";

# remove the space between the two walls and the ball itself
my $realdistance = $distance - 3;

# built the matrix
my @space = ();

# initialize the drawing canvas for the bouncing 
$space[0] = $space[$height + 1] = [ ($floor) x $distance ]; 
for (my $i = 1; $i <= $height; $i++) {
	
	$space[$i][0] = $space[$i][$distance - 1] = $wall;
	
	for (my $j = 1; $j < $distance - 1; $j++) { 
		
		$space[$i][$j] = " ";
		
	}
	
}
	
#print Data::Dumper -> Dump([ \@space ], [ qw/ *SPACE / ]);

# initialize the position variables of the ball 
my $x = 3;
my $y = 3;

my $xd = +1;
my $yd = +1;

my $lastx;
my $lasty;
my $penultimatex;
my $penultimatey;
my $antepenultimatex;
my $antepenultimatey;

# make the ball move
for (my $T = 0; $T < $trips; $T++) {

	if ($T == 0) {
		
		# place the ball
		$space[$x][$y] = $ball;
	
	};
	
	if ($T == 1) {
		
		# place the ball
		$space[$x][$y] = $ball;
		$space[$lastx][$lasty] = "·";
	
	};
	
	if ($T == 2) {
		
		# place the ball
		$space[$x][$y] = $ball;
		$space[$lastx][$lasty] = "·";
		$space[$penultimatex][$penultimatey] = ".";
	
	};
	
	if ($T >= 3) {
		
		# place the ball
		$space[$x][$y] = $ball;
		$space[$lastx][$lasty] = "·";
		$space[$penultimatex][$penultimatey] = ".";
		$space[$antepenultimatex][$antepenultimatey] = " ";
	
	};

	# keep the ball location	
	if ($T >= 2) {
		
		$antepenultimatex = $penultimatex;
		$antepenultimatey = $penultimatey;
	
	};
	
	if ($T >= 1) {
		
		$penultimatex = $lastx;
		$penultimatey = $lasty;
	};
	
	$lastx = $x;
	$lasty = $y;
	
	# print canvas in terminal
	for (my $i = 0; $i <= $height + 1; $i++) {
		
		print STDOUT join('', @{ $space[$i] }), "\n"; 
	
	}; # looping through rows
	
	print STDOUT $backseven;
	
	Time::HiRes::sleep($ball_speed);
	
	$x += $xd;
	$y += $yd;
	
	# perform the next movement of the ball	
	if ($x > $height) { 
		$xd = -1; 
		$x += $xd;
	};
	
	if ($y > $realdistance) { 
		$yd = -1; 
		$y += $yd;
	};
		
	if ($x < 1) { 
		$xd = +1; 
		$x += $xd;
	};
	
	if ($y < 1) { 
		$yd = +1; 
		$y += $yd;
	};

}; # for ST

print STDOUT "\n" x 7;

exit(0);
