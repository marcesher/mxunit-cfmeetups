<cfcomponent extends="mxunit.framework.TestCase">
	
	
	
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset util = createObject("component","#application.frameworkroot#.utility.FileSystemUtility")>
	
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="testmakeFileNameSafe" returntype="void" hint="">
		<cfset var name = "MyFile.pdf">
		<cfset var newname = util.makeFileNameSafe(name)>	
		<cfset assertEquals(name,newname,"filenames should be equal")>
		
		<cfset name = "My.File blah2.pdf">
		<cfset newname = util.makeFileNameSafe(name)>		
		<cfset assertEquals("My_File_blah2.pdf",newname,"filenames should be equal")>
		
		<cfset name = "\\path\to\f ile_3_!@$%^&*(1)##.pdf">
		<cfset newname = util.makeFileNameSafe(name)>
		<cfset assertEquals("\\path\to\f_ile_3_________1__.pdf",newname,"filenames should be equal")>
		
	</cffunction>
	
	<cffunction name="testMakeFileNameUnique">
		<cfset dir = getDirectoryFromPath(getCurrentTemplatePath())>
		<cfif getTempDirectory() neq "">
			<cfset dir = getTempDirectory()>					
		</cfif>
		
		<cfset  tmpFile = getTempFile(dir,"tmp")>
		<cftry>
			<cfoutput>tmpFile: #tmpFile#</cfoutput>
			<cfset newFile = util.MakeFileNameUnique(tmpFile)>
			<cfoutput>newFile: #newFile#<br></cfoutput>
			<cfset assertEquals(getDirectoryFromPath(tmpFile),getDirectoryFromPath(newFile),"directories should be equal but aren't")>
			<cfset assertTrue(newFile neq tmpFile,"newFile shouldn't equal tmpFile")>
			
			<cffile action="write" file="#newFile#" output="blah"> 
			<cfset newFile2 = util.MakeFileNameUnique(newFile)>
			<cfset assertEquals(getDirectoryFromPath(newFile2),getDirectoryFromPath(newFile),"directories should be equal but aren't")>
			<cfset assertTrue(newFile neq newFile2,"newFile shouldn't equal tmpFile")>
			<cfoutput>
			newFile2: #newFile2#		
			</cfoutput>
			
			<cfset newFile3 = util.MakeFileNameUnique(tmpFile)>
			<cfset assertEquals(getDirectoryFromPath(newFile3),getDirectoryFromPath(tmpFile),"directories should be equal but aren't")>
			<cfset assertTrue(newFile3 neq tmpFile,"newFile shouldn't equal tmpFile")>
			<cfoutput>
			newFile3: #newFile3#		
			</cfoutput>
		<cffile action="delete" file="#tmpFile#">
		<cfset debug("file deleted")>
		<cfcatch>
			<cffile action="delete" file="#tmpFile#">
			<cfrethrow>
		</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="testGetFilenameWithoutExtension" returntype="void" hint="">
		<cfset var name = "file.pdf">
		<cfset var newname = "">
		<cfset assertEquals("file",util.GetFileNamewithoutExtension(name))>
		<cfset name = "\\path\to\file.pdf">
		<cfset assertEquals("file",util.getFileNameWithoutExtension(name))>
		<cfset name = "\\path\to\file">
		<cfset newname = util.getFilenameWithoutExtension(name)>
		<cfset assertEquals("file",newname)> 
		<cfset name = "\\path\to.1\file.1.pdf">
		<cfset newname = util.getFileNameWithoutExtension(name)>
		<cfset assertEquals("file.1",newname)>
	</cffunction>
	

</cfcomponent>