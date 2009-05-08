<cfcomponent output="false" extends="mxunit.framework.TestCase">

  <cffunction name="fuzzMeLongTime">
   <cfset fp = expandPath("/cfobjective/code/fuzzingtests/thumbs/") />
 
     <cfoutput query="xss" maxrows="25">
     <cfscript>
     datePrefix = dateFormat(now(),"mm_dd_yyy_hh_mm_ss_ms");   
     ff.get('http://dev/cfobjective/code/exampleapp/fuzzmelongtime.cfm');    
     element = ff.findElement('fuzzme');   
     debug(xss.currentrow & '  ' & xss.name);
     element.clear();
     element.sendKeys(attack);
     element.submit();
     </cfscript>
    </cfoutput>
   </cffunction>


<cfscript>



function setUp(){
  ff = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('ff');
  ff.setFireFoxPath('C:/Programs/Mozilla Firefox/firefox.exe');
  ff.setUseExistingFireFoxInstance(true);
  vectors = createObject('component','cfobjective.code.vectors.FuzzyVectors');
  xss = vectors.getXSSAlertVectors();
}


</cfscript>

<cffunction name="writeToFile" access="private">
  <cfargument name="filePath">
  <cfargument name="fileContent">
  <cffile action="write" output="#arguments.fileContent#" file="#arguments.filePath#">
</cffunction>
</cfcomponent>