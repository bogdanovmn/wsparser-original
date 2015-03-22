package WebSiteParser::Posts;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;
use Utils;

sub new {
	my ($class, %p) = @_;

	my $self = {
		site => $p{site}
	};
		
	return bless $self, $class;
}
	
sub add_list {
	my ($self, $posts) = @_;

	foreach my $p (@$posts) {
		schema->resultset('Post')->create({
			user_id => $p->{user_id},
			url     => $p->{url}
		});
	}

}

sub without_html_count {
	my ($self, $count) = @_;
	
	return schema->resultset('Post')->search(
		{ 
			'user.site_id'      => $self->{site}->id,
			'post_html.post_id' => undef
		},
		{ 
			join   => ['user', 'post_html'],
		}
	)->count;
}

sub without_html {
	my ($self, $count) = @_;

	my $total = $self->without_html_count;
	return $total
		? {
			total     => $total,
			resultset => scalar schema->resultset('Post')->search(
				{ 
					'user.site_id'      => $self->{site}->id,
					'post_html.post_id' => undef
				},
				{ 
					join => ['user', 'post_html'],
					rows => $count || 100,
					page => 1
				}
			)
		}
		: undef;
}

sub not_processed_count {
	my ($self) = @_;

	return schema->resultset('Post')->search(
		{ 
			parse_failed        => 0,
			'user.site_id'      => $self->{site}->id, 
			'post_html.post_id' => { '!=' => undef },
			-or => {
				'me.name' => undef,
				'me.body' => undef
			}
		},
		{ 
			join => ['post_html', 'user'] 
		}
	)->count;
}

sub not_processed {
	my ($self, $count) = @_;

	my $total = $self->not_processed_count;
	return $total
		? {
			total     => $total,
			resultset => scalar schema->resultset('Post')->search(
				{ 
					parse_failed        => 0,
					'user.site_id' => $self->{site}->id, 
					'post_html.post_id' => { '!=' => undef },
					-or => {
						'me.name' => undef,
						'me.body' => undef
					}
				},
				{ 
					join => ['post_html', 'user'],
					rows => $count || 100,
					page => 1
				}
			)
		}
		: undef;
}

sub add_html {
	my ($self, $post, $html) = @_;

	schema->resultset('PostHtml')->create({
		post_id => $post->id,
		html    => Utils::trim_html($html)
	});
}

1;
