package WSParserApp::Action::Post::ViewAll;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;

sub main {
	my ($self) = @_;

	my @posts = schema->resultset('Post')->search(
		{ user_id  => $self->params->{user_id} },
		{ AS_HASH }
	)->all;

	if (@posts) {
		my $user = schema->resultset('User')->find($self->params->{user_id});
		my $site = schema->resultset('Site')->find($user->site_id);
		return {
			posts     => \@posts,
			user_name => $user->name,
			user_id   => $user->id,
			site_id   => $user->site_id,
			site_host => $site->host,
		}
	}
}

1;
