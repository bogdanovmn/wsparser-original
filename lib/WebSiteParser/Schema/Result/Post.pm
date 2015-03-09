use utf8;
package WebSiteParser::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("post");
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
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("url", ["url"]);
__PACKAGE__->might_have(
  "post_html",
  "WebSiteParser::Schema::Result::PostHtml",
  { "foreign.post_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);
__PACKAGE__->belongs_to(
  "user",
  "WebSiteParser::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-09 23:39:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C0wlEi77s9LuYMNnkdvlww


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->result_class('DBIx::Class::ResultClass::HashRefInflator');
1;
