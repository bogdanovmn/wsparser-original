package WSParserApp::Action::Post::View;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;

sub main {
	my ($self) = @_;

	my $post = schema->resultset('Post')->search(
		{ 'me.id' => $self->params->{post_id} },
		{ prefetch => 'user' }
	)->single;


	if ($post) {
		my $site = schema->resultset('Site')->find($post->user->site_id);
		return {
			name => $post->name,
			date => $post->post_date,
			body => $post->body,
			url  => $post->url,
			user_name => $post->user->name,
			user_id   => $post->user->id,
			site_id   => $post->user->site_id,
			site_host => $site->host,
		}
	}
}

1;
