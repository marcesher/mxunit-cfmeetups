<cfcomponent extends="mxunit.framework.TestCase">

		
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		
		<cfset fsm = createObject("component","FileSystemMaintenance")>
		<!--- ensure all deletes are safe! --->
		<cfset injectMethod(fsm,this,"deleteOverride","deleteFile")>
		
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
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
	
	* Does it correctly loop through our config query?
	* Does it correctly gather just the old files from our directory?
	* Does it call delete on those old files?
	  --->
	<cffunction name="runCleanupMaintenanceWithNoValidDirectoriesReturnsNoResults">
		<cfset injectMethod(fsm,this,"spoofCleanupConfig","getCleanupConfig")>		
		<cfset results = fsm.runCleanupMaintenance()>
		<cfset assertEquals(0,ArrayLen(results.deletedfiles),"none of the spoof directories exist and therefore no files should be marked for deletion")>
	</cffunction>  
	  
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFiles">
		<cfset injectMethod(fsm,this,"spoofCleanupConfig","getCleanupConfig")>		
		<cfset injectMethod(fsm,this,"bigSpoofDirectory","getDirectoryListing")>		
		
		<cfset results = fsm.runCleanupMaintenance()>
		<cfset debug(results)>
		<cfset fileList = ArrayToList(results.deletedfiles)>
		
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
	
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFilesAtMidnight">
		<cfset fail("How would you test this? Hint.... think injectMethod() and getMidnight()")>
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceShouldNotFailOnFileDeleteErrors">
		<cfset injectMethod(fsm,this,"spoofCleanupConfig","getCleanupConfig")>		
		<cfset injectMethod(fsm,this,"bigSpoofDirectory","getDirectoryListing")>		
		<cfset injectMethod(fsm,this,"deleteAndCauseError","deleteFile")>
		<cfset results = fsm.runCleanupMaintenance()>
		<cfset assertEquals(0, ArrayLen(results.deletedfiles)  )>
		<!--- 3 because that's how many files we know should've been deleted --->
		<cfset assertEquals(3,ArrayLen(results.errors))>
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
		
		<!--- inject our directory spoofer query; this has one file in the future, so it should be filtered out; the rest should be returned --->
		<cfset injectMethod(fsm,this,"spoofDirectory","getDirectoryListing")>
		<!--- make getFilesOlderThan public so we can test it --->
		<cfset makePublic(fsm,"getFilesOlderThan")>
		
		<cfset all = fsm.getFilesOlderThan("c:\files\",targetTime)>
		<cfset FileList = Valuelist(all.Name)>
		<cfset assertTrue( listFind(FileList,"oneminuteold.txt") ,"")>
		<cfset assertFalse( listFind(FileList,"oneminutenewer.txt") ,"")>
	</cffunction>

	<cffunction name="getCleanupConfigShouldReturnResults" returntype="void" access="public" hint="extremely simple test to make sure query has guts">
		<cfset makePublic(fsm,"getCleanupConfig")>
		<cfset results = fsm.getCleanupConfig()>
		<cfset assertTrue(results.recordcount GT 0,"Expected results from CleanupConfig table but got none")>
	</cffunction>
	
	<!--- ////  END TESTS --->
	
	
	<!--- all this stuff is for spoofing/overriding --->
	<cffunction name="deleteOverride" access="private">
		<!--- do nothing! --->
	</cffunction>
	
	<cffunction name="deleteAndCauseError" access="private">
		<cfthrow message="error deleting file!" type="FileDeleteError">
	</cffunction>
	
	<cffunction name="spoofDirectory" access="private">
		<cfset var dir = "">
		<cfset var dirname = "c:\files\">
		<cfset var thisTime = getTime()>
		<cfoutput>
		<cf_querysim>			
		dir
		DateLastModified,Directory,Mode,Name,Size,Type
		#DateAdd("d",-1,thisTime)#|#dirname#| |onedayold.txt|100|File
		#DateAdd("n",-1,thisTime)#|#dirname#| |oneminuteold.txt|100|File		
		#DateAdd("n",1,thisTime)#|#dirname#| |oneminutenewer.txt|100|File
		#DateAdd("n",0,thisTime)#|#dirname#| |exactlynow.txt|100|File
		</cf_querysim>
		</cfoutput>
		<cfreturn dir>
	</cffunction>
	
	<cffunction name="bigSpoofDirectory" access="private">
		<cfset var dir = "">		
		<cfset var thisTime = getTime()>
		<cfoutput>
		<cf_querysim>			
		dir
		DateLastModified,Directory,Mode,Name,Size,Type
		#DateAdd("n",-29,thisTime)#|c:\noexist\| |29minutesold_NO.txt|100|File
		#DateAdd("n",-30,thisTime)#|c:\noexist\| |30minutesold_NO.txt|100|File
		#DateAdd("n",-31,thisTime)#|c:\noexist\| |31minutesold_YES.txt|100|File		
		#DateAdd("n",-61,thisTime)#|c:\noexist2\| |61minutesold_YES.txt|100|File		
		#DateAdd("n",1,thisTime)#|c:\noexist2\| |1minutenewer_NO.txt|100|File
		#DateAdd("d",-5,thisTime)#|c:\noexist3\| |5daysold_YES.txt|100|File
		</cf_querysim>
		</cfoutput>
		<cfreturn dir>
	</cffunction>
	
	<cffunction name="spoofCleanupConfig" access="private">
		<cfset var configurations = "">
		<cf_querysim>
		configurations
		CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		1|c:\noexist\|30| |
		2|c:\noexist2\|60| |
		3|c:\noexist3\|360| |
		</cf_querysim>
		<cfreturn configurations>
	</cffunction>
	 
	<cffunction name="getTime" access="private">
		<cfreturn now()>
	</cffunction>
	
	<cffunction name="getMidnight" access="private">		
		<cfreturn createDateTime(year(now()),month(now()),1,0,0,0)>
	</cffunction>


</cfcomponent>