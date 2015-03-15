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

sub full_parse {
	my ($self) = @_;

	$self->_get_users;
	$self->_get_users_pages;
	$self->_process_users_pages;
	
	$self->_get_posts_pages;
	$self->_process_posts_pages;
}

sub abs_url {
	my ($self, $url) = @_;

	return sprintf 'http://%s%s', $self->{site}->host, $url;
}

sub _get_users {
	my ($self, $url) = @_;

	logger->info('get users list');
	
	my $html = download($self->abs_url($url));
	if ($html) {
		logger->info('parse users list');
		my $users = $self->_parse_users_list($html);

		logger->info('add users to database');
		$self->{users}->add_list($users);
	}
	else {
		logger->error('get users page error');
	}
}

sub _get_users_pages {
	my ($self, $handler) = @_;

	logger->info('get users pages');

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

sub _process_users_pages {
	my ($self) = @_;

	logger->info('process users pages');
	my $users = schema->resultset('User')->search({ site_id => $self->{site}->id, name => undef });

	while (my $user = $users->next) {
		logger->debug('process user_id='. $user->id);
		my $user_html = schema->resultset('UserHtml')->find($user->id);
		if ($user_html) {
			#
			# User info
			#
			logger->debug(sprintf 'parse info');
			my $info = $self->_parse_user_info($user_html->html);
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
			#
			# User posts list
			#
			logger->debug(sprintf 'parse posts list');
			my $list = $self->_parse_user_posts_list($user_html->html);
			if (ref $list eq 'ARRAY' and $list->{name}) {
				logger->info(sprintf 'found %d posts links', scalar @$list);
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
				logger->warn('parse failed');
			}
		}
	}
}

sub _get_post_pages {
	my ($self) = @_;

	logger->info('get posts pages');
	my $posts = schema->resultset('Post')->search(
		{ 
			'users.site_id' => $self->{site}->id, 
			name => undef 
		},
		{ join => 'users' }
	);

	while (my $post = $posts->next) {
	}

}
sub _process_posts_data {
	my ($self) = @_;

	logger->info('fetch data from users posts pages');
	my $posts = schema->resultset('Post')->search(
		{ 
			'users.site_id' => $self->{site}->id, 
			name => undef 
		},
		{ join => 'users' }
	);

	while (my $post = $posts->next) {
		my $post_html = schema->resultset('PostHtml')->find($post->id);
		if ($post_html) {
			logger->debug(sprintf 'parse post info, id=%d', $post->id);
			my $data = $self->_parse_post_data($post_html->html);
			if (ref $data eq 'HASH' and $data->{name}) {
				logger->debug(
					sprintf 'parse success: %s', 
						join(', ', sort grep { $data->{$_} } keys %$data)
				);
				$post->update({
					name      => $data->{name},
					body      => $data->{body},
					post_date => $data->{post_date},
				});
			}
			else {
				logger->warn('parse failed');
			}
		}
	}
}

1;
