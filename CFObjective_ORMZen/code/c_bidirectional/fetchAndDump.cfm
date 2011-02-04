<cfscript>

ormreload();

administrators = entityLoad("Administrator");
writeDump( var = administrators, top = 3, label="Administrators");

events = entityLoad("Event");
writeDump( var = events, top = 3, label="Events");

attendees = entityLoad("Attendee");
writeDump( var = attendees, top = 3, label="Attendees");


</cfscript>
