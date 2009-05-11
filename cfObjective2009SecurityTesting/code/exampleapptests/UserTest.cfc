<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>

//HTTPJSESSIONID
  function testLogin() {
     user.login('bill','bill');
     debug(session);
     assertEquals( 'bill@kungfu.fu',session.email );
  }


  function testLogout() {
     user.logout();
     debug(session);
  }



  function setUp(){
    user = createObject('component','cfobjective.code.exampleapp.lesssecure.User').init();
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>