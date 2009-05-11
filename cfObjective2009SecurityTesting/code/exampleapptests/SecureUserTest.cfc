<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>

  function validateUser(){
    assert( user.validate() );
  }

  function loginUser(){
    user = createObject('component','cfobjective.code.exampleapp.moresecure.SecureUser').init();
    user.login( 'billys','$billY8' );    
    debug(session);
    sameUser = session.arm.getDirectReference( session.uref );
    debug(sameUser.getName());
    debug(user.getName());
    assertEquals( user.getName(), sameUser.getName() );
    assertSame( user, sameUser );
   }

  function sanityCheck() {
     assertIsTypeOf( user , 'cfobjective.code.exampleapp.moresecure.SecureUser' );
     assert(name==user.getName());
     assert(email==user.getEmail());
     assert(username==user.getUsername());
     assert(pwd==user.getPwd());
  }
 
  
  function getUsersFromDbSmokeTest(){
   makePublic(user,"getUserFromDb","_getUserFromDb");
   u = user._getUserFromDb('billys','$billY8'); 
   debug(u);
   assertEquals( 'bill@kungfu.fu', u.email );
  }


 


  function setUp(){
   id = 123;
   name = 'Wolverine';
   email = 'radmutant@xmen.fu';
   userName = 'wolverine';
   pwd = 'b@rK';

   user = createObject('component','cfobjective.code.exampleapp.moresecure.SecureUser').init();
   user.setId(id);
   user.setName(name);
   user.setEmail(email);
   user.setUserName(userName);
   user.setPwd(pwd);



  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>