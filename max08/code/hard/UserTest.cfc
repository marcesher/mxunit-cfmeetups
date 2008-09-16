<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset user = createObject("component","User")>		
		
		<cfset user.init()>
	</cffunction>

		
	<cffunction name="userShouldStartWithNoPermissions" returntype="void" access="public">
		<cfset assertEquals("", user.getPermissionsAsList() )>
	</cffunction>
	
	<cffunction name="testGetPermissionsAsList">
		<cfset user.addPermission("one")
					.addPermission("two")
					.addPermission("three")>
		
		<cfset expected = ListSort("one,two,three","text","asc")>
		<cfset actual = ListSort(user.getPermissionsAsList(),"text","asc")>
		
		<cfset assertEquals(expected,actual )>
	</cffunction>
	
	<cffunction name="addPermissionResultsInSuccessfulHasPermission">
		<cfset permissionName = "himom">
		<cfset assertFalse( user.hasPermission(permissionName) )>
		
		<cfset user.addPermission(permissionName)>
		<cfset assertTrue( user.hasPermission(permissionName) )>
	</cffunction>
	
	<!--- this one is easy! Just use an ID we know can't exist' --->
	<cffunction name="loadPermissionsForNoPermissionsResultsInEmptyStruct">
		<cfset user.init(UserID=-100)>
		<cfset user.loadPermissions()>
		<cfset assertEquals("",user.getPermissionsAsList())>
	</cffunction>
	
	<!--- in the ideal world, we could granularly control the query being used by loadPermissions;
	however, in the real world, we have to settle for what's in the DB or else create the conditions
	and hope they don't change --->
	
	<cffunction name="loadPermissionsForKnownExistingPermissions">
		<cfset UserID = 1>
		<cfset user.init(UserID=UserID)>
		<cfset user.loadPermissions()>
		<cfset assertTrue( user.hasPermission("Kick it") )>
		<cfset assertTrue( user.hasPermission("SmokeStogies") )>
		
		<cfset assertFalse( user.hasPermission("BuyScotch") )>
	</cffunction>
	
	
	<!--- now, tell me: how the heck are you realistically going to test this? --->
	<cffunction name="reloadPermissionsClearsDeletedPermissions">
		<cfset UserID = 1>
		<cfset user.init(UserID=UserID)>
		<cfset user.loadPermissions()>
		<cfset assertTrue( user.hasPermission("Kick it") )>
		
		<!--- gotta do something here to delete this permission for this user from the database --->
		<cfset iDontKnowHowToDoThisEasily = true>
		
		<!--- then load em again and make sure the permission is gone --->
		<cfset user.loadPermissions()>
		<cfset assertFalse( user.hasPermission("Kick it") )>
	</cffunction>

</cfcomponent>