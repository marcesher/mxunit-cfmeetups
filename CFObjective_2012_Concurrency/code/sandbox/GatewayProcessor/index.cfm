<cfoutput>
	
Completion Queue Size: #application.completionQueue.size()#

<cfdump var="#application.completionQueue#" label="Completion Queue... this is the collection of completed tasks that need to be poll()'d">
<cfdump var="#application.completionService#" label="Completion Service">

<br>	
	
</cfoutput>