<cfcomponent output="false" extends="mxunit.framework.TestCase">


<cfscript>

function setUp(){
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

   userValidator = createObject('component','cfobjective.code.exampleapp.UserValidator').init();
   generator = createObject('component','cfobjective.code.vectors.Generator');
   xssVectors = createObject('component','cfobjective.code.vectors.FuzzyVectors').getXSSVectors();
   encoder = createObject('component','cfobjective.code.esapilite.org.owasp.esapi.Encoder').init();


  }

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
     assert( userValidator.isValidPassword('asdasdas1$') );
     
     //assert( userValidator.isValidPassword('123asdDa?') );
    // assert( userValidator.isValidPassword('q$%KLJj1sd}') );
     //assert( userValidator.isValidPassword('3+_lR(9s?>') );
 }

 function isValidName() {
     assert( userValidator.isValidName('bill shelton') );
     assert( userValidator.isValidName('Kwai Chang Caine') );
     assert( userValidator.isValidName('Master Po') );
 }

 function isValidUser(){
   assert( userValidator.isValidUser(user) );
 }


 function regExTest(){
   s = 'q)wQ8H@8';
  
   //s = generator.genRandPassword();

   r = '^(?=.*[a-zA-Z])(?=.*[0-9]){8,16}';
   s = 'asQf12a4as@'; 
   s = '00AaK:>w'; 
   for(i=1;i<100;i++){
	   s = generator.genRandPassword();
	   debug(s);
	  // debug( refind(r,s) );
	   assert( refind(r,s) ) ;
   }
 }

 function kickCrapOutOfPwd(){
  for(i=1;i<100;i++){
    pwd = generator.genRandPassword();
    debug(pwd);
    assert( userValidator.isValidPassword(pwd) ,'failed on #pwd# on iteration ' & i );
  }
 }

</cfscript>

<cffunction name="kickShitOutOfUser">
 <cfoutput query="xssVectors">
  <cfscript>
   user.setId(attack);
   user.setName(attack);
   user.setEmail(attack);
   user.setUserName(attack);
   user.setPwd(attack);
  </cfscript>
  <cfif userValidator.isValidUser(user) >
     <cfset debug( attack )>
    <cfthrow type="mxunit.exception.AssertionFailedError"
              message="Invalid input slipped by"
              detail="Failure at row #xssvectors.currentrow# for #xssvectors.attack#">
  </cfif>
 </cfoutput>
</cffunction>


<cffunction name="kickShitOutOfUsername">
 <cfoutput query="xssVectors">
   <cfset debug('Checking against #attack#') />
  <cfif userValidator.isValidUserName(attack) >
    <cfset debug(attack)>
    <cfthrow type="mxunit.exception.AssertionFailedError"
              message="Invalid input slipped by"
              detail="Failure at row #xssvectors.currentrow# for #xssvectors.attack#">
  </cfif>
 </cfoutput>
</cffunction>

<cffunction name="kickShitOutOfPassword">
 <cfoutput query="xssVectors">
   <cfset debug('Checking against #attack#') />
  <cfif userValidator.isValidPassword(attack) >
    <cfthrow type="mxunit.exception.AssertionFailedError"
              message="Invalid input slipped by"
              detail="Failure at row #xssvectors.currentrow# for #xssvectors.attack#">
  </cfif>
 </cfoutput>
</cffunction>


</cfcomponent>