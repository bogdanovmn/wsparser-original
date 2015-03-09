package WebSiteParser;

use strict;
use warnings;
use utf8;

use WebSiteParser::Users;
use WebSiteParser::Posts;
use WebSiteParser::DB;
use WebSiteParser::Logger;

sub new {
	my ($class, %p) = @_;

	my $self = {
		site     => $p{site},
		url_base => 'http://'. $p{site},
		users    => WebSiteParser::Users->new,
		posts    => WebSiteParser::Posts->new,
	};

	return bless $self, $class;
}

sub get_users {
	my ($self, $url, $handler) = @_;

	logger->info('get users start');
	
	my $html = '';

	logger->debug('url: '. $self->{url_base}. $url);
	logger->debug('handler: '. $handler);

	my $users = &$handler($html);
	$self->{users}->add_list($users);
}

1;
