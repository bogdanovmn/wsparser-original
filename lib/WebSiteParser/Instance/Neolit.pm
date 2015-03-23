package WebSiteParser::Instance::Neolit;

use strict;
use warnings;
use utf8;

use Utils;
use base 'WebSiteParser';


sub _parse_users_list {
	my ($self, $html) = @_;

	my ($links_html) = $html =~ m#<p class=h2>авторы Неоновой:</p>(.*?)<div class="regus">#;
	my %users;
	if ($links_html) {
		%users = $links_html =~ m#<a href=(index\.php\?r1=0&r2=2&ad=\d+)>(.*?)</a>;#g;
	}

	return [
		map {{ name => $users{$_}, url => '/'.$_ }}
		keys %users
	];
}

sub _parse_user_info {
	my ($self, $html) = @_;

	my ($name, $email) = $html =~ m#<p class=auth><span class=select>(.*?)</span><a href=mailto:(.*?)>#;
	
	return { 
		name  => $name,
		email => $email,
	};
}

sub _parse_user_posts_list {
	my ($self, $html) = @_;	
	
	my ($creos_html) = $html =~ m#<b>все работы автора:</b></font><br>(.*?)</font></td></tr></table></form>#;
	my @list;
	if ($creos_html) {
		@list = map { '/forprint.php?id='.$_ } $creos_html =~ m#<a href="index\.php\?r1=0&r2=0&td=(\d+)">#g;
	}

	return \@list;
}

sub _parse_post_data {
	my ($self, $html) = @_;
	
	my ($name) = $html =~ m#<p class="style2">(.*?)<p class="style10">#;
	my ($body) = $html =~ m#</strong><br></p></a><br><p>(.*?)</p><br><p class="style9">Copyright#;
	my $date;
	if ($html =~ m#class="style9">Copyright.*?,\s+(\d+)\.(\d+)\.(\d+)\s*</p><br>#) {
		$date = $1 > 1999
			? sprintf '%d-%02d-%02d', $1, $2, $3
			: sprintf '%d-%02d-%02d', $3 + 2000, $2, $1;
	}

	return {
		name      => $name,
		body      => $body,
		post_date => $date
	}
}

1;
