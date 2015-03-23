<h1>ПАЦИЭНТ<span class=letter>Ы</span></h1>

<table class=user_edit_menu>
<tr>
	<td id="m_diag" class=selected onclick="select_block('diag');">По диагнозу
	<td id="m_date" onclick="select_block('date');">По дате поступления
	<td id="m_letter" onclick="select_block('letter');">По алфавиту
</table>

<div class="user_list_open" id="diag">

	<table class=users>
	<tr>
	<td>
	<TMPL_IF rank_1>
		<h2 class=user_rank>Легенды Психуюшки</h2>
		<TMPL_LOOP rank_1>
			<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
		</TMPL_LOOP>
	</TMPL_IF>
	</table>

	<table class=users>
	<tr>
	<td>
		<TMPL_IF rank_2>
			<h2 class=user_rank>Шизофреники</h2>
			<TMPL_LOOP rank_2>
				<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
			</TMPL_LOOP>
		</TMPL_IF>
		<td>
		<TMPL_IF rank_3>
			<h2 class=user_rank>Пациэнты Фрейда</h2>
			<TMPL_LOOP rank_3>
				<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
			</TMPL_LOOP>
		</TMPL_IF>
		<td>
		<TMPL_IF rank_4>
			<h2 class=user_rank>Параноики</h2>
			<TMPL_LOOP rank_4>
				<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
			</TMPL_LOOP>
		</TMPL_IF>
	</table>

	<table class=users>
	<tr>
	<td>
	<TMPL_IF rank_5>
		<h2 class=user_rank>Тяжелый случай (нуждаются в срочной лоботомии)</h2>
		<TMPL_LOOP rank_5>
			<TMPL_IF ru_plagiarist><s></TMPL_IF>
			<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
			<TMPL_IF ru_plagiarist></s></TMPL_IF>
		</TMPL_LOOP>
	</TMPL_IF>
	</table>
	
	<table class=users>
	<tr>
	<td>
	<TMPL_IF rank_0>
		<h2 class=user_rank>Диагноз пока не ясен</h2>
		<TMPL_LOOP rank_0>
			<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
		</TMPL_LOOP>
	</TMPL_IF>
	<td>
	<TMPL_IF rank_100>
		<h2 class=user_rank>Сидят в очереди на сдачу анализов</h2>
		<TMPL_LOOP rank_100>
			<p><a href='/users/<TMPL_VAR ru_id>.html'><TMPL_VAR ru_name></a></p>
		</TMPL_LOOP>
	</TMPL_IF>
	</table>

</div>

<!-- by date -->

<div class=user_list id="date">
	<table class=user_list_by_reg_date>
		<TMPL_LOOP users_by_reg_date>
			<tr <TMPL_IF u_group>class=group</TMPL_IF>>
				<td class=date><TMPL_IF u_show_date><TMPL_VAR u_reg_date></TMPL_IF>
				<td class=name>
					<TMPL_IF u_plagiarist><s></TMPL_IF>
					<a href='/users/<TMPL_VAR u_id>.html'><TMPL_VAR u_name></a>
					<TMPL_IF u_plagiarist></s></TMPL_IF>
		</TMPL_LOOP>
	</table>
</div>

<!-- by letter -->

<div class=user_list id="letter">
	<TMPL_LOOP user_list_by_letter_groups>
		<h2><TMPL_VAR title></h2>
		<table class=user_list_by_letter>
			<tr>
				<TMPL_LOOP data>
					<td>
						<TMPL_LOOP ul_letters>
							<br>
							<span class=user_letter><TMPL_VAR ull_letter></span>
							<br><br>
							<TMPL_LOOP ull_users>
								<TMPL_IF u_plagiarist><s></TMPL_IF>
								<a href='/users/<TMPL_VAR u_id>.html'><TMPL_VAR u_name></a>
								<TMPL_IF u_plagiarist></s></TMPL_IF>
								<br>
							</TMPL_LOOP>
						</TMPL_LOOP>
				</TMPL_LOOP>
		</table>
	</TMPL_LOOP>
</div>

<script type="text/javascript">
function select_block(id) {
	var blocks = ['diag', 'date', 'letter'];
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
