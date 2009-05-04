<cfcomponent output="false" extends="BaseTest">
<cfscript>

 null = chr(0);

function simpleEncoderTest(){
  encoder = createObject('component', 'cfesapi.org.owasp.esapi.Encoder').init();
  evilString = '<script>alert("punk")</script>';
  html = encoder.encodeForHtml(evilString);
  writeoutput(html);
  u = encoder.encodeForURL(evilString);
  writeoutput(u);
  notSafe = encoder.decodeFromURL(evilString);
  writeoutput( encoder.encodeForHtml(notSafe) );
 }

  function setUp(){
    encoder = createObject('component', 'cfobjective.code.esapilite.org.owasp.esapi.Encoder').init();
    instance = encoder;
  }

  function tearDown(){

  }


</cfscript>

<!--- <cffunction name="testAllOpenBracketPermuationsWithCFEncodeFunction">
 <cfset q = getEncodedCharacters()>
 <cfoutput query="q">
 #q.currentRow#. #q.encoded# #htmlEditFormat(q.encoded)# #urlEncodedFormat(q.encoded)#
 <br />
 </cfoutput>
</cffunction> --->

<cffunction name="testAllOpenBracketPermuations">
 <cfset q = getEncodedCharacters()>
 <cfoutput query="q">
  <cfset assertEquals("<", encoder.canonicalize( q.encoded ) , 'Failure at row  #q.currentrow#') />
 </cfoutput>
</cffunction>

<cffunction name="getEncodedCharacters" access="private" hint="These are from snake @ ha.ckers.org">
<cf_querysim>
encodedChars
encoded
&lt;
%3C
%3c
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
 <cfreturn encodedChars />
</cffunction>



</cfcomponent>