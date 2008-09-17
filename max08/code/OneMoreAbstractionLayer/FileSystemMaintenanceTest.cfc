<cfcomponent extends="mxunit.framework.TestCase">

		
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		
		<cfset fsm = createObject("component","FileSystemMaintenance")>
		<!--- ensure all deletes are safe! --->
		<cfset injectMethod(fsm,this,"deleteOverride","deleteFile")>
		
		<cfset targetDirectory = expandPath("../")>
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="runCleanupMaintenanceShouldHitExpectedFiles">
		
		
	</cffunction>
	
	<cffunction name="getMarkedFilesForDeletionShouldReturnAllOldFiles">
		<cfset var dir = targetDirectory>
		<!--- set the target time in the future. this means ALL files in the parent should be returned --->
		<cfset var targetTime = DateAdd("n",1,now())>
		<cfset makePublic(fsm,"getMarkedFilesForDeletion")>
		<cfset all = fsm.getMarkedFilesForDeletion(dir,targetTime)>
		<cfset allParent = getAllFilesInMyParent()>
		<cfset debug(all)>
		<cfset debug(allParent)>
		<cfset assertEquals(all,allParent)>
	</cffunction>
	
	<cffunction name="getMarkedFilesForDeletionShouldNotReturnNewerFiles">
		<cfset var dir = targetDirectory>
		<!--- set the target time one minute before the oldest time in the target. this means there are no older files --->
		<cfset var oldestFile = getOldestFileTimeInParent()>
		<cfset var targetTime = DateAdd("n",-1,  oldestFile  )>
		<cfset makePublic(fsm,"getMarkedFilesForDeletion")>
		<cfset all = fsm.getMarkedFilesForDeletion(dir,targetTime)>
		<cfset assertEquals(0,all.recordcount)>
	</cffunction>
	
	<cffunction name="getCleanupConfigShouldReturnResults" returntype="void" access="public" hint="extremely simple test to make sure query has guts">
		<cfset makePublic(fsm,"getCleanupConfig")>
		<cfset results = fsm.getCleanupConfig()>
		<cfset assertTrue(results.recordcount GT 0)>
	</cffunction>
	
	<cffunction name="deleteOverride" access="private">
		<!--- do nothing! --->
	</cffunction>
	
	<cffunction name="deleteError" access="private">
		<cfthrow message="error deleting file!" type="FileDeleteError">
	</cffunction>
	
	<cffunction name="getAllFilesInMyParent" access="private">
		<cfset var files = "">
		<cfdirectory action="list" name="files" directory="#targetDirectory#" type="file">
		<cfreturn files>
	</cffunction>
	
	<cffunction name="getOldestFileTimeInParent" access="private">
		<cfset var files = "">
		<cfdirectory action="list" name="files" directory="#targetDirectory#" type="file" sort="DateLastModified asc">
		<cfreturn files.DateLastModified[1]>
	</cffunction>

</cfcomponent>