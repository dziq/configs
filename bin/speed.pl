#!/usr/bin/perl
# Copyright (c) 2009, Ezequiel R. Aguerre
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the author nor the names of its contributors may be used
#   to endorse or promote products derived from this software without specific
#   prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
use strict;
use warnings;
use Time::HiRes qw (gettimeofday);

if ( $#ARGV != 0 ) { die "ERROR: Need an interface."; }
my $ifface = shift;

sub getData {
	my $dev = shift;
	open ( my $fd, "ifconfig ${dev}|" ) or die "Couldn't open $dev: $!";
	while (<$fd>) {
		chomp $_;
		if ( /RX bytes:(\d+).*TX bytes:(\d+)/ ) {
			$_[0] = $1;
			$_[1] = $2;
		}
	}
	close $fd or die "Can't close pipe: $!";
}

while ( 1 ) {
	getData $ifface, my $rx1, my $tx1;
	my ($sec1, $usec1) = gettimeofday;

	sleep 1;

	getData $ifface, my $rx2, my $tx2;
	my ($sec2, $usec2) = gettimeofday;

	my $delta = ($sec2 - $sec1) + ($usec2 - $usec1) * 0.000001;
	my $txrate = ($tx2 - $tx1) / $delta / 1000.0; # KBps with SI multiples
	my $rxrate = ($rx2 - $rx1) / $delta / 1000.0; # KBps with SI multiples

	print "$ifface data rate:\n";
	printf "TX Rate: %.2f KBytes/Seconds\n", $txrate;
	printf "RX Rate: %.2f KBytes/Seconds\n", $rxrate;
}
