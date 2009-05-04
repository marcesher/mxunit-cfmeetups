<cfcomponent displayname="ESAPI" hint="ESAPI locator class to make it easy to get a concrete implementation of the various ESAPI classes." output="false">
	<cffunction name="init" access="public" returntype="ESAPI" output="false" hint="Instantiates the object and loads it with the security services">
		<cfargument name="configPath" type="string" required="true" hint="Path to the config file" />

		<cfset var configXML = "" />
		<cfset var config = "" />


		<cffile action="read" file="#configPath#" charset="UTF-8" variable="configXML" />

		<cfif NOT IsXML(configXML)><cfthrow message="Invalid Config File"></cfif>

		<cfset config = XMLParse(configXML) />

		<cfset variables.SecurityConfiguration = createObject("component","cfobjective.esapilite.org.owasp.esapi.SecurityConfiguration").init(config) />
		<cfset variables.Encoder = createObject("component","cfobjective.esapilite.org.owasp.esapi.Encoder").init() />
		<cfset variables.Validator = createObject("component","cfobjective.esapilite.org.owasp.esapi.Validator").init() />

  	<cfreturn this />
	</cffunction>

  <cffunction name="encoder" access="public" returntype="cfobjective.esapilite.org.owasp.esapi.Encoder" output="false">
	  <cfreturn variables.Encoder />
	</cffunction>

	<cffunction name="setEncoder" access="public" returntype="void" output="false">
		<cfargument name="Encoder" type="cfobjective.esapilite.org.owasp.esapi.Validator" />
	</cffunction>


	<cffunction name="securityConfiguration" access="public" returntype="cfobjective.esapilite.org.owasp.esapi.SecurityConfiguration" output="false">
		<cfreturn variables.SecurityConfiguration />
	</cffunction>

	<cffunction name="setSecurityConfiguration" access="public" returntype="void" output="false">
		<cfargument name="SecurityConfiguration" type="cfobjective.esapilite.org.owasp.esapi.SecurityConfiguration" />
	</cffunction>

	<cffunction name="validator" access="public" returntype="cfobjective.esapilite.org.owasp.esapi.Validator" output="false">
	  <cfreturn variables.Validator />
	</cffunction>

	<cffunction name="setValidator" access="public" returntype="void" output="false">
		<cfargument name="Validator" type="cfobjective.esapilite.org.owasp.esapi.Validator" />
	</cffunction>

</cfcomponent>