<cfcomponent output="false" hint="Contains properties specific to Twitter">
<cfscript>
 this.authUrl = "http://twitter.com/account/verify_credentials.xml";
 this.authResponse = "<authorized>true</authorized>";
 this.friendsAtom = "http://twitter.com/statuses/friends_timeline.atom";
 this.myAtom = "http://twitter.com/statuses/user_timeline.atom";
</cfscript>
</cfcomponent>