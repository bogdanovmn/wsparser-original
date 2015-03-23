package WSParserApp::Action::Index;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;

sub main {
	my ($self) = @_;

	my @sites = schema->resultset('Site')->search({})->all;
	return {
		sites => [ 
			map {{ 
				host => $_->host,
				id   => $_->id,
			}}
			@sites
		]
	};
}

1;
