#! /usr/bin/perl
#  Name:				password_4.3.pl
#  Author:				Ryan Spishock
#  Email:				ryan.spishock@me.com
#  Date Created:		August 30, 2016
#  Last Modified:		August 30, 2016
#  Description: 		This script will generate
#						passwords based on a user
#  						defined length and level
#						of security.
#-------------------------------------------------------+
# Version 1.0:			Creates standard alphanumeric	|
#						passwords with special 			|
#						characters						|
# Version 2.0:			Added the ability to choose 	|
#						the level of complexity for 	|
#			      		the password.					|
# Version 2.1:			Added the ability to create 	|
#						a numeric passcode.				|
# Version 3.0:			Added the ability to export 	|
#						the generated password to an 	|
#						external file.					|
# Version 4.0.1:		Script now requires a minimum 	|
#						length of 14 characters except 	|
#						for passcodes.					|
# Version 4.1:			Script now warns the user if 	|
#						an insecure password type is	|
#						chosen.  Script only forces		|
#						14 character restrictions on	|
#						high security passwords.		|
# Version 4.2:			Fixed export loop.				|
# Version 4.2.1:		Corrected some minor 			|
#						housekeeping issues.			|
# Version 4.2.2:		Corrected some minor 			|
#						housekeeping issues.  Updated	|
#						minimum password length to 		|
#						reflect current standards.		|
# Version 4.3:			Added a single subroutine to	|
#						handle password generation.		|
# Version 5.0:			Created a function to perform	|
#						the randomization of characters	|
#						and generation of pass codes.	|
#						Corrected error with single 	|
#						case password generation that 	|
#						generated a lower case password	|
#						if any key other than '1' was	|
#						selected.						|
#-------------------------------------------------------+

use diagnostics;
use strict;
use warnings;

#sets password ranges
my @password;
my $password;
my ($password_length, $user_length) = 0;
#my $type = "Numeric", "Upper case", "Lower case", "Mixed case", "Alphanumeric";
#seperate arrays for each password type
my @chars;
my @chars1 = ('0'..'9');
my @chars2 = ('A'..'Z');
my @chars3 = ('a'..'z');
my @chars4 = ('A'..'Z', 'a'..'z');
my @chars5 = ('A'..'Z', 'a'..'z', '0'..'9');
my @chars6 = ('0'..'9', 'a'..'z', 'A'..'Z', '!','@', '#', '$', '%',
'^', '&', '*', '(', ')', '<', '>', '?', '`', '+', '/', '[', '{', ']',
'}', '|', '=', '_','~', ',', '.');

#user inputs required length of password
print "Enter the required password length: ";
chomp($user_length = <STDIN>);
print "\n";

#user selects level of complexity12
print "Select a level of complexity for your password: \n";
print "1. Numeric passcode\t\t\t\t(low level of security) \n";
print "2. Single case alphabetic\t\t\t(low level of security) \n";
print "3. Multi-case alphabetic\t\t\t(low level of security) \n";
print "4. Alphanumeric\t\t\t\t\t(medium level of security) \n";
print "5. Alphanumeric with special characters\t\t(high level of security) \n";
print "Complexity level: ";
chomp(my $level = <STDIN>);
print "\n";

if ($level > 1) {
	while ($user_length < 16) {
		CONFORM:
		print "\t\t*********************************\n";
		print "\t\t*\t\tError!\t\t*\n";
		print "\t\t*********************************\n";
		print "\n";
		print "Strong password guidelines require a minimum password length of 16 characters.";
		print "\n";
		print "\n";
		print "Do you want to generate a password which conforms to strong password guidelines? ";
		chomp (my $guidelines = <STDIN>);
		if ($guidelines =~ m/^y/i) {
			print "Enter a new password length: ";
			chomp ($user_length = <STDIN>);
		} elsif ($guidelines =~ m/^n/i) {
			goto PW;
		} else {
			print "Invalid selection, please select either \'y\' or \'n\'.";
			goto CONFORM;
		}
	}
}

PW:
if ($level == 1) {
 	#numeric passcode
 	print "Generating a numeric passcode.";
 	print "\n";
	@chars = @chars1;
	goto GENERATE;
} elsif ( $level == 2) {
	CASE:
	#single case password
	print "Select case: \n";
	print "1. Upper \n";
	print "2. Lower \n";
	print "Case: ";
	chomp(my $case = <STDIN>);	
		if ($case == 1) {
			#uppercase password
  			print "Generating an uppercase password.";
  			print "\n";
  			@chars = @chars2;
  			goto GENERATE;
 		} elsif ($case == 2 ){
  			#lower case password
  			print "Generating a lowercase password.";
  			print "\n";
  			@chars = @chars3;
  			goto GENERATE;
 		} else {
 			print "Invalid selection, please select '1' for uppercase or '2' for lowercase.";
 			goto CASE;
 		}
} elsif ($level == 3) {
 	#mixed case password
 	print "Generating a mixed case password.";
 	print "\n";
 	@chars = @chars4;
 	goto GENERATE;
} elsif ($level == 4) {
	#alphanumeric password
 	print "Generating an alphanumeric password.";
 	print "\n";
 	@chars = @chars5;
 	goto GENERATE;
} else {
	#alphanumeric password with special characters
	print "Generating an alphanumeric password with special characters.";
	print "\n";
	@chars = @chars6;
	goto GENERATE;
}

#code to generate password
GENERATE:
while ($password_length <= ($user_length-1)) {
  		$password = $chars[int rand @chars];
  		push @password, $password;
		++$password_length;
}

#start export function
EXPORT:
print "\n";
print "Do you want to export your password to a text file? (y/n) ";
chomp(my $export = <STDIN>);
print "\n";

if ($export =~ m/^y/i) {
	open (FH, '>>password.txt') or die $!;
	print FH "Your password is: ", @password, "\n";
	close FH;
} elsif ($export =~ m/^n/i) {
	print "Your password is: ", @password ,"\n";
} else {
	print "Enter either 'y' or 'n' to continue. \n" ;
	goto EXPORT;
}

print "\n";
print "\n";
print "Your password has been generated. \n";