package WebSiteParser::Abstract;

use strict;
use warnings;
use utf8;

use WebSiteParser::Schema;
use LWP::UserAgent;

sub new {
	my ($class, %p) = @_;

	my $self = {
		ua => LWP::UserAgent->new,
	};
		
	return bless $self, $class;
}

1;
