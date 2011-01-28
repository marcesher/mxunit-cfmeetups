<cfscript>

ormreload();

events = entityLoad("Event");
writeDump( var = events, top = 3 );

attendees = entityLoad("Attendee");
writeDump( var = attendees, top = 3);

</cfscript>
