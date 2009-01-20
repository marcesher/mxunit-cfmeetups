<cfcomponent extends="mxunit.framework.TestCase">

	<cfset setCredentials()>

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset twitter = createObject("component","TwitterClient")>
		<cfset twitter.init(uname,pw,"json")>
		
	</cffunction>
	
	<cffunction name="initShouldReturnSelf" returntype="void" access="public">
		<cfset assertSame(twitter,twitter.init(uname,pw,"json"),"init should have returned 'this' but didn't")  >		
	</cffunction>
	
	<cffunction name="initShouldSetCredentials" returntype="void">
		<cfset twitter.init(uname,pw,"rss")>
		<cfset assertEquals("rss",twitter.getFormat())>
		<cfset assertEquals(uname,twitter.getUsername())>
		<cfset assertEquals(pw,twitter.getPassword())>
	</cffunction>
	
	<cffunction name="testShouldReturnOK" hint="the test command is not rate limited so it's safe to call it all the time. this also serves as a nice sanity test to make sure twitter is responding.">
		<cfset assertEquals('"ok"',twitter.test())>
	</cffunction>

	<cffunction name="myTimelineShouldReturnMyTweetsArray">
		<cfset var results = twitter.myTimeline()>
		<cfset debug(results)>
		<!--- perform some basic assertions to ensure we have successfully converted the response to an array of structs --->
		<cfset assertTrue(isArray(results))>
		<cfset assertTrue( isNumeric(results[1].id) )>
		<cfset assertTrue( len(results[1].text) GT 0 )>
		<cfset assertTrue(structKeyExists(results[1],"user"))>
	</cffunction>
	
	<cffunction name="friendsTimelineShouldReturnFriendsTweetsArray">
		<cfset var results = twitter.friendsTimeline()>
		<!--- <cfset debug(results)> --->
		<cfset assertTrue(isArray(results))>
		<cfset assertTrue( isNumeric(results[arraylen(results)].id) )>
		<cfset assertTrue( structKeyExists(results[arraylen(results)],"user") )>
	</cffunction>
	
		
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