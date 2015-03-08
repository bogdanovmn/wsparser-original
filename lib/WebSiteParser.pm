package WebSiteParser;

use strict;
use warnings;
use utf8;

use WebSiteParser::Users;
use WebSiteParser::Posts;
use WebSiteParser::Schema;

sub new {
	my ($class, %p) = @_;

	my $self = {
		site  => $p{site},
		users => WebSiteParser::Users->new,
		posts => WebSiteParser::Posts->new,
	};

	return bless $self, $class;
}

sub get_users {
	my ($self, $url, $handler) = @_;

	my $html;
	my $users = &$handler($html);
	$self->{users}->add_list($users);
}

1;
