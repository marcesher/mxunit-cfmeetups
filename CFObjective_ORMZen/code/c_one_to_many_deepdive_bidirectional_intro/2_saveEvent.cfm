<cfscript>
ormReload();

admin = entityLoad("Administrator",{},{maxresults=1})[1];

event = new Event();
event.setEventName("End of the world");
event.setEventDate("12/21/2012");
event.setIsActive(1);

event.setModifiedBy(admin);

// NOTICE: We didn't need to add anything into the Administrator object to get the 
// collection of administered Events to show up... that's because this is the 
// simplest possible bi-di relationship. We'll see more complex ones soon
transaction{
	entitySave( event );
}

writeDump( var = event, top = 10 );

</cfscript>