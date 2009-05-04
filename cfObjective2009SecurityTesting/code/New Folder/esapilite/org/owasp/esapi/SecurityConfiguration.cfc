<cfcomponent displayname="Security Configuration" output="false">
	<cffunction name="init" access="public" returntype="Any" output="false">
		<cfargument name="config" type="XML" required="true" hint="XML Config for security preferences" />
		
		<cfset variables.properties = XMLSearch(arguments.config, "/Config/Properties/Property")>
        <cfset variables.config = arguments.config />
		
		<cfloop from="1" to="#ArrayLen(properties)#" index="propertyIndex">
			<cfset "variables.#properties[propertyIndex].XmlAttributes.name#" = #properties[propertyIndex].XmlAttributes.value# />
		</cfloop>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getProperty" access="public" returntype="string" output="false">
		<cfargument name="propertyName" type="string" required="true" hint="Name of property to return" />
		<cfset var props = XMLSearch(variables.config, "/Config/Properties/Property[@name='#arguments.propertyName#']")>
		<cfreturn props[1].xmlattributes['value'] />
	</cffunction>
</cfcomponent>