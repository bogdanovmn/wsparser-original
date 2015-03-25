package WSParserApp::Action::User::View;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;
use Utils;


sub main {
	my ($self) = @_;

	my $user  = schema->resultset('User')->find($self->params->{user_id});
	my $site  = schema->resultset('Site')->find($user->site_id);
	my @posts = schema->resultset('Post')->search(
		{ user_id => $user->id },
		{ 
			order_by     => 'post_date',
			columns      => [qw| id name parse_failed url post_date |],
			AS_HASH
		}
	)->all;

	return {
		name      => $user->name,
		id        => $user->id,
		reg_date  => $user->reg_date,
		edit_date => $user->edit_date,
		about     => $user->about,
		region    => $user->region,
		email     => $user->email,
		posts     => \@posts,
		site_id   => $site->id,
		site_name => $site->host,
	};
}

1;
