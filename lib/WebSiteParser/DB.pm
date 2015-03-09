package WebSiteParser::DB;

use strict;
use warnings;
use utf8;

use WebSiteParser::Schema;
use WebSiteParser::Config;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( schema );

my $__SCHEMA;

sub schema {
	unless ($__SCHEMA) {
		$__SCHEMA  = WebSiteParser::Schema->connect(
			sprintf('dbi:mysql:%s:%s', config_db->param('name'), config_db->param('host')), 
			config_db->param('user'), 
			config_db->param('pass'),
			{ 
				RaiseError => 1,
				mysql_auto_reconnect => 1,
				mysql_enable_utf8    => 1
			}
		) or die $!;
	}
	return $__SCHEMA;
}

1;
