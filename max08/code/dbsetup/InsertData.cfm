<cffile action="read" file="#expandPath('insertdata.sql')#" variable="statements">
<cfset dsn = "UnitTest">

<cfloop list="#trim(statements)#" index="sql" delimiters=";">
	
	<cfquery name="ins" datasource="#dsn#">
	#trim(preserveSingleQuotes(sql))#
	</cfquery>

</cfloop>