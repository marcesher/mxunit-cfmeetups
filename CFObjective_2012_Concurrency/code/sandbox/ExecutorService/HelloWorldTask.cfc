component{

	result = {message = "", error = "", you="awesome"};
	
	function init( name ){
		structAppend(variables, arguments);
		return this;
	}

	// MUST be named call() if API expects a Callable; 
	// must be named run() and return void if API expects a Runnable
	public any function call(){
		try{
			result.message = "HELLO " & variables.name;

		}catch( any ex ){
			result.status = "error";
			result.error = ex;
		}
		return result;
	}
}
