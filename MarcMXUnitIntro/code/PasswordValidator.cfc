<cfcomponent>
	
	<cfset results = StructNew()>
	<cfset pw = "">
	
	<cffunction name="validate" output="false" returntype="boolean" hint="validates a password">
		<cfargument name="password" type="string" required="true"/>
	
		<cfset results = StructNew()>
		<cfset results.success = true>
		<cfset results.message = "">
		
		<cfset variables.pw = arguments.password>
		<cfset testNoUpper()>
		<cfset testNoLower()>
		<cfset testNoNumber()>	
		
		<cfreturn results.success>
	</cffunction>
	
	<cffunction name="getResultsMessage" access="public">
		<cfreturn listChangeDelims(results.message," ","|")>
	</cffunction>
	
	<cffunction name="testNoUpper" access="private">
		<cfif not reFind("[A-Z]",pw)>
			<cfset addFailure("At least one uppercase letter required.")>
		</cfif>
	</cffunction>
	
	<cffunction name="testNoLower" access="private">
		<cfif not reFind("[a-z]{4,}",pw)>
			<cfset addFailure("At least 4 lowercase letters required.")>
		</cfif>
	</cffunction>
	
	<cffunction name="testNoNumber" access="private">
		<cfif not reFind("[0-9]",pw)>
			<cfset addFailure("At least 1 number required.")>
		</cfif>
	</cffunction>
	
	<cffunction name="addFailure" access="private">
		<cfargument name="message" type="string" required="true"/>
		<cfset results.success = false>
		<cfset results.message = ListAppend(results.message, arguments.message, "|")>
	</cffunction>

</cfcomponent>