<cffile action="read" file="#expandPath('insertdata.sql')#" variable="sql">

<cfloop list="#trim(sql)#" index="idx" delimiters=";">
	
	<cfquery name="ins" datasource="UnitTest">
	<cfoutput>#trim(preserveSingleQuotes(idx))#</cfoutput>  
	</cfquery>

</cfloop>