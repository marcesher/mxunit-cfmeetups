component{
	this.name = "threadtests";
	
	function onRequestStart(){
		if(structKeyExists(url, "stop")){
			applicationStop();
		}
	}
}