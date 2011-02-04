<cfscript>
ormReload();

//admin = entityLoad("Administrator",{},{maxresults=1})[1];

event = new Event();
event.setEventName("End of the world");
event.setEventDate("12/21/2012");
event.setIsActive(1);

event.setModifiedBy(7);

transaction{
	entitySave( event );
}

writeDump( var = event, top = 3 );

</cfscript>