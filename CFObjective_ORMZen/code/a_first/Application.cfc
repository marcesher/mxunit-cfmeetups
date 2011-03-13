component{
	this.name = "ORMZen";
	this.datasource = "events";
	this.ormEnabled = true;

	this.ormsettings = {
		logsql = true, //set to false and ormReload() to get rid of console logging
		flushAtRequestend = false, // I *always* keep this false
		automanageSession = false // I *always* keep this false
	};

	//IF You're on Oracle 10/11, you may need the following; In one of our apps, without useDBForMapping = false, the app would barely run
	//dialect = "Oracle10g",
	//useDBForMapping = false,
}
