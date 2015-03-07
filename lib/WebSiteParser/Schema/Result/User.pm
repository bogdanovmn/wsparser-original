use utf8;
package WebSiteParser::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WebSiteParser::Schema::Result::User - user parsed data

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 site_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 url

  data_type: 'varchar'
  is_nullable: 0
  size: 250

=head2 reg_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 edit_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=head2 about

  data_type: 'text'
  is_nullable: 1

=head2 sex

  data_type: 'tinyint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "site_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "reg_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "edit_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 250 },
  "about",
  { data_type => "text", is_nullable => 1 },
  "sex",
  {
    data_type => "tinyint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 250 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 250 },
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

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<url>

=over 4

=item * L</url>

=back

=cut

__PACKAGE__->add_unique_constraint("url", ["url"]);

=head1 RELATIONS

=head2 posts

Type: has_many

Related object: L<WebSiteParser::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "WebSiteParser::Schema::Result::Post",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 site

Type: belongs_to

Related object: L<WebSiteParser::Schema::Result::Site>

=cut

__PACKAGE__->belongs_to(
  "site",
  "WebSiteParser::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);

=head2 user_html

Type: might_have

Related object: L<WebSiteParser::Schema::Result::UserHtml>

=cut

__PACKAGE__->might_have(
  "user_html",
  "WebSiteParser::Schema::Result::UserHtml",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-08 00:15:02
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KrVB0G9OglDBhfGzLtY3ng


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
