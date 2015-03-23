package WebSiteParser::Instance::Teplovoz;

use strict;
use warnings;
use utf8;

use Utils;
use base 'WebSiteParser';


sub _parse_users_list {
	my ($self, $html) = @_;

	my %users = $html =~ m#<a class=author_auth href=(/community/\w+)>(.*?)</a>#g;

	return [
		map {{ name => $users{$_}, url => $_ }}
		keys %users
	];
}

sub _parse_user_info {
	my ($self, $html) = @_;

	my ($name)      = $html =~ m#<span\s+class=pageheader12r>(.*?)</span>#;
	my ($reg_date)  = $html =~ m#<i>Регистрация:\s+(\d+-\d+-\d+)</i><BR>#;
	my ($edit_date) = $html =~ m#<i>Последнее изменение:\s+(\d+-\d+-\d+)</i><BR>#;
	my ($city)      = $html =~ m#<B>Город</B><BR>(.*?)<br>#;
	my ($about)     = $html =~ m#<b>О себе</b><BR>(.*?)<br><br>\s*<i>Регистрация#;
	my ($email)     = $html =~ m#<B>e-mail</B><BR><a href=mailto:(.*?)>#;
	
	return { 
		name      => $name,
		email     => $email,
		about     => $about,
		region    => $city,
		reg_date  => $reg_date,
		edit_date => $edit_date
	};
}

sub _parse_user_posts_list {
	my ($self, $html) = @_;	
	
	my ($creos_html) = $html =~ m#<BR><span\s+class=pageheader10r>Креативы</span>(.*?)<br><span\s+class=pageheader10r>Избранное</span>#;
	my @list;
	if ($creos_html) {
		@list = $creos_html =~ m#<a.*?href=(.*?)>#g;
	}

	return \@list;
}

sub _parse_post_data {
	my ($self, $html) = @_;
	
	my ($date, $name) = $html =~ m#<td width=100% class=justified>(\d\d\d\d-\d\d-\d\d) : <a class=author_auth href=/community/\w+ title=".*?">.*?</a> : <B>(.*?)</B>#;
	my ($body)        = $html =~ m#<table width=100% cellspacing=10><tr><td class=justified>(.*?)</td></tr></table>#;
	
	return {
		name      => $name,
		body      => $body,
		post_date => $date
	}
}

1;
