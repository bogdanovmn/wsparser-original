use utf8;
package WebSiteParser::Schema::Result::Site;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("site");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "host",
  { data_type => "varchar", is_nullable => 0, size => 250 },
  "create_date",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
  "last_user_download",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "last_post_download",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("host", ["host"]);
__PACKAGE__->has_many(
  "users",
  "WebSiteParser::Schema::Result::User",
  { "foreign.site_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-09 23:46:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vvp4DF6dkEqkoO7RJjR6ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
