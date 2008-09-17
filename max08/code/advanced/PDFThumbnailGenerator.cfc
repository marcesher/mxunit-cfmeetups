<cfcomponent hint="Builds thumbnails of a PDF" output="false">

	<cffunction name="createThumbnail" output="false" access="public" returntype="array" hint="creates thumbnails in a separate thread. optionally waits for completion. returns an array of thumbnail file paths">
		<cfargument name="source" type="String" required="true" hint="full path to pdf"/>
		<cfargument name="destination" type="string" required="false" default="" hint="directory to place the thumbnail. If not passed, thumbnail generated in same directory as source file. MUST be a full path"/>
		<cfargument name="format" type="string" required="false" default="jpg" hint="png, jpg, or tiff. defaults to jpeg"/>
		<cfargument name="pages" type="String" required="false" default="1" hint="a valid list of pages or ranges (eg: 1,16-32). pass the string 'all' to get thumbnails for all pages"/>
		<cfargument name="scale" type="numeric" required="false" default="100" hint="percentage between 1 and 100"/>
		<cfargument name="resolution" type="string" required="false" default="low" hint="high or low"/>
		<cfargument name="WaitForCompletion" type="boolean" required="false" default="true" hint="if false, it'll do this asynchronously"/>
		<cfargument name="UseCopyFile" type="boolean" required="false" default="true" hint="Whether to create the thumbnail by making a copy of the original PDF file. You need this functionality particularly when you want to spawn the thumbnail generation Right before sending the pdf for optimization. This way, the thumbnail can generate simultaneously with optimization. if you don't copy the file, however, optimization will likely fail because the thumbnail generation will still have a hold of the original"/>
		<cfargument name="ForceErrorInThread" type="boolean" required="false" default="false"/>
		<cfset var a_files = ArrayNew(1)>
		<cfset var totalPages = "">
		<cfset var prefix = getFileFromPath(source)>
		<cfset var pdfinfo = "">
		<cfset var element = "">
		<cfset var threadname = "">
		<cfset var deletesource = false>
		<cfset var copydest = "">
		<cfset prefix = replaceNoCase(prefix,".pdf","","one")>
		<cfset threadname = "cfpdfthread_#prefix#_#getTickCount()#">
		
		<cfpdf action="getInfo" source="#source#" name="pdfinfo">
		<cfset totalPages = pdfinfo.TotalPages>
		
		<cfif not FileExists(source)>
			<cfthrow message="Source file [#source#] does not exist or is not visible">
		</cfif>
		
		<cfset destination = prepareDestination(source,destination)>
		<cfif pages eq "all" or pages eq "">
			<cfset pages = "1-#totalpages#">
		</cfif>
		
		<cfif arguments.UseCopyFile>
			<cfset deletesource = true>
			<cfset copydest = replaceNoCase(source,".pdf","_#getTickCount()#_copy.pdf","one")>
			<cffile action="copy" source="#source#" destination="#copydest#">
			<cfset source=copydest>
		</cfif>
		
		<cfthread action="run" name="#threadname#" 
			source="#source#" deletesource="#deletesource#" destination="#destination#" resolution="#resolution# "scale="#scale#" prefix="#prefix#" pages="#pages#" forceerror="#ForceErrorInThread#">
			<cfpdf action="thumbnail" 
				source="#attributes.source#" 
				destination="#attributes.destination#" 
				resolution="#attributes.resolution#" 
				scale="#attributes.scale#" 
				imageprefix="#attributes.prefix#"
				overwrite="true"
				pages="#pages#"> 
				
			<cfif forceerror>
				<cfthrow message="Forcing error">
			</cfif>
				
			<cfif attributes.DeleteSource>
				<cffile action="delete" file="#attributes.source#">
			</cfif>
		</cfthread>
		
		<cfif WaitForCompletion>
			<!---<cfset request.logger.debug("#cfthread#",1)>  --->
			<cfthread action="join" name="#threadname#"/>
		<cfelse>
			<!--- what should i do here? --->
			
		</cfif>
			<!--- if it's just a single page, append it straight up --->
			<cfif isNumeric(pages)>
				<cfset ArrayAppend(a_files,destination & prefix & "_page_#pages#.#format#")>
			<cfelse>
				<cfset filenameList = constructRangeList(pages,totalpages)>
				<cfloop list="#filenameList#" index="element">
					<cfset ArrayAppend(a_files,destination & prefix & "_page_#element#.#format#")>
				</cfloop>
			</cfif>
		<cfset sleep(100)>
		<cfset throwOnThreadErrors(cfthread)>
		<cfreturn a_files>
	</cffunction>
	
	<cffunction name="prepareDestination" output="false" access="private" returntype="string" hint="ensures the destination exists">
		<cfargument name="source" type="String" required="true" hint="full path to pdf"/>
		<cfargument name="destination" type="string" required="true"/>
		<cfset var dest = destination>
		<cfset var sourceDest = getDirectoryFromPath(source)>
		<cfset var sep = "">
		<cfif not len(dest)>			
			<cfset dest = sourceDest>	
		</cfif>
		
		<cfset sep = createObject("java","java.lang.System").getProperty("file.separator")>
		
		<cfif right(dest, 1) neq sep>
			<cfset dest = dest & sep>
		</cfif>
		
		<cfreturn dest>
	</cffunction>
	
	<cffunction name="constructRangeList" output="false" access="public" returntype="string" hint="">
		<cfargument name="pagerange" type="string" required="true"/>
		<cfargument name="totalpages" type="numeric" required="true"/>
		<cfset var result = "">
		<cfset var mylist = "">
		<cfset var element = "">
		<cfset var start = "">
		<cfset var end = "">		
		<cfset var max = totalpages>
		<cfset var i = 1>
		
		<cfloop list="#pagerange#" delimiters="," index="element">			
			<cfif isNumeric(element)>
				<cfset result = ListAppend(result,element)>
			<cfelse>
				<cfset start = listFirst(element,"-")>
				<cfset end = listLast(element,"-")>
				<cfset end = min(end,max)>
				<cfloop from="#start#" to="#end#" index="i">
					<cfset result = ListAppend(result,i)>
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn result>
	</cffunction>
	
	<cffunction name="throwOnThreadErrors" output="false" access="public" returntype="void" hint="">
		<cfargument name="threadstruct" required="true"/>
		<cfset var key = "">
		<cfloop collection="#threadstruct#" item="key">
			<cfif StructKeyExists(threadstruct[key],"error")>
				<cfset request.logger.addErrorVariable(name="PDFGenThreads",value="#threadstruct#")>
				<cfset request.logger.debug("#threadstruct#",1)>				
				<cfthrow message="Error in PDFThumbnailGenerationThread">
			</cfif>
		</cfloop>		
	</cffunction>
	

</cfcomponent>