<cfcomponent displayname="Validator" output="false">

  <cfscript>
	//Ideally, the below should be class level members. Try to
	//instantiate only once, maybe in ESAPI.cfc
    loader = createObject('component' , 'ClassLoader').init();
    validator = loader.create('org.owasp.esapi.ESAPI').validator();
    
    
    
    //Move to SecurityConfiguration?
    function setResourceDirectory(dir){
       config = loader.create('org.owasp.esapi.ESAPI').securityConfiguration();
       config.setResourceDirectory( dir );
    }
    
  </cfscript>


	<cffunction name="init" access="public" returntype="Validator" output="false">
		<cfreturn this />
	</cffunction>


<!--------------------------------------------------------------------
             main validation methods.
 -------------------------------------------------------------------->

 <cffunction name="isValidInput" access="public">
   <cfargument name="context" type="string" required="true" hint="" />
   <cfargument name="input" type="string" required="true" hint="" />
   <cfargument name="type" type="string" required="true" hint="" />
   <cfargument name="maxlength" type="numeric" required="true" hint="" />
   <cfargument name="allowNulls" type="boolean" required="true" hint="" />
   <cftry>
    <cfset getValidInput(context, input, type, javacast('int',maxlength), allowNulls) />
    <cfreturn true />
    <cfcatch type="any">
      <cfreturn false />
    </cfcatch>
   </cftry>
 </cffunction>


  <cffunction name="getValidInput" access="public" output="true">
	<cfargument name="context" type="string" required="true" hint="The name of the input." />
    <cfargument name="input" type="string" required="true" hint="The value of the input." />
    <cfargument name="type" type="string" required="true" hint="The type to be used for validation." />
    <cfargument name="maxlength" type="numeric" required="true" hint="The maximum length it should be." />
    <cfargument name="allowNulls" type="boolean" required="true" hint="Flag to indicate whether or not to allow nulls." />
    <cfset var ret = '' />
    <cftry>
      <cfif input eq chr(0) and allowNulls>
        <cfset input = createObject('java','java.lang.Byte') />
      </cfif>
      <cfset ret = validator.getValidInput(context, input, type, javacast('int',maxlength), allowNulls) />
      <cfif isDefined('ret')>
        <cfreturn  ret  />
      <cfelse>
        <cfreturn '' />
      </cfif>
    <cfcatch type="any"><!--- CF doesn't appear to catch Java exceptions, so type:any has to be used :-( --->
      <cfthrow type="#cfcatch.Type#"
               message="#cfcatch.Message#"
               detail="#cfcatch.Detail#"
               errorcode="#cfcatch.ErrorCode#"
               extendedinfo="#cfcatch.ExtendedInfo#" />
    </cfcatch>
    </cftry>

  </cffunction>


  <cffunction name="isValidSafeHTML" access="public" returntype="boolean">
    <cfargument name="context" type="string" required="true" hint="" />
    <cfargument name="input" type="string" required="true" hint="" />
    <cfargument name="maxlength" type="numeric" required="true" hint="The maximum length it should be." />
    <cfargument name="allowNulls" type="boolean" required="true" hint="" />
    <cfset var ret = '' />
    <cftry>
      <cfset ret = validator.isValidSafeHTML(context, input, javacast('int',maxlength), allowNulls) />
    <cfreturn ret />
    <cfcatch type="any"><!--- CF doesn't appear to catch Java exceptions, so type:any has to be used :-( --->
      <cfthrow type="#cfcatch.Type#"
               message="#cfcatch.Message#"
               detail="#cfcatch.Detail#"
               errorcode="#cfcatch.ErrorCode#"
               extendedinfo="#cfcatch.ExtendedInfo#" />
    </cfcatch>
    </cftry>
  </cffunction>


 <cffunction name="isValidCreditCard" access="public">
   <cfargument name="context" type="string" required="true" hint="" />
   <cfargument name="input" type="string" required="true" hint="" />
   <cfargument name="allowNulls" type="boolean" required="true" hint="" />
   <cfreturn validator.isValidCreditCard(context,input,allowNulls) />
 </cffunction>

  <cffunction name="getValidCreditCard" access="public">
   <cfargument name="context" type="string" required="true" hint="" />
   <cfargument name="input" type="string" required="true" hint="" />
   <cfargument name="allowNulls" type="boolean" required="true" hint="" />
   <cfreturn validator.getValidCreditCard(context,input,allowNulls) />
 </cffunction>
<!---
Include all of the following:

