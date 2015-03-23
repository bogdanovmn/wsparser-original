
<table class=pages <TMPL_IF width>style='width:<TMPL_VAR width>px'</TMPL_IF>>
<tr>
<TMPL_IF no_empty>
<td class=pages_navigation><span class=note>Страницы:&nbsp;&nbsp;</span>
<TMPL_IF prev_page>
	<a href='<TMPL_VAR uri>page<TMPL_VAR prev_page>.html'>< сюда</a> |
</TMPL_IF>

<TMPL_IF many>

	<TMPL_IF first>
		<a href='<TMPL_VAR uri>page1.html'>1</a>
		<a href='<TMPL_VAR uri>page<TMPL_VAR left_jump>.html'>...</a>
	</TMPL_IF>

	<TMPL_LOOP left>
		<a href='<TMPL_VAR p_uri>page<TMPL_VAR page>.html'><TMPL_VAR page></a>
	</TMPL_LOOP>

	<b><TMPL_VAR current_page></b>

	<TMPL_LOOP right>
		<a href='<TMPL_VAR p_uri>page<TMPL_VAR page>.html'><TMPL_VAR page></a>
	</TMPL_LOOP>

	<TMPL_IF last>
		<a href='<TMPL_VAR uri>page<TMPL_VAR right_jump>.html'>...</a>
		<a href='<TMPL_VAR uri>page<TMPL_VAR last>.html'><TMPL_VAR last></a>
	</TMPL_IF>

<TMPL_ELSE>

	<TMPL_LOOP left>
		<a href='<TMPL_VAR p_uri>page<TMPL_VAR page>.html'><TMPL_VAR page></a>
	</TMPL_LOOP>

	<b><TMPL_VAR current_page></b>

	<TMPL_LOOP right>
		<a href='<TMPL_VAR p_uri>page<TMPL_VAR page>.html'><TMPL_VAR page></a>
	</TMPL_LOOP>

</TMPL_IF>

<TMPL_IF next_page>
	| <a href='<TMPL_VAR uri>page<TMPL_VAR next_page>.html'>туда ></a>
</TMPL_IF>

<TMPL_ELSE>
	<td class=pages_empty>&nbsp;
</TMPL_IF>

<TMPL_IF show_pages_count>
	<td class=pages_rows_count>Записей: <TMPL_VAR rows_count>
</TMPL_IF>

</table>
