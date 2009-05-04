<cfcomponent output="false" extends="BaseTest">
<cfscript>


  function loggerExceptionShouldBeThrown() {
     try{
       ve.init('Invalid Input','details ... details',-100);
       fail('should not get here.');
     }
     catch(org.owasp.esapi.errors.loggerException e){
       assertEquals('Invalid Input', e.getMessage() , 'incorrect exception message');
       assertEquals('details ... details', e.getDetail(), 'incorrect exception detail');
       assertEquals(-100, e.getErrorCode(), 'incorrect exception error code');
     }
  }



  function setUp(){
    ve = createObject('component', root & 'org.owasp.esapi.errors.loggerException');
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>