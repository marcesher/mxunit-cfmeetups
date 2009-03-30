<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset userhistory = createObject("component","UserHistory")>				
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<!--- Because UserHistory looks into the session scope, we now have to ensure the appropriate session 
	vars are set. This is not what you want to do in a unit test. --->
	<cffunction name="getUserOrderHistoryShouldReturnAllOrderIDsForUser" returntype="void" access="public">
		<cfset session.user = createObject("component","User")>
		<cfset session.user.init(UserID=1)>
		<cfset results = userhistory.getUserOrderHistory()>
		<cfset assertTrue(results.recordcount gt 0)>
	</cffunction>

</cfcomponent>