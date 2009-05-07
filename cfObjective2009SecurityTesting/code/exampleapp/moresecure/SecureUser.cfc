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


	//
initUsers();
</cfscript>

<cffunction name="init">
 <cfreturn this />
</cffunction>



<cffunction name="login">
  <cfargument name="username">
  <cfargument name="pwd">
  <cfquery name="q" dbtype="query" maxrows="1">
   select *
   from users
   where username = '#arguments.username#' and
         password = '#arguments.pwd#'
  </cfquery>
  <cfscript>
   local.user.name = q.name;
   local.user.username = q.username;
   local.user.email = q.email;
   local.user.id = q.id;
   local.user.pwd = q.password;
   session.user = local.user;
  </cfscript>
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
4|bill shelton|bill@kungfu.fu|bill|bill
</cf_querysim>
</cffunction>
</cfcomponent>