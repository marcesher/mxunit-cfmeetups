<cfcomponent output="false" extends="mxunit.framework.TestCase">
    <cfscript>
    
  function testMyWebPage(){
    assertEquals("cloak",driver.findElement("c").getText());
 }


//----------------------------------------------------------------------
    
   function setUp(){
    driver = createObject("component","cfwebdriver.WebDriver").newInstance("firefox");
    driver.setUseExistingFireFoxInstance(true); 
    driver.get("http://dev/bacfug/ui/cloak.cfm");
   }
    
   function  tearDown(){
    //driver.close();
  }

    </cfscript>

</cfcomponent>