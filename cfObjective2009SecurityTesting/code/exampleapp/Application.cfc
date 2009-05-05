<cfcomponent>
  <cfset this.Sessionmanagement=true>

<cfset This.name = "Example">
<cfset This.Sessionmanagement=true>
<cfset This.Sessiontimeout="#createtimespan(0,0,20,0)#">
<cfset This.applicationtimeout="#createtimespan(15,0,0,0)#">
<!---
<cffunction name="onApplicationStart">
 </cffunction>

<cffunction name="onApplicationEnd">
   <cfargument name="ApplicationScope" required=true/>
</cffunction>


<cffunction name="onRequestStart">

</cffunction>

<cffunction name="onRequest">
   <cfargument name = "targetPage" type="String" required=true/>

</cffunction>


<cffunction name="onRequestEnd">
   <cfargument type="String" name = "targetTemplate" required=true/>
</cffunction>


<cffunction name="onSessionStart">
</cffunction>

<cffunction name="onSessionEnd">
</cffunction>
 --->



</cfcomponent>
