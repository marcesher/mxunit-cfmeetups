<cfcomponent output="false" extends="BaseTest">
<cfscript>
  
  
  function whatDoesListFindOnNullDo(){
   list = chr(0);
   debug( listfind(list, 'asd') );
  }
  
  function onlySpecifiedJarsShouldBeLoaded(){
   // var loader = createObject('component' , root & '.org.owasp.esapi.ClassLoader').init(jarsToInclude='nekohtml-0.9.5.jar');
  }
  
  function classLoaderShouldReturnSelf(){
    assertSame(loader,loader);
  }
  
 
  
  function testThatESAPIisLoaded(){
    encoder = loader.create('org.owasp.esapi.reference.DefaultEncoder').init();
    actual = encoder.encodeForHTML('<script />');
    debug(actual);
    assertEquals('&lt;script &##x2f;&gt;', actual );
  }
  
  function setUp(){
    loader = createObject('component' , root & '.org.owasp.esapi.ClassLoader').init();
    
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>