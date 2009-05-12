<cfcomponent output="false" extends="mxunit.framework.TestCase">

  <cffunction name="fuzzProfile">
    <cfscript>
		firefox.get('http://dev/cfobjective/code/exampleapp/moresecure/loginform.cfm');
     uname = firefox.findElement('username');
     pwd = firefox.findElement('password');
     uname.sendKeys('billys');
     pwd.sendKeys('$billY8');
     e = firefox.findElement('submitMe');
     e.click();
     link = firefox.findElement('Update Profile');
     link.click();
     path = getDirectoryFromPath( '/home/billy/webapps/cfobjective/code/fuzzingtests/thumbs/foo.png');
   </cfscript>

   <cfoutput query="xssVectors" maxrows="25">
     <cfscript>
     pName = firefox.findElement('name');
     email = firefox.findElement('email');
     pwd = firefox.findElement('newpwd');
     pName.sendKeys( attack );
     email.sendKeys( attack );
     pwd.sendKeys( attack );
     pName.submit();
     failedDiv = firefox.findElement('invalid');
     debug(failedDiv.getText());

     firefox.get('http://dev/cfobjective/code/exampleapp/moresecure/profile.cfm');

     </cfscript>
    </cfoutput>

   </cffunction>






<cfscript>
  function setUp(){
    firefox = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('firefox');
    firefox.setUseExistingFireFoxInstance(true);
   // firefox.setFirefoxPath('C:/Programs/Mozilla Firefox/firefox.exe');

    vectors = createObject('component','cfobjective.code.vectors.FuzzyVectors');
    xssVectors = vectors.getXSSAlertVectors();
  }



</cfscript>
</cfcomponent>