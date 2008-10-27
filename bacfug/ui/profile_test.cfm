<cfset ini = getDirectoryFromPath(getCurrentTemplatePath()) & "credentials" />

<cfparam name="user" default="#getProfileString(ini,"section","u")#">
<cfparam name="pass" default="#getProfileString(ini,"section","p")#">

<cfoutput>
#user#</br>
#pass#
</cfoutput>