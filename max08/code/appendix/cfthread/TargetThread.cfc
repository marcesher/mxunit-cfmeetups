<cfcomponent name="TargetThread">


	<cffunction name="gogoGopher" access="public" output="true" returntype="Any">
		<cfargument name="threadId" type="string" />
        <cfargument name="message" type="string" />
		<cfargument name="listener" type="any" required="false" />
        
        <!--- Allow for injection --->
        <cfif structKeyExists(arguments, "listener")>
          <cfset this.listener = arguments.listener />
        </cfif>
        <!--- Mimicing arbitrary time to do something.
              Would, in practice, be something like invoking a
              gateway event, consuming a web service; e.g. RSS/ATOM feed.
              
              Using sleep is for demo purposes and will be more consistent
              when presenting.
        --->
        <cftry>
          <cfset sleep(300) />
          <!--- Passing back the message to the listener. --->
          <cfset this.listener.addMessage(threadId,message) />
        <cfcatch type="any">
          <!--- Passing back the exception details to the listener. --->
          <cfset this.listener.addMessage(threadId, cfcatch.Detail) />
          <!--- Make sure this exception gets logger --->
          <cfrethrow>
        </cfcatch>
        </cftry>
		
	</cffunction>
    

    
   <!--- Injection Door ---> 
   <cffunction name="setListener">
      <cfargument name="listener" />
      <cfset this.listener = listener />
   </cffunction>
    
</cfcomponent>