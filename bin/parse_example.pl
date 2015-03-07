use strict;
use warnings;
use utf8;

use WebSiteParser;


sub get_users_list {}
sub parse_user_page {}
sub parse_post_page {}

my $parser = WebSiteParser->new(
	site => 'ncuxywka.com',
	users => {
		get_list   => get_users_list,
		parse_page => parse_user_page,
	},
	posts => {
		parse_page => parse_post_page
	}
);

$parser->go;

