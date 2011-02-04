<cfscript>

ormreload();

events = entityLoad("Event");
writeDump( var = events, top = 3, label="Events");

</cfscript>
