<cfcomponent>

	<cffunction name="runCleanupMaintenance" hint="cleans up old files">
		<cfset var cleanupConfig = getCleanupConfig()>
		<cfset var targetTime = "">
		<cfset var errors = ArrayNew(1)>
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		
		<cfloop query="cleanupConfig">
			<cfset targetTime = DateAdd("n",-#cleanupConfig.StaleInMinutes#,getTime())>
			<cfset filesToDelete = getMarkedFilesForDeletion(cleanupConfig.DirectoryPath,targetTime)>
			<cfloop query="filesToDelete">
				<cftry>
					<cfset fullFilePath = filesToDelete.Directory & filesToDelete.Name>
					<cfset deleteFile(fullFilePath)>
				<cfcatch>
					<cfset ArrayAppend(errors,cfcatch)>
				</cfcatch>
				</cftry>
			</cfloop>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="getMarkedFilesForDeletion" access="private" returntype="query" hint="gets all files to be deleted for a given directory and given target time">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfargument name="targetTime" type="date" required="true" hint="the target time. files older than this will be gathered.">
		<cfset var files = "">
		<cfdirectory directory="#directory#" action="list" name="files" type="file">
		
		<cfquery dbtype="query" name="files">
		select * from files
		where DateLastModified < #createODBCDateTime(targetTime)#
		</cfquery>
		
		<cfreturn files>
	</cffunction>
	
	<cffunction name="getCleanupConfig" hint="gets the configured directories for cleanup from the database" returntype="query" access="private">
		<cfset var qConfig = "">
		
		<cfquery name="qConfig" datasource="UnitTest">
		select CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		from CleanupConfig
		</cfquery>
		
		<cfreturn qConfig>
	</cffunction>
	
	<!--- pull these simple operations into separate functions because then they're easier to override in unit tests --->
	<cffunction name="deleteFile" hint="deletes a file" access="private">
		<cfargument name="fileToDelete" required="true" type="string" hint="the file to be deleted">
		<cffile action="delete" file="#fileToDelete#">
	</cffunction>
	
	<cffunction name="getTime" hint="returns the current time. splitting out to make unit testing easier" returntype="date" access="private">
		<cfreturn now()>
	</cffunction>
	
	


</cfcomponent>