<h3>Update Profile (Flex)</h3>
<cfoutput>
<cfform format="flash" action="update_profile.cfm" method="post">
  <cfformitem type="html">
   <cfoutput>
     username: #session.user.username# <br />
     id: #session.user.id# <br />
   </cfoutput>
  </cfformitem>
<cfinput label="new password" type="password" name="newpwd" /><br />
<cfinput type="text" label="name" name="name" value="#session.user.name#" /><br />
<cfinput type="text" label="email" name="email" value="#session.user.email#" /><br />
<cfinput name="submit" type="submit" value="Update Profile">
</cfform>
</cfoutput>