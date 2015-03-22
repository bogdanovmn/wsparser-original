package WebSiteParser::Users;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;
use WebSiteParser::Logger;
use Utils;

sub new {
	my ($class, %p) = @_;

	my $self = {
		site => $p{site}
	};
		
	return bless $self, $class;
}
	
sub add_list {
	my ($self, $users) = @_;

	foreach my $u (@$users) {
		if (schema->resultset('User')->search({ site_id => $self->{site}->id, url => $u->{url} })->single) {
			logger->trace(sprintf 'user "%s" already exists, url link: %s', $u->{name}, $u->{url});
		}
		else {
			logger->debug(sprintf 'create user "%s", url link: %s', $u->{name}, $u->{url});
			schema->resultset('User')->create({
				url     => $u->{url},
				site_id => $self->{site}->id,
			});
		}
	}
}

sub without_html_count {
	my ($self, $count) = @_;
	
	return schema->resultset('User')->search(
		{ 
			'me.site_id'      => $self->{site}->id,
			'user_html.user_id' => undef
		},
		{ 
			join   => 'user_html',
		}
	)->count;
}

sub without_html {
	my ($self, $count) = @_;

	my $total = $self->without_html_count;
	return $total
		? {
			total     => $total,
			resultset => scalar schema->resultset('User')->search(
				{ 
					'me.site_id'      => $self->{site}->id,
					'user_html.user_id' => undef
				},
				{ 
					join => 'user_html',
					rows => $count || 100,
					page => 1
				}
			)
		}
		: undef;
}

sub add_html {
	my ($self, $user, $html) = @_;

	$html =~ s/\n|\r//g;

	schema->resultset('UserHtml')->create({
		user_id => $user->id,
		html    => Utils::trim_html($html)
	});
}
1;
