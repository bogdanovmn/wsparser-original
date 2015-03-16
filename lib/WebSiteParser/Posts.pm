package WebSiteParser::Posts;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;


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
	
	return {
		count     => $self->without_html_count,
		resultset => schema->resultset('Post')->search(
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
	};
}

sub add_html {
	my ($self, $post, $html) = @_;

	schema->resultset('PostHtml')->create({
		post_id => $post->id,
		html    => $html
	});
}

1;
