package WebSiteParser::Downloader;

use strict;
use warnings;
use bytes;

use LWP::UserAgent;
use LWP::Parallel::UserAgent;
use HTTP::Request;
use WebSiteParser::Logger;
use Time::HiRes;
use Format::LongNumber;
use Utils;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( download download_fast );


my $__UA;
my $__PUA;


sub _ua {
	unless ($__UA) {
		$__UA = LWP::UserAgent->new(
			agent => 'Mozilla/5.0 (compatible; AhrefsBot/5.0; +http://ahrefs.com/robot/)'
		);
	}
	return $__UA;
}

sub _pua {
	unless ($__PUA) {
		$__PUA = LWP::Parallel::UserAgent->new(
			agent => 'Mozilla/5.0 (compatible; AhrefsBot/5.0; +http://ahrefs.com/robot/)'
		);
		$__PUA->max_req(5);
		$__PUA->ssl_opts( verify_hostnames => 0 );
	}
	return $__PUA;
}

sub download {
	my ($url) = @_;

	logger->debug('downloading '. $url);

	my $begin_time = Time::HiRes::time;
	my $response = _ua()->get($url);
	my $elapsed_time = sprintf('%.4f', Time::HiRes::time - $begin_time);

	logger->debug(
		sprintf '%s, time: %s, size: %s', 
			$response->status_line, 
			$elapsed_time, 
			short_traffic(bytes::length($response->decoded_content))
	);
	
	return $response->is_success
		? $response->decoded_content
		: undef;
}

sub download_fast {
	my ($urls) = @_;

	logger->debug(sprintf 'downloading %d urls', scalar @$urls);
	
	my $begin_time = Time::HiRes::time;
	foreach my $url (@$urls) {
		_pua()->register(HTTP::Request->new(GET => $url));
	}
	my $responses = _pua()->wait;
	my $elapsed_time = sprintf('%.4f', Time::HiRes::time - $begin_time);
	my $avg_elapsed_time = sprintf('%.4f', $elapsed_time / scalar(@$urls));

	my %result;
	while (my ($request, $entry) = each %$responses) {
		$result{$request} = $entry->response->is_success ? $entry->response->decoded_content : undef;

		logger->debug(
			sprintf '%s, avg time: %s, size: %s', 
				$entry->response->status_line, 
				$avg_elapsed_time, 
				short_traffic(bytes::length($entry->response->decoded_content))
		);
	}
	
	return \%result; 
}
1;
