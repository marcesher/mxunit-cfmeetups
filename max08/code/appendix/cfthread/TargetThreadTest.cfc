<!---  
 This is an example of testing asynchronous thread calls specifying a callback 
 to the thread. When the thread completes, it invokes the callback. This is 
 implemented as a Listener object. It is also possible to just pass in a 
 method reference. Either way, creates tighter coupling, but this is 
 probably a good idea when it comes to monitoring asynchronous threads.
--->

<cfcomponent output="false" extends="mxunit.framework.TestCase" >
 
  
  <cfscript>
   
   function setUp(){
   	 listener = createObject("component","ThreadListener");
     mythread = createObject("component","TargetThread");
   }
   
  </cfscript>
  
  
  <!--- 
   If the intended usage of TargetThread was something else, this
   essentially just tests that the communication between TargetThread
   and ThreadListener works. In practice, you may also want to mock
   the Listener.  
   --->
  <cffunction name="testSynchronousThreadedCallBackNoThreads">
      <cfset var threadId = "synchronousTest" />
      <cfset var message = "I'm waiting ..." />
      <cfset mythread.gogoGopher(threadId, message, listener) />
      <cfset debug(listener.getMessageStack()) />
      <cfset assertEquals("I'm waiting ...",listener.getMessage(threadId))>
  </cffunction>
  
  
  <cffunction name="testThreadedCallBacks">
    <cfset var threadTimeOut = 5000 />

    <!--- Call threads in setUp  --->
    <cfthread action="run" name="t1">
      <cfset mythread.gogoGopher("t1","I am thread t1",listener) />
    </cfthread>
    
    <cfthread action="run" name="t2">
      <cfset mythread.gogoGopher("t2","I am thread t2",listener) />
    </cfthread>
    
    <cfthread action="run" name="t3">
      <cfset mythread.gogoGopher("t3","I am thread t3",listener) />
    </cfthread>
    
    <cfthread action="run" name="t4">
      <cfset mythread.gogoGopher("t4","I am thread t4",listener) />
    </cfthread>

    <!--- Nice CF feature: these threads should all complete within 5 seconds --->
    <cfthread action="join" name="t1,t2,t3,t4" timeout="#threadTimeOut#" /> 
    <cfset debug(cfthread)>
    <!--- 
      Using the cfthred action=join, we can now test the state of each thread 
      No need to poll this.callBackFlag, which doesn't seem to work anyway ... scope?,
      but we can verity output in the callback method. This output can be arbitrary.
    --->
	 <cfloop collection="#cfthread#" item="thread">
	   <cfset debug(cfthread[thread]) />
       <cfset assertEquals("COMPLETED",cfthread[thread].status, "#thread# did not complete as expected or return within 5000 ms") >
       <cfset assertEquals("I am thread #thread#", listener.getMessage(thread), "#thread# did not execute callBack or return within 5000 ms") > 
     </cfloop> 

  </cffunction>

  
</cfcomponent>