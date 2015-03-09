use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use WebSiteParser;


sub parse_users_list {
	my ($html) = @_;

	print $html;

	return [
		{ url => '', name => '' }
	];
}

sub parse_user_page {
	my ($html) = @_;

	return {
		name => '',
		email => '',
		about => '',
		region => '',
		sex => '',
		reg_date => '',
		edit_date => ''
	};
}
sub parse_post_page {}

my $parser = WebSiteParser->new(site => 'ncuxywka.com');
$parser->get_users(
	'/users/',
	\&parse_users_list
);
$parser->get_users_pages;

#$parser->fetch_user_info(parse_user_page);

#$parser->get_user_posts_list;
#$parser->get_user_posts_pages;