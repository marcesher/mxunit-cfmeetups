<!---

See.... the application.completionQueue passed into the executor service is where completed requests end up.

You thus periodically need to pull them off and do whatever you need to do with them.... this is just one method of doing this.

Often, an app will have a 'completion' thread that spins all the time, perhaps on a Timer that runs every second, and all it does
is "drain" the completion queue

In this example, I'm just assuming you'd have a scheduled task that ran this file every minute, but you can certainly
conceive of all manner of ways in which you'd process the completion queue

 --->
 
<cfscript>

thisTask = application.completionService.poll();
while(  NOT isNull( thisTask ) ){

	try
    {
    	result = thisTask.get();
    	writeDump(result);
    }
    catch(Any e)
    {
		writeDump(var=e, label="Error occurred on a Future.get() call");
    }


	thisTask = application.completionService.poll();
}
 	 
</cfscript>
