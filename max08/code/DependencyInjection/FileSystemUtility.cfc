<cfcomponent>

	<cffunction name="getFilesOlderThan" access="public" returntype="query" hint="gets all files to be deleted for a given directory and given target time">
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
	
	<cffunction name="getDirectoryListing" access="public" returntype="query" hint="returns a query representing the directory">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfset var files = "">
		<cfdirectory directory="#directory#" action="list" name="files" type="file">
		<cfreturn files>
	</cffunction>
	
	<!--- pull these simple operations into separate functions because then they're easier to override in unit tests --->
	<cffunction name="deleteFile" hint="deletes a file" access="public">
		<cfargument name="fileToDelete" required="true" type="string" hint="the file to be deleted">
		<cffile action="delete" file="#fileToDelete#">
	</cffunction>
	
	<cffunction name="getTime" hint="returns the current time. splitting out to make unit testing easier" returntype="date" access="public">
		<cfreturn now()>
	</cffunction>


</cfcomponent>