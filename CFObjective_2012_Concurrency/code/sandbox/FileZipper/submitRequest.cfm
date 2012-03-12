<cfscript>
	
	//mimic a unique key coming from a form post
	attributes.key = createUUID();
	//mimic file selection coming from a form post
	attributes.files = [];
	
	writeLog("message accepted");
		
	//create an instance of the domain object which will process the task
	task = new FileZipTask( key = attributes.key, files = attributes.files );
	//create a proxy for it to pass to the executor service
	proxy = application.CFCDynamicProxy.createInstance(task, application.taskInterfaces);
	//submit to the service
	application.completionService.submit( proxy );
	writeLog("proxy submitted to the queue");
	writeOutput("proxy submitted to the queue");
</cfscript>
