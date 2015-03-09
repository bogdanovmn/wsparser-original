use utf8;
package WebSiteParser::Schema::Result::PostHtml;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("post_html");
__PACKAGE__->add_columns(
  "post_id",
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
__PACKAGE__->set_primary_key("post_id");
__PACKAGE__->belongs_to(
  "post",
  "WebSiteParser::Schema::Result::Post",
  { id => "post_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-09 23:39:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pBNfXJpAe28LHroMEONW6A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
