<cfcomponent>

	<cffunction name="runCleanup" hint="cleans up old files">
		<cfargument name="directory" type="string" required="true">
		<cfargument name="staleInMinutes" type="numeric" required="true" hint="the number of minutes in the past when a file is considered too old">
		<cfargument name="emailRecipients" type="string" required="true">
		<cfset var startTime = now()>
		<cfset var files = "">
		<cfset var filesToDelete = "">
		<cfset var fullFilePath = "">
		<cfset var results = StructNew()>
	
		<cfset results = {errors=ArrayNew(),deletedFiles=ArrayNew()}>
		<cfset targetTime = DateAdd("n",-#staleInMinutes#,startTime)>
		
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
		
		<cfmail from="directorycleaner@myco.com" to="#emailRecipients#" subject="File System Cleaner Results: #now()#" type="html">
		<p>#ArrayLen(results.deletedFiles)#	files deleted.</p>
		
		these errors were encountered:
		
		<cfdump var="#results.errors#">
		</cfmail>
			
		<cfreturn results>
	</cffunction>
	
</cfcomponent>