package WebSiteParser::Logger;

use strict;
use warnings;
use utf8;

use WebSiteParser::Config;
use Log::Log4perl;
use FindBin;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( logger );

my $__LOGGER;


sub logger {
	unless ($__LOGGER) {
		Log::Log4perl->init($FindBin::Bin. '/../etc/'. config->param('logger'));
		$__LOGGER = Log::Log4perl->get_logger;
	}
	return $__LOGGER;
}

$SIG{__WARN__} = sub {
	logger->warn($_[0]);
	warn $_[0];
};

$SIG{__DIE__} = sub {
	logger->error($_[0]);
	die $_[0];
};

1;
