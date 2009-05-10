<cfcomponent>

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
				<cfset deleteFile(fullFilePath)>
				<cfset arrayAppend(results.deletedfiles,fullFilePath)>
			<cfcatch>
				<cfset ArrayAppend(results.errors,cfcatch)>
			</cfcatch>
			</cftry>
		</cfloop>
		<cfset sendNotifications(deletedFiles=results.deletedfiles,errors=results.errors,recipients=EmailRecipients)>
		
		<cfreturn results>
	</cffunction>
	
	
	
	<!--- pull these simple operations into separate functions because 
	then they're easier to override in unit tests --->
	
	<cffunction name="getFilesOlderThan" access="private" returntype="query" hint="gets all files to be deleted for a given directory and given target time">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfargument name="targetTime" type="date" required="true" hint="the target time. files older than this will be gathered.">
		<cfset var files = getDirectoryListing(directory)>		
		
		<cfquery dbtype="query" name="files">
		select * from files
		where DateLastModified < #createODBCDateTime(targetTime)#
		and Directory = '#directory#'
		</cfquery>
		
		<cfreturn files>
	</cffunction>
	
	<!--- These are simply wrappers around built-in ColdFusion functionality
	that we wish to override in unit tests --->
	<cffunction name="getDirectoryListing" access="private" returntype="query" hint="returns a query representing the directory">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfset var files = "">
		<cfdirectory directory="#directory#" action="list" name="files" type="file">
		<cfreturn files>
	</cffunction>
	
	<cffunction name="deleteFile" hint="deletes a file" access="private">
		<cfargument name="fileToDelete" required="true" type="string" hint="the file to be deleted">
		<cffile action="delete" file="#fileToDelete#">
	</cffunction>

	<cffunction name="getTime" hint="returns the current time. splitting out to make unit testing easier" returntype="date" access="private">
		<cfreturn now()>
	</cffunction>
	
	<cffunction name="sendNotifications" output="false" access="private" returntype="void" hint="sends notifications about the results of file system cleanup">
		<cfargument name="deletedFiles" type="array" required="true"/>
		<cfargument name="errors" type="array" required="true"/>
		<cfargument name="recipients" type="string" required="true"/>
		<cfmail from="directorycleaner@myco.com" to="#recipients#" subject="File System Cleaner Results: #now()#" type="html">
		<p>#ArrayLen(deletedFiles)#	files deleted.</p>
		
		these errors were encountered:
		
		<cfdump var="#errors#">
		</cfmail>
	</cffunction>
</cfcomponent>