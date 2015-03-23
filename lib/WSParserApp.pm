package WSParserApp;

use strict;
use warnings;
use utf8;

use Dancer ':syntax';
use Dancer::Plugin::Controller '0.152';

our $VERSION = '0.1';

use WSParserApp::Action::Index;

use WSParserApp::Action::List::User;
use WSParserApp::Action::List::Post;

use WSParserApp::Action::User::View;
use WSParserApp::Action::Post::View;

get '/'       => sub { controller(template => 'index', action => 'Index') };
get '/users/' => sub { controller(template => 'users', action => 'List::User') };
get '/posts/' => sub { controller(template => 'posts', action => 'List::Post') };
get '/user/'  => sub { controller(template => 'user' , action => 'User::View') };
get '/post/'  => sub { controller(template => 'post' , action => 'Post::View') };

any qr{.*}    => sub { controller(template => 'not_found') };

true;