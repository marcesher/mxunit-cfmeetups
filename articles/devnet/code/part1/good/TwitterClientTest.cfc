<cfcomponent extends="mxunit.framework.TestCase">

	<cfset setCredentials()>

	<cffunction name="twitterShouldBeAlive">
       <cfset twitter = createObject("component","TwitterClient")>
	   <cfset assertEquals('ok',twitter.ping())> 
	</cffunction>
    
    
	<cffunction name="theTwitterAccountShouldBeValid">
      <cfset twitter = createObject("component","TwitterClient")>
      <cfset actual = twitter.verifyCredentials(variables.uname,variables.pw) />
      <cfset assertTrue(actual)>
    </cffunction>
    
    <cffunction name="invalidCredentialsShouldThrowTwitterAuthenticationFailureException">
      <cfset twitter = createObject("component","TwitterClient")>
      <cftry>
       <cfset twitter.verifyCredentials('bobo','the clown') />
       <cfset fail('Should not get here.') />
       <cfcatch type="TwitterAuthenticationFailure"></cfcatch>      
      </cftry>
    </cffunction>

 <!--- 
	<cffunction name="initShouldSetFeedFormat">
		<cfset twitter = createObject("component","TwitterClient")>
		<cfset twitter.init(uname,pw,"json")>
		<cfset assertEquals(twitter.getFormat(),'json') />
	</cffunction>

	<cffunction name="initShouldSetCredentials">
	  <cfset twitter = createObject("component","TwitterClient")>
		<cfset twitter.init(uname,pw,"rss")>
		<cfset assertEquals("rss",twitter.getFormat())>
		<cfset assertEquals(uname,twitter.getUsername())>
		<cfset assertEquals(pw,twitter.getPassword())>
	</cffunction>


	<cffunction name="twitterFriendsShouldReturn20Items">
		<cfset twitter = createObject("component","TwitterClient")>
		<cfset twitter.init(uname,pw,"json")>
		<cfset results = twitter.friendsTimeline()>
		<!---<cfset debug(results)> --->
		<cfset assertTrue(isArray(results), "Something other than an array was returned.") />
		<cfset assertEquals(20, arrayLen(results), "Something other than 20 items were returned.") />
	</cffunction>
--->


<!---
  Private utility method. 
 --->

	<cffunction name="setCredentials" access="private">
		<cfset var contents = "">
		<cfset var filepath = "#getDirectoryFromPath(getCurrentTemplatePath())#/credentials.txt">
		<cfif not fileExists(filepath)>
			<cfthrow message="to run these tests, create a file in this directory named credentials.txt with a single line in the form of username,password for your twitter account">
		</cfif>
		<cffile action="read" file="#filepath#" variable="contents">
		<cfset variables.uname = listFirst(contents)>
		<cfset variables.pw = listLast(contents)>
	</cffunction>



</cfcomponent>