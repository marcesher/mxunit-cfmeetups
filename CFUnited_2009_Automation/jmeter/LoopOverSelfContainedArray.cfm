<cfset theArray = ArrayNew(1)>
<cfloop from="1" to="1000" index="i">
	<cfset ArrayAppend(theArray,i)>
</cfloop>
<cfloop array="#theArray#" index="element">
	<cfoutput>#element#<br></cfoutput>
</cfloop>