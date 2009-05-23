
<title>Login Form</title>

<h3>Process Login</h3>

<cfoutput>

<cfset user = createObject('component','User') />
<cfset user.login(form.username,form.password) />


<cfif user.getId() is ''>
  Bad login <br />
  <a href="loginform.cfm">Try again</a>
<cfelse>
  <p><a href="profile.cfm">Update Profile</a></p>
  <cfdump label="Session Info" var="#session#">
  <cfdump label="Cookie Info" var="#cookie#">
  <p><hr />


</cfif>

</cfoutput>











