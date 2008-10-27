<cfsetting showdebugoutput="false" />
<style type="text/css" media="all">/* <![CDATA[ */
 @import "style.css"; 
/* ]]> */
</style>
<h4 align="center">Friends Timeline</h4>
<cfscript>
    twitter = createObject("component","bacfug.twitter.CFTwitter").init(user,pass);
    twitter.printFriendsTimeline(50);
</cfscript>