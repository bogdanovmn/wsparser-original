<h1><a href="/user/<TMPL_VAR user_id>/"><TMPL_VAR user_name></a></h1>

<TMPL_LOOP posts>
	<h2>
	<TMPL_VAR name>, <TMPL_VAR post_date>
	[ <a href="http://<TMPL_VAR site_host><TMPL_VAR url>">original: <TMPL_VAR site_host><TMPL_VAR url></a> ]
	</h2>

	<p>
	<TMPL_VAR body ESCAPE=NONE>
	</p>
</TMPL_LOOP>
