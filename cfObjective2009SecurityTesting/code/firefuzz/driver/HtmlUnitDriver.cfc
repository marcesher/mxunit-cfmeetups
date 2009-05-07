<cfcomponent output="false" extends="WebDriver">
  <cfscript>
   /*
    to do: instead of maintaining a separate java class just to handle authentication,
    use reflectiion to the the protected method, getWebClient() to get the client
    and set it's authentication properties. 
  */
  
  
    function init(){
  	  this.driverType = "HtmlUnit";
	    this.driver = loader.create("org.openqa.selenium.htmlunit.HtmlUnitDriver");
      return this;
    }
    
    
    
    
   function isJavascriptEnabled(){
	   return this.driver.isJavascriptEnabled();
	 } // boolean 
		
		
	function setJavascriptEnabled(enable){
	  this.driver.setJavascriptEnabled(enable);
	} //void 
	
	
	function authenticate(username, password, domain){
	  //To Do: NTLM Credentials ... more params, or separate method?
	  getWebClient().getCredentialsProvider().addCredentials(username,password); 
	}
	

	function addNTLMCredentials(username, password, host, port, clientHot, domain){
	  //To Do: NTLM Credentials ... more params, or separate method?
	  getWebClient().getCredentialsProvider().addNTLMCredentials(username, password, host, port, clientHot, domain); 
	}
		
		
		
	function getWebClient(){
      var getWebClientMethod = this.driver.getClass().getDeclaredMethod("getWebClient",arrayNew(1));
      var params = arrayNew(1); 
      getWebClientMethod.setAccessible(true);
      return getWebClientMethod.invoke(this.driver,params);
    }
  </cfscript>

</cfcomponent>