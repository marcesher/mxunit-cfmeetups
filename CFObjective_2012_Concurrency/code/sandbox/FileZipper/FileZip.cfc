<cfcomponent>
	
	<cfset variables.outputPath = "">
	<cfset variables.zipped = {}>	
    <cfset variables.reapLookup = []>
	
	<cfset variables.reapMinutes = 1>
	
	<cffunction name="init" output="false" access="public" returntype="any" hint="">    
    	<cfargument name="outputPath" type="string" required="true"/>
		
		<cfset structAppend( variables, arguments )>
		<cfreturn this>
    </cffunction>
	
    <cffunction name="zipFiles" output="false" access="public" returntype="any" hint="">    
    	<cfargument name="key" type="string" required="true"/>
		<cfargument name="files" type="array" required="true"/>
    	
    	<!--- if we've zipped this key recently, simply ignore it as it's a double submission --->
    	<cfif isRecentlyProcessed( key )>
			<cfreturn>
		</cfif>
		
		
		<cfset sow( key )>
		
		<cfset var z = "">
		<cfzip action="zip" file="#variables.outputPath#\#arguments.key#.zip" overwrite="false">
			<cfloop array="#files#" index="z">
				<cfzipparam source="#z#">
			</cfloop>
		</cfzip>
		
    </cffunction>
    
    <cffunction name="isRecentlyProcessed" output="false" access="private" returntype="boolean" hint="">    
		<cfset variables.zipped[key] = now()>
    	<cfreturn structKeyExists( variables.zipped, arguments.key )>
    </cffunction>
    
    <cffunction name="sow" output="false" access="private" returntype="any" hint="">    
    	<cfargument name="key" type="string" required="true"/>
		<cfset variables.zipped[key] = {timestamp = now()}>
		<cfset arrayAppend(variables.reapLookup, variables.zipped[key])>
    </cffunction>
    
    <cffunction name="reap" output="false" access="private" returntype="any" hint="">    
    	<cfset var length = arrayLen(variables.reapLookup)>
		<cfset var index = "">
		<cfset var targetTime = dateAdd("n", -variables.reapMinutes, now() )>
		
    	<cfloop from="#length#" to="1" index="index" step="-1">
			<cfif dateCompare( targetTime, now() ) eq 1>
				<!---delete from the struct and array... TODO: investigate a better data structure --->
			</cfif>
		</cfloop>
    </cffunction>
	
</cfcomponent>