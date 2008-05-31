<cfcomponent extends="mxunit.framework.TestCase">

	

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset validator = createObject("component","mxunit-cfmeetups.MarcMXUnitIntro.code.PasswordValidator")>
		<cfset PASSWORD_WITHOUT_UPPERCASE = "mustfail">
		<cfset PASSWORD_WITHOUT_LOWERCASE = "MUSTFAIL">
		<cfset PASSWORD_WITHOUT_NUMBERS = "MustFailMust">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="testFailNoUpper">
		<cfset result = validator.validate(PASSWORD_WITHOUT_UPPERCASE)>
		<cfset debug(validator.getResultsMessage())>
		<cfset assertEquals("false",result,"Should've returned false but didn't. Results message is #validator.getResultsMessage()#")>
	</cffunction>
	
	<cffunction name="testFailNoLower">		
		<cfset result = validator.validate(PASSWORD_WITHOUT_LOWERCASE)>
		<cfset assertEquals("false",result,"#PASSWORD_WITHOUT_LOWERCASE# should've failed but didn't")>
	</cffunction> 
	
	<cffunction name="testFailNoNumbers">
		<cfset result = validator.validate(PASSWORD_WITHOUT_NUMBERS)>
		<cfset assertEquals("false",result,"#PASSWORD_WITHOUT_NUMBERS# should've failed but didn't")>
	</cffunction>
	
	<cffunction name="testGetResults">
		<cfset validator.validate(PASSWORD_WITHOUT_UPPERCASE)>
		<cfset assertTrue(len(validator.getResultsMessage()),"Results message must have length for a failed password")>
	</cffunction>
	
	<cffunction name="testGetResultsNoDupes">
		<cfset validator.validate(PASSWORD_WITHOUT_UPPERCASE)>
		<cfset mess1 = validator.getResultsMessage()>
		<cfset validator.validate(PASSWORD_WITHOUT_UPPERCASE)>
		<cfset mess2 = validator.getResultsMessage()>
		<cfset assertEquals(mess1,mess2,"Validation messages should be the same; there should be no duplicates.")>
	</cffunction>
	
	<!--- NOTICE HOW THIS TEST NAME SEEMS CLEARER? HOW WOULD YOU RENAME THE OTHER TESTS 
	TO MAKE THEM MORE EXPRESSIVE? --->
	<cffunction name="shouldNotHaveSpaces" returntype="void" hint="">
		<cfset var XX = "">
		<cfset fail("ShouldNotHaveSpaces not yet implemented")>
	</cffunction>
	
</cfcomponent>