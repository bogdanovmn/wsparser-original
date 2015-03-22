use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use WebSiteParser::Instance::Ncuxywka;
use WebSiteParser::Instance::Teplovoz;
use Utils;
use Getopt::Long;


sub show_usage {
	print qq{
Usage:
	$0 --site <host_name> --type <type> --parse_post <post_id>
		
		--site          host name of parsed site
		--type          type of parser coverage (user
		--parse_post    run parse procedure for <post_id> (for debug only)

	\n};
}

my $site;
my $type;
my $post_id;
GetOptions(
	'site=s'       => \$site,
	'type=s'       => \$type,
	'parse_post=i' => \$post_id,
);

$type ||= 'full';

if (not $site or $type !~ /^(full|users)$/) {
	show_usage();
	exit;
}


my $parser;
if ($site eq 'ncuxywka.com') {
	$parser = WebSiteParser::Instance::Ncuxywka->new(
		host           => 'ncuxywka.com',
		users_list_url => '/users/',
		fast_download  => 1 
	);
}
elsif ($site eq 'teplovoz.com') {
	$parser = WebSiteParser::Instance::Teplovoz->new(
		host           => 'teplovoz.com',
		users_list_url => '/community/',
		fast_download  => 1,
		charset        => 'cp1251'
	);
}
else {
	die sprintf "No parser for site '%s'\n", $site;
}


if ($post_id) {
	$parser->parse_post_by_id($post_id);
}
else {
	if ($type eq 'full') {
		$parser->full_parse;
	}
	elsif ($type eq 'users') {
		$parser->users_full_parse;
	}
}
