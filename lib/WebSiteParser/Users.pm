package WebSiteParser::Users;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;
use WebSiteParser::Logger;


sub new {
	my ($class, %p) = @_;

	my $self = {
		site_id => $p{site_id}
	};
		
	return bless $self, $class;
}
	
sub add_list {
	my ($self, $users) = @_;

	foreach my $u (@$users) {
		logger->debug(sprintf 'create user "%s", url link: %s', $u->{name}, $u->{url});

		schema->resultset('User')->create({
			name    => $u->{name},
			url     => $u->{url},
			site_id => $self->{site_id},
		});
	}
}

1;
