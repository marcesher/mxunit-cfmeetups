component{

	this.name = "fileZipperExample";

	root = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/javaloader"] = root & "../../javaloader";

	function onApplicationStart(){

		application.config = {
			// you ALWAYS want a reasonably bounded queue. This is the maximum number of requests we'll allow to queue
			maxQueueLength = 1000


			//you'd most likely make this threadpool count dynamic based on the number of processors+1
			//For CPU-intensive tasks, you may want to decrease it
			//FOR IO-intensive tasks, you may want to increase it
			//For the purpose of this exercise, I'm setting it to 1 to mimic "process only one at a time"
			, maxConcurrentZips = 1

			//when the application stops, how many seconds do we give the completion service to finish currently executing tasks
			, awaitTerminationSeconds = 10

			, zipOutputPath = root & "/zipoutput/"

			//how many seconds do we consider a submission with the same 'key' a duplicate/ignorable submission?
			, preventDupSeconds = 30

			//how long do we wait before we 'cancel' an executing zip? Note that this won't (can't!) actually
			//stop ColdFusion from processing the zip till completion... this just opens up the queue to start processing another
			, zipFileCancelSeconds = 60
		};


		//following best practice for putting the specific javaloader instance in the server scope
		structDelete( server, "appJavaLoader" );
		var libs = directoryList( root & "/lib", true, "array" );
		arrayAppend( libs, root & "../../javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar" );
		server.appJavaLoader = new javaloader.JavaLoader(loadPaths = libs, loadColdFusionClassPath = true);

		//for convenience
		application.javaloader = server.appJavaLoader;

		//NOTE: you most likely would wrap all these things into a CFC which you kept in the app scope... this is just an example

		//This is Part 1 of the 'bread-n-butter' of using the Java Concurrency Framework. It includes the following:

		//1: a queue to hold completed tasks
		application.completionQueue = createObject("java", "java.util.concurrent.LinkedBlockingQueue").init(application.config.maxQueueLength);

		//2: a thread pool configured with the number of max threads we wish it to allocate
		application.executorThreadPool = createObject("java", "java.util.concurrent.Executors").newFixedThreadPool(application.config.maxConcurrentZips);

		//3: a Completion Service, to which we will submit 'Task' instances. It schedules and executes those tasks, and places completed results into the completion queue
		application.completionService = createObject("java", "java.util.concurrent.ExecutorCompletionService").init(application.executorThreadPool, application.completionQueue);

		//this DynamicProxy is a kind of "factory"... we'll use it to create "proxy" objects which we can submit to the Completion Service
		//without this, we would not be able to use the Java Concurrency Framework
		//NOTE: in CF 10, you can use the new createDynamicProxy() function instead of using javaloader
		application.CFCDynamicProxy = application.javaloader.create("com.compoundtheory.coldfusion.cfc.CFCDynamicProxy");
		application.taskInterfaces = ["java.util.concurrent.Callable"];

		//create an app-scoped instance of a component that zips files and such. File zipping is trivial...
		//the real work in this component involves decision making to avoid obvious duplicate zip file creation
		application.fileZip = new DuplicatePreventingFileZipper( application.config.zipOutputPath, application.config.preventDupSeconds );
	}

	function onApplicationStop(){
		var timeUnit = createObject("java", "java.util.concurrent.TimeUnit");
		writeLog("shutting down executor");

		//when the app stops, we'll shut down the thread pool, giving it a few seconds to finish what it was doing
		application.executorThreadPool.shutdown();
		application.executorThreadPool.awaitTermination( javacast("int", application.config.awaitTerminationSeconds), timeUnit.SECONDS );
		writeLog("executor shut down");
	}

	function onRequestStart(){
		if( structKeyExists(URL, "reinit") ){
			applicationStop();
			onApplicationStop();
		}
	}

}