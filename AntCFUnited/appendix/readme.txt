GetLatest.xml
------------------
Shows how to use an ant file to keep your computer up to date 
with the latest check-ins from VSS and SVN. It uses a properties 
file to define the repository locations and uses the for loop 
from the antlib package to loop over the repositories. Uses 
scriptdef to parse the locations


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

mxunit-build.xml
-----------------
the build file we use for packaging the mxunit framework. Shows
how to use propertyfile for version numbering, subversion for 
updating/commit/tagging, running unit tests, zipping, ftping, 
uploading to googlecode, and emailing

SwapPDFLib.xml
---------------
PDFLib is a library for building pdf files. Unfortunately, you 
can only run a single version of it on a computer at any one time.
This ant file shows how to switch between different versions of pdflib.
It stops CF, copies the appropriate files to the appropriate places,
restarts CF, runs a test page that confirms it's working properly
and displays the resultant pdf in the browser.
