<cfcomponent extends="mxunit.framework.TestCase">

		
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		
		<cfset fsm = createObject("component","FileSystemMaintenance")>
		<!--- create our collaborator;
		in the tests, we'll override his methods to achieve the desired setup we want --->
		<cfset util = createObject("component","FileSystemUtility")>
		
		<!--- ensure all deletes are safe! --->
		<cfset injectMethod(util,this,"deleteOverride","deleteFile")>
		
		<!--- initialize our object under test with its collaborator --->
		<cfset fsm.init(util)>
		
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceWithNoValidDirectoriesReturnsNoResults">
		<cfset injectMethod(fsm,this,"spoofCleanupConfig","getCleanupConfig")>		
		<cfset results = fsm.runCleanupMaintenance()>
		<cfset assertEquals(0,ArrayLen(results.deletedfiles),"none of the spoof directories exist and therefore no files should be marked for deletion")>
	</cffunction>  
	  
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFiles">
		<cfset injectMethod(fsm,this,"spoofCleanupConfig","getCleanupConfig")>		
		<!--- override the method in the collaborator --->
		<cfset injectMethod(util,this,"bigSpoofDirectory","getDirectoryListing")>		
		
		<cfset results = fsm.runCleanupMaintenance()>
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
			
		<!--- override these methods in the collaborator --->
		<cfset injectMethod(util,this,"bigSpoofDirectory","getDirectoryListing")>		
		<cfset injectMethod(util,this,"deleteAndCauseError","deleteFile")>
		
		<cfset results = fsm.runCleanupMaintenance()>
		<cfset assertEquals(0, ArrayLen(results.deletedfiles)  )>
		<!--- 3 because that's how many files we know should've been deleted --->
		<cfset assertEquals(3,ArrayLen(results.errors))>
		<cfset assertTrue( StructKeyExists( results.errors[1],"TagContext" ) )> 
	</cffunction>


	<cffunction name="getCleanupConfigShouldReturnResults" returntype="void" access="public" hint="extremely simple test to make sure query has guts">
		<cfset makePublic(fsm,"getCleanupConfig")>
		<cfset results = fsm.getCleanupConfig()>
		<cfset assertTrue(results.recordcount GT 0)>
	</cffunction>
	
	<!--- ////  END TESTS --->
	
	
	<!--- all this stuff is for spoofing/overriding --->
	<cffunction name="deleteOverride" access="private">
		<!--- do nothing! --->
	</cffunction>
	
	<cffunction name="deleteAndCauseError" access="private">
		<cfthrow message="error deleting file!" type="FileDeleteError">
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