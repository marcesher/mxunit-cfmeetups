<cfcomponent output="false" extends="mxunit.framework.TestCase">

  <cffunction name="fuzzProfile">
   <cfscript>
     ff.get('http://dev/cfobjective/code/exampleapp/lesssecure/loginform.cfm');
     u = ff.findElement('username');
     p = ff.findElement('password');
     u.sendKeys('bill');
     p.sendKeys('bill');
     u.submit();
     link = ff.findElement('Update Profile');
     link.click();
     ff.get('http://dev/cfobjective/code/exampleapp/lesssecure/profile.cfm');
     //fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/#datePrefix#.png");
      pname = ff.findElement('name');
       pname.clear();
       pname.sendKeys('asd');
       pname.submit();
    </cfscript>

    <cfoutput query="xss">
      <cfscript>
       datePrefix = dateFormat(now(),"mm_dd_yyy_hh_mm_ss_ms");
       ff.get('http://dev/cfobjective/code/exampleapp/lesssecure/profile.cfm');
       fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/#datePrefix#.png");
       pname = ff.findElement('name');
       pname.sendKeys(attack);
       pname.submit();
       ff.saveScreenShot(fp);
      </cfscript>
    </cfoutput>
  </cffunction>


<cfscript>


  function smokeSomeFuzz() {
     ff.get('http://google.com');
     e = ff.findElement('q');
     e.sendKeys('fuzzing');
     e.submit();
     e = ff.findElement('Fuzzing - OWASP');
     e.click();
     fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/smoke.png");
     ff.saveScreenShot(fp);
  }


function setUp(){
  ff = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('ff');
  vectors = createObject('component','cfobjective.code.vectors.FuzzyVectors');
  xss = vectors.getXSSVectors();
}


</cfscript>
</cfcomponent>