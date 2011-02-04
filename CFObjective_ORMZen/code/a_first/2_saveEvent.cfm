<cfquery datasource="events" name="getAdminID" maxrows=1>
select id from administrator
</cfquery>

<cfscript>
ormReload();

event = new Event();
event.setEventName("End of the world");
event.setEventDate("12/21/2012");
event.setIsActive(1);

event.setModifiedBy(getAdminID.id);

transaction{
	entitySave( event );
}

writeDump( var = event, top = 3 );

</cfscript>