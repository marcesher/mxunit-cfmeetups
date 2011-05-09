<cffile action="read" file="#expandPath('CreateMYSQLDatabase.txt')#" variable="sql">

<cfquery datasource="Events" name="rebuild">
#preserveSingleQuotes(sql)#
</cfquery>

<cfinclude template="loadData.cfm" >