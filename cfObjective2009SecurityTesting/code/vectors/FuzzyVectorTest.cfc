<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


 function dumpXSSAlertVectors(){
  q = vectors.getXSSAlertVectors();
  assert( q.recordCount > 100 );
  assertEquals( 'XSS Locator', q['name'][1] );
  assertEquals( 'URL Encoding', q['name'][100] );
  debug(q);
 }
 
 function dumpXSSDocWriteVectors(){
  q = vectors.getXSSDocWriteVectors();
  assert( q.recordCount > 100 );
  assertEquals( 'XSS Locator', q['name'][1] );
  assertEquals( 'URL Encoding', q['name'][100] );
  debug(q);
 }


  function testFuzzyVector() {
     debug(vectors);
  }


 function dumpEncodedChars(){
  debug(vectors.getEncodedCharacters());
 }



  function setUp(){
   vectors = createObject('component','cfobjective.code.vectors.FuzzyVectors');
  }

  function tearDown(){

  }


</cfscript>


</cfcomponent>