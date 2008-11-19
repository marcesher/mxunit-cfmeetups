<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
    
 //------------------setUp/tearDown-------------------------------// 
  
  function setUp(){
  	un = ''; //set this to valid Twitter credentials
  	pwd = '';
  	ini = getDirectoryFromPath(getCurrentTemplatePath()) & "credentials";

    un = getProfileString(ini,"section","u");
    pwd = getProfileString(ini,"section","p");
    twitter = createObject("component","bacfug.twitter.CFTwitter").init(un,pwd);  
  }
  
  function tearDown(){
  
  }  
  
  
  //-------------------------------------------------------------//
  
  function testTwitterType(){
   debug(twitter.twitterProps);
   assertIsTypeOf(twitter,"bacfug.twitter.CFTwitter");
  }
  
  
  
  function verifyCredentialsSuccessfully(){
    twitter.verifyCredentials(twitter.username,twitter.password);
  }
  
  
  
  function verifyBadCredentials(){
    try{
     twitter.verifyCredentials(username='asdasdads',password='asdasdasd3214');
    }
    catch(cftwitter.exception.authexception te){
    }
  }
  
  
  function testFetch(){
   u = "http://twitter.com/account/verify_credentials.xml";
   results = twitter.fetch(url=twitter.twitterProps.authUrl,username=un,password=pwd);
   //debug(results);
   assertEquals(twitter.twitterProps.authResponse,results, "Authentication test failed");
  }
  
  
  
  function testFetchFriendsXML(){
   results = twitter.fetch(url=twitter.twitterProps.friendsXML,username=un,password=pwd);
   dom = xmlParse(results);
   //debug(dom);
   nodes = xmlSearch(dom,"//status[/statuses/status/user/screen_name='codeodor']");
   debug(nodes);
  }
  
  
  
  function testDumpAFriendsTimeLine(){
    fail("not sure yet how to get a single user's timeline ...'");
  }
  
  
  
  function testGetFriendsTimeLine(){
    tl = twitter.getFriendsTimeline(25);
    assertIsQuery(tl);
    assertEquals(25,tl.recordcount);
  }
  
  
  function dumpFriendsTimeLine(){
     twitter.printFriendsTimeline(25);
  }
  
  /* only have 1 tweet with this account!
  function dumpMyFiveMostRecentTweets(){
    a = twitter.getMyTimeLine(5);
    debug(a);
    assertEquals(5,a.recordCount);
  }
  */
  
  function dumpMyMostRecentTweet(){
    a = twitter.getMyTimeLine(1);
    debug(a);
    assertEquals(1,a.recordCount);
  }

  
    
    
</cfscript>

<!--- 
  Mock/spoof methods: to do
 --->
<cffunction name="toggleSpoof" access="private">
<!--- set spoofs for all --->

</cffunction>


<cffunction name="spoofCFFeedWrapper" access="private">

</cffunction>

