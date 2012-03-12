component{

	this.name = "gatewayExample";
	
	root = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/javaloader"] = root & "../../javaloader"; 
	
	function onApplicationStart(){
		
		application.poolConfig = {
			// you ALWAYS want a reasonably bounded queue
			maxQueueLength = 100000 
			
			
			//you'd most likely make this threadpool count dynamic based on the number of processors+1
			//For CPU-intensive tasks, you may want to decrease it
			//FOR IO-intensive tasks, you may want to increase it
			//For the purpose of this exercise, I'm setting it to 1 to mimic "process only one at a time"
			, maxConcurrent = 4 
		};
		
		//following best practice for putting the specific javaloader instance in the server scope
		structDelete( server, "appJavaLoader" );
		paths = [ root & "../../javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar" ];
		server.appJavaLoader = new javaloader.JavaLoader(loadPaths = paths, loadColdFusionClassPath = true);
		//for convenience
		application.javaloader = server.appJavaLoader;
		
		//NOTE: you most likely would wrap all these things into a CFC which you kept in the app scope... this is just an example
		
		application.completionQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init(application.poolConfig.maxQueueLength);
		application.executor = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(application.poolConfig.maxConcurrent);
		application.completionService = createObject("java", "java.util.concurrent.ExecutorCompletionService").init(application.executor, application.completionQueue);
		application.CFCDynamicProxy = application.javaloader.create("com.compoundtheory.coldfusion.cfc.CFCDynamicProxy");
		application.taskInterfaces = ["java.util.concurrent.Callable"];
	}
	
	function onApplicationStop(){
		var timeUnit = createObject("java", "java.util.concurrent.TimeUnit");
		writeLog("shutting down executor");
		application.executor.shutdown();
		application.executor.awaitTermination( javacast("int",10), timeUnit.SECONDS );
		writeLog("executor shut down");
	}

	function onRequestStart(){
		if( structKeyExists(URL, "reinit") ){
			applicationStop();
			onApplicationStop();
		}
	}

}