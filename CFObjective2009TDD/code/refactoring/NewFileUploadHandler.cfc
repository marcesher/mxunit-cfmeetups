<cfcomponent>
	
	<cfset optimizer = createObject("component","PDFOptimizer")>
	<cfset thumbnailgenerator = createObject("component","ThumbnailGenerator")>	
	
	<!--- dependency injection through Setter injection --->	
	<cffunction name="setOptimizer">
		<cfargument name="Optimizer" type="any" required="true"/>
		<cfset variables.Optimizer = arguments.Optimizer>
	</cffunction>
	<cffunction name="setThumbnailGenerator">
		<cfargument name="ThumbnailGenerator" type="any" required="true"/>
		<cfset variables.ThumbnailGenerator = arguments.ThumbnailGenerator>
	</cffunction>
	
<!--- 	Is there any value at all in doing this? why not just cffile upload the file in your .cfm template?
	<cffunction name="uploadFile" output="false" access="public" returntype="struct">
		<cfargument name="UploadFormField" type="string" required="true"/>
		<cfargument name="destination" type="string" required="true"/>
		<cffile action="upload" nameconflict="overwrite" filefield="#UploadFormField#" result="uploadResult" destination="destination">
		<cfreturn uploadResult>
	</cffunction> --->
	
	<cffunction name="handleUpload" output="false" access="public" returntype="any" hint="">
		<cfargument name="fileToProcess" type="string" required="true"/>
		<cfif listLast(uploadResult.ServerFile,".") eq "pdf">
			<cfset optimizer.optimize(uploadResult.ServerFile)>
		</cfif>
		<cfset thumbnailgenerator.generateThumbnails(fileToProcess)>
	</cffunction>
	
</cfcomponent>