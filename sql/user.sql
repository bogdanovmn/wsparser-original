CREATE TABLE user (

	id          smallint unsigned NOT NULL AUTO_INCREMENT,
	site_id     smallint unsigned NOT NULL,
	url         varchar(250)      NOT NULL UNIQUE,
	reg_date    datetime          DEFAULT NULL,
	edit_date   datetime          DEFAULT NULL,
	name        varchar(250)      DEFAULT NULL,
	about       text              DEFAULT NULL,
	sex         tinyint unsigned  NOT NULL DEFAULT '0',
	email       varchar(250)      DEFAULT NULL,
	region      varchar(250)      DEFAULT NULL,
	updated     timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (id),

	KEY i_user__site_id (site_id),

	FOREIGN KEY (site_id) REFERENCES site (id) ON DELETE CASCADE
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='user parsed data'
