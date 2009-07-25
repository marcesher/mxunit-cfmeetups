<cfinclude template="MakeBigList.cfm">
<cfloop list="#thelist#" index="element">
	<cfoutput>#element#<br></cfoutput>
</cfloop>