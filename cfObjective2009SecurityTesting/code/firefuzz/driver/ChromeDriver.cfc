<cfcomponent output="false">
  
  <cfscript>
    function init(){
  	  this.driverType = "Chrome";
	    //this.driver = createObject("java","org.openqa.selenium.ie.ChromeDriver");
      return this;
    }
    
    function get(){
      throwNotImplementedException("ChromeDriver.init()");
    }
  </cfscript>

</cfcomponent>