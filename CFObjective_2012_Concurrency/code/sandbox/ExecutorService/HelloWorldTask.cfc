component{

	result = {message = "", error = "", you="awesome"};
	
	function init( name ){
		structAppend(variables, arguments);
		return this;
	}

	// MUST be named call()
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
