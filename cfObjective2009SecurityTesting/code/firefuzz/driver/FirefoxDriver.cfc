<cfcomponent output="false" extends="WebDriver">

  <cfscript>

    function init(){
     this.driverType = "Firefox";
     this.driver = loader.create('org.openqa.selenium.firefox.FirefoxDriver');
     return this;
    }

    function get(url){
     try{
     	super.get(arguments.url);
     }
     catch(java.lang.RuntimeException e){
       throwException("org.mxunit.cfwebdriver.FirefoxLoadFailureException",
                       "Failed to load Firefox",
                       "If Firefox is not located in C:/Program Files/Mozilla Firefox/, please set the path to the Firefox executable using driver.setFirefoxPath(...)");
     }
    }

  function executeScript(script,args){
     var localArgs = arrayNew(1);
     localArgs[1] = arguments.args;
     this.driver.executeScript(script,localArgs);
  }

	function setFireFoxPath(path){
	  createObject("java","java.lang.System").setProperty("webdriver.firefox.bin", path);
	}

	function setUseExistingFireFoxInstance(toggle){
	  createObject("java","java.lang.System").setProperty("webdriver.firefox.useExisting", toggle);
	}

  function saveScreenShot(path){
    var file = createObject('java','java.io.File').init(path);
    this.driver.saveScreenShot(file);

  }
  </cfscript>

</cfcomponent>