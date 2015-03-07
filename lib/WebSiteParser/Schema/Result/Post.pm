use utf8;
package WebSiteParser::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

WebSiteParser::Schema::Result::Post - post parsed data

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<post>

=cut

__PACKAGE__->table("post");

=head1 ACCESSORS

=head2 id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'smallint'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 url

  data_type: 'varchar'
  is_nullable: 0
  size: 250

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 250

=head2 body

  data_type: 'text'
  is_nullable: 1

=head2 post_date

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

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
  "user_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "url",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 250 },
  "body",
  { data_type => "text", is_nullable => 1 },
  "post_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
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

=head2 post_html

Type: might_have

Related object: L<WebSiteParser::Schema::Result::PostHtml>

=cut

__PACKAGE__->might_have(
  "post_html",
  "WebSiteParser::Schema::Result::PostHtml",
  { "foreign.post_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QAz0DIA4+8jdoQb/EnrUFg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
