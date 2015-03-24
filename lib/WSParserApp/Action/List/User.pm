package WSParserApp::Action::List::User;

use strict;
use warnings;
use utf8;

use WebSiteParser::DB;
use Utils;


sub main {
	my ($self) = @_;

	my $site  = schema->resultset('Site')->find($self->params->{site_id});
	my $users = schema->resultset('User')->search(
		{ 
			site_id => $self->params->{site_id},
			name    => { '!=' => undef }
		},
		{
			columns  => [qw| id name reg_date |],
			order_by => 'reg_date'
		}
	);

	return {
		site_name                  => $site->host,
		$users
			? (
				user_list_by_letter_groups => $self->_by_letter($users),
				users_by_reg_date          => $self->_by_date($users),
			)
			: ()
	};
}

sub _by_date {
	my ($self, $users) = @_;

	$users->reset;

	my @result;
	my $prev_date = '';
	while (my $user = $users->next) {
		my ($date) = split / /, $user->reg_date || '';
		$date ||= '???';

		my $group     = 0;
		my $show_date = 1;
		if ($prev_date eq $date) {
			$group = 1;
			$result[-1]->{group} = $group;
			$show_date = 0;
		}

		push @result, {
			id        => $user->id,
			name      => $user->name,
			reg_date  => $date,
			show_date => $show_date,
			group     => $group,
		};
		$prev_date = $date;
	}

	return \@result;
}

sub _by_letter {
	my ($self, $users) = @_;

	my %result  = (rus => [], eng => [], other => []);
	my %letters = (rus => [], eng => [], other => []);
	my %users_count;
	my $letter_groups = {};
	
	
	while (my $user = $users->next) {
		my $char = uc substr($user->name, 0, 1);
		my $type = 'other';
		if ($char =~ /[а-я]/i) {
			$type = 'rus';
		}
		elsif ($char =~/[a-z]/i) {
			$type = 'eng';
		}

		unless (exists $letter_groups->{$type}->{$char}) {
			push @{$letters{$type}}, $char;
		}
		push @{$letter_groups->{$type}->{$char}}, { name => $user->name, id => $user->id };
		$users_count{$type}++;
	}

	my $groups_count       = 5;
	my $letter_header_size = 5;
	
	foreach my $type (qw| rus eng other |) {
		my $group_size = int(($users_count{$type} + $letter_header_size*@{$letters{$type}}) / $groups_count) 
			+ 2*$letter_header_size;
		
		my $current_group_index = 0;
		my $current_group_size  = 0;
		for my $l (sort @{$letters{$type}}) {
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
		{ title => 'ENG', data  => $result{eng} },
		{ title => 'OTHER', data  => $result{other} },
	];
}
1;
