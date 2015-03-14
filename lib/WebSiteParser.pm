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
		$self->{site} = schema->resultset('Site')->create({ host => $host });
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

	my $users = schema->resultset('User')->search({ site_id => $self->{site}->id, name => undef });

	while (my $user = $users->next) {
		my $html = download($self->abs_url($user->url));
		
		if ($html) {
			logger->trace('store html to database');
			schema->resultset('UserHtml')->update_or_create({
				user_id => $user->id,
				html    => $html
			});
		}
		else {
			logger->error('get users page error');
		}
	}
}

sub fetch_users_info {
	my ($self, $html_handler) = @_;

	logger->info('fetch info from users pages');
	my $users = schema->resultset('User')->search({ site_id => $self->{site}->id, name => undef });

	while (my $user = $users->next) {
		my $user_html = schema->resultset('UserHtml')->find($user->id);
		if ($user_html) {
			logger->debug(sprintf 'parse user (id=%d) info', $user->id);
			my $info = &$html_handler($user_html->html);
			if (ref $info eq 'HASH' and $info->{name}) {
				logger->debug(
					sprintf 'parse success: %s', 
						join(', ', sort grep { $info->{$_} } keys %$info)
				);
				$user->update({
					name      => $info->{name},
					about     => $info->{about},
					region    => $info->{region},
					reg_date  => $info->{reg_date},
					edit_date => $info->{edit_date}
				});
			}
			else {
				logger->warn('parse failed');
			}
		}
	}
}

sub get_users_posts_list {
	my ($self, $html_handler) = @_;

	logger->info('get users posts list');

	my $users = schema->resultset('User')->search({ site_id => $self->{site}->id, name => { '!=' => undef }});

	while (my $user = $users->next) {
		my $user_html = schema->resultset('UserHtml')->find($user->id);
		if ($user_html) {
			logger->debug(sprintf 'parse user (id=%d) posts list', $user->id);
			my $list = &$html_handler($user_html->html);

			if (ref $list eq 'ARRAY' and @$list) {
				logger->info(sprintf 'for user_id=%d parsed %d posts links', $user->id, scalar @$list);
				foreach my $url (@$list) {
					if (schema->resultset('Post')->search({user_id => $user->id, url => $url })->single) {
						logger->debug(sprintf 'post link already exists: user_id=%d, url=%s', $user->id, $url);
					}
					else {
						logger->trace(sprintf 'store to database url=%s', $url);
						schema->resultset('Post')->create({
							user_id => $user->id,
							url     => $url,
						});
					}
				}
			}
			else {
				logger->warn('parse empty result');
			}
		}
	}
}
1;
