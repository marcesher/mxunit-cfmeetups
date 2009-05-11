<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


function sessionIdShouldBeJ2EECompliant() {
     debug(session);
     email = session.arm.getDirectReference( session.uref ).getEmail();
     debug(email);
     assertEquals( user.getEmail(), email , 'WTF? different objects?' );
     //Note changed ESAPI.properties to allow case insensitive jsessionid and to allow 36 charcters
     assert( validator.isValidInput('sessionid', session.sessionid, 'HTTPJSESSIONID', 36, false) );    
  }

 function cookieShouldBeValid() {
     cookie['userFullName'] = user.getName();
     debug(cookie);
     assert( validator.isValidInput('name',cookie.userFullName, 'HTTPCookieValue', 36, false) );
  }



 function setUp(){
   user = createObject('component','cfobjective.code.exampleapp.moresecure.SecureUser').init();
   validator = createObject('component','cfobjective.code.esapilite.org.owasp.esapi.Validator').init();
   //use the my ESAPI.properties files instead.
   validator.setResourceDirectory( expandpath('/cfobjective/code/esapilite/tests/fixture/resources/.esapi') );
   user.login( 'billys','$billY8' ); 
 }


  function tearDown(){
   
  }


</cfscript>
</cfcomponent>