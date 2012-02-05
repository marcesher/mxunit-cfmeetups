<cfscript>


completionQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init(1000000);
executor = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(4);
completionService = createObject("java", "java.util.concurrent.ExecutorCompletionService").init(executor, completionQueue);
timeUnit = createObject("java", "java.util.concurrent.TimeUnit");



sanity = new ThingieDoer(1, "normal old thingiedoer");
writeDump(var=sanity.call(), label="result of calling thingieDoer directly");


CFCDynamicProxy = application.javaloader.create("com.compoundtheory.coldfusion.cfc.CFCDynamicProxy");
interfaces = ["java.util.concurrent.Callable"];

for(i=2; i LTE 5; i++){
	thingieDoer = new ThingieDoer(i , "name #i#" );
	//proxy = createDynamicProxy(thingieDoer, interfaces); //zeus
	proxy = CFCDynamicProxy.createInstance(thingieDoer, interfaces);
	completionService.submit( proxy ); 
	writeDump(var=proxy, label="The thingieProxy", expand="false");
}
executor.shutdown();
executor.awaitTermination( javacast("int",1), timeUnit.SECONDS );

thisResult = completionService.poll();
while(  NOT isNull( thisResult ) ){
	writeDump( var = thisResult, label = "completionService.poll() result. This is a Future" );
	writeOutput( "<br>done: " & thisResult.isDone() );
	writeOutput( "<br>canceled: " & thisResult.isCancelled() );

	try
    {
		thisResult.get();
    }
    catch(Any e)
    {
		writeDump(var=e, label="Error occurred on a Future.get() call");
    }


	thisResult = completionService.poll();
}



</cfscript>


