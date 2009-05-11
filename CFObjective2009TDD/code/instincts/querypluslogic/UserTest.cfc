<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset user = createObject("component","User")>				
	</cffunction>
	
	<!--- this one's kind of easy. just pass a password you know can't possibly exist' --->
	<cffunction name="authenticateWithZeroMatchesShouldReturnFalse" returntype="void" access="public">
		<cfset fail("this test not yet implemented")>
		
	</cffunction>
	
	<!--- this one's hard: you need to know a valid username/password combination. More importantly,
	what if the system has password-changing requirements (new passwords every 30 days)? This means
	every 30 days, your test will start to fail and now you'll be maintaining your tests. What a hassle!' --->
	<cffunction name="authenticateWithOneMatchShouldReturnTrue" returntype="void" hint="">
		<cfset fail("authenticateWithOneMatchShouldReturnTrue not yet implemented")>
			
	</cffunction>

</cfcomponent>