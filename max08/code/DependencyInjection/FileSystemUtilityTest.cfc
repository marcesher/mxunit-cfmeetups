<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset util = createObject("component","FileSystemUtility")>
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
		
	<cffunction name="getFilesOlderThanShouldReturnOnlyOldFiles">		
		<!--- set the target time one minute in the future.  --->
		<cfset var targetTime = DateAdd("n",1,util.getTime())>
		
		<!--- inject our directory spoofer query; this has one file in the future, so it should be filtered out; the rest should be returned --->
		<cfset injectMethod(util,this,"spoofDirectory","getDirectoryListing")>
		
		<cfset all = util.getFilesOlderThan("c:\files\",targetTime)>
		<cfset FileList = Valuelist(all.Name)>
		<cfset assertTrue( listFind(FileList,"oneminuteold.txt") ,"")>
		<cfset assertFalse( listFind(FileList,"oneminutenewer.txt") ,"")>
	</cffunction>
	
	<cffunction name="spoofDirectory" access="private">
		<cfset var dir = "">
		<cfset var dirname = "c:\files\">
		<cfset var thisTime = getTime()>
		<cfoutput>
		<cf_querysim>			
		dir
		DateLastModified,Directory,Mode,Name,Size,Type
		#DateAdd("d",-1,thisTime)#|#dirname#| |onedayold.txt|100|File
		#DateAdd("n",-1,thisTime)#|#dirname#| |oneminuteold.txt|100|File		
		#DateAdd("n",1,thisTime)#|#dirname#| |oneminutenewer.txt|100|File
		#DateAdd("n",0,thisTime)#|#dirname#| |exactlynow.txt|100|File
		</cf_querysim>
		</cfoutput>
		<cfreturn dir>
	</cffunction>
	
	

</cfcomponent>