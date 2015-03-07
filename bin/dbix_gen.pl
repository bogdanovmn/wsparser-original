use strict;
use warnings;
use utf8;

use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use FindBin;
use Config::Simple;


my $config = Config::Simple->new($FindBin::Bin. '/../etc/config');

make_schema_at(
	'WebSiteParser::Schema',
	{ 
		debug => 1,
		dump_directory => $FindBin::Bin. '/../lib',
	},
	[ 
		sprintf('dbi:mysql:dbname="%s"', $config->param('db_name')),
		$config->param('db_user'), 
		$config->param('db_pass'), 
	#	{ loader_class => 'MyLoader' } # optionally
	],
);
