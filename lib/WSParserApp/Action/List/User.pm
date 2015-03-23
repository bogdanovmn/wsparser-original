package WSParserApp::Action::List::User;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;
use Utils;


sub main {
	my ($self) = @_;

	return {
		user_list_by_letter_groups => $self->_by_letter($self->params->{site_id})
	};
}

sub _by_letter {
	my ($self, $site_id) = @_;

	my %result  = (rus => [], eng => []);
	my %letters = (rus => [], eng => []);
	my %users_count;
	my $letter_groups = {};
	
	my $users = schema->resultset('User')->search({ site_id => $site_id });
	
	while (my $user = $users->next) {
		my $char = substr($user->name, 0, 1);
		my $type = $char =~ /[а-я]/i ? 'rus' : 'eng';

		unless (exists $letter_groups->{$type}->{$char}) {
			push @{$letters{$type}}, $char;
		}
		push @{$letter_groups->{$type}->{$char}}, { name => $user->name, id => $user->id };
		$users_count{$type}++;
	}

	my $groups_count       = 5;
	my $letter_header_size = 3;
	
	foreach my $type (qw| rus eng |) {
		my $group_size = int(($users_count{$type} + $letter_header_size*@{$letters{$type}}) / $groups_count) 
			+ 2*$letter_header_size;
		
		my $current_group_index = 0;
		my $current_group_size  = 0;
		for my $l (@{$letters{$type}}) {
			my $letter_size = scalar @{$letter_groups->{$type}->{$l}} + $letter_header_size;
			if (
				$current_group_size + $letter_size > $group_size and 
				($current_group_index + 1) < $groups_count
			) {
				$current_group_index++;
				$current_group_size = 0;
			}
			push @{$result{$type}->[$current_group_index]->{letters}}, {
				letter => $l, 
				users  => $letter_groups->{$type}->{$l} 
			};
			$current_group_size += $letter_size;
		}
	}
	
	return [
		{ title => 'RUS', data  => $result{rus} },
		{ title => 'ENG', data  => $result{eng} }
	];
}
1;
