package WebSiteParser::Instance::Ncuxywka;

use strict;
use warnings;
use utf8;

use Utils;
use base 'WebSiteParser';


sub _parse_users_list {
	my ($self, $html) = @_;

	my %users = $html =~ m#<p><a href='(/users/\d+\.html)'>(.*?)</a></p>#g;

	return [
		map {{ name => $users{$_}, url => $_ }}
		keys %users
	];
}

sub _parse_user_info {
	my ($self, $html) = @_;

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

sub _parse_user_posts_list {
	my ($self, $html) = @_;	
	
	my @list = $html =~ m#<tr>\s*<td class=date>\s*\d+-\d+-\d+\s*<td class=title>\s*<a href="(.*?)">#g;
	return \@list;
}

sub _parse_post_data {
	my ($self, $html) = @_;

	my ($name) = $html =~ m#<h1 class=creo_title>(.*?)</h1>#;
	my ($date) = $html =~ m#<span class=creo_date>(.*?)</span>#;
	my ($body) = $html =~ m#<div class=creo_body>(.*?)</div>#;

	return {
		name      => $name,
		body      => $body,
		post_date => $date
	}
}

1;
