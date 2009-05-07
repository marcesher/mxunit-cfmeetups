<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


  function sanityCheck() {
     assertIsTypeOf( user , 'cfobjective.code.exampleapp.moresecure.SecureUser' );
     assert(name==user.getName());
     assert(email==user.getEmail());
     assert(username==user.getUsername());
     assert(pwd==user.getPwd());
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