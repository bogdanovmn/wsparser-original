use strict;
use warnings;
use utf8;

use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use FindBin;
use Config::Simple;


my $config = Config::Simple->new($FindBin::Bin. '/../etc/db');

make_schema_at(
	'WebSiteParser::Schema',
	{ 
		debug => 1,
		dump_directory => $FindBin::Bin. '/../lib',
		generate_pod => 0,
	},
	[ 
		sprintf('dbi:mysql:dbname=%s', $config->param('name')),
		$config->param('user'), 
		$config->param('pass'), 
	#	{ loader_class => 'MyLoader' } # optionally
	],
);
