<cfcomponent output="false">
  
  <cfscript>
   function init(){
  	  this.driverType = "Safari";
	    //this.driver = createObject("java","org.openqa.selenium.ie.SafariDriver");
      return this;
    }
     
    function get(){
     throwNotImplementedException("Safari.get()");
    }
  </cfscript>

</cfcomponent>