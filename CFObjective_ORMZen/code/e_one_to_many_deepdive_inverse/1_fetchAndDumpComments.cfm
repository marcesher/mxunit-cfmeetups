<cfscript>

ormreload();

/* 1. Load this to get a feel for what an EventComment object looks like */

/* 2. Open EventComment.cfc and inspect. */
comments = entityLoad("EventComment" );
writeOutput("<h1>Loading comments directly</h1>");
writeDump( var = comments, top = 3);


</cfscript>
