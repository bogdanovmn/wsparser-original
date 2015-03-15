use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use NcuxywkaParser;
use Utils;


my $parser = NcuxywkaParser->new(
	host           => 'ncuxywka.com',
	users_list_url => '/users/',
);
$parser->full_parse;

