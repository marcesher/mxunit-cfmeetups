<!---
 This demonstrates some refactoring of the same component in the
 "good" directory. It is functionally identical, but has a slightly
 better design.

 --->

<cfcomponent>
	<cfset variables.instance = StructNew()>
	<cfset variables.instance.twitterUrl = "http://www.twitter.com">

<cffunction name="init" hint="Initializes TwitterClient">
  <cfargument name="uname" type="string">
  <cfargument name="pwd" type="string">
	<cfargument name="format" type="string" required="false" default="json">
  <cfset variables.instance.userName = arguments.uname >
  <cfset variables.instance.password = arguments.pwd >
	<cfset variables.instance.format = arguments.format >
  <cfreturn this >
</cffunction>

<cffunction name="ping" hint="Runs the twitter api test command.">
  <cfset var response = 'not ok' />
     <cfhttp url="#getTwitterUrl()#/help/test.#getFormat()#" method="get">
     <cfset response = deserializeJSON(cfhttp.FileContent)>
      <cfif response is not 'ok'>
	  <cfthrow type="TwitterPingFailure"
	  		   message="Twitter might be down"
	  		   detail="Twitter says #cfhttp.FileContent#">
	</cfif>
	<cfreturn response>
</cffunction>


<cffunction name="verifyCredentials" hint="Tests that the credentials are valid.">
	<cfset var response = callTwitter(location="account/verify_credentials") >
	
	<cfif not structKeyExists(response.getDeserializedData(),'id')>
		<cfthrow type="TwitterAuthenticationFailure"
			message="Could not log into Twitter."
			detail="Tried user:#getUserName()# pwd:#getPassword()#">
	</cfif>
	<cfreturn true />
</cffunction>

<cffunction name="friendsTimeline" hint="returns the authenticated user's friends timeline">
  <cfreturn callTwitter(location="statuses/friends_timeline")>
</cffunction>

<cffunction name="callTwitter" access="private" returntype="TwitterResponse">
	<cfargument name="location" type="string" required="true" hint="the twitter api location, such as 'statuses/friends_timeline'"/>
	<cfargument name="requestMethod" type="string" required="false" hint="the http request method. use 'get' or 'post'" default="get">
	<cfargument name="apiArgs" type="struct" required="false" hint="any args to be passed to twitter" default="#StructNew()#"/>
	<cfset var urlString = structToQueryString(apiArgs=arguments.apiArgs)>
	<cfset var httpResponse = doHttpCall(location=arguments.location,requestMethod=arguments.requestMethod,urlString=urlString)>
	<cfset var response = deserializeResponse(httpResponse.FileContent) >
	<cfreturn createObject("component","TwitterResponse")
				.setDeserializedData(response)
				.setHttpRequestMethod(arguments.requestMethod)
				.setURL(arguments.location)
				.setRawResponseData(httpResponse)>
</cffunction>

<cffunction name="structToQueryString" access="private" hint="converts the struct of api args to a query string" returntype="string">
	<cfargument name="apiArgs" type="struct" required="false" hint="any args to be passed to twitter"/>
	<cfset var urlString = "?">
	<cfset var key = "">
	<cfif not StructIsEmpty(arguments.apiArgs)>
		<cfloop collection="#apiArgs#" item="key">
			<cfset urlString = listAppend(urlString,"#key#=#apiArgs[key]#","&")>
		</cfloop>
	</cfif>	
	<cfreturn urlString>
</cffunction>

<cffunction name="doHttpCall" access="private" hint="wrapper around the http call" returntype="struct">
	<cfargument name="location" type="string" required="true" hint="the twitter api location, such as 'statuses/friends_timeline'"/>
	<cfargument name="requestMethod" type="string" required="false" hint="the http request method. use 'get' or 'post'" default="get">
	<cfargument name="urlString" type="string" required="false" hint="the query string to pass" default="">
	<cfhttp url="#getTwitterUrl()#/#location#.#getFormat()##urlString#"
	        method="#arguments.requestMethod#"
	        username="#getUserName()#"
	        password="#getPassword()#">
	  <cfreturn cfhttp>
</cffunction>

<cffunction name="deserializeResponse" access="private" hint="deserializes the http response into CFML data">
	<cfargument name="httpContent" type="string" required="true" hint="the http content to be deserialized">
	<cfif getFormat() eq "JSON">
		<cfif isJSON(arguments.httpContent)>
			<cfreturn deserializeJSON(arguments.httpContent)>
		<cfelse>
			<cfreturn "">	
		</cfif>
	<cfelse>
		<cfthrow message="Currently there is no deserializer for #getFormat()#">
	</cfif>
</cffunction>

<!--- Accessor methods --->
<cffunction name="getFormat">
 <cfreturn variables.instance.format>
</cffunction>

<cffunction name="getTwitterUrl">
 <cfreturn variables.instance.twitterUrl>
</cffunction>

<cffunction name="getUserName">
  <cfreturn variables.instance.userName>
</cffunction>

<cffunction name="getPassword">
  <cfreturn variables.instance.password>
</cffunction>

</cfcomponent>