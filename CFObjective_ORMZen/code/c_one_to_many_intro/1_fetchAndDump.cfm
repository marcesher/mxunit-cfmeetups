<cfscript>

ormreload();

// 1. Run this to show the non-persistent array of administered events for an administrator


// 2. Change Administrator.cfc to load all administered Events and run this again

// 3. Question: Do you *NEED* This kind of bidirectional one-to-many?

administrators = entityLoad("Administrator");
writeDump( var = administrators, top = 3, label="Administrators");




</cfscript>
