use strict;
use warnings;
use utf8;

use FindBin;
use lib $FindBin::Bin. '/../lib';

use NcuxywkaParser;
use Utils;


my $parser = NcuxywkaParser->new(host => 'ncuxywka.com');
$parser->full_parse;

