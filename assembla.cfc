<cfcomponent output="false" hint="">

<cffunction name="init" returntype="assembla" access="public" hint="als Konstruktor der Klasse die Vorgabewerte setzen" output="false">
  <cfargument name="configfile"	type="string" required="false" default="#getDirectoryFromPath(getCurrentTemplatePath())#config/#listFirst(getFileFromPath(getCurrentTemplatePath()),'.')#.ini" hint="Pfad zur INI-Datei" />

	<cfloop collection="#arguments#" item="myArg">	<!--- alle Argumente als Objektvariablen setzen --->
		<cfset variables.instance[myArg] = arguments[myArg] />
	</cfloop>
	<cfset variables.instance['config'] = loadConfigFile(arguments.configfile) />

	<cfreturn this />
</cffunction>


<cffunction name="getSpaces" returntype="any" access="public" output="false" hint="">
	<cfargument name="url"			type="string" required="true" hint="" />
	<cfargument name="username" type="string" required="true" hint="" />
	<cfargument name="password" type="string" required="true" hint="" />
	<cfargument name="owned"		type="string" required="false" default="false" hint="Nur meine eigenen Projekte" />

	<cfset var myResult = structNew() />
	<cfset var mySpace	= "" />

	<cfhttp url="#arguments.url#" method="get" username="#arguments.username#" password="#arguments.password#" result="myResult.content">
		<cfhttpparam type="header" name="Accept" value="application/xml" />
	</cfhttp>
	<cfset myResult.xml = xmlParse(myResult.content.fileContent) />

	<cfset myResult.data = queryNew('ID,Name,Info,Alias,Owned,createdAt,updatedAt') />

	<cfloop from="1" to="#arrayLen(myResult.xml.xmlRoot.xmlChildren)#" index="mySpace">
		<cfset queryAddRow(myResult.data) />
		<cfset querySetCell(myResult.data,'ID',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[5].xmlText) />
		<cfset querySetCell(myResult.data,'Name',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[9].xmlText) />
		<cfset querySetCell(myResult.data,'Info',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[4].xmlText) />
		<cfset querySetCell(myResult.data,'Alias',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[15].xmlText) />
		<cfset querySetCell(myResult.data,'Owned',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[1].xmlText) />
		<cfset querySetCell(myResult.data,'createdAt',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[2].xmlText) />
		<cfset querySetCell(myResult.data,'updatedAt',myResult.xml.xmlRoot.xmlChildren[mySpace].xmlChildren[13].xmlText) />
	</cfloop>
	
	<cfreturn myResult.data />
</cffunction>


<cffunction name="getData" returntype="query" access="public" output="false" hint="">
	<cfargument name="action"		type="string" required="true"  hint="" />
	<cfargument name="url"			type="string" required="false" hint="" />
	<cfargument name="username" type="string" required="false" hint="" />
	<cfargument name="password" type="string" required="false" hint="" />

	<cfset var myResult = "" />
	<cfinvoke component="#this#" method="#arguments.action#" argumentcollection="#arguments#" returnvariable="myResult" />

	<cfreturn myResult />
</cffunction>


<!--- CFC-Basis --->
<cffunction name="getServerName" returntype="string" access="public" output="false" hint="Liefert den Namen der akt. Machine">
	<cfreturn listFirst(createObject('java','java.net.InetAddress').getLocalHost().getHostName(),'/') />
</cffunction>


<cffunction name="getConfig" returntype="any" access="public" hint="liest einen Wert oder Section aus der Configuration">
  <cfargument name="myField" type="string" required="true" hint="Wert aus der 'INI-Datei' bzw. diesem Objekt lesen">

  <cfreturn evaluate('variables.instance.config.#arguments.myField#') />
</cffunction>


<cffunction name="loadConfigFile" returntype="struct" access="public" output="false" hint="liest alle Daten die zur Navigation notwendig sind">
  <cfargument name="iniFile" type="string" required="true" hint="Pfad zur INI-Datei" />

  <cfset var struct   = structNew() />
  <cfset var myFile   = arguments.iniFile />
  <cfset var sections = getProfileSections(myFile) />

  <cfset var section  = "" />
  <cfset var entry    = "" />

  <cfloop collection="#sections#" item="section">
    <cfset myStruct[section] = structNew() />
    <cfloop list="#sections[section]#" index="entry">
      <cfset struct[section][entry] = getProfileString(myFile,section,entry) />
    </cfloop>
  </cfloop>

  <cfreturn struct />
</cffunction>


<cffunction name="getInstanceData" returntype="struct" access="public" hint="zur Anzeige der akt. Objekt-Variablen">
  <cfreturn variables.instance />
</cffunction>

</cfcomponent>