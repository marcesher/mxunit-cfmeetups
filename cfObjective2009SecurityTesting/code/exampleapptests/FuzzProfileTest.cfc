<cfcomponent output="false" extends="mxunit.framework.TestCase">

  <cffunction name="fuzzProfile">
    <cfscript>
		firefox.get('http://dev/cfobjective/code/exampleapp/lesssecure/loginform.cfm');
     uname = firefox.findElement('username');
     pwd = firefox.findElement('password');
     uname.sendKeys('bill');
     pwd.sendKeys('bill');
     e = firefox.findElement('submitMe');
     e.click();
      link = firefox.findElement('Update Profile');
     link.click();
     path = getDirectoryFromPath( '/home/billy/webapps/cfobjective/code/fuzzingtests/thumbs/foo.png');
     debug(path);
      firefox.saveScreenShot( path );
     return;
   </cfscript>

   <cfoutput query="xssVectors">
     <cfscript>

     elem = firefox.findElement('name');
     elem.clear();
     elem.sendKeys( attack );
     elem.submit();
     firefox.get('http://dev/cfobjective/code/exampleapp/lesssecure/profile.cfm');
     firefox.saveScreenShot( getDirectoryFromPath( getCurrentTemplatePath() ) & 'thumbs' );
     </cfscript>
    </cfoutput>
   </cffunction>






<cfscript>
  function setUp(){
    firefox = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('firefox');
    firefox.setUseExistingFireFoxInstance(true);
    firefox.setFirefoxPath('C:/Programs/Mozilla Firefox/firefox.exe');

    vectors = createObject('component','cfobjective.code.vectors.FuzzyVectors');
    xssVectors = vectors.getXSSVectors();
  }



</cfscript>
</cfcomponent>