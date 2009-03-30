<cfcomponent>
	
	<cffunction name="getUserOrderHistory" output="false" access="public" returntype="query" hint="">
		
		<cfset var history = "">
		
		<cfquery datasource="unittest" name="history">
		select *
		from Users u
		join J_Users_Orders juo ON u.UserID = juo.UserID
		where UserID = <cfqueryparam value="#session.user.getUserID()#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfreturn history>
	</cffunction>
	
</cfcomponent>