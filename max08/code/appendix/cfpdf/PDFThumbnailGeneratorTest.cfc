<cfcomponent extends="mxunit.framework.TestCase">
	
	
	
	<cfset gen = createObject("component","PDFThumbnailGenerator")>
	
	
	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset sourceFilePath = expandPath("sourcefiles\")>
		<cfset onepage = sourceFilePath & "onepage.pdf">
		<cfset twopage = sourceFilePath & "letter.pdf">
		<cfset weirdname = sourceFilePath & "one.pdf_hmmm.pdf">
		<cfset twentypage = sourceFilePath & "20pages.pdf">
		<cfset asynch = sourceFilePath & "20pages.pdf">	
		<cfset image = sourceFilePath & "max logo.tif">
		
		<cfset newdir = sourceFilePath & createUUID()>
		<cfset a_output = ArrayNew(1)>
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
		
		<cfloop from="1" to="#ArrayLen(a_output)#" index="i">
			<cfif fileExists(a_output[i])>
				<cffile action="delete" file="#a_output[i]#">
			</cfif>
		</cfloop>
		
		<cfif DirectoryExists(newdir)>
			<cfdirectory action="delete" directory="#newdir#" recurse="true">
		</cfif> 
	</cffunction>
	
	<cffunction name="addResult" access="private">
		<cfargument name="result" required="true">
		<cfset var i = 1>
		<cfloop from="1" to="#ArrayLen(result)#" index="i">
			<cfset arrayAppend(a_output,result[i])>
		</cfloop>
	</cffunction>
	
 	<cffunction name="testCreateThumbnailBasic" returntype="void" access="public">		
		<cfset result = gen.createThumbnail(source=onepage)>
		<cfset addResult(result)>
		<cfset assertEquals(1,ArrayLen(result),"should have one image returned")>
		<cfset assertTrue(FileExists(result[1]),"thumbnail file [#result[1]#] should exist")>		
	</cffunction>
	
	<cffunction name="testCreateThumbnailPaging" returntype="void" access="public">		
		<cfset result = gen.createThumbnail(source=twopage,pages="all")>
		<cfset addResult(result)>
		<cfset debug("#result#",1)>
		<cfset assertEquals(2,ArrayLen(result),"should have two image returned")>
		<cfloop from="1" to="#ArrayLen(result)#" index="i">
			<cfset assertTrue(FileExists(result[i]),"#i#-- File #result[i]# should exist")>
		</cfloop>
		
		<cfset result = gen.createThumbnail(source=twentypage,destination=newdir,pages="1,3,5,6,17-100")>
		<cfset addResult(result)>
		<cfset debug("#result#",1)>
		<cfset assertEquals(8,ArrayLen(result),"should have 8 images returned")>
		<cfloop from="1" to="#ArrayLen(result)#" index="i">
			<cfset assertTrue(FileExists(result[i]),"#i#-- File #result[i]# should exist")>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="testCreateThumbnailWeirdName" returntype="void" access="public">		
		<cfset result = gen.createThumbnail(source=weirdname)>
		<cfset addResult(result)>
		<cfset debug("inside weirdname test",1)>
		<cfset debug("#result#",1)>
		<cfset assertEquals(1,ArrayLen(result),"should have one image returned")>
		<cfset assertTrue(FileExists(result[1]),"thumbnail file [#result[1]#] should exist")>		
	</cffunction>
	
	
	
	<cffunction name="testCreateThumbnailInNewDirectory">			
		<cfset result = gen.createThumbnail(source=onepage,destination=newdir)>
		<cfset addResult(result)>
		<cfset assertTrue(DirectoryExists(newdir),"newdir should exist")>
		
	</cffunction> 
	
	<cffunction name="testConstructRangeList" returntype="void" hint="">		
		<cfset result = gen.constructRangeList("1-4,6",7)>	
		<cfset assertEquals("1,2,3,4,6",result,"1-")>
		
		<cfset result = gen.constructRangeList("1,2",2)>	
		<cfset assertEquals("1,2",result,"2-")>
		
		<cfset result = gen.constructRangeList("1,2,19-20",20)>	
		<cfset assertEquals("1,2,19,20",result,"3-")>		
		
		<cfset result = gen.constructRangeList("1,2,19-100",20)>	
		<cfset assertEquals("1,2,19,20",result,"4-")>
		
		<cfset result = gen.constructRangeList("1-4",4)>	
		<cfset assertEquals("1,2,3,4",result,"5-")>
	</cffunction>
	
	 <cffunction name="testCreateThumbnailNoWait" returntype="void" hint="">
		
		<cfset result = gen.createThumbnail(source=asynch,destination=newdir,waitforcompletion="false",pages="1-3")>
		<cfset addResult(result)>
		<cfset debug("asynch result:",1)>
		<cfset debug("#result#",1)>
		<cfset debug(cfthread)>
		<cfset assertTrue( NOT FileExists(result[3]),"asynch file [#result[1]#] shouldn't yet exist" )>
		<cfthread action="join"/>
		<cfset assertTrue( FileExists(result[3]),"asynch file [#result[1]#] should now exist" )>
		
	</cffunction> 
	
	
	<cffunction name="testCreateThumbnailNonExistentFile"  returntype="void" hint="">		
		<cftry>
			<cfset error = false>
			<cfset result = gen.createThumbnail(source="noexist.pdf")>
		<cfcatch>
			<cfset error = true>
		</cfcatch>
		</cftry>
		<cfset assertTrue(error,"Error should be thrown")>
	</cffunction>
	
 	<cffunction name="testCreateThumbnailWithBadPDF" access="public" returntype="void" hint="tests building a thumbnail with a known bad pdf">
	
		<cftry>
			<cfset result = gen.createThumbnail(source=onepage,forceerrorinthread=true)>
			<cfset fail("shouldn't get here")>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfrethrow>
		</cfcatch>
		<cfcatch>
			<cfdump var="#cfcatch#">		
			<cfset structclear(cfthread)>	
		</cfcatch>
		</cftry>		
		
		<!--- <cfdump var="#cfthread#">---> 
		
	</cffunction> 
	
	<cffunction name="testtestDumpThreads" returntype="void" hint="nothing!">
		<cfdump var="#cfthread#">
	</cffunction>
	

</cfcomponent>