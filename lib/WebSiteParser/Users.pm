package WebSiteParser::Users;

use strict;
use warnings;
use utf8;

use base 'WebSiteParser::Abstract';


sub new {
	my ($class, %p) = @_;

	my $self = {
		action => {
			get_list => $p{get_list},
		}
	};
		
	return bless $self, $class;
}

sub parse {
	my ($self) = @_;

	$self->_get_list;
	$self->_get_pages;
	$self->_parse_pages;
}

sub _get_list {
}

sub _get_pages {
}

sub _parse_pages {
}

sub _parse_page {
}

1;
