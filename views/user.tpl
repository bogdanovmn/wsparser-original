<h1>User [ <a href="/users/<TMPL_VAR site_id>/"><TMPL_VAR site_name></a> ]</h1>

<div class=user_info>
	<p>
		<b>Имя:</b>
		<br>
		<TMPL_VAR name>
		<br>
		<br>
		<TMPL_IF region>
			<b>Город:</b>
			<br>
			<TMPL_VAR region>
			<br>
			<br>
		</TMPL_IF>

		<TMPL_IF about>
			<b>О себе:</b>
			<br>
			<TMPL_VAR NAME=about>
			<br>
			<br>
		</TMPL_IF>

		<b>Дата регистрации:</b>
		<br>
		<TMPL_VAR reg_date>
		<br>
		<br>
		<TMPL_IF edit_date>
			<b>Дата изменения данных:</b>
			<br>
			<TMPL_VAR edit_date>
		</TMPL_IF>
	</p>
</div>


<TMPL_IF posts>
	<div class=user_posts>
	<table>
		<tr>
			<th class=date>Дата
			<th class=title>Название
	<TMPL_LOOP posts>
		<tr>
			<td class=date>
				<TMPL_VAR post_date>
			<td class=name>
				<TMPL_IF parse_failed>
					<TMPL_VAR name>
				<TMPL_ELSE>
					<a href="/post/<TMPL_VAR id>/"><TMPL_VAR name></a>
				</TMPL_IF>
	</TMPL_LOOP>
	</table>
	</div>
</TMPL_IF>

