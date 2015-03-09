use utf8;
package WebSiteParser::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-08 00:15:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ye209ExmvO+5YPE7ulf5oA

# You can replace this text with custom code or comments, and it will be preserved on regeneration

use WebSiteParser::Config;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( schema );

my $__SCHEMA;

sub schema {
	unless ($__SCHEMA) {
		$__SCHEMA  = __PACKAGE__->connect(
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
