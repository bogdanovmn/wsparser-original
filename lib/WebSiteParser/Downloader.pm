package WebSiteParser::Downloader;

use strict;
use warnings;
use bytes;

use LWP::UserAgent;
use WebSiteParser::Logger;
use Time::HiRes;
use Format::LongNumber;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( download );


my $__UA;


sub _ua {
	unless ($__UA) {
		$__UA = LWP::UserAgent->new(
			agent => 'Mozilla/5.0 (compatible; AhrefsBot/5.0; +http://ahrefs.com/robot/)'
		);
	}
	return $__UA;
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

1;
