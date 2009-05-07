<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


function sessionIdShouldBeJ2EECompliant() {
     user.login('bill','bill');
     debug(session);
     assertEquals( 'bill@kungfu.fu',session.user.email );
     //Note changed ESAPI.properties to allow case insensitive jsessionid and to allow 36 charcters
     assert( validator.isValidInput('sessionid',session.sessionid, 'HTTPJSESSIONID', 36, false) );

  }

 function cookieShouldBeValid() {
     user.login('bill','bill');
     cookie['userFullName'] = user.getName();
     debug(cookie);
     assert( validator.isValidInput('name',cookie.userFullName, 'HTTPCookieValue', 36, false) );

  }



 function setUp(){
  user = createObject('component','cfobjective.code.exampleapp.lesssecure.User').init();
  validator = createObject('component','cfobjective.code.esapilite.org.owasp.esapi.Validator').init();
  validator.setResourceDirectory( expandpath('/cfobjective/code/esapilite/tests/fixture/resources/.esapi') );
 }


  function tearDown(){

  }


</cfscript>
</cfcomponent>