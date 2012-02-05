component{

	result = {startTS = "", completeTS = "", error = "", status = 'pending'};
	
	function init(struct message){
		structAppend(variables, arguments);
		variables.result.incomingMessage = arguments.message;
		return this;
	}

	public any function call(){
		try{
			result.startTS = now();
			sleep(1000);//mimic long-ish running process
			result.status = "complete";
			writeLog("call finished!");
		}catch( any ex ){
			result.status = "error";
			result.error = ex;
			writeLog("Call errored!");
		}
		result.completeTS = now();
		return result;
	}

	function toString(){
		return serializeJson(result);
	}

}
