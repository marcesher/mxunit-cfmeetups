<cfcomponent extends="cfobjective.esapilite.org.owasp.esapi.Validator">
<cfscript>

  function init(){
    return this;
  }


  function isValidUserName(username){
     return isValidInput('user.username',username,'^[a-zA-Z]{6,10}', 10, true);
  }

  function isValidEmail(email){
     return isValidInput('user.email',email,'Email', 128, true);
  }

</cfscript>

<!---
  <cfargument name="context" type="string" required="true" hint="" />
   <cfargument name="input" type="string" required="true" hint="" />
   <cfargument name="type" type="string" required="true" hint="" />
   <cfargument name="maxlength" type="numeric" required="true" hint="" />
   <cfargument name="allowNulls" type="boolean" required="true" hint="" />
 --->
</cfcomponent>