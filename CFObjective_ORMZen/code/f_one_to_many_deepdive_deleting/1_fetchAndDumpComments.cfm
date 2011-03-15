<cfscript>

ormreload();

comments = entityLoad("EventComment" );
writeOutput("<h1>Loading comments directly</h1>");
writeDump( var = comments, top = 3);


</cfscript>
