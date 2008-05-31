<cfset v = createObject("component","mxunit-cfmeetups.MarcMXUnitIntro.code.PasswordValidator")>

<cfset v.validate("MyBig1LongUsername")>

<cfoutput>message ('MyBig1LongUsername'): [#v.getResultsMessage()#]</cfoutput>


<br><br>
<cfset v.validate("none")>

<cfoutput>message ('none'): [#v.getResultsMessage()#]</cfoutput>


