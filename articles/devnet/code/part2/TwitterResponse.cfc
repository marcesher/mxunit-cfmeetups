<cfcomponent hint="A container for all the useful information we want to make available for Twitter API calls">

	<cfset variables.instance = StructNew()>
	
	<cffunction name="set" access="private" hint="generic setter">
		<cfargument name="name" required="true" hint="data name" type="string">
		<cfargument name="value" required="true" hint="data value" type="any">
		<cfset variables.instance[arguments.name] = arguments.value>
		<cfreturn this>
	</cffunction>
	<cffunction name="get" access="private" hint="generic getter" returntype="any">
		<cfargument name="name" required="true" hint="data name" type="string">
		<cfreturn variables.instance[arguments.name]>
	</cffunction>
	
	<cffunction name="setDeserializedData" access="package" hint="sets the deserialized data from the http call to Twitter">
		<cfargument name="data" required="true" type="any">
		<cfreturn set("deserializeddata",data)>
	</cffunction>
	<cffunction name="getDeserializedData" access="public" hint="returns the deserialized data from the http call to Twitter" returntype="any">
		<cfreturn get("deserializeddata")>
	</cffunction>
	
	<cffunction name="setHttpRequestMethod" access="package" hint="sets the http request method used for the Twitter call">
		<cfargument name="requestmethod" required="true" hint="http request method" type="string">
		<cfreturn set("httprequestmethod",requestmethod)>
	</cffunction>
	<cffunction name="getHttpRequestMethod" access="public" hint="returns the request method for the http call to Twitter" returntype="string">
		<cfreturn get("httprequestmethod")>
	</cffunction>
	
	<cffunction name="setURL" access="package" hint="sets the url used for the Twitter call">
		<cfargument name="twitterURL" required="true" hint="the URL" type="string">
		<cfreturn set("twitterURL",twitterURL)>
	</cffunction>
	<cffunction name="getURL" access="public" hint="returns the url for the http call to Twitter" returntype="string">
		<cfreturn get("twitterURL")>
	</cffunction>
	
	<cffunction name="setRawResponseData" access="package" hint="sets the entire CFHTTP struct returned by the Twitter call">
		<cfargument name="twitterURL" required="true" hint="the cfhttp struct" type="struct">
		<cfreturn set("rawResponseData",twitterURL)>
	</cffunction>
	<cffunction name="getRawResponseData" access="public" hint="gets the entire CFHTTP struct returned by the Twitter call" returntype="struct">
		<cfreturn get("rawResponseData")>
	</cffunction>

</cfcomponent>