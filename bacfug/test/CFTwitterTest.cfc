<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
 
  
  function testTwitterType(){
   assertIsTypeOf(twitter,"bacfug.twitter.CFTwitter");
   debug(twitter.twitterProps);
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
   //assertEquals(twitter.twitterProps.authResponse,results, "Authentication test failed");
  }
  
  function testDumpAFriendsTimeLine(){
    fail("not sure yet how to get a single user's timeline ...'");
  }
  
  function testGetFriendsTimeLine(){
    tl = twitter.getFriendsTimeline();
    assertIsQuery(tl);
  }
  
  function dumpFriendsTimeLine(){
    //tl = twitter.getFriendsTimeline();
   // dump(tl);
    twitter.printFriendsTimeline();
  }
  
  
  function dumpMyFiveMostRecentTweets(){
    a = twitter.getMyTimeLine(5);
    debug(a);
    assertEquals(5,a.recordCount);
  }
  
  function dumpMy25MostRecentTweets(){
    a = twitter.getMyTimeLine(25);
    debug(a);
    assertEquals(25,a.recordCount);
  }
  
  function printMyTweets(){
    twitter.printMyTimeline(5);
  }
  
 //-------------------------------------------------// 
  
  function setUp(){
  	var un = ''; //set this to valid Twitter credentials
  	var pwd = '';
    twitter = createObject("component","bacfug.twitter.CFTwitter").init(un,pwd);
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>



</cfcomponent>