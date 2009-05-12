<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset var fullPath = StructFindKey(getMetadata(this),"fullname")>
		<cfset pathToHere = listDeleteAt(fullpath[1].value,"#listlen(fullPath[1].value,'.')#",".")>
		<cfset processor = createObject("component","AttachmentProcessor")>
		<cfset optimizerMock = createObject("component","mightymock.MightyMock").init("#pathToHere#.PDFOptimizer")>
		<cfset generatorMock = createObject("component","mightymock.MightyMock").init("#pathToHere#.ThumbnailGenerator")>
		<cfset optimizerMock.optimize("{string}").returns("I ran!")>
		<cfset generatorMock.generateThumbnails("{string}").returns(ArrayNew(1))>
		 <cfset processor.setOptimizer(optimizerMock).setThumbnailGenerator(generatorMock)> 
	</cffunction>
	
	<cffunction name="handleAttachment_shouldOptimizeAndGenerateThumbnailsForPDFFile">
		<cfset processor.handleAttachment("c:\mypdf.pdf")>
		<cfset optimizerMock.verifyTimes(1).optimize("{string}")>
		<cfset generatorMock.verifyTimes(1).generateThumbnails("{string}")>
	</cffunction>
	
	<cffunction name="handleAttachment_shouldGenerateThumbnailsForTiffFile">
		<cfset processor.handleAttachment("c:\mytiff.tiff")>
		<cfset optimizerMock.verifyTimes(0).optimize("{string}")>
		<cfset assertThumbsNoOptimize()>
	</cffunction>
	
	<cffunction name="handleAttachment_shouldGenerateThumbnailsForJPEGFile">
		<cfset processor.handleAttachment("c:\myjpg.jpg")>
		<cfset assertThumbsNoOptimize()>
	</cffunction>
	
	<!--- this will fail because our code doesn't fulfill our expectations!' --->
	<cffunction name="handleAttachment_shouldErrorInfoWhenOptimizationFails">
		<cfset optimizerMock = createObject("component","mightymock.MightyMock").init("#pathToHere#.PDFOptimizer")>
		<cfset optimizerMock.optimize("{string}").throws("BadOptimizationError")>
		<cfset processor.handleAttachment("c:\mypdf.pdf")>
		<cfset generatorMock.verifyTimes(0).generateThumbnails("{string}")>
	</cffunction>
	
	<cffunction name="assertThumbsNoOptimize" output="false" access="private" returntype="any" hint="">
		<cfset optimizerMock.verifyTimes(0).optimize("{string}")>
		<cfset generatorMock.verifyTimes(1).generateThumbnails("{string}")>
	</cffunction>

</cfcomponent>