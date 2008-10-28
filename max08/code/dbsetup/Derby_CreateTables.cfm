
<cfset drops = "drop table j_users_permissions,drop table permissions,drop table users">
<cfset dsn = "UnitTest">

<cfloop list="#drops#" delimiters="," index="d">
	<cftry>
		<cfquery datasource="#dsn#" name="q">
		#d#	
		</cfquery>
	<cfcatch></cfcatch>
	</cftry>
</cfloop>

<cffile action="read" file="#expandPath('Derby_CreateTables.sql')#" variable="statements">

<cfloop list="#statements#" delimiters=";" index="sql">
	<cfquery name="ins" datasource="#dsn#">
	#trim(preserveSingleQuotes(sql))#  
	</cfquery>
</cfloop>

