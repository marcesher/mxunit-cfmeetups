<cfcomponent output="false">
<!---
   This is a User entity type object, and is not
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
  initUsers();
</cfscript>

<cffunction name="init">
 <cfreturn this />
</cffunction>



<cffunction name="login" hint="Plenty of problems here!">
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

   //Shoot me, please, if you ever see me doing this.
   session.userName = local.user.username;
   session.personName = local.user.name;
   session.email = local.user.email;
   session.userId = local.user.id;
   session.userPassword = local.user.pwd;
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