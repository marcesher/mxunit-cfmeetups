<cfcomponent>
	
	<cffunction name="getUserOrderHistory" output="false" access="public" returntype="query" hint="">
		<cfargument name="UserID" type="numeric" required="true"/>		
		<cfset var history = "">
		
		<cfquery datasource="unittest" name="history">
		select *
		from Users u
		join J_Users_Orders juo ON u.UserID = juo.UserID
		where UserID = <cfqueryparam value="#arguments.UserID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn history>
	</cffunction>
	
</cfcomponent>