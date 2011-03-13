component{
	this.name = "ORMZen";
	this.datasource = "events";
	this.ormEnabled = true;

	this.ormsettings = {
		//set to false and ormReload() to get rid of console logging
		logsql = true, 
		
		// I *always* keep this false; this will *require* you to use transaction{}
		// or ormFlush() in order to commit database inserts/updates/deletes
		flushAtRequestend = false, 
		
		// I *always* keep this false
		automanageSession = false 
	};

	//If You're on Oracle 10/11, you may need the following; 
	//In one of our apps, without useDBForMapping = false, the app would barely run
	//dialect = "Oracle10g",
	//useDBForMapping = false,
	
	ormReloadKey="hotdog";
	
	function onRequestStart(){
		//http://localhost/path/to/file.cfm?ormReload=hotdog
		if( structKeyExists(url, "ormReload") 
			&& url.ormReload == ormReloadKey ){
			ormReload();
		}
	}
}
