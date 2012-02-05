component{

	result = {multiplied=0};
	function init(value1, value2, atomicLongHolder){
		structAppend(variables, arguments);
		structAppend(result, arguments);
		return this;
	}

	public any function call(){
		try{
			//writeLog("inside call for values #value1# & #value2#");
			result.multiplied = value1 * value2;
			atomicLongHolder.addAndGet(result.multiplied);
			result.status = "complete";

		}catch( any ex ){
			result.status = "error";
			result.error = ex;
			writeLog("Call errored!");
		}
		return result;
	}

	function toString(){
		return "#value1# * #value2#";
	}

}
