<cfif not isDefined('session.user')>
 <cflocation url="loginform.cfm">
</cfif>


<h3>Update Profile</h3>
<cfoutput>
<form action="update_profile.cfm" method="post">
username: #session.user.getUsername()# <br />
id: #session.user.getId()# <br />
new password: <input type="password" name="newpwd" /><br />
name: <input type="text" name="name" value="#session.user.getName()#" /><br />
email: <input type="text" name="email" value="#session.user.getEmail()#" /><br />
<input type="submit" value="Update Profile">
<input type="button" value="Logout" onclick="location.href='logout.cfm'">
</form>
</cfoutput>
