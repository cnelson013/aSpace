<table>
<tr>
	<td>ID</td>
	<td>Name</td>
	<td>created</td>
	<td>updated</td>
</tr>
<cfoutput query="myResult">
<tr>
	<td>#ID#</td>
	<td title="#Info#"><a href="https://www.assembla.com/wiki/show/#Name#">#Name#</a></td>
	<td nowrap="true">#lsDateFormat(listFirst(createdAt,'T'),'DD.MM.YYYY')# #lsTimeFormat(left(listLast(createdAt,'T'),8),'HH:MM')#&nbsp;&nbsp;</td>
	<td nowrap="true">#lsDateFormat(listFirst(updatedAt,'T'),'DD.MM.YYYY')# #lsTimeFormat(left(listLast(updatedAt,'T'),8),'HH:MM')#</td>
</tr>
</cfoutput>
</table>