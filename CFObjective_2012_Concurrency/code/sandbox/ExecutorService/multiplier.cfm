<cfsetting showdebugoutput="false">
<cfscript>

completionQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init(1000000);
executor = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(4);
completionService = createObject("java", "java.util.concurrent.ExecutorCompletionService").init(executor, completionQueue);
timeUnit = createObject("java", "java.util.concurrent.TimeUnit");

holder = createObject("java", "java.util.concurrent.atomic.AtomicLong");
holder.init();

//create a single example to demonstrate the object in action outside of the executor service
sanityHolder = createObject("java", "java.util.concurrent.atomic.AtomicLong");
sanityHolder.init();
sanity = new Multiplier(2, 3, sanityHolder);
writeDump(var=sanity.call(), label="result of calling thingieDoer directly");


//now, from 1 to "goTo", create a new multiplier and a proxy for it, and pass it to the executor, which will handle all concurrency
CFCDynamicProxy = application.javaloader.create("com.compoundtheory.coldfusion.cfc.CFCDynamicProxy");
interfaces = ["java.util.concurrent.Callable"];

goTo = 2;
startTS = getTickCount();
for(i=1; i LTE goTo; i++){
	multiplier = new Multiplier(i, i+1, holder);
	proxy = CFCDynamicProxy.createInstance(multiplier, interfaces);
	completionService.submit( proxy );
}
executor.shutdown();
executor.awaitTermination( javacast("int",1), timeUnit.SECONDS );

allAddedUp = 0;
executorResult = holder.get();
executorTotalMS = getTickCount() - startTS;
/* Uncomment this to illustrate how you might add this up without using the AtomicLong
thisResult = completionService.poll();
while(  NOT isNull( thisResult ) ){

	try
    {
		allAddedUp += thisResult.get().multiplied;
    }
    catch(Any e)
    {
		writeDump(var=e, label="Error occurred on a Future.get() call");
    }


	thisResult = completionService.poll();
}*/

</cfscript>

<cfoutput>
#allAddedUp# vs. #executorResult#

<br>
Finished in #executorTotalMS#
</cfoutput>