assertIsValidHTTPRequest()  	void
assertIsValidHTTPRequestParameterSet(java.lang.String, java.util.Set, java.util.Set) 	void
assertIsValidHTTPRequestParameterSet(java.lang.String, java.util.Set, java.util.Set, org.owasp.esapi.ValidationErrorList) 	void
assertValidFileUpload(java.lang.String, java.lang.String, java.lang.String, byte[], int, boolean) 	void
assertValidFileUpload(java.lang.String, java.lang.String, java.lang.String, byte[], int, boolean, org.owasp.esapi.ValidationErrorList) 	void
getValidCreditCard(java.lang.String, java.lang.String, boolean) 	java.lang.String
getValidCreditCard(java.lang.String, java.lang.String, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidDate(java.lang.String, java.lang.String, java.text.DateFormat, boolean) 	java.util.Date
getValidDate(java.lang.String, java.lang.String, java.text.DateFormat, boolean, org.owasp.esapi.ValidationErrorList) 	java.util.Date
getValidDirectoryPath(java.lang.String, java.lang.String, boolean) 	java.lang.String
getValidDirectoryPath(java.lang.String, java.lang.String, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidDouble(java.lang.String, java.lang.String, double, double, boolean) 	java.lang.Double
getValidDouble(java.lang.String, java.lang.String, double, double, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.Double
getValidFileContent(java.lang.String, byte[], int, boolean) 	byte[]
getValidFileContent(java.lang.String, byte[], int, boolean, org.owasp.esapi.ValidationErrorList) 	byte[]
getValidFileName(java.lang.String, java.lang.String, boolean) 	java.lang.String
getValidFileName(java.lang.String, java.lang.String, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidInput(java.lang.String, java.lang.String, java.lang.String, int, boolean) 	java.lang.String
getValidInput(java.lang.String, java.lang.String, java.lang.String, int, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidInteger(java.lang.String, java.lang.String, int, int, boolean) 	java.lang.Integer
getValidInteger(java.lang.String, java.lang.String, int, int, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.Integer
getValidListItem(java.lang.String, java.lang.String, java.util.List) 	java.lang.String
getValidListItem(java.lang.String, java.lang.String, java.util.List, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidNumber(java.lang.String, java.lang.String, long, long, boolean) 	java.lang.Double
getValidNumber(java.lang.String, java.lang.String, long, long, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.Double
getValidPrintable(java.lang.String, byte[], int, boolean) 	byte[]
getValidPrintable(java.lang.String, byte[], int, boolean, org.owasp.esapi.ValidationErrorList) 	byte[]
getValidPrintable(java.lang.String, java.lang.String, int, boolean) 	java.lang.String
getValidPrintable(java.lang.String, java.lang.String, int, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidRedirectLocation(java.lang.String, java.lang.String, boolean) 	java.lang.String
getValidRedirectLocation(java.lang.String, java.lang.String, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
getValidSafeHTML(java.lang.String, java.lang.String, int, boolean) 	java.lang.String
getValidSafeHTML(java.lang.String, java.lang.String, int, boolean, org.owasp.esapi.ValidationErrorList) 	java.lang.String
isValidCreditCard(java.lang.String, java.lang.String, boolean) 	boolean
isValidDate(java.lang.String, java.lang.String, java.text.DateFormat, boolean) 	boolean
isValidDirectoryPath(java.lang.String, java.lang.String, boolean) 	boolean
isValidDouble(java.lang.String, java.lang.String, double, double, boolean) 	boolean
isValidFileContent(java.lang.String, byte[], int, boolean) 	boolean
isValidFileName(java.lang.String, java.lang.String, boolean) 	boolean
isValidFileUpload(java.lang.String, java.lang.String, java.lang.String, byte[], int, boolean) 	boolean
isValidHTTPRequest() 	boolean
isValidHTTPRequest(javax.servlet.http.HttpServletRequest) 	boolean
isValidHTTPRequestParameterSet(java.lang.String, java.util.Set, java.util.Set) 	boolean
isValidInput(java.lang.String, java.lang.String, java.lang.String, int, boolean) 	boolean
isValidInteger(java.lang.String, java.lang.String, int, int, boolean) 	boolean
isValidListItem(java.lang.String, java.lang.String, java.util.List) 	boolean
isValidNumber(java.lang.String, java.lang.String, long, long, boolean) 	boolean
isValidPrintable(java.lang.String, byte[], int, boolean) 	boolean
isValidPrintable(java.lang.String, java.lang.String, int, boolean) 	boolean
isValidRedirectLocation(java.lang.String, java.lang.String, boolean) 	boolean
isValidSafeHTML(java.lang.String, java.lang.String, int, boolean) 	boolean
safeReadLine(java.io.InputStream, int)

 --->

</cfcomponent>