<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function testGetLoginPage() {
     firefox.get('http://dev/cfobjective/code/exampleapp/lesssecure/loginform.cfm');
     uname = firefox.findElement('username');
     pwd = firefox.findElement('password');
     uname.sendKeys('foo');
     pwd.sendKeys('123');
     e = firefox.findElement('submitMe');
     e.click();
  }



  function setUp(){
    firefox = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('firefox');
    firefox.setUseExistingFireFoxInstance(true);
    firefox.setFirefoxPath('C:/Programs/Mozilla Firefox/firefox.exe');
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>