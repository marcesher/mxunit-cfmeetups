<cfcomponent output="false" extends="BaseTest">
<cfscript>


  function smokeJavaLoader() {

    paths = [];
  	paths[1] = expandPath('/#root#/lib/ESAPI.jar');
  	paths[2] = expandPath('/#root#/lib/antisamy-bin.1.2.jar');
    loader = createObject('component','#root#.javaloader.JavaLoader').init(paths,true);
    encoder = loader.create('org.owasp.esapi.reference.DefaultEncoder').init();
    validator = loader.create('org.owasp.esapi.reference.DefaultValidator').init();
    debug(validator);
    debug(encoder);
    assert('org.owasp.esapi.reference.DefaultValidator'==validator.getClass().getName());
    assert('org.owasp.esapi.reference.DefaultEncoder'==encoder.getClass().getName());

  }



</cfscript>
</cfcomponent>