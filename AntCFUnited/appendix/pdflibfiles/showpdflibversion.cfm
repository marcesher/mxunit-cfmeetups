<cfset filename = listlast(cgi.SCRIPT_NAME,"/")>
<cfset pdffilename = replaceNoCase(filename,".cfm",".pdf","one")>
<cfset root = getDirectoryFromPath(getCurrentTemplatePath()) >
<cfset pdffilepath = root & pdffilename>
<cfset pdfpreviewsrc = replaceNoCase(cgi.SCRIPT_NAME,".cfm",".pdf","one")>


<cfif fileExists(pdffilepath)>
	<cffile action="delete" file="#pdffilepath#">
</cfif>


<h1>Testing pdflib setup</h1>
<cftry>
<cfset pdflib = createObject("java","com.pdflib.pdflib")>
<cfset pdflib.set_parameter("compatibility", 1.4)>
<cfset pdflib.set_parameter("pdiwarning","true")>

<cffile action="write" file="#pdffilepath#" output="">
<cfset pdflib.open_file(pdffilepath)>

<cfset pdflib.begin_page(612,792)>
<cfset font = pdflib.findfont("Helvetica-Bold", "winansi", 0)>
<cfset pdflib.setfont(font, 76)>
<cfoutput>
<cfset pdflib.show_xy("#TimeFormat(now(),'full')#",10,700)>

<cfset pdflib.setfont(font, 50)>
<cfset pdflib.show_xy("PDFLibVersion: " & pdflib.get_parameter("version",0),10,500)>

</cfoutput>
<cfset pdflib.end_page()>
<cfset pdflib.close()>
<cfset pdflib.delete()>

<cfoutput><iframe width="500" height="500" src="#pdfpreviewsrc#"></iframe></cfoutput>
<h2>OK</h2>
<cfcatch>
<h2>ERROR</h2>
<cfdump var="#cfcatch#" expand="false">
</cfcatch>
</cftry>
