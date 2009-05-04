<cfcomponent output="false" extends="BaseTest">

<cfscript>


function $testRegexGetValidInput(){
//public String getValidInput(String context, String input, String type, int maxLength, boolean allowNull)
 var actual = validator.getValidInput('foo', 123, '[0-9]{3,3}', 3, false) ;
  assertEquals( 123,actual );

  actual = validator.getValidInput('zxc','wolverine','[a-zA-Z]{6,10}', 10, false);

}

function $testRegexIsValidInput(){
//public String getValidInput(String context, String input, String type, int maxLength, boolean allowNull)
 var actual = validator.isValidInput('foo', 'asd123', '[0-9a-z]{3,6}', 6, false) ;
  assert( actual , 'actual should be true' );

}


function testGetValidInput(){
//public String getValidInput(String context, String input, String type, int maxLength, boolean allowNull)
 var actual = validator.getValidInput('cc', getItem('goodcc1'), 'CreditCard', 19, false) ;

}

function dumpTestData(){
 debug( testData() );
}

function getTestDataItem(){
 var actual = getItem('goodcc1') ;
 debug( actual );
 assertEquals('1234 9876 0000 0008' , actual);
}

  function isValidCreditCard(){
    assertTrue(validator.isValidCreditCard("test",  getItem('goodcc1'), false));
    assertTrue(validator.isValidCreditCard("test",  getItem('goodcc2'), false));
    assertFalse(validator.isValidCreditCard("test", getItem('badcc1'), false));
    assertFalse(validator.isValidCreditCard("test", getItem('badcc2'), false));
  }

  function getValidCreditCard(){
    var actual = validator.getValidCreditCard("test", getItem('goodcc1'), false);
    assertEquals( getItem('goodcc1'),actual );

    actual = validator.getValidCreditCard("test", getItem('goodcc2'), false);
    assertEquals( getItem('goodcc2'),actual );

    try{
    actual = validator.getValidCreditCard("test", getItem('badcc1'), false);
    fail('should not get here');
    }
    catch(any e){}

   try{
    actual = validator.getValidCreditCard("test", getItem('badcc2'), false);
    fail('should not get here');
    }
    catch(any e){}

  }


 function isValidSSN(){
  actual = validator.isValidInput('ssn','287-58-4529','SSN', 11, false);
  assert(actual);
 }

 function isValidEmail(){
  actual = validator.isValidInput("test", "jeff.williams@aspectsecurity.com", "Email", 100, false);
  assert(actual);
 }


  function vallidatorInitShouldReturnItself() {
    assertSame(validator,validator);
    assertIsTypeOf(validator,'WEB-INF.cftags.component');
  }



  function validatorShouldAllowLowerCaseSSN(){
   var ssn = getItem('goodssn1');
   validInput = validator.getValidInput( 'ssn', ssn, 'SSN', 11, false);
   assertEquals( ssn, validInput );
  }

  function validatorShouldFailOnBadSSN(){
    var ssn = getItem('badssn1');
    try{
      validInput = validator.getValidInput( 'ssn', ssn, 'SSN', 11, false);
      fail('failed on #ssn#');
    }
    catch(org.owasp.esapi.errors.ValidationException e){}
  }



  function setUp(){
  	validator = createObject('component', 'cfobjective.code.esapilite.org.owasp.esapi.Validator').init();

  }

  function tearDown(){

  }



/***************   To Do: Other methods available but not yet implemented:


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

*/

</cfscript>

</cfcomponent>