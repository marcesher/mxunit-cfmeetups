<cfscript>
goTo = 100;
startTS = getTickCount();
for(i=1; i LTE goTo; i++){
	message = {
		name = 'hey there #i#',
		count = i,
		ts = now()
	};	
	application.gatewayProcessor.submit( message );
	
}	
</cfscript>
