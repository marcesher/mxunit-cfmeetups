<cfcomponent displayname="org.owasp.esapia.Encoder" output="false" hint="Wrapper for ESAPI DefaultEncoder">

  <cfscript>
	//Ideally, the below should be class level members. Try to
	//instantiate only once, maybe in ESAPI.cfc
    loader = createObject('component' , 'ClassLoader').init();
    encoder = loader.create('org.owasp.esapi.ESAPI').encoder();
  </cfscript>


	<cffunction name="init" access="public" returntype="Encoder" output="false">
		<cfreturn this />
	</cffunction>


<!--------------------------------------------------------------------
                      Main encoding methods.
 -------------------------------------------------------------------->
  <cffunction name="canonicalize" returntype="String" hint="Returns the cannonicalized input">
    <cfargument name="input" type="String" />
    <cfargument name="strict" type="boolean" required="false" default="true" />
     <cfset ret = chr(0) />
    <cftry>
      <cfset ret = encoder.canonicalize(arguments.input, arguments.strict) />
    <cfcatch type="any">
      <cfthrow type="#cfcatch.Type#"
               message="#cfcatch.Message#"
               detail="#cfcatch.Detail#"
               errorcode="#cfcatch.ErrorCode#"
               extendedinfo="#cfcatch.ExtendedInfo#" />
    </cfcatch>
    </cftry>

    <cfreturn ret />
  </cffunction>


  <cffunction name="encodeForHTML" returntype="String" hint="Returns the HTML encoded input">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForHTML(arguments.input) />
    <cfreturn ret />
  </cffunction>

   <cffunction name="encodeForJavaScript" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForJavaScript(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForCSS" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForCSS(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForHtmlAttribute" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForHtmlAttribute(arguments.input) />
    <cfreturn ret />
  </cffunction>

   <cffunction name="encodeForURL" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForURL(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="decodeFromURL" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.decodeFromURL(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForXML" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForXML(arguments.input) />
    <cfreturn ret />
  </cffunction>


 <cffunction name="encodeForXMLAttribute" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForXMLAttribute(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForSQL" returntype="String" hint="">
    <cfargument name="codec" type="any"  />
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForSQL(arguments.codec, arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForVBScript" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForVBScript(arguments.input) />
    <cfreturn ret />
  </cffunction>


  <cffunction name="encodeForXPath" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForXPath(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForLDAP" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForLDAP(arguments.input) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="encodeForDN" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.encodeForDN(arguments.input) />
    <cfreturn ret />
  </cffunction>


  <cffunction name="encodeForBase64" returntype="String" hint="">
    <cfargument name="bytes" type="binary"  />
    <cfargument name="wrap" type="boolean" />
    <cfset var ret = encoder.encodeForBase64(arguments.bytes, arguments.wrap) />
    <cfreturn ret />
  </cffunction>

  <cffunction name="decodeFromBase64"  returntype="Binary" hint="">
    <cfargument name="input" type="String" />
    <cfset var ret = encoder.decodeFromBase64(arguments.input) />
    <cfreturn ret />
  </cffunction>

   <cffunction name="normalize" returntype="String" hint="">
    <cfargument name="input" type="String" />
    <!--- <cfthrow type="NotImplementedException" message="This method is not yet implemented.">--->
    <cfset var ret = encoder.normalize(arguments.input) />
    <cfreturn ret />
  </cffunction>

</cfcomponent>