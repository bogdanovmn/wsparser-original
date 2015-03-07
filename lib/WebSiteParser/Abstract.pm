package WebSiteParser::Abstract;

use strict;
use warnings;
use utf8;


sub new {
	my ($class, %p) = @_;

	my $self = {};

	return bless $self, $class;
}

sub parse {
	my ($self) = @_;

	$self->_get_users_list;
	$self->_parse_users_list;

	$self->_process_users;
}

sub _preocess_users {
	my ($self) = @_;

	while (my $users = $self->_get_not_processed_users) {
		foreach $user (@$users) {
			$self->_process_
}

sub _get_users_list {
}

sub _get_user_posts_list {
}

sub _get_user_info {
}

sub _get_user_post_data {
}

sub _parse_user_post_data {
}

sub _parse_user_info {
}


1;
