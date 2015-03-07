use utf8;
package WebSiteParser::Schema::Result::UserHtml;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WebSiteParser::Schema::Result::UserHtml - user raw data

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user_html>

=cut

__PACKAGE__->table("user_html");

=head1 ACCESSORS

=head2 user_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 html

  data_type: 'blob'
  is_nullable: 0

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "html",
  { data_type => "blob", is_nullable => 0 },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("user_id");

=head1 RELATIONS

=head2 user

Type: belongs_to

Related object: L<WebSiteParser::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "WebSiteParser::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-08 00:15:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dEjDEJSiM8Wmppvu8BcGYg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
