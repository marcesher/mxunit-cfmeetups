/**

  WebDriver
  @author bill
  @description ColdFusion wrapper for webdriver (http://code.google.com/p/webdriver)

  @todo: lots - subclass driver types

*/

<cfcomponent displayname="WebDriver" output="true">


  <cfscript>

	  this.driver = "";
	  this.webelement = "";
	  this.driverType = "";
    paths = arrayNew(1);
    loadJars();
    loader =  createObject("component", "cfwd.javaloader.JavaLoader").init(paths,true);

    System = createObject('java','java.lang.System');
    this.by = loader.create("org.openqa.selenium.By");



	  //
	  function newInstance(type){
	     switch(type){

	     case "ff" : {
	      return createObject("component","FirefoxDriver").init();
	      break;
	     }

	     case "firefox" : {
	      return createObject("component","FirefoxDriver").init();
	      break;
	     }

	     case "ie": {
	     	 return createObject("component","InternetExplorerDriver").init();
	       break;
	     }

	     case "htmlunit": {
	       return createObject("component","HtmlUnitDriver").init();
	       break;
	     }

	     case "safari" : {
	      return createObject("component","SafariDriver").init();
	     }

	     case "chrome" : {
	      return createObject("component","ChromeDriver").init();
	     }

	     default :
	       return createObject("component","HtmlUnitDriver").init();
	       break;
	     }

	   }


	  function getType(){
	    return this.driverType;
	  }

	  function setDriver(driver){
	   this.driver = driver;
	   return this;
	  }


	  function get(url) {
	     this.driver.get(arguments.url);
	  }



	    function close() {
	      this.driver.close();
	    }


		function executeScript() {
		  throwNotImplementedException("executeScript");
		} //java.lang.String, java.lang.Object[] :: java.lang.Object


		function findElement(by){
		  /*
		  var element = createObject("component","WebElement");
		  this.webelement = this.driver.findElement(this.by.name(by));
		  element.init(this.webelement);
		  return element;
		  */

		  try{
		 	return findElementById(by);
		   }catch(any ex){}

		   try{
			 return findElementByName(by);
		   }catch(any  ex){}

		   try{
			 return findElementByXpath(by);
			}catch(any  ex){}

		   try{
			 return findElementByLinkText(by);
		   }catch(any  ex){}

		 throwException("UndefinedElementException","Element [#by#] was not found","Make sure the element exists"); //return empty string, if it's not there - no exceptions for now
		}


		function findElementByLinkText(text){
		  var element = createObject("component","WebElement");
		  this.webelement = this.driver.findElementByLinkText(text);
		  element.init(this.webelement);
		  return element;
		}



		function getTitle() {
		  return this.driver.getTitle();
		} //java.lang.String


		function getPageSource() {
		  return this.driver.getPageSource();
		} //java.lang.String


		function getCurrentUrl() {
		  return this.driver.getCurrentUrl();
		} //java.lang.String


	   function findElementByName(name) {
			var element = this.driver.findElement(this.by.name(name));
			return createObject("component","WebElement").init(element);
		}

	   function findElementById(id) {
		  var element = this.driver.findElement(this.by.id(id));
			return createObject("component","WebElement").init(element);
		}

		function findElementsById(id) {
		   var elements = arrayNew(1);
		   var element = "";
		   var i = 1;
		   var webelements = this.driver.findElementsById(id);
		   for(i = 1; i lte arrayLen(webelements); i = i +1){
			  element = createObject("component","WebElement").init(webelements[i]);
			  elements.add(element);
			}
		  return elements; //array of WebElement objects
		}  //)(java.lang.String) java.util.List


	   function findElements(by){
	     //to do: returns an array of element objects
	     // by name, xpath, etc...
	   }


		function findElementsByName(name) {
			var elements = arrayNew(1);
			var element = "";
			var i = 1;
			var webelements = this.driver.findElementsByName(name);
			for(i = 1; i lte arrayLen(webelements); i = i +1){
			  element = createObject("component","WebElement").init(webelements[i]);
			  elements.add(element);
			}
		  return elements; //array of WebElement objects
		}





		function findElementsByXPath(xpath) {
			var elements = arrayNew(1);
			var element = "";
			var i = 1;
			//var webelements = this.driver.findElementsByXPath(xpath);
			var webelements = this.driver.findElements(this.By.xPath(xpath));
			for(i = 1; i lte arrayLen(webelements); i = i +1){
			  element = createObject("component","WebElement").init(webelements[i]);
			  elements.add(element);
			}
		  return elements; //array of WebElement objects
		}


		function findElementByXPath(xpath) {
		   var element = this.driver.findElementByXPath(xpath);
		   return createObject("component","WebElement").init(element);
		}


		function getVisible() {
		  return this.driver.getVisible();
		} //boolean


		function setVisible(visible){
		  this.driver.setVisible( javacast("boolean",visible) );
		} //void


		function quit() {
		  this.driver.quit();
		}  //void


		function navigate(location){
		 //throwNotImplementedException("navigate ... not shure best how to implement this");
		 this.driver.get(location);
		} //org.openqa.selenium.WebDriver$Navigation


		//Not tested.
		function setProxy(proxyUrl, port){
		 this.driver.setProxy(proxyUrl, port);
		} //void


		//authenticateAs(String username, String password, String host, int port, String clientHost, String domain)
		function authenticateAs(username,password, host, port, clientHost, domain){
		  this.driver.authenticateAs(username,password, host, port, clientHost, domain);
		 }


		function switchTo(){
		  return this.driver.switchTo();
		} //org.openqa.selenium.WebDriver$TargetLocator





		//To Do's ......................


		function manage(){
		 throwNotImplementedException("manage");
		} //org.openqa.selenium.WebDriver$Options


  </cfscript>

<cffunction name="loadJars">
    paths[1] =  expandPath("/cfwd/lib/webdriver-common.jar");
    paths[2] = expandPath("/cfwd/lib/webdriver-firefox.jar");
    paths[3] = expandPath("/cfwd/lib/json-20080701.jar");
    paths[4] = expandPath("/cfwd/lib/webdriver-jobbie.jar");
    paths[5] = expandPath("/cfwd/lib/jna.jar");
<cfset var i = 1 />

<cfdirectory name="d" action="list" directory="#expandPath("/cfwd/lib/")#" />
 <cfoutput query="d">
   <cfset paths[i] =  expandPath("/cfwd/lib/#d.name#") />
   <cfset i++ />
 </cfoutput>

</cffunction>

 <cffunction name="throwNotImplementedException">
   <cfargument name="methodName" />
   <cfthrow type="org.mxunit.exception.NotImplementedException"
            message="The method you called has not yet been implemented"
            detail="Method name: #arguments.methodName#">
 </cffunction>

 <cffunction name="throwException">
   <cfargument name="type" />
   <cfargument name="message" />
   <cfargument name="detail" />
   <cfthrow type="#arguments.type#"
            message="#arguments.message#"
            detail="#arguments.detail#">
 </cffunction>

</cfcomponent>