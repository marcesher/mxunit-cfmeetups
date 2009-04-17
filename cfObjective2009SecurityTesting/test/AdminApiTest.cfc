<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
  
  
  function admin(){
    debug(l);
    debug(adminObj);
   }
   
  function peekDebug(){
   db = createObject("component","cfide.adminapi.debugging");
   debug(db);
   debug(db.getIpList());
   assertEquals(2,listLen(db.getIpList()));
   assertEquals('127.0.0.1',listGetAt(db.getIpList(),1) );
  }  
  


 function peekRuntime(){
   rt = createObject("component","cfide.adminapi.runtime");
   debug(rt);
  
  }  
  
  function setUp(){
   adminObj = createObject("component","cfide.adminapi.administrator");
   l = adminObj.login('admin','admin');
   
  }
  
  function tearDown(){
  
  }    
    
    
</cfscript>
</cfcomponent>