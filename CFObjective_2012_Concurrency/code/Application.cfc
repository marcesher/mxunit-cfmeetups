component{
	this.name = "concurrency_zen";
	
	root = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/javaloader"] = root & "/javaloader"; 
	
	function onApplicationStart(){
		structDelete( server, "concurrencyZenJavaLoader" );
		paths = [ root & "javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar" ];
		server.concurrencyZenJavaLoader = new javaloader.JavaLoader(loadPaths = paths, loadColdFusionClassPath = true);
		
		//for convenience
		application.javaloader = server.concurrencyZenJavaLoader;
	}
	
	function onRequestStart(){
		if(structKeyExists(url, "stop")){
			applicationStop();
		}
	}
}