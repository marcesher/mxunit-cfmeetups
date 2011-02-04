<cfscript>
ormReload();

//admin = entityLoad("Administrator",{},{maxresults=1})[1];

event = new Event();
event.setEventName("End of the world");
event.setEventDate("12/21/2012");
event.setIsActive(1);

/*
look what happens when we try to save a simple value
The value for property java.lang.String cannot be retrieved from object of type id. Expected object type is Administrator.

Root cause :org.hibernate.HibernateException: The value for property java.lang.String cannot be retrieved from object of type id. Expected object type is Administrator.
*/

event.setModifiedBy(7);
//event.setModifiedBy(admin);

transaction{
	entitySave( event );
}

writeDump( var = event, top = 3 );

</cfscript>