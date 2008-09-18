<cfcomponent hint="Simple User Object" output="false">

	<cfset variables.instance = StructNew()>
	<cfset variables.instance.UserPermissions = StructNew()>

	<cffunction name="init" returntype="User">
		<cfargument name="UserID" required="false" type="numeric" default="0">
		<cfargument name="FirstName" required="false" type="string" default="">
		<cfargument name="LastName" required="false" type="string" default="">
		<cfargument name="UserName" required="false" type="string" default="">
		<cfargument name="Password" required="false" type="string" default="">
		<cfset StructAppend(variables.instance,arguments,true)>
		
		<cfreturn this>
	</cffunction>
	
	
	<cffunction name="loadPermissions" hint="queries database for all permissions for this user and loads into the permissions struct">
		<cfset var permissions = getUserPermissionsQuery()>

		<cfloop query="permissions">
			<cfset addPermission(permissions.PermissionName)>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getUserPermissionsQuery" returntype="query" access="private" hint="queries for the user permissions">
		<cfset var permissions = "">
		
		<cfquery name="permissions" datasource="UnitTest">
		select u.UserID, p.PermissionID,PermissionName
		from J_Users_Permissions jup 
		join users u on jup.UserID = u.UserID
		join Permissions p on jup.PermissionID = p.PermissionID
		where u.userid = <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.instance.UserID#">
		</cfquery>
		
		<cfreturn permissions>
	</cffunction>
	
	<cffunction name="addPermission" returntype="User" hint="adds a permission for this user">
		<cfargument name="permissionName" required="true" type="string">
		<cfset variables.instance.UserPermissions[permissionName] = true>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="hasPermission" returntype="boolean" hint="returns true if user has requested permission">
		<cfargument name="permissionName" required="true" type="string">
		
		<cfreturn StructKeyExists(variables.instance.UserPermissions,arguments.permissionName)>		
	</cffunction>
	
	<cffunction name="getPermissionsAsList" returntype="string" hint="returns a list of permissions for this user">
		<cfreturn StructKeyList(variables.instance.UserPermissions)>
	</cffunction>

</cfcomponent>