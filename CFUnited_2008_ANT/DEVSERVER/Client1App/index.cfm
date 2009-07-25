<h1>Hey, CFUnited!</h1>

<p><a href="index.cfm?reinit=true&dumpsettings=true">Reinitialize settings</a></p>
<p><a href="index.cfm?dumpsettings">Show application settings</a></p>

<h2>What is this?</h2>
<p>This demonstrates a non-simple application that uses two different shared codebases: a "codebase" directory for CFM files and a "com" directory for CFC files. On "dev", those files are shared among all applications. On all other environments, we want them to be underneath the client directory so that when deployed, changes to this shared code don't affect other client applications running on the same server. To achieve this, we use ANT to move the shared code into the client application

</p>

<h2>In action:</h2>
<p>	
	<ol>
		<li>run the index.cfm file inside of the DEVSERVER directory</li>
		<li>use the CopyToTest target from b_CopyingFiles.xml to copy files from dev to test</li>
		<li>inside TESTSERVER, run index.cfm</li>
		<li>Click the "reinit" link to reinitialize the app</li>
	</ol> 
</p>

<h3>Current settings</h3>
<cfoutput>
<ul>
	 <li><b>/com mapping = </b> #application.mappings["/com"]#</li> 
	<li><b>application.codebase = </b> #application.codebase#</li>
</ul>
</cfoutput>

<h3>Creating an object from "com" works in both environments</h3>
<p>
Create an AdminService object:
</p>

<p>
createObject("component","com.admin.AdminService")
<cfset createObject("component","com.admin.AdminService")>
</p>

<h3>Including files from codebase works in both environments</h3>
<p>
cfinclude application.codebase/admin/dsp_AdminMain.cfm:
</p>

<p>
<cfinclude template="#application.codebase#/admin/dsp_AdminMain.cfm">
</p>