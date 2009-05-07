<cfcomponent output="false" extends="mxunit.framework.TestCase">


<cfscript>

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

   userValidator = createObject('component','cfobjective.code.exampleapp.moresecure.UserValidator').init();
   generator = createObject('component','cfobjective.code.vectors.Generator');
   xssVectors = createObject('component','cfobjective.code.vectors.FuzzyVectors').getXSSVectors();
   encoder = createObject('component','cfobjective.code.esapilite.org.owasp.esapi.Encoder').init();


  }

 function sanityCheck() {
     debug(userValidator);
     assertIsTypeOf(userValidator,'cfobjective.code.exampleapp.moresecure.UserValidator');
  }


  function isValidUsernameSyntax() {
     assert(userValidator.isValidUserName(name) );
  }


  function isValidEmailSyntax() {
     assert(userValidator.isValidEmail(email) );
  }


 function isValidPasswordSyntax() {
     assert( userValidator.isValidPassword('asaDsd1$') );
     assert( userValidator.isValidPassword('13asdDa?') );
     assert( userValidator.isValidPassword('q$KLJj1}') );
     assert( userValidator.isValidPassword('3+_lR9s?') );
     //assert( userValidator.isValidPassword('asdfghjk') );
 }

 function isValidNameSyntax() {
     assert( userValidator.isValidName('bill shelton') );
     assert( userValidator.isValidName('Kwai Chang Caine') );
     assert( userValidator.isValidName('Master Po') );
 }

 function isValidUser(){
   assert( userValidator.isValidUser(user) );
 }



function altPasswordChecker(){
 loader = createObject('component' , 'cfobjective.code.esapilite.org.owasp.esapi.ClassLoader').init();
 authenticator = loader.create('org.owasp.esapi.ESAPI').authenticator();
 pwd1 = authenticator.generateStrongPassword();
 pwd2 = authenticator.generateStrongPassword();
 debug(pwd1);
 debug(pwd2);
 authenticator.verifyPasswordStrength(pwd1,pwd2);

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