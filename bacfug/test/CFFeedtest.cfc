<cfcomponent output="false" extends="mxunit.framework.TestCase">

<cffunction name="getLiveXMLFeed">
 <cffeed action="read" xmlvar="x"  name="f" source="http://twitter.com/statuses/user_timeline/15230367.rss">
</cffeed>
<cfoutput>
#x#
</cfoutput>
<cfset debug(x) />
<cfset assertIsXMLDoc(xmlParse(x),"Not valid XML comming back from Twitter")>
</cffunction>

<cffunction name="getLiveFeedAsQuery">
 <cffeed action="read" query="q"  name="f" source="http://twitter.com/statuses/user_timeline/15230367.rss">
</cffeed>
<cfset debug(q) />
<cfset assertIsQuery(q, "Mmm not a query object")>
<cfset assertEquals(20, q.recordCount, "Should be 50 records")>
</cffunction>

</cfcomponent>