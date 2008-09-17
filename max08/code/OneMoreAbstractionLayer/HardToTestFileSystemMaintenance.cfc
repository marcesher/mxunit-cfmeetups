<cfcomponent>

	<cffunction name="runCleanupMaintenance" hint="cleans up old files">
		
		<cfset var cleanupConfig = "">
		<cfset var startTime = now()>
		<cfset var files = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = StructNew()>
		
		<cfset results.errors = ArrayNew(1)>
		<cfset results.deletedfiles = ArrayNew(1)>
		
		<cfquery name="cleanupConfig" datasource="UnitTest">
		select CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		from CleanupConfig
		</cfquery>
		
		<cfloop query="cleanupConfig">
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
					<cfset ArrayAppend(results.deletedfiles,fullFilePath)>
				<cfcatch>
					<cfset ArrayAppend(results.errors,cfcatch)>
				</cfcatch>
				</cftry>
			</cfloop>
		</cfloop>
		
		<cfreturn results>
	</cffunction>
	
</cfcomponent>