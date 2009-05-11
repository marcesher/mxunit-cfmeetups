<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset var fullPath = StructFindKey(getMetadata(this),"fullname")>
		<cfset var pathToHere = listDeleteAt(fullpath[1].value,"#listlen(fullPath[1].value,'.')#",".")>
		<cfset deleter = createObject("component","OldFileDeleter2")>
		
		<cfset fsuMock = createObject("component","mightymock.MightyMock").init("#pathToHere#.FileSystemUtility",true)>
		<cfset nuMock = createObject("component","mightymock.MightyMock").init("#pathToHere#.NotificationUtility")>
		
		<!--- ensure all deletes are safe! --->
		<cfset nuMock.deleteFile("{string}").returns("")>
		<!--- ensure no emails get sent --->
	 	<cfset nuMock.sendNotifications("{string}","{string}","{string}","{string}").returns()>
		<!--- ensure calls to getDirectoryListing always return our fake directory listing --->
		<cfset fsuMock.getDirectoryListing("{string}").returns(bigSpoofDirectory())>
		
		<!--- inject the mocks --->
		<cfset deleter.setFileSystemUtility(fsuMock)>
		<cfset deleter.setNotificationUtility(nuMock)> 
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceWithNoValidDirectoriesReturnsNoResults">
		<cfset results = deleter.runCleanupMaintenance("c:\notvalid",1,"marc@marc.com")>
		<cfset assertEquals(0,ArrayLen(results.deletedFiles),"the directory does not exist and therefore no files should be marked for deletion")>
	</cffunction>  
	
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFiles">
		<cfset results = deleter.runCleanupMaintenance("c:\noexist\",30,"marc@marc.com")>
		<!--- <cfset debug(results)> --->
		
		<cfset fileList = ArrayToList(results.deletedFiles)>
		
		<!--- this should thoroughly test our results; this works because we created a spoof
		query that makes it really easy to see which ones we know should've been included (using the "YES"/"NO" stuff) --->
		<cfset ourDirectories = bigSpoofDirectory()>
		<cfloop query="ourDirectories">
			<cfset thisFile = ourDirectories.Directory & ourDirectories.Name>
			<cfif find("_YES.txt",ourDirectories.Name)>
				<cfset assertTrue( ListFind(fileList,thisFile),   "should've found #thisFile# in #fileList#")>
			</cfif>
			<cfif find("_NO.txt",ourDirectories.Name)>
				<cfset assertFalse( ListFind(fileList,thisFile),   "should not have found #thisFile# in #fileList#")>
			</cfif>
		</cfloop>
		<cfset nuMock.verifyTimes(1).sendNotifications("{string}","{string}","{string}","{string}")>
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceShouldNotFailOnFileDeleteErrors">
		<cfset fsuMock.deleteFile("{string}").throws("File Could Not Be Deleted!")>
		<cfset results = deleter.runCleanupMaintenance("c:\noexist\",30,"marc@marc.com")>
		<cfset assertEquals(0, ArrayLen(results.deletedfiles) )>
		<!--- 4 because that's how many files we know should've been deleted --->
		<cfset assertEquals(4,ArrayLen(results.errors))>
		<cfset assertTrue( StructKeyExists( results.errors[1],"TagContext" ) )> 
		<cfset assertMocksRun()> 
	</cffunction>
	
	<cffunction name="getFilesOlderThanShouldReturnOnlyOldFiles">		
		<!--- set the target time one minute in the future.  --->
		<cfset var targetTime = DateAdd("n",1,now())>
		<!--- make getFilesOlderThan public so we can test it --->
		<cfset makePublic(deleter,"getFilesOlderThan")>
		
		<cfset all = deleter.getFilesOlderThan("c:\noexist\",targetTime)>
		<cfset debug(all)>
		<cfset FileList = Valuelist(all.Name)>
		<cfset assertTrue( listFind(FileList,"1minuteold_NO.txt") ,"")>
		<cfset assertFalse( listFind(FileList,"1minutenewer_NO.txt") ,"")>
	</cffunction>
	
	<cffunction name="formatEmailContentShouldHaveSummaryParagraph" returntype="void">
		<cfset var tmp = makePublic(deleter,"formatEmailContent")>
		<cfset var deletedFiles = ["c:\somefile.txt","c:\somefile2.txt"]>
		<cfset var str = deleter.formatEmailContent(deletedFiles,ArrayNew(1))>
		<cfoutput>[#str#]</cfoutput>
		<cfset assertXPath(xpath="/html/body/p",data=str,text="Results: 2 files deleted.")>
	</cffunction>
	
	<cffunction name="formatEmailContentShouldDumpErrors" returntype="void">
		<cfset var tmp = makePublic(deleter,"formatEmailContent")>
		<cfset var errors = ["c:\somefile.txt","c:\somefile2.txt"]><!--- in the real world, this would be an array of cfcatch structures; no need to duplicate that here though --->
		<cfset var str = deleter.formatEmailContent(ArrayNew(1),errors)>
		<cfoutput>[#str#]</cfoutput>
		<cfset assertTrue(findNoCase("cfdump",str))>
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFilesAtMidnight">
		<cfset fail("How would you test this? Hint.... think fsuMock.getTime().returns() and getMidnight()")>
	</cffunction>
	
	
	<!--- ////  END TESTS --->
	
	<!--- custom assertions --->
	<cffunction name="assertMocksRun" output="false" access="private" returntype="any" hint="">
		<cfset nuMock.verifyTimes(1).sendNotifications("{string}","{string}","{string}","{string}")>
		<cfset fsuMock.verifyTimes(1).getDirectoryListing("{string}")>
		<cfset fsuMock.verifytimes(4).deleteFile("{string}")>
	</cffunction>
	
	<!--- all this stuff is for spoofing/overriding; this contains 4 files (designated with 'YES' in the name) that I expect to be deleted;
	it contains 5 files (with 'NO' in the name) that should not be deleted, based on passing in  30 minutes as the "StaleInMinutes" arg to runCleanupMaintenance--->
	<cffunction name="bigSpoofDirectory" access="private">
		<cfset var dir = "">		
		<cfset var dirname = "c:\noexist\">
		<cfset var thisTime = now()>
		<cfoutput>
		<cf_querysim>			
		dir
		DateLastModified,Directory,Mode,Name,Size,Type
		#DateAdd("n",-1,thisTime)#|#dirname#| |1minuteold_NO.txt|100|File	
		#DateAdd("n",-29,thisTime)#|#dirname#| |29minutesold_NO.txt|100|File
		#DateAdd("n",-30,thisTime)#|#dirname#| |30minutesold_NO.txt|100|File
		#DateAdd("n",0,thisTime)#|#dirname#| |exactlynow_NO.txt|100|File
		#DateAdd("n",1,thisTime)#|#dirname#| |1minutenewer_NO.txt|100|File
		#DateAdd("n",-31,thisTime)#|#dirname#| |31minutesold_YES.txt|100|File		
		#DateAdd("n",-61,thisTime)#|#dirname#| |61minutesold_YES.txt|100|File		
		#DateAdd("d",-5,thisTime)#|#dirname#| |5daysold_YES.txt|100|File
		#DateAdd("d",-1,thisTime)#|#dirname#| |1dayold_YES.txt|100|File
		</cf_querysim>
		</cfoutput>
		<cfreturn dir>
	</cffunction>
	
	<cffunction name="getMidnight" access="private">		
		<cfreturn createDateTime(year(now()),month(now()),1,0,0,0)>
	</cffunction>

</cfcomponent>