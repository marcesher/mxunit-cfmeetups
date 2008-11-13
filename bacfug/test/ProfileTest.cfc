<cfcomponent output="false" extends="mxunit.framework.TestCase">
    <cfscript>
    
  function testReadPassword(){
  	p = credentials.getPasswordFromIni();
    debug(p);
    assertTrue(len(p));
  }
  
  function testReadUsername(){
  	u = credentials.getUsernameFromIni();
    debug(u);
    assertTrue(len(u));
  }


//----------------------------------------------------------------------
    
   function setUp(){
     credentials = createObject("component","bacfug.twitter.Util");
     debug(credentials.getIniPath());
   }
    
   function  tearDown(){
    //driver.close();
  }

    </cfscript>

</cfcomponent>