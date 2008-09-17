<cfcomponent>

	<cffunction name="runCleanupMaintenance" hint="cleans up old files">
		<cfset var cleanupConfig = getCleanupConfig()>
		<cfset var startTime = getTime()>		
		<cfset var targetTime = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = StructNew()>
		
		<cfset results.errors = ArrayNew(1)>
		<cfset results.deletedfiles = ArrayNew(1)>
		
		<cfloop query="cleanupConfig">
			<cfset targetTime = DateAdd("n",-#cleanupConfig.StaleInMinutes#,startTime)>
			<cfset filesToDelete = getFilesOlderThan(cleanupConfig.DirectoryPath,targetTime)>
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
		</cfloop>
		<cfreturn results>
	</cffunction>
	
	<cffunction name="getCleanupConfig" hint="gets the configured directories for cleanup from the database" returntype="query" access="private">
		<cfset var qConfig = "">
		
		<cfquery name="qConfig" datasource="UnitTest">
		select CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		from CleanupConfig
		</cfquery>
		
		<cfreturn qConfig>
	</cffunction>
	
	<cffunction name="getTime" hint="returns the current time. splitting out to make unit testing easier" returntype="date" access="private">
		<cfreturn now()>
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
	
	<cffunction name="getDirectoryListing" access="private" returntype="query" hint="returns a query representing the directory">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfset var files = "">
		<cfdirectory directory="#directory#" action="list" name="files" type="file">
		<cfreturn files>
	</cffunction>
	
	<!--- pull these simple operations into separate functions because then they're easier to override in unit tests --->
	<cffunction name="deleteFile" hint="deletes a file" access="private">
		<cfargument name="fileToDelete" required="true" type="string" hint="the file to be deleted">
		<cffile action="delete" file="#fileToDelete#">
	</cffunction>

</cfcomponent>