
<title>Login Form</title>

<h3>Process Login</h3>

<cfoutput>

<!--- Create AccessReferenceMap --->
<cfset arm = createObject('component','cfobjective.code.esapilite.org.owasp.esapi.AccessReferenceMap') />
<cfset user = createObject('component','User') />
<cfset user.login(form.username,form.password) />


<cfif user.getId() is ''>
  Bad login <br />
  <a href="loginform.cfm">Try again</a>
<cfelse>
  <!--- Regsiter a reference to user --->
  <cfset userRef = arm.addDirectReference(user) />
  <!--- Typical  Bad way to persist user info--->
  <cfset session.user = user />
  <!--- Better way to persist user info --->
  <cfset session.userRef = userRef />

  <p><a href="profile.cfm">Update Profile</a></p>

  <cfdump label="Session Info" var="#session#">
  <p><hr />
  This is data retrieved from session using <em>indirect reference</em>
  </p>
  <cfset userRefObject = arm.getDirectReference(session.userRef) />
  <cfdump label="User Info from Reference" var="#userRefObject#">
  <cfoutput>
   #userRefObject.getName()#<br />
   #userRefObject.getEmail()#
  </cfoutput>

</cfif>

</cfoutput>











