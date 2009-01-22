<cfcomponent>

<cffunction name="init" hint="Initializes TwitterClient">
  <cfargument name="uname" type="string">
  <cfargument name="pwd" type="string">
  <cfset this.userName = arguments.uname >
  <cfset this.password = arguments.pwd >
  <cfreturn this >
</cffunction>

<cffunction name="ping" hint="Runs the twitter api test command.">
  <cfset var response = 'not ok' />
     <cfhttp url="http://www.twitter.com/help/test.json" method="get">
     <cfset response = deserializeJSON(cfhttp.FileContent)>
      <cfif response is not 'ok'>
	  <cfthrow type="TwitterPingFailure"
	  		   message="Twitter might be down"
	  		   detail="Twitter says #cfhttp.FileContent#">
	</cfif>
	<cfreturn response>
</cffunction>

 
<cffunction name="verifyCredentials" hint="Tests that the credentials are valid.">
  <cfset var response = {} >
  <cfhttp url="http://www.twitter.com/account/verify_credentials.json" 
          method="get"
          username="#getUserName()#"
          password="#getPassword()#">
    <cfset response = deserializeJSON(cfhttp.FileContent)>
    <cfif not structKeyExists(response,'id')>
	    <cfthrow type="TwitterAuthenticationFailure"
		         message="Could not log into Twitter."
		         detail="Tried user:#getUserName()# pwd:#getPassword()#">
    </cfif>
  <cfreturn true />
 </cffunction>

<cffunction name="friendsTimeline" hint="returns the authenticated user's friends timeline">
  <cfset var response = {} >
  <cfhttp url="http://www.twitter.com/statuses/friends_timeline.json" 
          method="get" 
          username="#getUserName()#" 
          password="#getPassword()#">
  <cfset response = deserializeJSON(cfhttp.FileContent)>
  <cfreturn response>
</cffunction>

<cffunction name="getUserName">
  <cfreturn this.userName >
</cffunction>

<cffunction name="getPassword">
  <cfreturn this.password >
</cffunction>

</cfcomponent>