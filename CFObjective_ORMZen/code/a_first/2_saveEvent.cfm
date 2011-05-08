
<!--- Get a single administrator ID --->
<cfquery datasource="events" name="getAdminID" maxrows=1>
select id from administrator
</cfquery>

<cfscript>
//When in doubt, ormReload()!
//But... Don't be surprised if ormReload() doesn't work 
//and you need to restart CF
ormReload();

event = new Event();
event.setEventName("End of the world");
event.setEventDate("12/21/2012");
event.setIsActive(1);

event.setModifiedBy(getAdminID.id);

entitySave( event );
transaction{}

writeDump( var = event, top = 3 );

</cfscript>