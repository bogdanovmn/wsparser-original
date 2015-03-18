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
		site           => schema->resultset('Site')->search({ host => $host })->first,
		users_list_url => $p{users_list_url}
	};

	unless ($self->{users_list_url}) {
		die 'users list url not defined!';
	}

	unless ($self->{site}) {
		$self->{site} = schema->resultset('Site')->create({ host => $host });
	}
	
	$self->{users} = WebSiteParser::Users->new(site => $self->{site});
	$self->{posts} = WebSiteParser::Posts->new(site => $self->{site});

	return bless $self, $class;
}

sub _posts { $_[0]->{posts} }
sub _users { $_[0]->{users} }

sub full_parse {
	my ($self) = @_;

	$self->_get_users;
	$self->_get_users_pages;
	$self->_process_users_pages;
	
	#$self->_get_posts_pages_fast;
	$self->_get_posts_pages;
	$self->_process_posts_pages;
}

sub _abs_url {
	my ($self, $url) = @_;

	return sprintf 'http://%s%s', $self->{site}->host, $url;
}

sub _get_users {
	my ($self) = @_;

	logger->info('get users list');
	
	my $html = download($self->_abs_url($self->{users_list_url}));
	if ($html) {
		logger->info('parse users list');
		my $users = $self->_parse_users_list($html);

		logger->info('add users to database');
		$self->_users->add_list($users);
	}
	else {
		logger->error('get users page error');
	}
}

sub _get_users_pages {
	my ($self, $handler) = @_;

	logger->info('get users pages');

	my $users = $self->_users->without_html;
	if ($users->count) {
		while (my $user = $users->next) {
			my $html = download($self->_abs_url($user->url));
			
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
	else {
		logger->info('all users already with html');
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
			logger->trace('parse info');
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
			logger->trace('parse posts list');
			my $list = $self->_parse_user_posts_list($user_html->html);
			if (ref $list eq 'ARRAY') {
				logger->info(sprintf 'found %d posts links', scalar @$list);
				foreach my $url (@$list) {
					if (schema->resultset('Post')->search({user_id => $user->id, url => $url })->single) {
						logger->trace(sprintf 'post link already exists: user_id=%d, url=%s', $user->id, $url);
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

sub _get_posts_pages {
	my ($self) = @_;

	logger->info('get posts pages');
	my $i = 0;
	while (my $posts = $self->_posts->without_html) {
		logger->info(sprintf 'get pack of posts without html (iter #%d, reminded: %d)', ++$i, $posts->{total});
		while (my $post = $posts->{resultset}->next) {
			my $html = download($self->_abs_url($post->url));
			if ($html) {
				$self->_posts->add_html($post, $html);
			}
			else {
				logger->error('get post page error');
			}
		}
	}

}

sub _get_posts_pages_fast {
	my ($self) = @_;

	logger->info('get posts pages fast');
	my $i = 0;
	while (my $posts = $self->_posts->without_html(10)) {
		logger->info(sprintf 'get pack of posts without html (iter #%d, reminded: %d)', ++$i, $posts->{total});
		my %url_post;
		while (my $post = $posts->{resultset}->next) {
			$url_post{$self->_abs_url($post->url)} = $post;
		}

		my $html_data = download_fast([ keys %url_post ]);
		while (my ($abs_url, $html) = each %$html_data) {
			if ($html) {
				$self->_posts->add_html($url_post{$abs_url}, $html);
			}
			else {
				logger->error('get post page error: '. $abs_url);
			}
		}
	}

}
sub _process_posts_pages {
	my ($self) = @_;

	logger->info('process posts data');

	my $i = 0;
	while (my $posts = $self->_posts->not_processed) {
		logger->info(sprintf 'get pack of not processed posts (iter #%d, reminded: %d)', ++$i, $posts->{total});
		while (my $post = $posts->{resultset}->next) {
			logger->trace(sprintf 'parse post info, id=%d', $post->id);
			my $html = schema->resultset('PostHtml')->find($post->id)->html;
			if ($html) {
				my $data = $self->_parse_post_data($html);
				if (ref $data eq 'HASH' and $data->{name} and $data->{body}) {
					logger->trace(
						sprintf 'parse success: %s', 
							join(', ', sort grep { $data->{$_} } keys %$data)
					);

					logger->trace('update post data');
					$post->update({
						name      => $data->{name},
						body      => $data->{body},
						post_date => $data->{post_date},
					});
				}
				else {
					logger->warn(
						sprintf 'parse failed (%s): post_id=%d, user_id=%d, url=%s', 
							join(', ', sort grep { not $data->{$_} } keys %$data),
							$post->id, $post->user_id, $post->url
					);
					$post->update({ parse_failed => 1 });
				}
			}
			else {
				logger->error('get stored html error');
			}
		}
	}
}

1;
