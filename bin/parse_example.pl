use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use NcuxywkaParser;
use TeplovozParser;
use Utils;


my $site = 'teplovoz.com';

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
		fast_download  => 1 
	);
	$parser->users_full_parse;
}
