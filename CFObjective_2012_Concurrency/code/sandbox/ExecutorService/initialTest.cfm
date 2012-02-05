<cfscript>
maxPendingPoolSize = 1000;
completionQueue = createObject("java", "java.util.concurrent.ArrayBlockingQueue").init(1000000);
executorService = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(4);
</cfscript>