<cffunction name="spoofFetch" access="private" hint="do nothing please">
<cfsavecontent variable="rss">
<rss xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:taxo="http://purl.org/rss/1.0/modules/taxonomy/" version="2.0"> <channel> <title>Twitter / virtix</title> <link>http://twitter.com/virtix</link> <description>Twitter updates from bill[y] shelton / virtix.</description> <language>en-us</language> <ttl>40</ttl> <item> <title>virtix: @codeodor me look forward to details on woolly mammoth multipolysystemic beast to slay.</title> <link>http://twitter.com/virtix/statuses/1011266459</link> <description>virtix: @codeodor me look forward to details on woolly mammoth multipolysystemic beast to slay.</description> <pubDate>Tue, 18 Nov 2008 14:28:17 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1011266459</guid> </item> <item> <title>virtix: gonna saunter over and grab some sugar at Moscone and see what Adobe has in mind.</title> <link>http://twitter.com/virtix/statuses/1009798022</link> <description>virtix: gonna saunter over and grab some sugar at Moscone and see what Adobe has in mind.</description> <pubDate>Mon, 17 Nov 2008 16:27:53 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1009798022</guid> </item> <item> <title>virtix: Heading downstairs to meet @marcesher and walk on over to the Max speaker brew-haha. Gorgeous day in SF!</title> <link>http://twitter.com/virtix/statuses/1008876212</link> <description>virtix: Heading downstairs to meet @marcesher and walk on over to the Max speaker brew-haha. Gorgeous day in SF!</description> <pubDate>Mon, 17 Nov 2008 00:58:46 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1008876212</guid> </item> <item> <title>virtix: adobe max menu: flash micro and yoohoo</title> <link>http://twitter.com/virtix/statuses/1008113473</link> <description>virtix: adobe max menu: flash micro and yoohoo</description> <pubDate>Sun, 16 Nov 2008 11:28:13 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1008113473</guid> </item> <item> <title>virtix: er eh ... /ETA/</title> <link>http://twitter.com/virtix/statuses/1008084836</link> <description>virtix: er eh ... /ETA/</description> <pubDate>Sun, 16 Nov 2008 10:36:29 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1008084836</guid> </item> <item> <title>virtix: totally rocked out to The Who on the way to IAD. EAT 10:15 in SF.</title> <link>http://twitter.com/virtix/statuses/1008084268</link> <description>virtix: totally rocked out to The Who on the way to IAD. EAT 10:15 in SF.</description> <pubDate>Sun, 16 Nov 2008 10:35:27 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1008084268</guid> </item> <item> <title>virtix: @joeRinehart may the Gods of travel smile upon you.</title> <link>http://twitter.com/virtix/statuses/1006847765</link> <description>virtix: @joeRinehart may the Gods of travel smile upon you.</description> <pubDate>Sat, 15 Nov 2008 10:10:31 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1006847765</guid> </item> <item> <title>virtix: Re-arranged flights to Adobe Max. Leaving early Sunday morning arriving mid morning PST. Leaving LA a couple days later. Wahoo!</title> <link>http://twitter.com/virtix/statuses/1006112358</link> <description>virtix: Re-arranged flights to Adobe Max. Leaving early Sunday morning arriving mid morning PST. Leaving LA a couple days later. Wahoo!</description> <pubDate>Fri, 14 Nov 2008 21:09:18 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1006112358</guid> </item> <item> <title>virtix: @marcesher couldn't be crack. @thecrumb'd be asking for money and shit. As benevolent as he is, I'd wager it's heroin.</title> <link>http://twitter.com/virtix/statuses/1005747860</link> <description>virtix: @marcesher couldn't be crack. @thecrumb'd be asking for money and shit. As benevolent as he is, I'd wager it's heroin.</description> <pubDate>Fri, 14 Nov 2008 17:02:45 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1005747860</guid> </item> <item> <title>virtix: @marcesher I've seen that cfx error only when the developer is mumbling.</title> <link>http://twitter.com/virtix/statuses/1005446357</link> <description>virtix: @marcesher I've seen that cfx error only when the developer is mumbling.</description> <pubDate>Fri, 14 Nov 2008 13:46:08 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1005446357</guid> </item> <item> <title>virtix: Need to /request/ a hotfix via email from MS? And "The system is currently unavailable" ... piss ants ...</title> <link>http://twitter.com/virtix/statuses/1005263690</link> <description>virtix: Need to /request/ a hotfix via email from MS? And "The system is currently unavailable" ... piss ants ...</description> <pubDate>Fri, 14 Nov 2008 10:29:19 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1005263690</guid> </item> <item> <title>virtix: http://twitpic.com/liuf - Tools of the trade - testing twitpic ...</title> <link>http://twitter.com/virtix/statuses/1003876669</link> <description>virtix: http://twitpic.com/liuf - Tools of the trade - testing twitpic ...</description> <pubDate>Thu, 13 Nov 2008 14:41:46 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1003876669</guid> </item> <item> <title>virtix: Hey, anyone ever monitored the scheduler in CF?</title> <link>http://twitter.com/virtix/statuses/1003855472</link> <description>virtix: Hey, anyone ever monitored the scheduler in CF?</description> <pubDate>Thu, 13 Nov 2008 14:27:43 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1003855472</guid> </item> <item> <title>virtix: "I'm a looser, baby (according to Twitterank), so why don't you kill me ..."</title> <link>http://twitter.com/virtix/statuses/1002757751</link> <description>virtix: "I'm a looser, baby (according to Twitterank), so why don't you kill me ..."</description> <pubDate>Wed, 12 Nov 2008 21:32:23 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1002757751</guid> </item> <item> <title>virtix: Practicing preso for BACFUG on 11-19-08 http://www.bacfug.org/ - Learn Unit Testing and Improve Your Sex Life</title> <link>http://twitter.com/virtix/statuses/1000743622</link> <description>virtix: Practicing preso for BACFUG on 11-19-08 http://www.bacfug.org/ - Learn Unit Testing and Improve Your Sex Life</description> <pubDate>Tue, 11 Nov 2008 17:53:13 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/1000743622</guid> </item> <item> <title>virtix: Doh! http://tinyurl.com/6kp8bt ... I'm actually going to keep my G1 firmware. I /want/ to execute unix commands on my phone.</title> <link>http://twitter.com/virtix/statuses/998806566</link> <description>virtix: Doh! http://tinyurl.com/6kp8bt ... I'm actually going to keep my G1 firmware. I /want/ to execute unix commands on my phone.</description> <pubDate>Mon, 10 Nov 2008 14:26:50 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/998806566</guid> </item> <item> <title>virtix: On today's menu: Fall leaf raking and Adobe Max and BACFUG presos. Life is good!</title> <link>http://twitter.com/virtix/statuses/997455238</link> <description>virtix: On today's menu: Fall leaf raking and Adobe Max and BACFUG presos. Life is good!</description> <pubDate>Sun, 09 Nov 2008 13:37:51 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/997455238</guid> </item> <item> <title>virtix: Peking Gourmet!</title> <link>http://twitter.com/virtix/statuses/996848052</link> <description>virtix: Peking Gourmet!</description> <pubDate>Sat, 08 Nov 2008 23:07:53 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/996848052</guid> </item> <item> <title>virtix: Testing from G1 at IHOP</title> <link>http://twitter.com/virtix/statuses/996458008</link> <description>virtix: Testing from G1 at IHOP</description> <pubDate>Sat, 08 Nov 2008 16:18:32 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/996458008</guid> </item> <item> <title>virtix: Any real guitar players out there who can't play Guitar Hero worth a damn?</title> <link>http://twitter.com/virtix/statuses/995421626</link> <description>virtix: Any real guitar players out there who can't play Guitar Hero worth a damn?</description> <pubDate>Fri, 07 Nov 2008 19:58:32 GMT</pubDate> <guid isPermaLink="false">http://twitter.com/virtix/statuses/995421626</guid> </item> </channel> </rss>
</cfsavecontent>
<cfreturn rss />
</cffunction>

<cffunction name="spoofVerifyCredentials" access="private">

</cffunction>

</cfcomponent>