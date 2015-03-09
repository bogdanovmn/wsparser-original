package WebSiteParser::Config;

use strict;
use warnings;
use utf8;

use Config::Simple;
use FindBin;
use Utils;

use Exporter;
our @ISA    = qw( Exporter );
our @EXPORT = qw( config_db config );

my $__CONFIG;

sub _get_config {
	my ($type) = @_;

	unless ($__CONFIG) {
		my $etc_dir = $FindBin::Bin. '/../etc';
		$__CONFIG->{db}     = Config::Simple->new($etc_dir.'/db')     or die "can't open $etc_dir/db config: $!";
		$__CONFIG->{common} = Config::Simple->new($etc_dir.'/common') or die "can't open $etc_dir/common config: $!";
	}
	return $__CONFIG->{$type};
}

sub config_db {
	return _get_config('db');
}

sub config {
	return _get_config('common');
}

1;
