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
		$self->{site} = schema->resultset('Site')->create({ host => $host })->first;
	}
	
	$self->{users} = WebSiteParser::Users->new(site_id => $self->{site}->{id});
	$self->{posts} = WebSiteParser::Posts->new(site_id => $self->{site}->{id});

	return bless $self, $class;
}

sub get_users {
	my ($self, $url, $handler) = @_;

	my $full_url = sprintf 'http://%s/%s', $self->{site}->{host}, $url;

	logger->info('get users start');
	
	my $html = download($full_url);
	if ($html) {
		my $users = &$handler($html);
		$self->{users}->add_list($users);
	}
	else {
		logger->error('get users page error');
	}
}

1;
