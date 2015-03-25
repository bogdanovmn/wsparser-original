CREATE TABLE user_html (

	user_id     int unsigned NOT NULL,
	html        mediumtext   NOT NULL,
	updated     timestamp    NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (user_id),
	
	FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='user raw data';

