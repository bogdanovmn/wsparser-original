use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use NcuxywkaParser;
use TeplovozParser;
use Utils;
use Getopt::Long;


my $site;
my $type;
my $post_id;
GetOptions(
	'site=s'       => \$site,
	'type=s'       => \$type,
	'parse_post=i' => \$post_id,
);


if ($site eq 'ncuxywka.com') {
	my $parser = NcuxywkaParser->new(
		host           => 'ncuxywka.com',
		users_list_url => '/users/',
		fast_download  => 1 
	);
	$parser->full_parse;
}
elsif ($site eq 'teplovoz.com') {
	my $parser = TeplovozParser->new(
		host           => 'teplovoz.com',
		users_list_url => '/community/',
		fast_download  => 1,
		charset        => 'cp1251'
	);
	#$parser->full_parse;
	#$parser->users_full_parse;
	$parser->parse_post_by_id(5685);
}
