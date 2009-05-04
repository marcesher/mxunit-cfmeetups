<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="message" required="false" default="Invalid data was detected">
		<cfargument name="detail"  required="false" default="">
		<cfargument name="errorcode"  required="false" default="">
	  <!--- to do: logger() --->
	  <cfthrow type="org.owasp.esapi.errors.LoggerException"
	  				 message="#arguments.message#"
	  				 detail="#arguments.detail#"
	  				 errorcode="#arguments.errorcode#">


	</cffunction>

	<cffunction name="logger">
	<!---
	  Probably needs to call logger
	 --->
	</cffunction>


</cfcomponent>