
<cfif not structKeyExists( application, "cfcWithLoop" )>
	<cfset application.cfcWithLoop = new VarScopeProblems()> 
</cfif>

<cfset result = application.cfcWithLoop.runALoop(5)>

<cfoutput>
	
	result was #result#
	
</cfoutput>