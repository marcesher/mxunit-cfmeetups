<cfcomponent>

	<cffunction name="runCleanupMaintenance" hint="cleans up old files" access="public">
		<cfset var cleanupConfig = getCleanupConfig()>
		<cfset var startTime = getTime()>		
		<cfset var targetTime = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = StructNew()>
		
		
		<cfloop query="cleanupConfig">
			<cfset results[cleanupConfig.CleanupID] = {errors=ArrayNew(1),deletedFiles=ArrayNew(1)}>
			<cfset targetTime = DateAdd("n",-#cleanupConfig.StaleInMinutes#,startTime)>
			<cfset filesToDelete = getFilesOlderThan(cleanupConfig.DirectoryPath,targetTime)>
			<cfloop query="filesToDelete">
				<cftry>
					<cfset fullFilePath = filesToDelete.Directory & filesToDelete.Name>
					<cfset deleteFile(fullFilePath)>
					<cfset arrayAppend(results[cleanupConfig.CleanupID].deletedfiles,fullFilePath)>
				<cfcatch>
					<cfset ArrayAppend(results[cleanupConfig.CleanupID].errors,cfcatch)>
				</cfcatch>
				</cftry>
				<cfset sendNotifications(deletedFiles=results[cleanupConfig.CleanupID].deletedfiles,errors=results[cleanupConfig.CleanupID].errors,recipients=cleanupConfig.EmailRecipients)>
			</cfloop>
		</cfloop>
		
		<cfreturn results>
	</cffunction>
	
	
	
	<!--- pull these simple operations into separate functions because 
	then they're easier to override in unit tests --->
	
	<cffunction name="getCleanupConfig" hint="gets the configured directories for cleanup from the database" returntype="query" access="private">
		<cfset var configurations = "">
		
		<cfquery name="configurations" datasource="UnitTest">
		select CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		from CleanupConfig
		</cfquery>
		
		<cfreturn configurations>
	</cffunction>	
	
	
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
	</cffunction>
</cfcomponent>