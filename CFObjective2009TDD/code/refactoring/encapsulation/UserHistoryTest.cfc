<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset userhistory = createObject("component","UserHistory")>				
	</cffunction>
	
	<!--- NOTE: this does NOT remove the need to set up state in the database;
	but it does remove the need to set up the session-scoped object--->
	<cffunction name="getUserOrderHistoryShouldReturnAllOrderIDsForUser" returntype="void" access="public">
		<cfset results = userhistory.getUserOrderHistory(1)>
		<cfset assertTrue(results.recordcount gt 0)>
	</cffunction>

</cfcomponent>