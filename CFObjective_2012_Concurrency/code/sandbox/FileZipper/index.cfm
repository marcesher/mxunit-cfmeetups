<cfoutput>
	
<p>Completion Queue Size: #application.completionQueue.size()#</p>

<!---<cfdump var="#application.completionQueue#" label="Completion Queue... this is the collection of completed tasks that need to be poll()'d">
<cfdump var="#application.completionService#" label="Completion Service">
--->
	
<p><a href="?reinit=true">Re-init</a></p>
<p><a href="submitRequest.cfm">Submit a request</a></p>
<p><a href="mimicMultipleSubmissions.cfm">Mimic multiple duplicate requests</a></p>
<p><a href="processFinishedRequests.cfm">Process finished requests</a></p>

<cfdump var="#application.fileZip.getVars()#" showudfs="false">
	
</cfoutput>