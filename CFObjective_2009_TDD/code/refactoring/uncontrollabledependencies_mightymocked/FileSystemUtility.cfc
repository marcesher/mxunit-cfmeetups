<cfcomponent hint="" output="false">
	
	
	<cffunction name="getDirectoryListing" access="public" returntype="query" hint="returns a query representing the directory">
		<cfargument name="directory" type="string" required="true" hint="the directory to search">
		<cfset var files = "">
		<cfdirectory directory="#directory#" action="list" name="files" type="file">
		<cfreturn files>
	</cffunction>
	
	<cffunction name="deleteFile" hint="deletes a file" access="public">
		<cfargument name="fileToDelete" required="true" type="string" hint="the file to be deleted">
		<cffile action="delete" file="#fileToDelete#">
	</cffunction>

</cfcomponent>