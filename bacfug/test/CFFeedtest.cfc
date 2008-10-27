<cfcomponent output="false" extends="mxunit.framework.TestCase">

<cffunction name="testFeed">
 <cffeed action="read" query="q"  name="f" source="http://twitter.com/statuses/user_timeline/15230367.rss">
</cffeed>
<cfset debug(q) />
</cffunction>


<cfscript>
  


</cfscript>

</cfcomponent>