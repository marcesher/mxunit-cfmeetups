<cfcomponent>

	<cffunction name="runCleanupMaintenance" hint="cleans up old files">
		
		<cfset var cleanupConfig = "">
		<cfset var startTime = now()>
		<cfset var files = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = StructNew()>
				
		<cfquery name="cleanupConfig" datasource="UnitTest">
		select CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		from CleanupConfig
		</cfquery>
		
		<cfloop query="cleanupConfig">
			<cfset results[cleanupConfig.CleanupID] = {errors=ArrayNew(),deletedFiles=ArrayNew()}>
			<cfset targetTime = DateAdd("n",-#cleanupConfig.StaleInMinutes#,startTime)>
			
			<cfdirectory directory="#directory#" action="list" name="files" type="file">
			
			<cfquery dbtype="query" name="filesToDelete">
			select * from files
			where DateLastModified < #createODBCDateTime(targetTime)#
			and Directory = '#directory#'
			</cfquery>
						
			<cfloop query="filesToDelete">
				<cftry>
					<cfset fullFilePath = filesToDelete.Directory & filesToDelete.Name>					
					<cffile action="delete" file="#fullFilePath#">
					<cfset ArrayAppend(results[cleanupConfig.CleanupID].deletedfiles,fullFilePath)>
				<cfcatch>
					<cfset ArrayAppend(results[cleanupConfig.CleanupID].errors,cfcatch)>
				</cfcatch>
				</cftry>
			</cfloop>
			
			<cfmail from="directorycleaner@myco.com" to="#EmailRecipients#" subject="File System Cleaner Results: #now()#" type="html">
			<p>#ArrayLen(results[CleanupID].deletedFiles)#	files deleted.</p>
			
			these errors were encountered:
			
			<cfdump var="#results[CleanupID].errors#">
			</cfmail>
			
			
		</cfloop>
		
		
		
		
		<cfreturn results>
	</cffunction>
	
</cfcomponent>