<cfcomponent output="false" extends="mxunit.framework.TestCase">

<cffunction name="setUp" >
 <cfquery name="users" datasource="unittest">
  select * from users 
</cfquery>

<cfquery name="permissions" datasource="unittest">
  select * from permissions 
</cfquery>


<cfquery name="J_Users_Permissions" datasource="unittest">
  select * from J_Users_Permissions 
</cfquery>
</cffunction>

<cfscript>
  
 function testGetUsers(){
   debug(users);
   assertEquals(2,users.recordCount);  
 }
 
  function testPermissions(){
   debug(permissions);
   assertEquals(6,permissions.recordCount);  
 }
  
  function testJ_Users_Permissions(){
   debug(J_Users_Permissions);
   assertEquals(4,J_Users_Permissions.recordCount);  
 }  
    
</cfscript>


</cfcomponent>