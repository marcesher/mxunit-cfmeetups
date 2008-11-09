<cfcomponent>

	<cfset variables.fsu = "">
	
	<!--- example of constructor dependency injection --->
	<cffunction name="init">
		<cfargument name="FileSystemUtility" type="FileSystemUtility" required="false" 
					default="#CreateObject('component','FileSystemUtility')#"/>
		<cfset variables.fsu = arguments.FileSystemUtility>
	</cffunction>
	
	<!--- example of setter dependency injection --->
	<cffunction name="setFileSystemUtility" access="public" hint="enable us to inject filesystemutility dependency">
		<cfargument name="FileSystemUtility" type="FileSystemUtility" required="true">
		<cfset variables.fsu = arguments.FileSystemUtility>
	</cffunction>
	
	<cffunction name="runCleanupMaintenance" hint="cleans up old files">
		<cfset var cleanupConfig = getCleanupConfig()>
		<cfset var startTime = fsu.getTime()>		
		<cfset var targetTime = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = StructNew()>
		
		<cfset results.errors = ArrayNew(1)>
		<cfset results.deletedfiles = ArrayNew(1)>
		
		<cfloop query="cleanupConfig">
			<cfset targetTime = DateAdd("n",-#cleanupConfig.StaleInMinutes#,startTime)>
			<cfset filesToDelete = fsu.getFilesOlderThan(cleanupConfig.DirectoryPath,targetTime)>
			<cfloop query="filesToDelete">
				<cftry>
					<cfset fullFilePath = filesToDelete.Directory & filesToDelete.Name>
					<cfset fsu.deleteFile(fullFilePath)>
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
		<cfset var configurations = "">
		
		<cfquery name="configurations" datasource="UnitTest">
		select CleanupID,DirectoryPath,StaleInMinutes,EmailRecipients
		from CleanupConfig
		</cfquery>
		
		<cfreturn configurations>
	</cffunction>
	
	
</cfcomponent>