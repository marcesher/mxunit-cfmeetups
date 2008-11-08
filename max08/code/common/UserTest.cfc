<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset user = createObject("component","User")>		
		
		<cfset user.init()>
	</cffunction>

		
	<cffunction name="userShouldStartWithNoPermissions" returntype="void" access="public">
		<cfset assertEquals("", user.getPermissionsAsList() )>
	</cffunction>
	
	<cffunction name="addPermissionResultsInSuccessfulHasPermission">
		<cfset permissionName = "himom">
		<cfset assertFalse( user.hasPermission(permissionName) )>
		
		<cfset user.addPermission(permissionName)>
		<cfset assertTrue( user.hasPermission(permissionName) )>
	</cffunction>
	
	<cffunction name="testGetPermissionsAsList">
		<cfset user.addPermission("one")
					.addPermission("two")
					.addPermission("three")>
		
		<cfset expected = ListSort("one,two,three","text","asc")>
		<cfset actual = ListSort(user.getPermissionsAsList(),"text","asc")>
		
		<cfset assertEquals(expected,actual )>
	</cffunction>
	
	
	<!--- other tests would go here for weirdo conditions... case sensitivity, spaces in key names (should they be allowed, etc) --->
	

</cfcomponent>