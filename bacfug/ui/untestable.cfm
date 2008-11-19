<cfsetting showdebugoutput="false" />
<cfparam name="url.tl" default="ftl">
<style type="text/css" media="all">/* <![CDATA[ */
 @import "style.css"; 
/* ]]> */
</style>


  <h4 align="center">Friends Timeline</h4>
  <cfset tlUrl = "http://twitter.com/statuses/friends_timeline.atom?count=50" />


<cfhttp url="http://twitter.com/account/verify_credentials.rss" username="#user#" password="#pass#" />

<cfif cfhttp.StatusCode is '401 Unauthorized'>
 <h2 align="center">Twitter Authorization Failed!</h2>
 <cfabort />
</cfif>

<cfset getTimeline(tlUrl)>
 

<cfset dest = "#getDirectoryFromPath(getCurrentTemplatePath())#/#createUUID()#.xml" />
<cffile action="write" output="#cfhttp.filecontent#" file="#dest#" />
<cffeed  action="read" source="#dest#" query="q" />

<table border="0">
 <cfoutput query="q">
  <tr style="padding:4px;border-top:1px ridge gray">	
       <cfscript>
	      user = listGetAt(q.title,1,":");
	      text = replace(q.title,user, '<a href="http://twitter.com/#user#">#user#</a>');
	    </cfscript>  
	   <td  valign="top">  
	    <img src="#listGetAt(q.linkhref,2)#" align="absmiddle"/>
	   </td> 
       <td valign="top" style="position:relative;left:4;font-size:12px">#text#</td>
	   
 </tr>
 </cfoutput>
 </table>
 
<cffile action="delete" file="#dest#" /> 
 
<cffunction name="getTimeline">
  <cfargument name="twitterUrl">
  <cfhttp url="#twitterUrl#" username="#user#" password="#pass#" />
</cffunction>

