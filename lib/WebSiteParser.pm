package WebSiteParser;

use strict;
use warnings;
use utf8;

use WebSiteParser::Users;
use WebSiteParser::Posts;


sub new {
	my ($class, %p) = @_;

	my $self = {
		users => WebSiteParser::Users->new,
		posts => WebSiteParser::Posts->new,
	};

	return bless $self, $class;
}

sub parse {
	my ($self) = @_;

	$self->{users}->parse;
	$self->{posts}->parse;
}

1;
