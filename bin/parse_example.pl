use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use WebSiteParser;
use Utils;


sub parse_users_list {
	my ($html) = @_;

	my %users = $html =~ m#<p><a href='(/users/\d+\.html)'>(.*?)</a></p>#g;

	return [
		map {{ name => $users{$_}, url => $_ }}
		keys %users
	];
}

sub parse_user_page {
	my ($html) = @_;

	my ($name)                 = $html =~ m#"<span class=letter>(.*?)</span>"</h1>#;
	my ($reg_date, $edit_date) = $html =~ m#<b>Дата регистрации:</b>\s*<br>\s*(\d+-\d+-\d+ \d+:\d+)\s*<br>\s*<br>\s*<b>Дата изменения данных:</b>\s*<br>\s*(\d+-\d+-\d+ \d+:\d+)\s#;
	my ($city)                 = $html =~ m#<b>Город:</b>\s*<br>\s*(.*?)\s*<br>#;
	my ($about)                = $html =~ m#<b>О себе:</b>\s*<br>\s*(.*?)\s*<br>#;

	return { 
		name      => $name,
		about     => $about,
		region    => $city,
		reg_date  => $reg_date,
		edit_date => $edit_date
	};
}
sub parse_post_page {}

my $parser = WebSiteParser->new(host => 'ncuxywka.com');
#$parser->get_users('/users/', \&parse_users_list);
#$parser->get_users_pages;
$parser->fetch_users_info(\&parse_user_page);

#$parser->get_user_posts_list;
#$parser->get_user_posts_pages;
