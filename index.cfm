	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<cfparam name="local"					type="struct" default="#structNew()#" />
	<cfparam name="local.action"	type="string" default="" />
	
	<cfset structAppend(local,URL) />
	<cfset structAppend(local,FORM) />
	
	<cfset objAssembla = createObject('component','assembla').init() />
	<cfset structAppend(local,objAssembla.getInstanceData()) />

	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>aSpace - [assembla]</title>
	<link rel="stylesheet" media="screen" href="config/assembla.css">
</head>

<body>



</body>
</html>

<form action="index.cfm" method="post">
	<cfoutput>
	<select name="action" onchange="document.forms[0].submit();">
		<option value="">#objAssembla.getConfig('default.action')#</option>
		<cfloop list="#objAssembla.getConfig('system.modules')#" index="myAction">
			<option value="#myAction#" #iif(myAction IS local.action,de('selected'),de(''))#>#objAssembla.getConfig('#myAction#.name')#</option>
		</cfloop>
	</select>
	</cfoutput>
</form>


<cfif len(local.action)>
	<cfset myArgs = structNew() />
	<cfset structAppend(myArgs,objAssembla.getConfig('#local.action#')) />
	<cfset structAppend(myArgs,objAssembla.getConfig('security')) />

	<cfinvoke component="#objAssembla#" method="#local.action#" argumentcollection="#myArgs#" returnvariable="myResult" />
<cfelse>
	<cfdump var="#local#" label="debugInfo:assembla.ini" expand="true" />
	<cfabort>
</cfif>

<br /><cfinclude template="views/#local.action#.cfm" />