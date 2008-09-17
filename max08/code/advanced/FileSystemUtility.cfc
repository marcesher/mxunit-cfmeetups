<cfcomponent hint="Contains useful functions for manipulating the file system">
	
	<cfset SLEEP_SECONDS = 1>
	
	<cffunction name="setSleepSeconds" hint="set the number of seconds to sleep in between retries when an operation fails" output="false" access="public">
		<cfargument name="seconds" required="true" type="numeric" hint="the number of seconds to sleep">
		<cfset SLEEP_SECONDS = seconds>
	</cffunction>
	
	<cffunction name="getSleepSeconds" hint="returns the current number of seconds the object is set to sleep for when operations fail and retry is true" access="public" returntype="numeric">
		<cfreturn SLEEP_SECONDS>
	</cffunction>
	

	<!---
	 Copies a directory.
	 
	 @param source 	 Source directory. (Required)
	 @param destination 	 Destination directory. (Required)
	 @param nameConflict 	 What to do when a conflict occurs (skip, overwrite, makeunique). Defaults to overwrite. (Optional)
	 @return Returns nothing. 
	 @author Joe Rinehart (joe.rinehart@gmail.com) 
	 @version 1, July 27, 2005 
	 @version 2, May 12, 2006 Marc Esher. added return struct
	--->
	<cffunction name="directoryCopy" output="false" returntype="struct" hint="copies a directory. returns a structure with useful information. This method will throw an error if any native CF errors occur. It will also throw an error if no errors occur but the number of files in the source and destination directories differs after the copy">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		<cfargument name="nameconflict" required="true" default="overwrite">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="ThrowOnError" required="false" default="true" hint="Whether to throw an error if the file counts of source and destination don't match after the copy. defaults to true">
		
		
		
		<cfset var contents = "" />
		<cfset var newcontents = "">
		<cfset var dirDelim = "/">
		<cfset var s_results = StructNew()>
		<cfset var attempt = 0>
		<cfset var thisCopy = "">
		<cfset s_results.debug = ArrayNew(1)>
		
		<cfif not DirectoryExists(source)>
			<cfthrow message="Source Directory does not exist" detail="This method could not see source directory [#source#]">
		</cfif>
		<cfloop from="0" to="#evaluate(retrycount+1)#" index="attempt">
			<cfset s_results.success = true>
			<cfset s_results.errormessage = "">
		
		
			<cfif server.OS.Name contains "Windows">
				<cfset dirDelim = "\" />
			</cfif>
			
			<cfif not(directoryExists(arguments.destination))>
				<cfset ArrayAppend(s_results.debug,"creating destination directory #destination#")>
				<cfdirectory action="create" directory="#arguments.destination#">
			</cfif>
			
			<cfdirectory action="list" directory="#arguments.source#" name="contents">
			<cfset s_results.sourceobjectcount = contents.recordcount>
			
			<cfloop query="contents">
				<cfif contents.type eq "file">
					<cfset ArrayAppend(s_results.debug,"Copying FILE #arguments.source#\#name# TO #arguments.destination#\#name#")>
					<cffile action="copy" source="#arguments.source#\#name#" destination="#arguments.destination#\#name#" nameconflict="#arguments.nameConflict#">
				<cfelseif contents.type eq "dir">
					<cfset thisCopy = directoryCopy(arguments.source & dirDelim & name, arguments.destination & dirDelim &  name) />
					<cfset ArrayAppend(s_results.debug,"Copying DIRECTORY: ")>
					<cfset ArrayAppend(s_results.debug,"#thisCopy#")>
				</cfif>
			</cfloop>
			
			<cfdirectory action="list" directory="#arguments.destination#" name="newcontents">
			<cfset s_results.destinationobjectcount = newcontents.recordcount>
			
			<cfif s_results.destinationobjectcount NEQ s_results.sourceobjectcount>
				<cfset s_results.success = false>
				<cfset s_results.ErrorMessage = "The number of files in the source directory [#source#] does not match the number of files in the destination directory! [#destination#]">
				<cfset s_results.SourceContents = contents>
				<cfset s_results.DestinationContents = newcontents>
			</cfif>
			
			<cfif s_results.success>
				<cfbreak>
			</cfif>
			
			<!--- if it failed and we haven't exhausted our retry attempts, sleep for a few and then try again --->
			<cfif NOT s_results.success AND attempt LT retrycount>
				<cfset sleepMX(retrysleep)>
			</cfif>
		</cfloop>
		<cfreturn s_results>
	</cffunction>
	
	
	<!---
	 Recursively delete a directory.
	 
	 @param directory 	 The directory to delete. (Required)
	 @param recurse 	 Whether or not the UDF should recurse. Defaults to false. (Optional)
	 @return Return a struct. 
	 @author Rick Root (rick@webworksllc.com) 
	 @version 1, July 28, 2005 
	 @version 2, May 12, 2006, Marc Esher, added struct return and retry hoogies
	--->
	<cffunction name="directoryDelete" returntype="struct" output="false">
		<cfargument name="directory" type="string" required="yes" >
		<cfargument name="recurse" type="boolean" required="no" default="true">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="true" hint="Whether to throw an error if the directory or any of its files could not be deleted">
		
		<cfset var myDirectory = "">
		<cfset var count = 0>
	
	
		<cfset var s_results = StructNew()>
		<cfset var attempt = 0>
		<cfset var thisDelete = "">
		<cfset s_results.debug = ArrayNew(1)>
		
		<cfif not DirectoryExists(directory)>
			<cfthrow message="Source Directory does not exist" detail="This method could not see source directory [#directory#]">
		</cfif>
		<cfloop from="0" to="#evaluate(retrycount+1)#" index="attempt">
			<cfset s_results.success = true>
			<cfset s_results.errormessage = "">
	
	
			<cfif right(arguments.directory, 1) is not "\">
				<cfset arguments.directory = arguments.directory & "\">
			</cfif>
			
			<cfdirectory action="list" directory="#arguments.directory#" name="myDirectory">
			<cfset s_results.DirectoryObjectCount = myDirectory.RecordCount>
		
			<cfloop query="myDirectory">
				<cfif myDirectory.name is not "." AND myDirectory.name is not "..">
					<cfset count = count + 1>
					<cfswitch expression="#myDirectory.type#">
					
						<cfcase value="dir">
							<!--- If recurse is on, move down to next level --->
							<cfif arguments.recurse>
								<cfset arrayAppend(s_results.debug,"Deleting DIRECTORY:")>
								<cfset thisdelete = directoryDelete(
									arguments.directory & myDirectory.name,
									arguments.recurse, arguments.retrycount, arguments.throwOnError )>
								<cfset arrayAppend(s_results.debug,thisDelete)>
							</cfif>
						</cfcase>
						
						<cfcase value="file">
							<!--- delete file --->
							<cfif arguments.recurse>
								<cfset ArrayAppend(s_results.debug,"Deleting FILE #arguments.directory##myDirectory.name#")>
								<cftry>
									<cffile action="delete" file="#arguments.directory##myDirectory.name#">
								<cfcatch>
									<cfset s_results.success = false>
									<cfset s_results.ErrorMessage = cfcatch.Message & ": " & cfcatch.Detail>
								</cfcatch>
								</cftry>
								
							</cfif>
						</cfcase>			
					</cfswitch>
				</cfif>
			</cfloop>
			<cfif (count is 0 or arguments.recurse) AND DirectoryExists(arguments.directory)>
				<cfset ArrayAppend(s_results.debug,"Deleting DIRECTORY #arguments.directory#")>
				
				<cftry>
					<cfdirectory action="delete" directory="#arguments.directory#">
				<cfcatch>
					<cfset s_results.success = false>
					<cfset s_results.ErrorMessage = cfcatch.Message & ": " & cfcatch.Detail>
				</cfcatch>
				</cftry>
				
			</cfif>
			
			
			<cfif s_results.success>
				<cfbreak>
			</cfif>
			
			<!--- if it failed and we haven't exhausted our retry attempts, sleep for a few and then try again --->
			<cfif NOT s_results.success AND attempt LT retrycount>
				<cfset sleepMX(retrysleep)>
			</cfif>
			
			
			
		</cfloop>
		
		<cfif DirectoryExists(arguments.Directory) and arguments.ThrowOnError>
			<cfthrow message="Directory [#arguments.Directory#] still exists!">
		</cfif>
		
		<cfreturn s_results>
	</cffunction>
	
	<!--- For cases where another process is preparing files to be deleted... --->
	<cffunction name="deleteDirectoriesFromStruct">
		<cfargument name="dirStruct" type="struct" required="yes" >
		<cfargument name="recurse" type="boolean" required="no" default="true">
		<cfargument name="retrycount" required="false" default="3">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="false" hint="Whether to throw an error if the file could not be deleted">
		
		<cfset L_KeyList = StructKeyList(arguments.dirStruct)>
		
		<cfloop list="#L_KeyList#" index="CurDir">
			<!--- OK, so the directory should exist, but if not we assume it is ok, this is for cleaning and shouldn't care... --->
			<cfif DirectoryExists(arguments.dirStruct[CurDir]) eq 1>
				<cfset directoryDelete(directory=arguments.dirStruct[CurDir],recurse=arguments.recurse,retrycount=arguments.retrycount,throwOnError=arguments.throwOnError)>
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="directoryMove" hint="renames one directory to another. this is a simple wrapper around the built-in cf functionality that has a retry mechanism" returntype="struct" output="false">
		<cfargument name="source" required="true" type="string">
		<cfargument name="destination" required="true" type="string">
		<cfargument name="nameconflict" required="true" default="overwrite">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="ThrowOnError" required="false" default="true" hint="Whether to throw an error if the source directory still exists or target directory does not exist after the rename">
		
		
		
		<cfset var contents = "" />
		<cfset var newcontents = "">
		<cfset var s_results = StructNew()>
		<cfset var attempt = 0>
		<cfset s_results.debug = ArrayNew(1)>
		
		<cfif not DirectoryExists(source)>
			<cfthrow message="Source Directory does not exist" detail="This method could not see source directory [#source#]">
		</cfif>
		<cfloop from="0" to="#evaluate(retrycount+1)#" index="attempt">
			<cfset s_results.success = true>
			<cfset s_results.errormessage = "">
	
			<cftry>
				<cfdirectory action="rename" directory="#source#" newdirectory="#destination#">
			<cfcatch>
			
			
			</cfcatch>
			</cftry>
	
			<cfif s_results.success>
				<cfbreak>
			</cfif>
			
			<!--- if it failed and we haven't exhausted our retry attempts, sleep for a few and then try again --->
			<cfif NOT s_results.success AND attempt LT retrycount>
				<cfset sleepMX(retrysleep)>
			</cfif>	
			
			
		</cfloop>
		
		<cfif DirectoryExists(arguments.source) and arguments.ThrowOnError>
			<cfthrow message="Directory [#arguments.source#] still exists!">
		</cfif>
		

		
		<cfreturn s_results>
	
	</cffunction>
	
	
	<cffunction name="deleteFile">
		<cfargument name="file" type="string" required="yes" >
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="true" hint="Whether to throw an error if the file could not be deleted">
		<cfargument name="deleteReadOnly" required="false" default="false" hint="if true, then read-only files will be deleted">
		<cfreturn fileAction(action="delete",argumentcollection=arguments)>
			
	</cffunction>
	
	<!--- For cases where another process is preparing files to be deleted... --->
	<cffunction name="deleteFilesFromStruct">
		<cfargument name="fileStruct" type="struct" required="yes" >
		<cfargument name="retrycount" required="false" default="3">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="false" hint="Whether to throw an error if the file could not be deleted">
		<cfargument name="deleteReadOnly" required="false" default="true" hint="if true, then read-only files will be deleted">
		
		<cfset L_KeyList = StructKeyList(arguments.fileStruct)>
		
		<cfloop list="#L_KeyList#" index="CurFile">
			<!--- OK, so the file should exist, but if not we assume it is ok, this is for cleaning and shouldn't care... --->
			<cfif fileExists(arguments.fileStruct[CurFile]) eq 1>
				<cfset deleteFile(file=arguments.fileStruct[CurFile],retrycount=arguments.retrycount,throwOnError=arguments.throwOnError,deleteReadOnly=arguments.deleteReadOnly)>
			</cfif>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="copyFile">
		<cfargument name="file" type="string" required="yes" >
		<cfargument name="destination" required="true">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="true" hint="Whether to throw an error if the file could not be copied">
	
		<cfreturn fileAction(action="copy",argumentcollection=arguments)>
	
	</cffunction>
	
	<cffunction name="moveFile">
		<cfargument name="file" type="string" required="yes" >
		<cfargument name="destination" required="true">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="true" hint="Whether to throw an error if the file could not be moved">
		
		<cfreturn fileAction(action="move",argumentcollection=arguments)>
		
	</cffunction>
	
	<cffunction name="renameFile">
		<cfargument name="file" type="string" required="yes" >
		<cfargument name="destination" required="true">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="true" hint="Whether to throw an error if the file could not be moved">
		
		<cfreturn fileAction(action="rename",argumentcollection=arguments)>
		
	</cffunction>
	
	<cffunction name="fileAction" access="private" returntype="struct">
		<cfargument name="file" type="string" required="yes" >
		<cfargument name="action" required="true" hint="delete, copy, move, rename">
		<cfargument name="destination" hint="required if action is copy or move or rename" required="false">
		<cfargument name="retrycount" required="false" default="0">
		<cfargument name="retrysleep" required="false" default="#SLEEP_SECONDS#">
		<cfargument name="throwOnError" required="false" default="true" hint="Whether to throw an error if the file could not be deleted">
		
		
		<cfset var s_results = StructNew()>
		<cfset var attempt = 0>
		<cfset s_results.debug = ArrayNew(1)>
		<cfset arrayAppend(s_results.debug,arguments)>
		<cfif not FileExists(file)>
			<cfthrow message="Source file does not exist" detail="This method could not see source file [#file#]">
		</cfif>
		<cfloop from="0" to="#evaluate(retrycount+1)#" index="attempt">
			<cfset s_results.success = true>
			<cfset s_results.errormessage = "">
			
			<cftry>
				<cfset arrayAppend(s_results.debug,"#ucase(action)# file #file#")>
				<cfswitch expression="#action#">
					<cfcase value="delete">
						<cfif arguments.deleteReadOnly and NOT fileCanWrite(file)>
							<cfset makeWritable(file)>
						</cfif>						
						<cffile action="delete" file="#file#">
					</cfcase>
					
					<cfcase value="copy,move,rename">						
						<cffile action="#action#" source="#file#" destination="#destination#">
					</cfcase>
					
					
				</cfswitch>
			<cfcatch>
				<cfset extramessage="It's true. THE file DOES NOT EXIST">
				<cfif fileExists(file)>
					<cfset extramessage = "The file DOES EXIST, so probably some process has a lock on it">
				</cfif>
				<cfset s_results.success = false>
				<cfset s_results.errormessage="#cfcatch.Message#: #cfcatch.Detail#. #extramessage#">
			</cfcatch>
			</cftry>
			
			<cfif s_results.success>
				<cfbreak>
			</cfif>
			
			<!--- if it failed and we haven't exhausted our retry attempts, sleep for a few and then try again --->
			<cfif NOT s_results.success>
				<cfif attempt LT retrycount>
					<cfset sleepMX(retrysleep)>
				<cfelseif throwonerror>
					<cfthrow message="#s_results.errormessage#">
				</cfif>			
				
			</cfif>
		</cfloop>
		<cfreturn s_results>
	</cffunction>
	
	
	
	
	
	<cffunction name="FileCanRead" hint="Checks if a file can be read." output="false" returntype="boolean">
		<cfargument name="filename" required="true" hint="full path to the file in question">
		<cfset var daFile = createObject("java", "java.io.File")>
		<cfset daFile.init(JavaCast("string", filename))>
		<cfreturn daFile.canRead()>
	
	</cffunction>
	
	<cffunction name="FileCanWrite" hint="Checks to see if a file can be written to." output="false" returntype="boolean">
		<cfargument name="filename" required="true" hint="full path to the file in question">
		<cfset var daFile = createObject("java", "java.io.File")>
		<cfset daFile.init(JavaCast("string", filename))>
		<cfreturn daFile.canWrite()>
	</cffunction>
	
	<cffunction name="makeWritable" hint="unsets the readonly flag on a file" output="false">
		<cfargument name="file" required="true" hint="the file to make writeable">
		<cfset var rt = createObject("java","java.lang.Runtime")>
		<cfset rt.getRuntime().exec("cmd.exe /c attrib -r #file#")>
		<!--- if we don't do this, then the file system cannot keep up! trust me --->
		<cfset sleepMX(.02)>
		<!--- justin's scared of cmd.exe from cfexecute --->
		<!--- 
		<cfexecute name="cmd.exe" arguments="/c attrib -r #file#" timeout="5"/> --->
	</cffunction>
	
	<cffunction name="sleepMX" access="public">
		<cfargument name="time" hint="time in seconds to sleep" required="true" type="numeric">
		<cfset var milliseconds = evaluate(arguments.time*1000)>
		<cfset var t = createObject("java","java.lang.Thread")>
		<cfset t.sleep(milliseconds)>
		<cfset t = "">
	</cffunction>
	
	<cffunction name="makeDirs" hint="creates all nonexistent directories in the path" access="public">
		<cfargument name="path" hint="the path to create" required="true" type="string">
		<cfset createObject("java", "java.io.File").init(path).mkdirs()>
	</cffunction>

	<cffunction name="stitchFiles" hint="combines files into one file" access="public" output="false">
		<cfargument name="Files" hint="An Array of files" type="array" required="true">
		<cfargument name="targetFile" hint="The file to write all the files to. This CAN be one of the files in the file array" required="true" type="string">
		<cfargument name="retryCount" hint="how many times to try reading a file into a byte array on our shitty production network. on a good network, you wouldn't need this" required="false" default="10" type="numeric">
		<cfargument name="retrySleep" hint="the number of seconds to sleep should something go wrong when reading a file into a byte array of on our shitty production network" required="false" default="2" type="numeric">
		
		<cfset var attempt = 1>
		<cfset var s_return = StructNew()>
		<cfset var fileutils = createObject("java","com.argus.util.FileUtils")>
		
		<cfset var tmpFile = targetFile & "_tmpToDelete">
		<cfset var javaTmpFile = createObject("java","java.io.File")>
		
		<cfscript>
		s_return.success = false;
		s_return.arguments = arguments;
		// read all bytes into byte array
		javaTmpFile.init(tmpFile);
		s_return.tmpfilelength = 0;
		s_return.totallength = fileutils.getFilesLength(Files);
		
		while(s_return.tmpfilelength neq s_return.totallength and attempt LTE retryCount){
			//this here little hoogie does all the work of stitching the files
			fileutils.writeBytesToFile(fileutils.filesToByteArray(Files),javaTmpfile);
		
		
			s_return.tmpfilelength = javaTmpFile.length();
			
			if(s_return.tmpfilelength LT s_return.totallength){
				attempt=attempt+1;
				sleepMX(retrySleep);
			}else{
				//overwrite the target with the temp
				if(fileExists(targetFile)){
					deleteFile(file=targetFile);
				}				
				moveFile(tmpFile,targetFile);	
				s_return.success = true;					
			}
		}
		s_return.attempts = attempt;
		
		</cfscript>
		<cfreturn s_return>
		
	</cffunction>
	
	<cffunction name="directoryQueryToArrayOfFiles" hint="turns a directory listing from a cfdirectory call into an array of full file paths" access="public" returntype="array">
		
		<cfargument name="baseDirectory" required="true" hint="the directory where these files live">
		<cfargument name="directoryQuery" required="true" hint="the query containing your cfdirectory results" type="query">
		
		<cfset var a_files = ArrayNew(1)>
		<cfif right(baseDirectory,1) neq "\">
			<cfset baseDirectory = baseDirectory & "\">
		</cfif>
		
		<cfloop query="directoryQuery">
			<cfif type eq "File">
				<cfset ArrayAppend(a_files,baseDirectory&name)>
			</cfif>
		</cfloop>
		
		<cfreturn a_files>
		
	</cffunction>
	
	<cffunction name="appendPDFs" hint="turns an array of pdf files into a single pdf file using ALE. This returns a structure with keys for messages, the ale return struct, and success=true/false" access="public" returntype="struct">
		<cfargument name="files" required="true" type="array" hint="An array of full file paths">
		<cfargument name="TargetFile" required="true" type="string" hint="Full file path of the resultant pdf">
		
		<cfset var i = "">
		<cfset var s_return = StructNew()>
		<cfset var ale = createObject("component","com.argus.framework.retail.ale.aleclient.AleClient")>
		<cfset var regionutils = createObject("component","com.argus.framework.retail.ale.aleclient.regions.RegionUtils")>
		<cfset var region = "">
		<cfset var tmpregion = "">
		<cfset s_return.Success = true>
		
		<!--- first, confirm all files are pdfs --->
		<cfloop from="1" to="#ArrayLen(files)#" index="i">
			<cfif right(files[i],3) neq "pdf">
				<cfthrow message="file named #files[i]# is not a pdf file">
			</cfif>
		</cfloop>
		
		<!--- send this sucker to ale --->
		<cfset ale.setPDFPath(TargetFile)>
		
		<!--- start a base region --->
		<cfset region = ale.newRegion()>
		<cfset region.setContentType("PDF")>
		<!--- create a temp region and copy its values into our base region --->
		<cfset tmpregion = regionutils.createStitchedImportRegions(SourcePathArray=files,TargetStartPage=1)>
		<cfset region.setContentAreas(tmpregion.contentareas)>
		<cfset region.setContent(tmpregion.content)>
		<cfset ale.attachRegion(region)>
		<cfset s_return.result = ale.build(forcereducewddx=true)>
		<cfset s_return.success = s_return.result.success>
		
		
		<cfreturn s_return>
	</cffunction>
	
	<cffunction name="makeFileNameSafe" access="public" output="false" hint="takes a file name and returns a new safe name">
		<cfargument name="FileName" required="true" type="string" hint="the file name to make safe. NOTE: ">
		<cfset var extension = listLast(arguments.FileName,".")>
		<cfset var dir = getDirectoryFromPath(arguments.FileName)>
		<cfset var name = getFileFromPath(arguments.FileName)>
		<cfset var finalPath = "">
		<!--- this will happen only when the arg passed is a name and not a full path --->
		<cfif listFind("\,/",dir)>
			<cfset dir = "">
		</cfif>
		
		<cfset name = reverse(listRest(reverse(name),"."))>
		<cfset name = reReplace(name,"\W","_","all")>
		<cfset finalPath = dir & name & "." & extension>
		<cfif finalPath neq fileName AND fileExists(finalPath)>
			<cfset finalPath = makeFileNameUnique(finalPath)>
		</cfif>
		<cfreturn finalPath>
	</cffunction>
	
	<cffunction name="makeFileNameUnique" output="false" access="public" returntype="string" hint="returns a unique file name">
		<cfargument name="FullPath" type="string" required="true"/>
		<cfargument name="delimiter" type="string" required="false" default="_" hint="optional delimiter to use when appending unique numbers onto the file name. defaults to underscore"/>
		<cfset var counter = 0>
		<cfset var dir = getDirectoryFromPath(FullPath)>
		<cfset var name = getFileNameWithoutExtension(FullPath)>
		<cfset var ext = "." & listLast(getFileFromPath(FullPath),".")>	
		<cfset var newPath = fullPath>
		<cfscript>
		while(fileExists(newPath)){
			counter = counter+1;					
			newPath = dir & name & delimiter & counter & ext; 	
		}
		</cfscript>
		<cfreturn newPath>
	</cffunction>
	
	<cffunction name="getFileNameWithoutExtension" output="false" access="public" returntype="string" hint="returns just the file name from a full path, without the extension">
		<cfargument name="FullPath" type="String" required="true"/>
		<cfset var name = "">
		<cfset var dir = getDirectoryFromPath(FullPath)>
		<cfset var filename = getFileFromPath(FullPath)>
		
		<cfset name = reverse(filename)>
		<cfif find(".",filename)>
			<cfset name = ListRest(name,".")>		
			<cfset name = reverse(name)>
		<cfelse>
			<cfset name = filename>
		</cfif>
		
		<cfreturn name>
	</cffunction>
	
	
</cfcomponent>
