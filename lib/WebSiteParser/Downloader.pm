package WebSiteParser::Downloader;

use strict;
use warnings;
use bytes;

use LWP::UserAgent;
use HTTP::Request;

use AnyEvent::HTTP;
$AnyEvent::HTTP::MAX_PER_HOST = 10;

use WebSiteParser::Logger;
use Time::HiRes;
use Format::LongNumber;
use Utils;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( download download_fast );

use constant USER_AGENT_NAME => [
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/0.4.154.25 Safari/525.19',
    'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; YPC 3.0.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)',
    'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)',
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1',
    'Mozilla/5.0 (Windows; U; Windows NT 6.0; ru; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3',
    'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1) Gecko/20090624 Firefox/3.5',
    'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322; .NET CLR 2.0.50215) Netscape/8.0.1',
    'Opera/9.50 (Windows NT 5.1; U; ru)',
    'Opera/9.0 (Windows NT 5.1; U; en)',
    'Opera/9.60 (J2ME/MIDP; Opera Mini/4.2.13337/724; U; ru) Presto/2.2.0',
    'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/521.25 (KHTML, like Gecko) Safari/521.24',
];

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

sub download_fast {
	my ($urls) = @_;

	logger->debug(sprintf 'downloading %d urls', scalar @$urls);
	
	my %responses;
	my $cv = AnyEvent->condvar;

	my $begin_time = Time::HiRes::time;
	my $i = @$urls;
	foreach my $url (@$urls) {
		http_get(
			$url, 
			#tls_ctx => { verify => 1, verify_peername => 'https' },
			_common_params(), 
			sub {
				my ($body, $headers) = @_;

				$responses{$url} = {
					body   => $body,
					size   => $headers->{'content-length'},
					status => $headers->{Status}. ' '. $headers->{Reason}
				};
				$cv->send unless --$i;
			}
		);
	}
	$cv->recv;

	my $elapsed_time     = sprintf('%.4f', Time::HiRes::time - $begin_time);
	my $avg_elapsed_time = sprintf('%.4f', $elapsed_time / scalar(@$urls));

	my %result;
	while (my ($url, $data) = each %responses) {
		$result{$url} = $data->{body};
		logger->debug(
			sprintf '%s, avg time: %s, size: %s, url: %s', 
				$data->{status}, 
				$avg_elapsed_time, 
				short_traffic($data->{size}),
				$url
		);
	}
	
	return \%result; 
}

sub _common_params {
    (
        cookie_jar => {},
        headers    => {
            #'Host'    => 'maps.yandex.ru',
            'Referer' => 'http://yandex.ru/',
            'User-Agent' => USER_AGENT_NAME->[int rand @{(USER_AGENT_NAME)}],
        },
    );
}

1;
