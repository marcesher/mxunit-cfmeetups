<cfinclude template="MakeBigList.cfm">
<cfset theArray = listToArray(thelist)>
<cfloop array="#theArray#" index="element">
	<cfoutput>#element#<br></cfoutput>
</cfloop>