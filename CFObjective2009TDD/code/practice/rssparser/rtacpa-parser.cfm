<cfhttp url="http://www.pomtalk.com/pomtalk/rss.xml">
<cfhttp url="http://feeds2.feedburner.com/ReedTinsleyCpa">


<cfset BlogXML = XmlParse(CFHTTP.FileContent)>
<cfset ElementXML = BlogXML["rdf:RDF"]>
<cfset NewLine = Chr(10) & chr(13)>
<cfset ElementCount = ArrayLen(ElementXML.XmlChildren)>
<cfset MaxItems = 6>
<cfset ItemCount = 1>
<cfset DisplayHTML = "">
<cfloop index="i" from = "1" to = "#ElementCount#">
	<cfset ItemXML = ElementXML.XmlChildren[i]>
	<cfset ElementType = ItemXML.XmlName>
	<cfif ElementType EQ "Item" and ItemCount LTE MaxItems>
		<cfset SubElementCount = ArrayLen(ItemXML.XmlChildren)>
		<cfloop index="j" from = "1" to = "#SubElementCount#">
			<cfset SubItemXML = ItemXML.XmlChildren[j]>
			<cfset SubItemType = SubItemXML.XmlName>
			<cfif SubItemType EQ "Title">
				<cfset SubTitle = SubItemXML.XmlText>
			</cfif>
			<cfif SubItemType EQ "link">
				<cfset SubLink = SubItemXML.XmlText>
			</cfif>
		</cfloop>           

		<cfset DisplayHTML = DisplayHTMl & "<p class=""item""><span><a href=""#SubLink#"" target=""_new"">#SubTitle#</a></span></p>" & newline>
		<cfset ItemCount = ItemCount + 1>
	</cfif>
</cfloop>
<cfset HomePageIncludeFile = expandpath(".") & "/homepageinclude.cfm">
<cffile action="write" file="#HomePageIncludeFile#" output="#DisplayHTML#">
<cfoutput>File written successfully</cfoutput>