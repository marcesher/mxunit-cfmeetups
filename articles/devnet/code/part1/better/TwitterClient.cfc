<cfcomponent>

	<cfset variables.instance = StructNew()>
	<cfset variables.twitterUrl = "http://www.twitter.com">

	<cffunction name="init">
		<cfargument name="username" type="string" required="true"/>
		<cfargument name="password" type="string" required="true"/>
		<cfargument name="format" type="string" required="false" hint="options are: xml, json. json suggested" default="json"/>
		<cfset StructAppend(variables.instance,arguments)>
		<cfreturn this>
	</cffunction>

	<cffunction name="ping" hint="runs the twitter api test command.">
		<cfhttp url="#twitterUrl#/help/test.json" method="get">
		<cfreturn cfhttp.FileContent>
	</cffunction>

	<cffunction name="verifyCredentials" hint="Simply tests that the credentials passed in are valid.">
		<cfset var response = {} >
		<cfhttp url="#twitterUrl#/account/verify_credentials.json" method="get"
						username="#variables.instance.username#"
						password="#variables.instance.password#">
		<cfset response = deserializeJSON(cfhttp.FileContent)>
		<cfif not structKeyExists(response,'id')>
		  <cfthrow type="TwitterAuthenticationFailure"
		  				 message="Could not log into Twitter with the specified credentials"
		  				 detail="Tried username:#variables.instance.username# and password #variables.instance.password#">
		</cfif>
		<cfreturn true />
	</cffunction>


	<cffunction name="myTimeline" hint="returns the authenticated user's timeline">
		<cfhttp url="#twitterUrl#/statuses/user_timeline/#getUsername()#.#getFormat()#" method="get">
		<cfreturn tweetsToStruct(cfhttp.FileContent)>
	</cffunction>

	<cffunction name="friendsTimeline" hint="returns the authenticated user's friends timeline">
		<cfhttp url="#twitterUrl#/statuses/friends_timeline.#getFormat()#" method="get" username="#getUsername()#" password="#getPassword()#">
		<cfreturn tweetsToStruct(cfhttp.FileContent)>
	</cffunction>

	<cffunction name="tweetsToStruct" access="private">
		<cfargument name="tweets" type="string" required="true" hint="xml or json string representing tweets"/>
		<cfif isXML(tweets)>
			<cfthrow message="not yet implemented">
		<cfelse>
			<cfreturn deserializeJSON(tweets)>
		</cfif>
	</cffunction>



	<cffunction name="getFormat" access="public">
		<cfreturn variables.instance.format>
	</cffunction>
	<cffunction name="getUsername" access="public">
		<cfreturn variables.instance.username>
	</cffunction>
	<cffunction name="getPassword" access="public">
		<cfreturn variables.instance.password>
	</cffunction>


</cfcomponent>