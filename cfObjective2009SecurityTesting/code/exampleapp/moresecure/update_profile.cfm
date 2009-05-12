
<cfset validateInput() />


<cfdump label="Form Scope" var="#form#">
<cfdump label="URL Scope" var="#URL#">
<cfdump label="Cookie Scope" var="#cookie#">
<cfdump label="Session   Scope" var="#session#">


<cffunction name="validateInput" returntype="void">
  <cfset userValidator = createObject('component','cfobjective.code.exampleapp.moresecure.UserValidator') />
  <cfif !userValidator.isValidName(form.name) ||
        !userValidator.isValidEmail(form.email) ||
        !userValidator.isValidPassword(form.newpwd)>
    <div id="invalid">Invalid input.</div>
    <cfabort>
  </cfif>
</cffunction>




