<cfcomponent>

	<cfset FileSystemUtility = createObject("component","FileSystemUtility")>
	<cfset NotificationUtility = createObject("component","NotificationUtility")>
	
	<cffunction name="runCleanupMaintenance" hint="cleans up old files" access="public">
		<cfargument name="directory" type="string" required="true">
		<cfargument name="StaleInMinutes" type="numeric" required="true" hint="the number of minutes in the past when a file is considered too old">
		<cfargument name="emailRecipients" type="string" required="true">
		<cfset var startTime = getTime()>		
		<cfset var targetTime = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = {errors=ArrayNew(1),deletedFiles=ArrayNew(1)}>
		
		<cfset targetTime = DateAdd("n",-#StaleInMinutes#,startTime)>
		<cfset filesToDelete = getFilesOlderThan(Directory,targetTime)>
		<cfloop query="filesToDelete">
			<cftry>
				<cfset fullFilePath = filesToDelete.Directory & filesToDelete.Name>
				<cfset FileSystemUtility.deleteFile(fullFilePath)>
				<cfset arrayAppend(results.deletedfiles,fullFilePath)>
			<cfcatch>
				<cfset ArrayAppend(results.errors,cfcatch)>
			</cfcatch>
			</cftry>
		</cfloop>
		<cfset NotificationUtility.sendNotifications(body=formatEmailContent(deletedFiles=results.deletedfiles,	errors=results.errors),
					subject="File System Cleaner Results: #now()#",
					sender="directorycleaner@myco.com",
					recipients=emailRecipients
				)>
		<cfreturn results>
	</cffunction>
	
	<cffunction name="getFilesOlderThan" access="public" returntype="query" hint="gets all files to be deleted for a given directory and given target time">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfargument name="targetTime" type="date" required="true" hint="the target time. files older than this will be gathered.">
		<cfset var files = FileSystemUtility.getDirectoryListing(directory)>		
		
		<cfquery dbtype="query" name="files">
		select * from files
		where DateLastModified < #createODBCDateTime(targetTime)#
		and Directory = '#directory#'
		</cfquery>
		
		<cfreturn files>
	</cffunction>
	
	<cffunction name="formatEmailContent" access="private" output="false" returntype="string" hint="formats the struct of deleted files and errors for email notification">
		<cfargument name="deletedFiles" type="array" required="true"/>
		<cfargument name="errors" type="array" required="true"/>
		<cfset var content = "">
		<cfsavecontent variable="content">
		<cfoutput><p>Results: #ArrayLen(deletedFiles)# files deleted.</p></cfoutput>
		
		these errors were encountered:
		
		<cfdump var="#errors#">	
		</cfsavecontent>
		<cfreturn content>
	</cffunction>

	<cffunction name="getTime" hint="returns the current time. splitting out to make unit testing easier" returntype="date" access="private">
		<cfreturn now()>
	</cffunction>
	
	<cffunction name="setFileSystemUtility" access="public" output="false">
		<cfargument name="FileSystemUtility" required="true"/>
		<cfset variables.FileSystemUtility = arguments.FileSystemUtility>
		<cfreturn this>
	</cffunction>
	<cffunction name="setNotificationUtility" access="public" output="false">
		<cfargument name="NotificationUtility" required="true"/>
		<cfset variables.NotificationUtility = arguments.NotificationUtility>
		<cfreturn this>
	</cffunction>
	
</cfcomponent>