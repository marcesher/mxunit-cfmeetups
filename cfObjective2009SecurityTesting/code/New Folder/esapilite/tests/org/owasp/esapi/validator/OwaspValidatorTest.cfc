<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
null = chr(0);

  function testNullIsEmptyStringInCF(){
   assert( null is '' );
  }

  function testIsValidCreditCard() {
        debug("isValidCreditCard");
        assertTrue(instance.isValidCreditCard("test", "1234 9876 0000 0008", false));
        assertTrue(instance.isValidCreditCard("test", "1234987600000008", false));
        assertFalse(instance.isValidCreditCard("test", "12349876000000081", false));
        assertFalse(instance.isValidCreditCard("test", "4417 1234 5678 9112", false));
    }

    function testIsValidInput() {
        debug("isValidInput");

        assertTrue(instance.isValidInput("test", "jeff.williams@aspectsecurity.com", "Email", 100, false));
        assertFalse(instance.isValidInput("test", "jeff.williams@@aspectsecurity.com", "Email", 100, false));
     
    
        assertFalse(instance.isValidInput("test", "jeff.williams@aspectsecurity", "Email", 100, false));
        assertTrue(instance.isValidInput("test", "123.168.100.234", "IPAddress", 100, false));
        assertTrue(instance.isValidInput("test", "192.168.1.234", "IPAddress", 100, false));
        assertFalse(instance.isValidInput("test", "..168.1.234", "IPAddress", 100, false));
        assertFalse(instance.isValidInput("test", "10.x.1.234", "IPAddress", 100, false));
        assertTrue(instance.isValidInput("test", "http://www.aspectsecurity.com", "URL", 100, false));
        assertFalse(instance.isValidInput("test", "http:///www.aspectsecurity.com", "URL", 100, false));
        assertFalse(instance.isValidInput("test", "http://www.aspect security.com", "URL", 100, false));
        assertTrue(instance.isValidInput("test", "078-05-1120", "SSN", 100, false));
        assertTrue(instance.isValidInput("test", "078 05 1120", "SSN", 100, false));
        assertTrue(instance.isValidInput("test", "078051120", "SSN", 100, false));
        assertFalse(instance.isValidInput("test", "987-65-4320", "SSN", 100, false));
        assertFalse(instance.isValidInput("test", "000-00-0000", "SSN", 100, false));
        assertFalse(instance.isValidInput("test", "(555) 555-5555", "SSN", 100, false));
        assertFalse(instance.isValidInput("test", "test", "SSN", 100, false));

     //  Problem passing nulls to java, but why would you want to validate null?
     //   assertTrue(instance.isValidInput("test", null, "Email", 100, true) , ' should accept null email');
     //   assertFalse(instance.isValidInput("test", null, "Email", 100, false) , ' should NOT accept null email');
    
    }



    /**
     * Test of isValidSafeHTML method, of class org.owasp.esapi.Validator.
     */
    function testIsValidSafeHTML() {
        debug("isValidSafeHTML");
        assertTrue(instance.isValidSafeHTML("test", "<b>Jeff</b>", 100, false));
        assertTrue(instance.isValidSafeHTML("test", '<a href="http://www.aspectsecurity.com">Aspect Security</a>', 100, false));
        assertFalse(instance.isValidSafeHTML("test", "Test. <script>alert(document.cookie)</script>", 100, false));

        // TODO: waiting for a way to validate text headed for an attribute for scripts
        // This would be nice to catch, but just looks like text to AntiSamy
        // assertFalse(instance.isValidSafeHTML("test", "\" onload=\"alert(document.cookie)\" "));
    }




  function setUp(){
   instance =  createObject('component', 'cfesapi.org.owasp.esapi.Validator').init();
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>

<!--- 

    /**
     * Test of isValidEmailAddress method, of class org.owasp.esapi.Validator.
     */

/*
    /**
     * Test of isValidSafeHTML method, of class org.owasp.esapi.Validator.
     */
    function testIsValidSafeHTML() {
        debug("isValidSafeHTML");
        assertTrue(instance.isValidSafeHTML("test", "<b>Jeff</b>", 100, false));
        assertTrue(instance.isValidSafeHTML("test", '<a href="http://www.aspectsecurity.com">Aspect Security</a>', 100, false));
        assertFalse(instance.isValidSafeHTML("test", "Test. <script>alert(document.cookie)</script>", 100, false));

        // TODO: waiting for a way to validate text headed for an attribute for scripts
        // This would be nice to catch, but just looks like text to AntiSamy
        // assertFalse(instance.isValidSafeHTML("test", "\" onload=\"alert(document.cookie)\" "));
    }



    function testGetValidSafeHTML() {
        debug("getValidSafeHTML");
        test1 = "<b>Jeff</b>";
        result1 = instance.getValidSafeHTML("test", test1, 100, false);
        assertEquals(test1, result1);
         test2 = "<a href=""http://www.aspectsecurity.com"">Aspect Security</a>";
         result2 = instance.getValidSafeHTML("test", test2, 100, false);
        assertEquals(test2, result2);

         test3 = "Test. <script>alert(document.cookie)</script>";
         result3 = instance.getValidSafeHTML("test", test3, 100, false);
        assertEquals("Test.", result3);

        // TODO: ENHANCE waiting for a way to validate text headed for an attribute for scripts
        // This would be nice to catch, but just looks like text to AntiSamy
        // assertFalse(instance.isValidSafeHTML("test", "\" onload=\"alert(document.cookie)\" "));
        //  result4 = instance.getValidSafeHTML("test", test4);
        // assertEquals("", result4);
    }




    /**
     * Test of isValidListItem method, of class org.owasp.esapi.Validator.
     */
    function testIsValidListItem() {
        debug("isValidListItem");

        //list = arrayNew(1);
        //list[1] = "one";
        //list.add("two");
        //assertTrue(instance.isValidListItem("test", "one", list));
        //assertFalse(instance.isValidListItem("test", "three", list));
    }

    /**
     * Test of isValidNumber method, of class org.owasp.esapi.Validator.
     */
    function testIsValidNumber() {
        debug("isValidNumber");

        //testing negative range
        assertFalse(instance.isValidNumber("test", "-4", 1, 10, false));
        assertTrue(instance.isValidNumber("test", "-4", -10, 10, false));
        //testing null value
        assertTrue(instance.isValidNumber("test", null, -10, 10, true));
        assertFalse(instance.isValidNumber("test", null, -10, 10, false));
        //testing empty string
        assertTrue(instance.isValidNumber("test", "", -10, 10, true));
        assertFalse(instance.isValidNumber("test", "", -10, 10, false));
        //testing improper range
        assertFalse(instance.isValidNumber("test", "5", 10, -10, false));
        //testing non-integers
        assertTrue(instance.isValidNumber("test", "4.3214", -10, 10, true));
        assertTrue(instance.isValidNumber("test", "-1.65", -10, 10, true));
        //other testing
        assertTrue(instance.isValidNumber("test", "4", 1, 10, false));
        assertTrue(instance.isValidNumber("test", "400", 1, 10000, false));
        assertTrue(instance.isValidNumber("test", "400000000", 1, 400000000, false));
        assertFalse(instance.isValidNumber("test", "4000000000000", 1, 10000, false));
        assertFalse(instance.isValidNumber("test", "alsdkf", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "--10", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "14.1414234x", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "Infinity", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "-Infinity", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "NaN", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "-NaN", 10, 10000, false));
        assertFalse(instance.isValidNumber("test", "+NaN", 10, 10000, false));
        assertTrue(instance.isValidNumber("test", "1e-6", -999999999, 999999999, false));
        assertTrue(instance.isValidNumber("test", "-1e-6", -999999999, 999999999, false));
    }

    /**
     *
     */
    function testIsValidInteger() {
        debug("isValidInteger");

        //testing negative range
        assertFalse(instance.isValidInteger("test", "-4", 1, 10, false));
        assertTrue(instance.isValidInteger("test", "-4", -10, 10, false));
        //testing null value
        assertTrue(instance.isValidInteger("test", null, -10, 10, true));
        assertFalse(instance.isValidInteger("test", null, -10, 10, false));
        //testing empty string
        assertTrue(instance.isValidInteger("test", "", -10, 10, true));
        assertFalse(instance.isValidInteger("test", "", -10, 10, false));
        //testing improper range
        assertFalse(instance.isValidInteger("test", "5", 10, -10, false));
        //testing non-integers
        assertFalse(instance.isValidInteger("test", "4.3214", -10, 10, true));
        assertFalse(instance.isValidInteger("test", "-1.65", -10, 10, true));
        //other testing
        assertTrue(instance.isValidInteger("test", "4", 1, 10, false));
        assertTrue(instance.isValidInteger("test", "400", 1, 10000, false));
        assertTrue(instance.isValidInteger("test", "400000000", 1, 400000000, false));
        assertFalse(instance.isValidInteger("test", "4000000000000", 1, 10000, false));
        assertFalse(instance.isValidInteger("test", "alsdkf", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "--10", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "14.1414234x", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "Infinity", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "-Infinity", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "NaN", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "-NaN", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "+NaN", 10, 10000, false));
        assertFalse(instance.isValidInteger("test", "1e-6", -999999999, 999999999, false));
        assertFalse(instance.isValidInteger("test", "-1e-6", -999999999, 999999999, false));

    }

    /**
     * Test of getValidDate method, of class org.owasp.esapi.Validator.
     *
     * @throws Exception
     */
    function testGetValidDate()  {
        debug("getValidDate");

        assertTrue(instance.getValidDate("test", "June 23, 1967", DateFormat.getDateInstance(DateFormat.MEDIUM, Locale.US), false) != null);
        try {
            instance.getValidDate("test", "freakshow", DateFormat.getDateInstance(), false);
        } catch (ValidationException e) {
            // expected
        }

        // This test case fails due to an apparent bug in SimpleDateFormat
        try {
            instance.getValidDate("test", "June 32, 2008", DateFormat.getDateInstance(), false);
            // fail();
        } catch (ValidationException e) {
            // expected
        }
    }

    /**
     * Test of isValidFileName method, of class org.owasp.esapi.Validator.
     */
    function testIsValidFileName() {
        debug("isValidFileName");

        assertTrue(instance.isValidFileName("test", "aspect.jar", false));
        assertFalse(instance.isValidFileName("test", "", false));
        try {
            instance.isValidFileName("test", "abc/def", false);
        } catch (IntrusionException e) {
            // expected
        }
    }

    /**
     * Test of isValidDirectoryPath method, of class org.owasp.esapi.Validator.
     */
    function testIsValidDirectoryPath() {
        debug("isValidDirectoryPath");

        // get an encoder with a special list of codecs and make a validator out of it
        //List list = new ArrayList();
        //list.add(new HTMLEntityCodec());
        //Encoder encoder = new DefaultEncoder(list);
        //Validator instance = new DefaultValidator(encoder);


        isWindows = false;//(System.getProperty("os.name").indexOf("Windows") != -1) ? true : false;

        if (isWindows) {
            // Windows paths that don't exist and thus should fail
            assertFalse(instance.isValidDirectoryPath("test", "c:\\ridiculous", false));
            assertFalse(instance.isValidDirectoryPath("test", "c:\\jeff", false));
            assertFalse(instance.isValidDirectoryPath("test", "c:\\temp\\..\\etc", false));

            // Windows paths that should pass
            assertTrue(instance.isValidDirectoryPath("test", "C:\\", false));                                // Windows root directory
            assertTrue(instance.isValidDirectoryPath("test", "C:\\Windows", false));                        // Windows always exist directory
            assertTrue(instance.isValidDirectoryPath("test", "C:\\Windows\\System32\\cmd.exe", false));        // Windows command shell

            // Unix specific paths should not pass
            assertFalse(instance.isValidDirectoryPath("test", "/tmp", false));        // Unix Temporary directory
            assertFalse(instance.isValidDirectoryPath("test", "/bin/sh", false));    // Unix Standard shell
            assertFalse(instance.isValidDirectoryPath("test", "/etc/config", false));

            // Unix specific paths that should not exist or work
            assertFalse(instance.isValidDirectoryPath("test", "/etc/ridiculous", false));
            assertFalse(instance.isValidDirectoryPath("test", "/tmp/../etc", false));
        } else {
            // Windows paths should fail
            assertFalse(instance.isValidDirectoryPath("test", "c:\\ridiculous", false));
            assertFalse(instance.isValidDirectoryPath("test", "c:\\temp\\..\\etc", false));

            // Standard Windows locations should fail
            assertFalse(instance.isValidDirectoryPath("test", "c:\\", false));                                // Windows root directory
            assertFalse(instance.isValidDirectoryPath("test", "c:\\Windows\\temp", false));                    // Windows temporary directory
            assertFalse(instance.isValidDirectoryPath("test", "c:\\Windows\\System32\\cmd.exe", false));    // Windows command shell

            // Unix specific paths should pass
            assertTrue(instance.isValidDirectoryPath("test", "/", false));            // Root directory
            assertTrue(instance.isValidDirectoryPath("test", "/bin", false));        // Always exist directory
            assertTrue(instance.isValidDirectoryPath("test", "/bin/sh", false));    // Standard shell

            // Unix specific paths that should not exist or work
            assertFalse(instance.isValidDirectoryPath("test", "/etc/ridiculous", false));
            assertFalse(instance.isValidDirectoryPath("test", "/tmp/../etc", false));
        }
    }

    /**
     *
     */
    function testIsValidPrintable() {
        debug("isValidPrintable");

        assertTrue(instance.isValidPrintable("name", "abcDEF", 100, false));
        assertTrue(instance.isValidPrintable("name", "!@#R()*$;><()", 100, false));
        byte[] bytes = {0x60, (byte) 0xFF, 0x10, 0x25};
        assertFalse(instance.isValidPrintable("name", bytes, 100, false));
        assertFalse(instance.isValidPrintable("name", "%08", 100, false));
    }

    /**
     * Test of isValidFileContent method, of class org.owasp.esapi.Validator.
     */
    function testIsValidFileContent() {
        debug("isValidFileContent");
        byte[] content = "This is some file content".getBytes();

        assertTrue(instance.isValidFileContent("test", content, 100, false));
    }

    /**
     * Test of isValidFileUpload method, of class org.owasp.esapi.Validator.
     */
    function testIsValidFileUpload() {
        debug("isValidFileUpload");

         filepath = System.getProperty("user.dir");
         filename = "aspect.jar";
        byte[] content = "This is some file content".getBytes();

        assertTrue(instance.isValidFileUpload("test", filepath, filename, content, 100, false));

        filepath = "/ridiculous";
        filename = "aspect.jar";
        content = "This is some file content".getBytes();
        assertFalse(instance.isValidFileUpload("test", filepath, filename, content, 100, false));
    }

    /**
     * Test of isValidParameterSet method, of class org.owasp.esapi.Validator.
     */
    function testIsValidParameterSet() {
        debug("isValidParameterSet");

        Set requiredNames = new HashSet();
        requiredNames.add("p1");
        requiredNames.add("p2");
        requiredNames.add("p3");
        Set optionalNames = new HashSet();
        optionalNames.add("p4");
        optionalNames.add("p5");
        optionalNames.add("p6");
        TestHttpServletRequest request = new TestHttpServletRequest();
        TestHttpServletResponse response = new TestHttpServletResponse();
        request.addParameter("p1", "value");
        request.addParameter("p2", "value");
        request.addParameter("p3", "value");
        ESAPI.httpUtilities().setCurrentHTTP(request, response);

        assertTrue(instance.isValidHTTPRequestParameterSet("HTTPParameters", requiredNames, optionalNames));
        request.addParameter("p4", "value");
        request.addParameter("p5", "value");
        request.addParameter("p6", "value");
        assertTrue(instance.isValidHTTPRequestParameterSet("HTTPParameters", requiredNames, optionalNames));
        request.removeParameter("p1");
        assertFalse(instance.isValidHTTPRequestParameterSet("HTTPParameters", requiredNames, optionalNames));
    }

    /**
     * Test safe read line.
     */
    function testSafeReadLine() {
        debug("safeReadLine");

        ByteArrayInputStream s = new ByteArrayInputStream("testString".getBytes());

        try {
            instance.safeReadLine(s, -1);
            fail();
        } catch (ValidationException e) {
            // Expected
        }
        s.reset();
        try {
            instance.safeReadLine(s, 4);
            fail();
        } catch (ValidationException e) {
            // Expected
        }
        s.reset();
        try {
             u = instance.safeReadLine(s, 20);
            assertEquals("testString", u);
        } catch (ValidationException e) {
            fail();
        }

        // This sub-test attempts to validate that BufferedReader.readLine() and safeReadLine() are similar in operation
        // for the nominal case
        try {
            s.reset();
            InputStreamReader isr = new InputStreamReader(s);
            BufferedReader br = new BufferedReader(isr);
             u = br.readLine();
            s.reset();
             v = instance.safeReadLine(s, 20);
            assertEquals(u, v);
        } catch (IOException e) {
			fail();
		} catch (ValidationException e) {
			fail();
		}
	}


*/
 --->