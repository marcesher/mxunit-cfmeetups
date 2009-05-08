Intended to display all images as thumbnails

<cfdirectory action="list" directory="#getDirectoryfromPath(getCurrentTemplatePath())#" name="dir">

<cfoutput query="dir">
 <a href="#name#">#name#</a> <br />
</cfoutput>