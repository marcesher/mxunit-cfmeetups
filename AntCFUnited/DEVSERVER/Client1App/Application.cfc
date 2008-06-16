<cfcomponent>

	
	
	<!--- set application settings --->
	<cfset this.name = "Client1App">
	<cfset this.clientmanagement = true>
	<cfset this.clientstorage = "cookie">
	<cfset this.sessionmanagement = false>
	<cfset this.applicationtimeout = CreateTimeSpan(7,0,0,0)>
	
	<!--- Ensure  "Enable Per App Settings option is checked in CFAdmin on ALL CF Servers" --->
	
	<!--- local mapping expects com at the webroot. All applications share this com directory in development --->
	<cfset this.localFrameworkMapping = expandpath("/com")>	
	<!--- in non-dev (i.e. test, staging, prod), com is underneath the client root; ant will put it there --->
	<cfset this.prodFrameworkMapping = getDirectoryFromPath(getcurrenttemplatepath()) & "com">
	
	<!--- Figure out where we are! --->
	<cfset environment = determineEnvironment()>
	
	<!--- if it's NOT local, use the prod path --->
	<cfif environment NEQ "dev">
		<cfset this.mappings["/com"] = this.prodFrameworkMapping> 
	<cfelse>
		<!--- else use the local "shared" path --->
		<cfset this.mappings["/com"] = this.localFrameworkMapping> 
	</cfif>


	<cffunction name="onApplicationStart">
		<!--- do app initialization --->
		<cfif environment neq "dev">
			<cfset application.codebase = "/mxunit-cfmeetups/AntCFUnited/TESTSERVER/#this.name#/codebase">
		<cfelse>
			<cfset application.codebase = "/mxunit-cfmeetups/AntCFUnited/DEVSERVER/SharedCodebase">
		</cfif>
	</cffunction>
	
	<cffunction name="onRequestStart">
		<!--- do request initialization --->
		<cfif isDefined("url.reinit")>
			<cfset onApplicationStart()>
		</cfif>
		<cfif isDefined("url.dumpsettings")>
			<cfdump var="#this#" label="this scope">
			<cfdump var="#application#" label="application scope">
		</cfif>
	</cffunction>
	
	<cffunction name="onSessionStart">
		<!--- do session initialization --->
	</cffunction>

	<cffunction name="determineEnvironment" access="private">
		<!--- if the com directory is INSIDE our client directory, then we know we're not in dev --->
		
		<cfif DirectoryExists(expandPath("com"))>
			<cfreturn "prod">
		<cfelse>
			<cfreturn "dev">
		</cfif>
	</cffunction>

</cfcomponent>