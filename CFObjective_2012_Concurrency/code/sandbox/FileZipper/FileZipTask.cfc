/*
* The FileZipTask is the 'wrapper', for purposes of use with the java concurrency framework.

An instance of this Task will run in isolation, and when it's completed the return from call()
will be available by polling the completion service. See processFinishedRequests.cfm for example
*/
component{
	createTick = getTickCount();
	result = {startTS = "", completeTS = "", error = "", status = 'pending', zipResult = {}};

	function init( string key, array files, any fileZipper ){
		structAppend(variables, arguments);
		return this;
	}

	public any function call(){
		try{
			var startTick = getTickCount();
			result.startTS = now();
			//because we initialize this task with the application-scoped fileZipper, ALL instances of a FileZipTask *share* this fileZipper
			//thus, it's imperative that any of its shared, mutable internal data structures (such as the 'duplicate cache') be thread-safe!
			result.zipResult = variables.fileZipper.zipFiles( variables.key, variables.files );

			result.status = "complete";
			writeLog("call finished!");
		}catch( any ex ){
			result.status = "error";
			result.error = ex;
			writeLog("Call errored! #ex.message#");
		}
		var endTick = getTickCount();
		result.completeTS = now();

		result.timeWaiting = startTick - createTick;
		result.timeZipping = endTick - startTick;
		result.timeTotal = endTick - createTick;

		return result;
	}

	function toString(){
		return serializeJson(result);
	}

}
