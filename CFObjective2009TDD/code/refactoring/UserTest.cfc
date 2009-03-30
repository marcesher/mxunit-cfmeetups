<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset user = createObject("component","User")>				
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="authenticateWithZeroMatchesShouldReturnFalse" returntype="void" access="public">
		<cfset var result = user.authenticate("marc","little bobby tables")>
		<cfset assertFalse(result,"")>
	</cffunction>
	
	<!--- override the  real query with a fake one. this removes the complicates of 
	setting up state but still lets us test the 'real' logic we want to test '--->
	<cffunction name="authenticateWithOneMatchShouldReturnTrue" returntype="void" hint="">
		<cfset var tmp = injectMethod(user,this,"findUserReturnsOneUser","findUser")>	 
		<cfset var result =  user.authenticate("doesnotmatter","doesnotmatter")>
		<cfset assertTrue(result,"user should have authenticated but did not")>
	</cffunction>
	
	<!--- create a function that will be a test-time stand-in (a "mock") for the findUser function --->
	<cffunction name="findUserReturnsOneUser" access="private">
		<cfset var q = "">
		<cfoutput>
		<cf_querysim>
		q
		userid,username,password,firstname,lastname
		1|mesher|mypassword|marc|esher
		</cf_querysim>
		</cfoutput>
		<cfreturn q>
	</cffunction>
	
	
	
	</cfcomponent>