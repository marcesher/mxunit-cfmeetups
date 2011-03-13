<cfscript>
ormReload();

//admin = entityLoad("Administrator",{},{maxresults=1})[1];

event = new Event();
event.setEventName("End of the world");
event.setEventDate("12/21/2012");
event.setIsActive(1);

// 1. Go to Event.cfc and change the "modifiedBy" property to a many-to-one
//		Then run this file


/*
look what happens when we try to save a simple value
The value for property java.lang.String cannot be retrieved from object of type id. Expected object type is Administrator.

Root cause :org.hibernate.HibernateException: The value for property java.lang.String cannot be retrieved from object of type id. Expected object type is Administrator.
*/

// 2. Fix the code below

event.setModifiedBy(7);
//event.setModifiedBy(admin);

// 3. Open Administrator.cfc and change its "modifiedBy" to a many-to-one

transaction{
	entitySave( event );
}

writeDump( var = event, top = 3 );

</cfscript>