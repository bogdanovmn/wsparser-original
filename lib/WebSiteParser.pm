package WebSiteParser;

use strict;
use warnings;
use utf8;

use WebSiteParser::Users;
use WebSiteParser::Posts;
use WebSiteParser::DB;
use WebSiteParser::Logger;
use WebSiteParser::Downloader;
use Utils;


sub new {
	my ($class, %p) = @_;

	my $host = $p{host};
	my $self = {
		site => schema->resultset('Site')->search({ host => $host })->first
	};

	unless ($self->{site}) {
		schema->resultset('Site')->create({ host => $host });
		$self->{site} = schema->resultset('Site')->find(schema->storage->dbh->last_insert_id);
	}
	
	$self->{users} = WebSiteParser::Users->new(site_id => $self->{site}->id);
	$self->{posts} = WebSiteParser::Posts->new(site_id => $self->{site}->id);

	return bless $self, $class;
}

sub abs_url {
	my ($self, $url) = @_;

	return sprintf 'http://%s%s', $self->{site}->host, $url;
}

sub get_users {
	my ($self, $url, $handler) = @_;

	logger->info('get users list');
	
	my $html = download($self->abs_url($url));
	if ($html) {
		logger->info('parse users list');
		my $users = &$handler($html);

		logger->info('add users to database');
		$self->{users}->add_list($users);
	}
	else {
		logger->error('get users page error');
	}
}

sub get_users_pages {
	my ($self, $handler) = @_;

	logger->info('get users pages start');

	my $users = schema->resultset('User')->search({ name => undef });

	while (my $user = $users->next) {
		my $html = download($self->abs_url($user->url));
		
		if ($html) {
			schema->resultset('UserHtml')->create({
				user_id => $user->id,
				html    => $html
			});
		}
		else {
			logger->error('get users page error');
		}
	}
}
1;
