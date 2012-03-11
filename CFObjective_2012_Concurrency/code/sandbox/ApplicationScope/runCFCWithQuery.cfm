
<cfif not structKeyExists( application, "cfcWithQuery" )>
	<cfset application.cfcWithQuery = new VarScopeProblems()> 
</cfif>

<cfset id = randRange(1, 15)>

<cfset result = application.cfcWithQuery.getArtist(id)>

<cfoutput>
	
	Found artist  with ID #result.artistid#, first name #result.firstName#
	
</cfoutput>