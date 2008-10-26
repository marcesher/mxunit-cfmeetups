<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  function smokeTestForMessageStack(){
    var stack = listener.getMessageStack();
    assertEquals(99,arrayLen(structKeyArray(stack)));
  }
  
  
  function testGettingAllThreadMessages(){
    var stack = listener.getMessageStack();
    var i = 0;
    for(i=1; i lt 100; i = i + 1){
      assertEquals("this is thread number #i#", structFind(stack,"t#i#"), "t#i# did not return : /this is thread number #i#/");
    }  
  }
  
  
   function testGettingAllThreadMessagesViaGetMessage(){
    var stack = listener.getMessageStack();
    var i = 0;
    for(i=1; i lt 100; i = i + 1){
      assertEquals("this is thread number #i#", listener.getMessage("t#i#"), "listener.getMessage('t#i#') did not return : /this is thread number #i#/");
    }
  }
  
  
  
 //-------------------------------------------------// 
  
  function setUp(){
   var i = 0;
   listener = createObject("component","ThreadListener");
   for(i=1; i lt 100; i = i + 1){
     listener.addMessage("t#i#","this is thread number #i#");
    }
   
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>