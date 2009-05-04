<cfcomponent output="false" extends="BaseTest">
<cfscript>


  function AuthenticationExceptionShouldBeThrown() {
     try{
       ve.init('Invalid Input','details ... details',-100);
       fail('should not get here.');
     }
     catch(org.owasp.esapi.errors.AuthenticationException  e){
       assertEquals('Invalid Input', e.getMessage() , 'incorrect exception message');
       assertEquals('details ... details', e.getDetail(), 'incorrect exception detail');
       assertEquals(-100, e.getErrorCode(), 'incorrect exception error code');
     }
  }



  function setUp(){
    ve = createObject('component', root & 'org.owasp.esapi.errors.AuthenticationException');
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>