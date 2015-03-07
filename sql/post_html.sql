CREATE TABLE post_html (

	post_id  smallint unsigned NOT NULL,
	html     blob              NOT NULL,
	updated  timestamp         NOT NULL DEFAULT CURRENT_TIMESTAMP,
	
	PRIMARY KEY (post_id),
	
	FOREIGN KEY (post_id) REFERENCES post (id) ON DELETE CASCADE
	
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='post raw data';

