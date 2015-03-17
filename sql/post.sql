CREATE TABLE post (

	id            smallint unsigned NOT NULL AUTO_INCREMENT,
	user_id       smallint unsigned NOT NULL,
	url           varchar(250)      NOT NULL UNIQUE,
	name          varchar(250)      DEFAULT NULL,
	body          text              DEFAULT NULL,
	post_date     datetime          DEFAULT NULL,
	parse_failed  tinyint unsigned  NOT NULL DEFAULT 0,
	updated       timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (id),

	KEY i_post__user_id (user_id),

	FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='post parsed data';

