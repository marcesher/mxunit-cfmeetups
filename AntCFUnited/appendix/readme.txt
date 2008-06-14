GetLatest.xml
------------------
Shows how to use an ant file to keep your computer up to date with the latest check-ins from VSS and SVN. It uses a properties file to define the repository locations and uses the for loop from the antlib package to loop over the repositories. Uses scriptdef to parse the locations


call-cfm.xml
-----------------
Shows how to load a CFM page and use the results


client1-build.xml, client2-build.xml, and base-build.xml
--------------------------------------------------------
shows how to use a single base ant file for performing
the hard work and having multiple client xml files for setting
client-specific properties. This is useful if you have a shared
codebase/application and multiple client applications that use the
shared application. This demonstrates both the "import" task and the 
"ant" task for calling targets from the base build file