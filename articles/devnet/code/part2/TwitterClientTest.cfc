<!---
 This demonstrates some refactoring of the same component in the
 "good" directory. It is functionally identical, but has a better
 design and uses setUp to initialize the TwitterClient instance
 rather than writing it out in every test. Either way, a new instance
 if TwitterClient is created for every test. This is done so that
 we can control the state of the TwitterClient at each test run.

 --->

<cfcomponent extends="mxunit.framework.TestCase">
	
	<cfset setCredentials()>

  <cffunction name="setup">
	 <cfset twitter = createObject("component","TwitterClient").init(variables.uname,variables.pw)>
	 <cfset request.debug = debug>
	</cffunction>

   <cffunction name="twitterShouldBeAlive">
	  <cfset assertEquals('ok',twitter.ping())>
   </cffunction>


	<cffunction name="theTwitterAccountShouldBeValid">
	  <cfset injectMethod(twitter,this,"verifyCredentialsHttpMock","doHTTPCall")>
	  <cfset result = twitter.verifyCredentials()>
	  <cfset debug(result)>
      <cfset assertTrue( result, "Credentials should have validated but did not")>
    </cffunction>


    <cffunction name="invalidCredentialsShouldThrowTwitterAuthenticationFailure">
	  <cfset injectMethod(twitter,this,"invalidCredentialsHTTPMock","doHTTPCall")>
      <cftry>
       <cfset twitter.verifyCredentials() />
       <cfset fail('Should not get here. verifyCredentials() should have thrown a TwitterAuthenticationFailure but did not') />
       <cfcatch type="TwitterAuthenticationFailure"></cfcatch>
      </cftry>
    </cffunction>
	
	<cffunction name="initShouldSetCredentials">
     <cfset twitter.init('Master Po', 'gimme my walking stick, bug boy.')>
     <cfset assertEquals('Master Po', twitter.getUserName(), 'Username was not set') >
     <cfset assertEquals('gimme my walking stick, bug boy.', twitter.getPassword(), 'Password was not set') >
   </cffunction>


   <cffunction name="twitterFriendsTimelineShouldReturn20Items">
	   <cfset injectMethod(twitter,this,"friendsTimelineHttpMock","doHTTPCall")>
	   <cfset twitterresponse = twitter.friendsTimeline()>
	   <cfset assertEquals(20, arrayLen(twitterresponse.getDeserializedData()), "Something other than 20 items were returned.") />
	   <cfset assertEquals("get",twitterresponse.getHttpRequestMethod())>
	   <cfset assertEquals("statuses/friends_timeline", twitterresponse.getURL())>
   </cffunction>

	<cffunction name="whenTwitterIsUnresponsiveRawResponseDataShouldBeAvailable">
		<cfset injectMethod(twitter,this,"TwitterIsDownMock","doHTTPCall")>
		<cfset twitterresponse = twitter.friendsTimeline()>
		<cfset rawdata = twitterresponse.getRawResponseData()>
		<cfset assertTrue( StructKeyExists(rawdata,"StatusCode") ,"StatusCode should exist in raw data" )>
		<cfset assertTrue( StructKeyExists(rawdata,"ErrorDetail") ,"ErrorDetail should exist in raw data" )>
		<cfset assertTrue( StructKeyExists(rawdata,"FileContent") ,"FileContent should exist in raw data" )>
		<cfset assertEquals("",twitterresponse.getDeserializedData(),"When an error occurs, there should be no deserialized data")>
	</cffunction>


<!---
  Private utility method.  Set up a credentials.txt file with one line: username,password
  setCredentials() is called once when the component is created.
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
	
	
	
	<!--- mocks! --->
	<cffunction name="verifyCredentialsHttpMock" access="private" returntype="struct">
		<cfset var http = StructNew()>
		<cfset http.FileContent = '{"id":"1"}'>
		<cfreturn http>		
	</cffunction>
	<cffunction name="invalidCredentialsHTTPMock" access="private">
		<cfset var http = StructNew()>
		<cfset http.FileContent = '{"error":"could not authenticate you"}'>
		<cfreturn http>
	</cffunction>
	<cffunction name="friendsTimelineHttpMock" access="private">
		<cfset var filepath = getDirectoryFromPath(getCurrentTemplatePath()) & "/friends_timeline.json">
		<cfset var filecontent = fileRead(filePath)>
		<cfset var http = {FileContent="#filecontent#"}>
		<cfreturn http>		
	</cffunction>
	<cffunction name="TwitterIsDownMock" access="private">
		<cfset var cfhttp = {filecontent="connection failure",statuscode="Connection Failure. Status code unavailable.", errordetail="FailWhale!"}>
		<cfreturn cfhttp>
	</cffunction>

</cfcomponent>