<cfcomponent output="false" extends="BaseTest">
<cfscript>
    paths = [];
  	paths[1] = expandPath('/#root#/lib/ESAPI.jar');
  	paths[2] = expandPath('/#root#/lib/antisamy-bin.1.2.jar');
  	paths[3] = expandPath('/#root#/lib/commons-fileupload-1.2.jar');
    loader = createObject('component','#root#.javaloader.JavaLoader').init(paths,true);
    config = loader.create('org.owasp.esapi.reference.DefaultSecurityConfiguration').init();
    config.setResourceDirectory( expandPath('/cfobjective/esapilite/tests/fixture/resources/.esapi/') );
    validator = loader.create('org.owasp.esapi.reference.DefaultValidator').init();

  function testLoadJavaClasses(){
    debug(validator);
    debug(config);
    assert('org.owasp.esapi.reference.DefaultValidator'==validator.getClass().getName());
    assert('org.owasp.esapi.reference.DefaultSecurityConfiguration'==config.getClass().getName());
  }

  function testLoadResourceDirectory(){
   config.setResourceDirectory( expandPath('/cfesapi/tests/fixture/resources/.esapi/') );
   debug('test to see if custom property is available');
   appName = config.getApplicationName();
   debug(appName);
   assert ( 'UnitTest' == appName ) ;
  }

  function testRunValidationFromUserDefinedResource(){
   config.setResourceDirectory( expandPath('/cfesapi/tests/fixture/resources/.esapi/') );
   cfvalidator = createObject('component', root & '.org.owasp.esapi.Validator').init();
   cc = '1234 9876 0000 0008';
   actual = validator.getValidCreditCard("cc", cc, false);
   assertEquals( cc,actual );
  }

  function testRunValidationForCustomDocketValidationRule(){
   config.setResourceDirectory( expandPath('/cfesapi/tests/fixture/resources/.esapi/') );
   d = '12345';
   actual = validator.getValidInput('docket',d,'Docket', 5, false);
   debug(actual);
   assertEquals( d,actual );

   try{
    d = 'zxc908zxciou)<script />';
    debug('trying #d# ... should fail');
    actual = validator.getValidInput('docket',d,'docket', 5, false);
    fail('should not let #d# pass.');
   }
   catch(any e){}

  }


  function setUp(){

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>