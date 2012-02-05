component{

	this.name = "gatewayExample";
	
	root = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/javaloader"] = root & "../../javaloader"; 
	
	function onApplicationStart(){
		structDelete( server, "gatewayJavaLoader" );
		paths = [ root & "../../javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar" ];
		server.gatewayJavaLoader = new javaloader.JavaLoader(loadPaths = paths, loadColdFusionClassPath = true);
		//for convenience
		application.javaloader = server.gatewayJavaLoader;
		
		//NOTE: you most likely would wrap all these things into a CFC which you kept in the app scope... this is just an example
		
		//You ALWAYS want a reasonably bounded queue.... 
		application.completionQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init(1000000);
		//you'd most likely make this threadpool count dynamic based on the number of processors+1
		application.executor = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(4);
		application.completionService = createObject("java", "java.util.concurrent.ExecutorCompletionService").init(application.executor, application.completionQueue);
		application.CFCDynamicProxy = application.javaloader.create("com.compoundtheory.coldfusion.cfc.CFCDynamicProxy");
		
		//this is *only* for ease in the submitRequests.cfm file
		application.gatewayProcessor = new Gateway(); 
	
	}
	
	function onApplicationStop(){
		var timeUnit = createObject("java", "java.util.concurrent.TimeUnit");
		writeLog("shutting down executor");
		application.executor.shutdown();
		executor.awaitTermination( javacast("int",10), timeUnit.SECONDS );
		writeLog("executor shut down");
	}

	function onRequestStart(){
		if( structKeyExists(URL, "reinit") ){
			applicationStop();
		}
	}

}