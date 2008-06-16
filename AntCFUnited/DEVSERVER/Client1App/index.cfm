<h1>Hey, CFUnited!</h1>

<p><a href="index.cfm?reinit=true&dumpsettings=true">Reinitialize settings</a></p>
<p><a href="index.cfm?dumpsettings">Show application settings</a></p>


<p>
Create an AdminService object:
</p>

<p>
createObject("component","com.admin.AdminService")
</p>

<p>
cfinclude application.codebase/admin/dsp_AdminMain.cfm:
</p>

<p>
<cfinclude template="#application.codebase#/admin/dsp_AdminMain.cfm">
</p>