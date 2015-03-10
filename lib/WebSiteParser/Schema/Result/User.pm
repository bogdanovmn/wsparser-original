use utf8;
package WebSiteParser::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("user");
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
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("url", ["url"]);
__PACKAGE__->has_many(
  "posts",
  "WebSiteParser::Schema::Result::Post",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "site",
  "WebSiteParser::Schema::Result::Site",
  { id => "site_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);
__PACKAGE__->might_have(
  "user_html",
  "WebSiteParser::Schema::Result::UserHtml",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-09 23:39:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5AEJBDDI9wQgdYyKAUcH/g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
#__PACKAGE__->result_class('DBIx::Class::ResultClass::HashRefInflator');

1;
