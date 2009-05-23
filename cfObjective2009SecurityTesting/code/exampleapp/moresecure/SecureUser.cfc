<cfcomponent output="false">
<!---
   This is a typical User entity type object, and is not
   particularly "secure". It does not perform any form of validation,
   and it sets the object reference
 --->
<cfscript>
	local.user = {};
	local.user.name = '';
	local.user.username = '';
	local.user.id = '';
	local.user.pwd = '';
	local.user.email = '';

	userValidator = createObject('component','UserValidator');
	arm = createObject('component','cfobjective.code.esapilite.org.owasp.esapi.AccessReferenceMap');
	userReference = '';

  function getName(){
	return local.user.name ;
  }

  function getUsername(){
   return local.user.username;
  }

  function getId(){
	return local.user.id ;
  }

  function getPwd(){
	return local.user.pwd ;
  }

  function getEmail(){
	return local.user.email ;
  }

  function setName(name){
	local.user.name = name ;
  }

  function setUsername(username){
    local.user.username = username;
  }

  function setId(id){
	local.user.id = id ;
  }

  function setPwd(pwd){
	local.user.pwd = pwd ;
  }

  function setEmail(email){
	local.user.email = email ;
  }


initUsers();
</cfscript>

<cffunction name="init">
 <cfreturn this />
</cffunction>



<cffunction name="login" returntype="void" hint="Still some problems, but better.">
  <cfargument name="username">
  <cfargument name="pwd">
  <cfset var q = getUserFromDb(username,pwd) />
  <cfif q.recordCount eq 0>
    <cfthrow type="InvalidCredentialsException" message="An invalid username and/or password was provided" />
  </cfif>
  <cfscript>
   setName(q.name );
   setUsername(q.username);
   setEmail(q.email);
   setId(q.id);
  </cfscript>
  <!--- This is the Trust Boundary --->
  <cfif validate()>
   <cfset setUserSession() />
  <cfelse>
     <cfthrow type="InvalidUserObjectException" message="The user data is not valid." />
  </cfif>

</cffunction>



<cffunction name="_throw">
 <cfthrow type="invaliduser" message="Invalid User">
</cffunction>

<cffunction name="setUserSession" access="private">
  <cfset session.arm = arm />
  <cfset userReference = session.arm.addDirectReference(this) />
  <cfset session.uref = userReference />
</cffunction>

<cffunction name="getUserSession" access="public">
  <cfargument name="ref" type="string" />
  <cfset var userRefObject = session.arm.getDirectReference(arguments.ref) />
  <cfreturn userRefObject />
</cffunction>

<cffunction name="validate" access="public">
  <cfreturn userValidator.isValidUser(this) />
</cffunction>




<!--------------------------------------------------------------------
   Mocking a database of Users
 -------------------------------------------------------------------->
<cffunction name="getUserFromDb" access="private">
  <cfargument name="username">
  <cfargument name="pwd">
  <cfquery name="q" dbtype="query" maxrows="1">
   select *
   from users
   where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#"> and
         password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pwd#">
  </cfquery>
  <cfreturn q />
</cffunction>

<cffunction name="logout">
  <cfset structClear(session) />
</cffunction>



<!--------------------------------------------------------------------
  The below is example data used to support login. Typically this
  would be in some db, but it's here for simplicity.
 -------------------------------------------------------------------->
<cffunction name="initUsers">
<cf_querysim>
users
id,name,email,username,password
1|Kwai Change Caine|grasshopper@kungfu.fu|grassphopper|h0tp0t
2|Master Po|oldblinddude@kungfu.fu|pome|iCanseeU
3|Bruce Lee|bruce@kungfu.fu|bruce|badass
4|bill shelton|bill@kungfu.fu|billys|$billY8
</cf_querysim>
</cffunction>
</cfcomponent>