<cfcomponent output="false" extends="mxunit.framework.TestCase">

  <cffunction name="fuzzProfile">
   <cfset fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/") />
   
    <cfscript>
     
     datePrefix = dateFormat(now(),"mm_dd_yyy_hh_mm_ss_ms");   
     ff.get('http://dev/cfobjective/code/exampleapp/lesssecure/loginform.cfm');
     u = ff.findElement('username');
     p = ff.findElement('password');
     u.sendKeys('bill');
     p.sendKeys('bill');
     u.submit();
     </cfscript>     
     <cfoutput query="xss">
     <cfscript>
     ff.get('http://dev/cfobjective/code/exampleapp/lesssecure/profile.cfm');
     debug(xss.currentrow & '  ' & xss.name);
     fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/#datePrefix#");
     pname = ff.findElement('name');
     e = ff.findElement('email');
     pname.clear();
     e.clear();
     //Submit payload
     pname.sendKeys(attack);
     //e.sendKeys(attack);
     pname.submit();
     //log results
     //pgSrc = ff.getPageSource(); 
     //ff.saveScreenShot(fp & '#datePrefix#.png');
     //pgSrc = ff.getPageSource(); 
     //writeToFile( fp & '#datePrefix#.html', pgSrc );
     //sleep(100);
     </cfscript>
    </cfoutput>
    <cfset  ff.get('http://dev/cfobjective/code/fuzzingtests/thumbs/index.cfm') />
  </cffunction>


<cfscript>


  function smokeSomeFuzz() {
     ff.get('http://google.com');
     e = ff.findElement('q');
     e.sendKeys('fuzzing');
     e.submit();
     e = ff.findElement('Fuzzing - OWASP');
     e.click();
     fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/");
     ff.saveScreenShot(fp & 'smoke.png');
     pgSrc = ff.getPageSource(); 
     writeToFile( fp & 'smoke.html', pgSrc );
     //display report
     ff.get('http://dev/cfobjective/code/fuzzingtests/thumbs/index.cfm');  
  }


function setUp(){
  ff = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('ff');
  ff.setFireFoxPath('C:/Programs/Mozilla Firefox/firefox.exe');
  ff.setUseExistingFireFoxInstance(true);
  vectors = createObject('component','cfobjective.code.vectors.FuzzyVectors');
  xss = vectors.getXSSDocWriteVectors();
}


</cfscript>

<cffunction name="writeToFile" access="private">
  <cfargument name="filePath">
  <cfargument name="fileContent">
  <cffile action="write" output="#arguments.fileContent#" file="#arguments.filePath#">
</cffunction>
</cfcomponent>