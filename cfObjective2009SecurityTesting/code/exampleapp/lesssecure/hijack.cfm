<title>Hi, Jack!</title>

<cfparam name="session.user" default="#structNew()#" type="struct">

Before Hijack
<cfdump label="Cookie" var="#cookie#">
<cfdump label="Session" var="#session#">
<cfdump label="Session.user" var="#session.user#">
<p><hr /></p>
<form action="##" method="POST">
jsessionid <input type="text" name="jsessionid" /><br />
urltoken <input type="text" name="urltoken" /><br />
<input type="submit" />
</form>

<cfif structKeyExists(form, 'jsessionid')>
  <cfcookie name="jsessionid" value="#form.jsessionid#" />
  <cfcookie name="urltoken" value="#form.urltoken#" />
</cfif>

<p><hr /></p>
After Hijack
<!---
<cfcookie name="jsessionid" value="#form.jsessionid#"> --->

<cfdump label="Cookie" var="#cookie#">
<cfdump label="Session" var="#session#">
<cfdump label="Session.user" var="#session.user#">


