<a href='/'>sites</a>
<h1>Users [ <TMPL_VAR site_name> ]</h1>

<table class=user_edit_menu>
<tr>
	<td id="m_date"   onclick="select_block('date');">По дате поступления
	<td id="m_letter" onclick="select_block('letter');" class=selected>По алфавиту
</table>

<!-- by date -->

<div class=user_list id="date">
	<table class=user_list_by_reg_date>
		<TMPL_LOOP users_by_reg_date>
			<tr <TMPL_IF group>class=group</TMPL_IF>>
				<td class=date>
					<TMPL_IF show_date><TMPL_VAR reg_date></TMPL_IF>
				<td class=name>
					<a href='/user/<TMPL_VAR id>/'><TMPL_VAR name></a>
		</TMPL_LOOP>
	</table>
</div>

<!-- by letter -->

<div class=user_list_open id="letter">
	<TMPL_LOOP user_list_by_letter_groups>
		<h2><TMPL_VAR title></h2>
		<table class=user_list_by_letter>
			<tr>
				<TMPL_LOOP data>
					<td>
						<TMPL_LOOP letters>
							<br>
							<span class=user_letter><TMPL_VAR letter></span>
							<br><br>
							<TMPL_LOOP users>
								<a href='/user/<TMPL_VAR id>/'><TMPL_VAR name></a>
								<br>
							</TMPL_LOOP>
						</TMPL_LOOP>
				</TMPL_LOOP>
		</table>
	</TMPL_LOOP>
</div>

<script type="text/javascript">
function select_block(id) {
	var blocks = ['date', 'letter'];
	for (var i = 0; i < blocks.length; i++) {
		if (blocks[i] == id) {
			document.getElementById(blocks[i]).style.display = "block";
			document.getElementById("m_" + blocks[i]).setAttribute("class", "selected");
		}
		else {
			document.getElementById(blocks[i]).style.display = "none";
			document.getElementById("m_" + blocks[i]).setAttribute("class", "");
		}
	}
}
</script>
