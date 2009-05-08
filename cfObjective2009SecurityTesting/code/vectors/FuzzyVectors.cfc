<cfcomponent>
<cfscript>

//should be the same for all attacks to support unions
columns = 'id,name,type,attack,label,description,browser';

function getXmlXssVectors(){
  return xmlXSSVectors;
}

function getDocWriteVectors(){
  return docWriteVectors;
}

function getXSSAlertVectors(){
  return  xmlXss2Query('xss.xml');
}

function getXSSDocWriteVectors(){
  return  xmlXss2Query('xss-docwrite.xml');
}


function xmlXss2Query(fileName){

  var q = queryNew( columns );
  var i = 1;
  var xssXml =  fileRead( expandPath('/cfobjective/code/vectors/#arguments.fileName#') );
  var dom = xmlParse(xssxml);
  var nodes = xmlSearch(dom,'/xss/attack');
  for(i; i <= arrayLen(nodes); i++){
   queryAddRow(q);
   querySetCell(q, 'name', nodes[i]['name'].XmlText  );
   querySetCell(q, 'attack', nodes[i]['code'].XmlText  );
   querySetCell(q, 'label', nodes[i]['label'].XmlText  );
   querySetCell(q, 'description', nodes[i]['desc'].XmlText  );
   querySetCell(q, 'browser', nodes[i]['browser'].XmlText  );
   querySetCell(q, 'type', 'xss'  );
  }
 return q;

}


</cfscript>


<cffunction name="getDocWriteVectorById">
  <cfargument name="name" />
  <cfquery name="xss" dbtype="query" maxrows="1">
     select exploit from docWriteVectors
     where name = '#arguments.name#'
  </cfquery>
  <cfreturn xss.exploit />
</cffunction>


<cffunction name="getXSSDocWrite" hint="list of common attacks">
  <cfquery name="xss" dbtype="query">
     select * from vectors
     where type = 'xss'
  </cfquery>
  <cfreturn xss />
</cffunction>


<cffunction name="getEncodedCharacters">
 <cfreturn encodedChars />
</cffunction>

<cf_querysim>
encodedChars
encoded
&lt;
%3C
&lt
&lt;
&LT
&LT;
&#60
&#060
&#0060

&#00060
&#000060
&#0000060
&#60;
&#060;
&#0060;
&#00060;
&#000060;
&#0000060;
&#x3c
&#x03c
&#x003c
&#x0003c
&#x00003c
&#x000003c
&#x3c;
&#x03c;

&#x003c;
&#x0003c;
&#x00003c;
&#x000003c;
&#X3c
&#X03c
&#X003c
&#X0003c
&#X00003c
&#X000003c
&#X3c;
&#X03c;
&#X003c;
&#X0003c;
&#X00003c;
&#X000003c;
&#x3C

&#x03C
&#x003C
&#x0003C
&#x00003C
&#x000003C
&#x3C;
&#x03C;
&#x003C;
&#x0003C;
&#x00003C;
&#x000003C;
&#X3C
&#X03C
&#X003C
&#X0003C
&#X00003C
&#X000003C

&#X3C;
&#X03C;
&#X003C;
&#X0003C;
&#X00003C;
&#X000003C;
\x3c
\x3C
\u003c
\u003C
</cf_querysim>


<cfset docWrite = "<script>document.write('<div id=\""_firefuzzTestDiv\"">hacked</div>')</script>" />
<cfoutput>
<cf_querysim>
	docWriteVectors
	name,type,exploit
	xss.doc1|xss|>%22%27>#docWrite#>
	xss.doc2|xss|>"'>#docWrite#
	xss.doc3|xss|#docWrite#
  xss.doc4|xss|&{document.write('<div id="_firefuzzTestDiv">hacked</div>')};
  xss.doc5|xss|#docWrite#
  xss.doc6|xss|<script>document.body.addEventListener("command", document.write('<div id=\"_firefuzzTestDiv\">hacked</div>'), true)</script>
  xss.doc7|xss|&apos;;document.write(String.fromCharCode(88,83,83))//
  xss.doc8|xss|%3c%73%63%72%69%70%74%3e%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%64%69%76%20%69%64%3d%22%5f%66%69%72%65%66%75%7a%7a%54%65%73%74%44%69%76%22%3e%68%61%63%6b%65%64%3c%2f%64%69%76%3e%27%29%3c%2f%73%63%72%69%70%74%3e
  xss.doc9|xss|%u003c%u0073%u0063%u0072%u0069%u0070%u0074%u003e%u0064%u006f%u0063%u0075%u006d%u0065%u006e%u0074%u002e%u0077%u0072%u0069%u0074%u0065%u0028%u0027%u003c%u0064%u0069%u0076%u0020%u0069%u0064%u003d%u0022%u005f%u0066%u0069%u0072%u0065%u0066%u0075%u007a%u007a%u0054%u0065%u0073%u0074%u0044%u0069%u0076%u0022%u003e%u0068%u0061%u0063%u006b%u0065%u0064%u003c%u002f%u0064%u0069%u0076%u003e%u0027%u0029%u003c%u002f%u0073%u0063%u0072%u0069%u0070%u0074%u003e
  xss.doc10|xss|%3c%3c
</cf_querysim>
</cfoutput>



</cfcomponent>