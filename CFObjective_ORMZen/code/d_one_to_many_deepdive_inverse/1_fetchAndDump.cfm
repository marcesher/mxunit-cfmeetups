<cfscript>

ormreload();

// 1. Look at Attendee.cfc -- Notice the one-to-many collection of Attendances that we've added

attendees = entityLoad("Attendee");
writeDump( var = attendees, top = 3, label="Attendees");



</cfscript>
