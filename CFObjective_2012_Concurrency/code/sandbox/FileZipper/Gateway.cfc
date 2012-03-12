component{

	variables.taskInterfaces = ["java.util.concurrent.Callable"];

	public function submit( struct message ){
		writeLog("message accepted");
		
		//create an instance of the domain object which will process the task
		var task = new ProcessingTask( message );
		//create a proxy for it to pass to the executor service
		var proxy = application.CFCDynamicProxy.createInstance(task, variables.taskInterfaces);
		//submit to the service
		application.completionService.submit( proxy );
		writeLog("proxy submitted to the queue");
		return true;
	}
	
	private function createProxy( struct message ){
		
	}
}