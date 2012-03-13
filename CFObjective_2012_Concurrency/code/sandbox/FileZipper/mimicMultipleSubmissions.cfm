<cfscript>
	
	//mimic a unique key coming from a form post
	attributes.key = createUUID();
	//mimic file selection coming from a form post
	attributes.files = directoryList(expandPath("input"), false, "array" );
	
	for(i = 1; i LTE 100; i++ ){
		
		//create an instance of the domain object which will process the task
		task = new FileZipTask( key = attributes.key, files = attributes.files, fileZipper = application.FileZip );
		
		//create a proxy for it to pass to the executor service
		proxy = application.CFCDynamicProxy.createInstance(task, application.taskInterfaces);
		
		//submit to the service
		application.completionService.submit( proxy );
		writeLog("proxy submitted to the queue");
		writeOutput("proxy submitted to the queue<br>");
	}
		
</cfscript>
