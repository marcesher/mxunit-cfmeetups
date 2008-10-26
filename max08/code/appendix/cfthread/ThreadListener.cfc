<!---
  Simple Listener to be passed to an asynchronous thread to 
  accept messages from that thread.
 --->

<cfcomponent output="false">

 <cfset this.messageStack = structNew()>

  <cffunction name="addMessage" access="public">
    <cfargument name="threadId">
    <cfargument name="message">
    <cfset structInsert(this.messageStack,arguments.threadId,arguments.message)>
  </cffunction>
  
  <cffunction name="getMessageStack">
    <cfreturn this.messageStack />  
  </cffunction>
  
  <cffunction name="getMessage">
    <cfargument name="threadId" />
    <cfreturn structFind(this.messageStack,arguments.threadId) />  
  </cffunction>

</cfcomponent>