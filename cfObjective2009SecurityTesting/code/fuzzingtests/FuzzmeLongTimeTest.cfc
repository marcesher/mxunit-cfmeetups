<cfcomponent output="false" extends="BaseTest">

  <cffunction name="fuzzMeLongTime">
     <cfoutput query="xss" maxrows="50">
     <cfscript>
     datePrefix = dateFormat(now(),"mm_dd_yyy_hh_mm_ss_ms");
     ff.get('http://#host#/cfobjective/code/exampleapp/fuzzmelongtime.cfm');
     element = ff.findElement('fuzzme');
     debug(xss.currentrow & '  ' & xss.name);
     element.clear();
     element.sendKeys(attack);
     element.submit();
     //log results
     namePrefix =  rereplace(name,'[ /]','','all') & '_' & dateFormat(now(),"mm_dd_yyy_hh_mm_ss_ms");
     fp = getDirectoryFromPath(getCurrentTemplatePath()) & 'thumbs/longtime/';
     ff.saveScreenShot(fp & '#namePrefix#.png');
     pgSrc = ff.getPageSource();
     writeToFile( fp & '#namePrefix#.html', pgSrc );
     </cfscript>
    </cfoutput>
   <cfset ff.get('http://#host#/cfobjective/code/fuzzingtests/thumbs/longtime/index.cfm') />
   </cffunction>


<cfscript>



function setUp(){
  ff = createObject('component','cfobjective.code.firefuzz.driver.WebDriver').newInstance('ff');
  //set this property when Firefox is installed not in default location
  //ff.setFireFoxPath('C:/Programs/Mozilla Firefox/firefox.exe');
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