<!---
 This demonstrates some refactoring of the same component in the
 "good" directory. It is functionally identical, but has a better
 design and uses setUp to initialize the TwitterClient instance
 rather than writing it out in every test. Either way, a new instance
 if TwitterClient is created for every test. This is done so that
 we can control the state of the TwitterClient at each test run.

 --->

<cfcomponent extends="mxunit.framework.TestCase">

  <cffunction name="setup">
	 <cfset twitter = createObject("component","TwitterClient").init(variables.uname,variables.pw)>
	</cffunction>

   <cffunction name="twitterShouldBeAlive">
	  <cfset assertEquals('ok',twitter.ping())>
   </cffunction>


	<cffunction name="theTwitterAccountShouldBeValid">
      <cfset var actual = twitter.verifyCredentials() />
      <cfset assertTrue(actual)>
    </cffunction>


    <cffunction name="invalidCredentialsShouldThrowTwitterAuthenticationFailure" mxunit:expectedException="TwitterAuthenticationFailure">
      <cfset twitter.init('Kwai Chang Caine','Grasshopper')>
       <cfset twitter.verifyCredentials() />
    </cffunction>


   <cffunction name="twitterFriendsTimelineShouldReturn20Items">
	   <cfset var results = twitter.friendsTimeline()>
	   <cfset debug(results)>
	   <cfset assertEquals(20, arrayLen(results), "Something other than 20 items were returned.") />
   </cffunction>


   <cffunction name="initShouldSetCredentials">
     <cfset twitter.init('Master Po', 'gimme my walking stick, bug boy.')>
     <cfset assertEquals('Master Po', twitter.getUserName(), 'Username was not set') >
     <cfset assertEquals('gimme my walking stick, bug boy.', twitter.getPassword(), 'Password was not set') >
   </cffunction>




<!---
  Private utility method.  Set up a credentials.txt file with one line: username,password
  setCredentials() is called once when the component is created.
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