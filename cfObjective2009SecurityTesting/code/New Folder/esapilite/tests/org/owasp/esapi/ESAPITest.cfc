<cfcomponent output="false" extends="BaseTest">
<cfscript>


  function esapiIsSame(){
    assertIsTypeOf( esapi, 'cfobjective.esapilite.org.owasp.esapi.ESAPI' );
    assertSame(esapi,esapi);
  }

  function encoderIsSame(){
   var encoder = esapi.encoder();
   assertIsTypeOf( encoder, 'cfobjective.esapilite.org.owasp.esapi.Encoder' );
   assertSame(encoder,encoder);
  }

  function validatorIsSame(){
   var validator = esapi.validator();
   assertIsTypeOf( validator, 'cfobjective.esapilite.org.owasp.esapi.Validator' );
   assertSame(validator,validator);
  }



  function setUp(){

  	//placeholder for now.
  	path = getDirectoryFromPath( getCurrentTemplatePath() );
  	config =   path & 'mock-config.xml' ;

  	dom = xmlParse(config);
  	//debug(dom);
  	props = XMLSearch(dom, "/Config/Properties/Property[@name='loglevel']");
  	debug(props[1].XmlAttributes['value']);

    esapi = createObject('component',  'cfobjective.esapilite.org.owasp.esapi.ESAPI').init(config);
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>