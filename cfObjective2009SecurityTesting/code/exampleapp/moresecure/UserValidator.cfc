<cfcomponent extends="cfobjective.code.esapilite.org.owasp.esapi.Validator">
<!-------------------------------------------------------------------------------------------------------
 http://owasp-esapi-java.googlecode.com/svn/trunk_doc/org/owasp/esapi/reference/DefaultValidator.html

isValidInput( String context,
              String input,
              String type,
              int maxLength,
              boolean allowNull)


Returns true if data received from browser is valid. Only URL encoding is
     supported. Double encoding is treated as an attack.

    Specified by:
        isValidInput in interface Validator

    Parameters:
        context - A descriptive name for the field to validate. This is used for error facing validation messages and element identification.
        input - The actual user input data to validate.
        type - The regular expression name while maps to the actual regular expression from "ESAPI.properties".
        maxLength - The maximum post-canonicalized String length allowed.
        allowNull - If allowNull is true then a input that is NULL or an empty string will be legal. If allowNull is false then NULL or an empty String will throw a ValidationException.


 -------------------------------------------------------------------------------------------------------->
<cfscript>
 loader = createObject('component' , 'cfobjective.code.esapilite.org.owasp.esapi.ClassLoader').init();
 authenticator = loader.create('org.owasp.esapi.ESAPI').authenticator();


  function init(){
    return this;
  }

/*--------------------------------------------------------------------
      The below methods perform "syntactical" validation.
--------------------------------------------------------------------*/
  function isValidUserName(username){
     return isValidInput('user.username',username,'^[a-zA-Z]{6,10}$', 10, true);
  }

  function isValidEmail(email){
     return isValidInput('user.email',email,'Email', 128, true);
  }




  // might be better to do this ...
  // authenticator.verifyPasswordStrength(tempGen,password);
  // where tempGen would be generated on demand
  function isValidPassword(password){
  	//Note that this does NOT, as implied test for the length of the entire string.
  	//var pattern = '^((?=.*[a-zA-Z])(?=.*[0-9])(?=.*[\$\@\##\%\^\&\*\(\)\_\-\+\=\{\}\[\]\!\?\.\/\,\<\>])){8,8}';
  	//if( len(password) gt 8 OR !refind(pattern,password) ){
  	  //For some reasone the ESAPI regex engine does not like the above syntax
  	  //return isValidInput('user.password', password, pattern, 8, false);
  	//}
  	//return true;
  	 
	 temp = authenticator.generateStrongPassword();
	 authenticator.verifyPasswordStrength(temp,password);
	 return true;
  }




  function isValidName(name){
     return isValidInput('user.name',name,'[a-zA-Z\ ]{4,128}', 128, true);
  }


/*--------------------------------------------------------------------
      This method performs example "semantic" validation.
--------------------------------------------------------------------*/
  function isValidUser(user){
    var valid = isValidUserName( user.getUsername() ) &&
    			isValidEmail( user.getEmail() ) &&
    			isValidName( user.getName() );
    return valid;

  }



</cfscript>


</cfcomponent>