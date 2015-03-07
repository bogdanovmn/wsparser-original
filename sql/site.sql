CREATE TABLE site (

	id                 smallint unsigned NOT NULL AUTO_INCREMENT,
	host               varchar(250)      NOT NULL,
	create_date        timestamp         NOT NULL,
	last_user_download timestamp         NOT NULL DEFAULT 0,
	last_post_download timestamp         NOT NULL DEFAULT 0,
	
	PRIMARY KEY (id)
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='site for parse description'
