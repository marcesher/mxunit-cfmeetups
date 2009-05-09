<h3>Fuzzy Report</h3>

<cfdirectory action="list" directory="#getDirectoryfromPath(getCurrentTemplatePath())#" name="dir" >

<cfoutput query="dir">
 <cfset isPing = right(name,3) is 'png' >
 <cfset isHtml = right(name,4) is 'html' >
 <cfset fileNameNoExt = left(name, find(".", name, 1) )  /> 
 <cfif isPing>
    <a href="#fileNameNoExt#html" title="View Source"><img src="#name#"></a>
    <br />
 </cfif>
 
</cfoutput>