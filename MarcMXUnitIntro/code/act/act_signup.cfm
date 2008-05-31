<!--- THIS IS BAD CODE!!!!!  --->


<!--- validate password --->
<cfset v = createObject("component","mxunit-cfmeetups.MarcMXUnitIntro.code.PasswordValidator")>
<cfset isValid = v.validate(form.password)>

<!--- if valid, process registration and redirect to main screen --->
<cfif isValid>
	<cflocation url="../dsp/dsp_main.cfm">
<cfelse>
<!--- else, return to user screen --->
	<cfset client.message = v.getResultsMessage()>
	<cflocation url="../dsp/dsp_SignUp.cfm">
</cfif>