package WebSiteParser::Users;

use strict;
use warnings;
use utf8;

use WebSiteParser::Schema;

use base 'WebSiteParser::Abstract';


sub new {
	my ($class, %p) = @_;

	my $self = {
	};
		
	return bless $self, $class;
}
	
sub add_list {
	my ($self, $list) = @_;

	foreach my $u (@$users) {
		schema->resultset('User')->create({
			name => $u->{name},
			url  => $u->{url}
		});
	}

}
1;
