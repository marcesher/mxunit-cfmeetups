<cfcomponent output="false" extends="mxunit.framework.TestCase">

<cffunction name="kickShitOutOfUsername">
 <cfoutput query="xssVectors">
   <cfset debug('Checking against #attack#') />
  <cfif userValidator.isValidUserName(attack) >
    <cfthrow type="mxunit.exception.AssertionFailedError"
              message="Invalid input slipped by"
              detail="Failure at row #xssvectors.currentrow# for #xssvectors.attack#">
  </cfif>
 </cfoutput>
</cffunction>

<cffunction name="kickShitOutOfPassword">
 <cfoutput query="xssVectors">
   <cfset debug('Checking against #attack#') />
  <cfif userValidator.isValidEmail(attack) >
    <cfthrow type="mxunit.exception.AssertionFailedError"
              message="Invalid input slipped by"
              detail="Failure at row #xssvectors.currentrow# for #xssvectors.attack#">
  </cfif>
 </cfoutput>
</cffunction>



<cfscript>

 function sanityCheck() {
     debug(userValidator);
     assertIsTypeOf(userValidator,'cfobjective.code.exampleapp.UserValidator');
  }


  function isValidUsername() {
     assert(userValidator.isValidUserName(name) );
  }


  function isValidEmail() {
     assert(userValidator.isValidEmail(email) );
  }
  
 
 function isValidPassword() {
     assert( userValidator.isValidPassword('123asdD?') );
     assert( userValidator.isValidPassword('$%KLJj1') );
     assert( userValidator.isValidPassword('+_)lR(9)') );
 }
 
 function isValidName() {
     assert( userValidator.isValidName('bill shelton') );
     assert( userValidator.isValidName('Kwai Chang Caine') );
     assert( userValidator.isValidName('Master Po') );
 }


  function setUp(){
   userValidator = createObject('component','cfobjective.code.exampleapp.UserValidator').init();

   id = 123;
   name = 'Wolverine';
   email = 'radmutant@xmen.fu';
   userName = 'wolverine';
   pwd = 'b@rK';

   user = createObject('component','cfobjective.code.exampleapp.SecureUser').init();
   user.setId(id);
   user.setName(name);
   user.setEmail(email);
   user.setUserName(userName);
   user.setPwd(pwd);

   xssVectors = createObject('component','cfobjective.code.vectors.FuzzyVectors').getXSSVectors();

  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>