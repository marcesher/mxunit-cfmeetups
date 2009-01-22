<cfcomponent extends="mxunit.framework.TestCase">

   <cffunction name="twitterShouldBeAlive">
     <cfset var twitter = createObject("component","TwitterClient")>
	 <cfset assertEquals('ok',twitter.ping())> 
   </cffunction>
    
    
	<cffunction name="theTwitterAccountShouldBeValid">
      <cfset var twitter = createObject("component","TwitterClient").init(variables.uname,variables.pw)>
      <cfset var actual = twitter.verifyCredentials() />
      <cfset assertTrue(actual)>
    </cffunction>
    
    
    <cffunction name="invalidCredentialsShouldThrowTwitterAuthenticationFailure">
      <cfset var twitter = createObject("component","TwitterClient").init('Kwai Chang Caine','Grasshopper')>
      <cftry>
       <cfset twitter.verifyCredentials() />
       <cfset fail('Should not get here.') />
       <cfcatch type="TwitterAuthenticationFailure"></cfcatch>      
      </cftry>
    </cffunction>
    
    
   <cffunction name="twitterFriendsShouldReturn20Items">
	 <cfset var twitter = createObject("component","TwitterClient").init(variables.uname,variables.pw)>
	 <cfset var results = twitter.friendsTimeline()>
	 <cfset debug(results)>
	 <cfset assertEquals(20, arrayLen(results), "Something other than 20 items were returned.") />
   </cffunction>
   
   
   <cffunction name="initShouldSetCredentials">
     <cfset var twitter = createObject("component","TwitterClient")>
     <cfset twitter.init('Master Po', 'gimme my walking stick')>
     <cfset assertEquals('Master Po', twitter.getUserName(), 'Username was not set') >
     <cfset assertEquals('gimme my walking stick', twitter.getPassword(), 'Password was not set') >
   </cffunction>




<!---
  Private utility method.  Set up a credentials.txt file with one line: username,password
 --->
    <cfset setCredentials()>
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