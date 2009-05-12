<cfcomponent>
	<cfset variables.instance = StructNew()>
	
	<cffunction name="init" output="false" access="public" returntype="any" hint="">
		<cfargument name="UserID" type="numeric" required="true"/>
		
		<cfset StructAppend(variables.instance,arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="authenticate" output="false" access="public" returntype="boolean" hint="returns true if username/password match found">
		<cfargument name="username" type="string" required="true"/>
		<cfargument name="password" type="string" required="true"/>

		<cfset var findUser = "">
		<cfquery datasource="unittest" name="findUser">
		select count(userid) as numfound
		from users
		where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#">
		and password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.password#">
		</cfquery>
		
		<cfif findUser.numFound eq 1>
			<cfreturn true>
		</cfif>

		<cfreturn false>
	</cffunction>
	
	<cffunction name="getUserID" output="false" access="public" returntype="numeric" hint="">
		<cfreturn variables.instance.UserID>
	</cffunction>

</cfcomponent>