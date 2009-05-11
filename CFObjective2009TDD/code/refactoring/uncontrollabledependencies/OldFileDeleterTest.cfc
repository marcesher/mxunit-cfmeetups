<cfcomponent extends="mxunit.framework.TestCase">

		
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset deleter = createObject("component","OldFileDeleter")>
		<!--- ensure all deletes are safe! --->
		<cfset injectMethod(deleter,this,"deleteOverride","deleteFile")>
		<!--- ensure no emails get sent --->
		<cfset injectMethod(deleter, this, "sendNotificationsOverride", "sendNotifications")>
	</cffunction>
	
	<!--- this is the hardest one to test. if we weren't abstracting out 
	
	 getDirectoryListing to return directory queries that mimic the conditions we'd like
	 to create, but without actually doing file system setup
	 
	 and deleteFile to ensure files aren't deleted, 
	 
	 it'd be virtually impossible to test correctly. 
	 
	 In addition, we couldn't test "edge cases" such as midnight, or Y2K, without
	 the ability to override "current time" (via getTime())
	 
	 But since we can manipulate so many pieces of the puzzle,
	we can focus on testing just the logic we want to test:
	
	* Does it correctly gather just the old files from our directory?
	* Does it call delete on those old files?
	
	* In addition, it'd be nice to see/test the contents of the notification email without actually sending the email
	  --->
	<cffunction name="runCleanupMaintenanceWithNoValidDirectoriesReturnsNoResults">
		<cfset results = deleter.runCleanupMaintenance("c:\notvalid",1,"marc@marc.com")>
		<cfset assertEquals(0,ArrayLen(results.deletedFiles),"the directory does not exist and therefore no files should be marked for deletion")>
	</cffunction>  
	
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFiles">
		<cfset injectMethod(deleter,this,"bigSpoofDirectory","getDirectoryListing")>		
		
		<cfset results = deleter.runCleanupMaintenance("c:\noexist\",30,"marc@marc.com")>
		<cfset debug(results)>
		
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
		
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceShouldNotFailOnFileDeleteErrors">
		<cfset injectMethod(deleter,this,"bigSpoofDirectory","getDirectoryListing")>		
		<cfset injectMethod(deleter,this,"deleteAndCauseError","deleteFile")>
		<cfset results = deleter.runCleanupMaintenance("c:\noexist\",30,"marc@marc.com")>
		<cfset assertEquals(0, ArrayLen(results.deletedfiles) )>
		<!--- 4 because that's how many files we know should've been deleted --->
		<cfset assertEquals(4,ArrayLen(results.errors))>
		<cfset assertTrue( StructKeyExists( results.errors[1],"TagContext" ) )> 
	</cffunction>
	
	
	
	<!--- this tests more granular stuff, not the entire process; 
		all we really want to ensure is that the code correctly filters
		out stuff newer than the target time. This is easy to test
		because we can simply create a query that simulates the file system
		and then override getDirectoryListing() with a function that returns
		the query we want.  
		
		MAIN POINT: by abstracting cfdirectory into a function, we can then
		override the function in a test, thereby freeing us from the confines
		of the file system when all we really want to test is the filtering,
		NOT the functionality of cfdirectory
		
	 --->
	
	<cffunction name="getFilesOlderThanShouldReturnOnlyOldFiles">		
		<!--- set the target time one minute in the future.  --->
		<cfset var targetTime = DateAdd("n",1,getTime())>
		<cfset injectMethod(deleter,this,"bigSpoofDirectory","getDirectoryListing")>
		<!--- make getFilesOlderThan public so we can test it --->
		<cfset makePublic(deleter,"getFilesOlderThan")>
		
		<cfset all = deleter.getFilesOlderThan("c:\noexist\",targetTime)>
		<cfset debug(all)>
		<cfset FileList = Valuelist(all.Name)>
		<cfset assertTrue( listFind(FileList,"1minuteold_NO.txt") ,"")>
		<cfset assertFalse( listFind(FileList,"1minutenewer_NO.txt") ,"")>
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFilesAtMidnight">
		<cfset fail("How would you test this? Hint.... think injectMethod() and getMidnight()")>
	</cffunction>
	
	
	<!--- ////  END TESTS --->

	
	<!--- all this stuff is for spoofing/overriding --->
	<cffunction name="deleteOverride" access="private">
		<!--- do nothing! --->
	</cffunction>
	
	<cffunction name="sendNotificationsOverride" access="private">
		<cfoutput>coming from sendNotificationsOverride</cfoutput>
		<cfdump var="#arguments#">
	</cffunction>
	
	<cffunction name="deleteAndCauseError" access="private">
		<cfthrow message="error deleting file!" type="FileDeleteError">
	</cffunction>
	
	<cffunction name="bigSpoofDirectory" access="private">
		<cfset var dir = "">		
		<cfset var dirname = "c:\noexist\">
		<cfset var thisTime = getTime()>
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
	 
	<cffunction name="getTime" access="private">
		<cfreturn now()>
	</cffunction>
	
	<cffunction name="getMidnight" access="private">		
		<cfreturn createDateTime(year(now()),month(now()),1,0,0,0)>
	</cffunction>


</cfcomponent>