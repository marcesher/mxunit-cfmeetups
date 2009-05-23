<cfif not isDefined('session.userid')>
 <cflocation url="loginform.cfm">
</cfif>


<h3>Update Profile</h3>
<cfoutput>
<form action="update_profile.cfm" method="post">
username: #session.username# <br />
id: #session.userid# <br />
new password: <input type="password" name="newpwd" /><br />
name: <input type="text" name="name" value="#session.personname#" /><br />
email: <input type="text" name="email" value="#session.email#" /><br />
<input type="submit" value="Update Profile">
<input type="button" value="Logout" onclick="location.href='logout.cfm'">
</form>
</cfoutput>
