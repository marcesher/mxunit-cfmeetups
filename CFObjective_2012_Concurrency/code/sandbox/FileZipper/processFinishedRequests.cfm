<!---

The application.completionQueue passed into the executor service is where completed requests end up.

You thus periodically need to pull them off and do whatever you need to do with them.... this is just one method of doing this.

Often, an app will have a 'completion' thread that spins all the time, most likely a ScheduledThreadPoolExecutor that runs every second, and all it does
is "drain" the completion queue

In this example, I'm just assuming you'd have a scheduled task that ran this file every minute, but you can certainly
conceive of all manner of ways in which you'd process the completion queue.

One great usage for this is for metrics... if your tasks keep track of how long they took, and how long they waited in the queue,
you can then get that data when you get the result, perhaps store it in the DB for later analysis

 --->
 
<cfscript>
timeUnit = createObject("java", "java.util.concurrent.TimeUnit");
thisTask = application.completionService.poll();
while(  NOT isNull( thisTask ) ){

	try
    {
    	result = thisTask.get( application.config.zipFileCancelSeconds , timeUnit.SECONDS);
    	writeDump(result);
    }
    catch(Any e)
    {
		writeDump(var=e, label="Error occurred on a Future.get() call");
    }


	thisTask = application.completionService.poll();
}
 	 
</cfscript>
