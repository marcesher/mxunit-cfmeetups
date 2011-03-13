<cfscript>

ormreload();

// 3. Change Administrator's 'modifiedBy' to a Many-to-One
administrators = entityLoad("Administrator");
writeDump( var = administrators, top = 3, label="Administrators");

events = entityLoad("Event");
writeDump( var = events, top = 3, label="Events");

attendees = entityLoad("Attendee");
writeDump( var = attendees, top = 3, label="Attendees");





// 4. how would you ask: "what events were administered by administratorID X?

//this is an Administrator Object
someAdmin = administrators[1];
events = entityLoad("Event", {modifiedBy = someAdmin});
writeDump( var = events, top = 3, label="Events administered by admin id #someAdmin.getId()#");
</cfscript>
