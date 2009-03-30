<cfcomponent>

	<cffunction name="handleUpload" output="false" access="public" returntype="any" hint="">
		<cfargument name="UploadFormField" type="string" required="true"/>
		<cfset var optimizer = createObject("component","PDFOptimizer")>
		<cfset var thumbnailgenerator = createObject("component","ThumbnailGenerator")>
		<cfset var uploadResult = "">
		
		<cffile action="upload" nameconflict="overwrite" filefield="#UploadFormField#" result="uploadResult" destination="somedir">
		
		<cfif listLast(uploadResult.ServerFile,".") eq "pdf">
			<cfset optimizer.optimize(uploadResult.ServerFile)>
		</cfif>
		<cfset thumbnailgenerator.generateThumbnails(uploadResult.ServerFile)>
		<cfreturn uploadResult>
	</cffunction>
	
</cfcomponent>