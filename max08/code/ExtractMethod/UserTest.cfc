<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset user = createObject("component","User")>		
		
		<cfset user.init()>
	</cffunction>
	
	<!--- make some queries to test our different scenarios --->
	<!--- these won't run as tests because they're private! --->
	<cffunction name="zeroPermissions" access="private">
		<cfset var q = "">
		<cf_querysim>
		q
		UserID,PermissionID,PermissionName
		</cf_querysim>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="eatPermissions" access="private">
		<cfset var q = "">
		<cf_querysim>
		q
		UserID,PermissionID,PermissionName
		1|1|EatIceCream
		1|2|EatSteak
		</cf_querysim>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="eatPermissionsOneLessRow" access="private">
		<cfset var q = "">
		<cf_querysim>
		q
		UserID,PermissionID,PermissionName
		1|1|EatIceCream
		</cf_querysim>
		<cfreturn q>
	</cffunction>
	
	
	<!--- !!! START OUR TESTS !!! --->
	
	<cffunction name="permissionsWithSpacesAndOtherWeirdness" access="private">
		<cfset var q = "">
		<cf_querysim>
		q
		UserID,PermissionID,PermissionName
		1|1|Hey Momma
		1|2|Here's an apostrophe
		1|3|User.List
		1|4|And a--dash
		</cf_querysim>
		<cfreturn q>
	</cffunction>

	
	<!--- we'll override this one just so we don't hit the DB at all --->
	<cffunction name="loadPermissionsForNoPermissionsResultsInEmptyStruct">
		
		<!--- 
		injectMethod(
			Receiver = The object receiving the overriding method,
			Giver = The object supplying the overriding method,
			functionName = The name of the method to be used as the override,
			functionNameInReceiver = The method in the receiver to be overridden
		)
		
		functionName from the Giver object will be used to 
		override functionNameInReceiver from the receiving object
		 --->
		
		<!--- in this case, this.zeroPermissions will be used to 
		override user.getUserPermissionsQuery --->
		<cfset injectMethod(user,this,"zeroPermissions","getUserPermissionsQuery")>
		
		<cfset user.loadPermissions()>
		<cfset assertEquals("",user.getPermissionsAsList())>
	</cffunction>
	
	<!--- in the ideal world, we could granularly control the query being used by loadPermissions;
	however, in the real world, we have to settle for what's in the DB or else create the conditions
	and hope they don't change. So instead of relying on the real world, we create the conditions
	we want by injecting in spoof queries --->
	
	<cffunction name="loadPermissionsForKnownExistingPermissions">
		<cfset injectMethod(user,this,"eatPermissions","getUserPermissionsQuery")>
		<cfset user.loadPermissions()>
		<cfset assertEquals("eatsteak,eaticecream",user.getPermissionsAsList())>
	</cffunction>
	
	
	<!--- now, tell me: how the heck are you realistically going to test this? --->
	<cffunction name="reloadPermissionsClearsDeletedPermissions">
		<cfset injectMethod(user,this,"eatPermissions","getUserPermissionsQuery")>
		<cfset user.loadPermissions()>
		<cfset assertTrue(user.hasPermission("EatSteak"))>
		
		<!--- now insert the query that has this permission deleted --->
		<cfset injectMethod(user,this,"eatPermissionsOneLessRow","getUserPermissionsQuery")>
		
		<!--- then load em again and make sure the permission is gone --->
		<cfset user.loadPermissions()>
		<cfset assertFalse(user.hasPermission("EatSteak"),"User should not have EatSteak permission any more")><!--- this will fail the first time b/c we have a bug in the code!!! --->
	</cffunction>
	
	<cffunction name="loadPermissionsWithCrazyCharactersShouldThrowNoErrors">
		<cfset var q_weird = permissionsWithSpacesAndOtherWeirdness()>
		<cfset injectMethod(user,this,"permissionsWithSpacesAndOtherWeirdness",
				"getUserPermissionsQuery")>
		<cfset user.loadPermissions()>
		
		<!--- doesn't this feel like the kind of thing we could 
		pull out as a custom assertion and use in ALL of our tests? --->
		<cfset assertEquals(q_weird.recordcount,ListLen(user.getPermissionsAsList()))>
		<cfloop query="q_weird">
			<cfset assertTrue(user.hasPermission(q_weird.PermissionName))>
		</cfloop>
		
	</cffunction>
	
	<!--- !!!! Example of using custom assertions in your test when it seems like
	you're duplicating the same assertions over and over --->
	<cffunction name="assertPermissionsMatchQuery" access="private" hint="custom assertion for testing permissions against the query that drove loadPermissions">
		<cfargument name="queryFunctionName" required="true">
		<cfargument name="user" required="true">
		<!--- what would you put here?  let's get you started: --->
		<cfset var q_permissions = evaluate("#queryFunctionName#()")>
		<cfset assertEquals(q_permissions.recordcount,ListLen(user.getPermissionsAsList()))>
		
		<!--- what else? --->
	</cffunction>

</cfcomponent>