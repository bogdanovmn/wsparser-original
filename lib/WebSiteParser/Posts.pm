package WebSiteParser::Posts;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;

use base 'WebSiteParser::Abstract';


sub new {
	my ($class, %p) = @_;

	my $self = {
	};
		
	return bless $self, $class;
}
	
sub add_list {
	my ($self, $posts) = @_;

	foreach my $p (@$posts) {
		schema->resultset('Post')->create({
			user_id => $p->{user_id},
			name    => $p->{name},
			url     => $p->{url}
		});
	}

}
1;
