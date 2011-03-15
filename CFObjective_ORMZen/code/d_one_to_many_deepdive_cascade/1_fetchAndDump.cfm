<cfscript>

ormreload();

// 1. Look at Event.cfc -- Notice the one-to-many collection of Attendees that we've added

events = entityLoad("Event");
writeDump( var = events, top = 3, label="Events");



</cfscript>
