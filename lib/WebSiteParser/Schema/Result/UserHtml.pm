use utf8;
package WebSiteParser::Schema::Result::UserHtml;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';
__PACKAGE__->table("user_html");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "smallint",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "html",
  { data_type => "mediumtext", is_nullable => 0 },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
  },
);
__PACKAGE__->set_primary_key("user_id");
__PACKAGE__->belongs_to(
  "user",
  "WebSiteParser::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-03-14 17:09:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mBLgrEyeDcjuEtzFMDkDig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
#__PACKAGE__->result_class('DBIx::Class::ResultClass::HashRefInflator');
1;
