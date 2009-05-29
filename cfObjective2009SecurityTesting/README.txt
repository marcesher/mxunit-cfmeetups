~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                     May 2009 - Bill Shelton, mxunit.org
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Description of Contents:
  Slides and Code for cfObjective 2009 Approaches to Automated Security Testing
  I will do my best to answer any questions: billshelton at comcast dot net

Set up:
 * Requirements - ColdFusion 8, MXUnit with a /mxunit cf mapping.
 * Expand code into your webroot. The files need to be located in 
   {webroot}/cfobjective. Optionally, you should be able to create a /cfobjective
   mapping.


Where stuff is:
 * Slides :
      - located in the root in a file called cf.objectitve.2009.ppt
 * Code  :
     - /esapilite - This is the 'light' version of the CF ESAPI project, which,
       at the time of this writing, is just starting out. For the purposes of
       this presentation, the Validator and AccessReferenceMap are used. 
       Check out these links for more information on this project:
       http://code.google.com/p/owasp-esapi-coldfusion/ ... parent project:
       http://www.owasp.org/index.php/ESAPI
              
       - /exampleapp - This has two directories - /lesssecure and /moresecure.
         The /lesssecure has a totally vulnerable app. This is intended to
         demontrate vulnerabilities, not secure practices.
         The moresecure.SecureUser demonstrates an approach to validating a 
         user object, using indirect references, and to a small degree,
         session management. The UserValidator abstracts validation logic into
         its own object and extends the Validator in esapilight.
         
       - /exampleapptests - This is where all the tests for the above are 
         located. The UserValidatorTest is the most interesting. It demonstrate 
         an approach to testing Validation. It uses a data generator as well as
         known XXS vulnerabilities to "attack" the Validation at its most 
         atomic level. The basic approach is a white list strategy, and as such,
         the validation should trust only that which is allowed.
         
         - /firefuzz - This contains the engine that drives Firefox. Essentially,
           this is a ColdFusion wrapper for the Webdriver project:
           http://code.google.com/p/webdriver/
           Note that only the minimal amount of features have been implemented.
           If this interests you, please contact me!
           
         - /fuzzingtests - This contains some simple tests that are aimed at
           showing how Firefuzz works and some of its potential.
           
         - /vectors - This contains exploit and data generators. The Generator
            component has methods for returning random strings, ints, passwords,
            and dictionary words. This is useful for fuzzing and generating
            edge-case data for tests.
            
            The /vectors/FuzzyVectors.cfc component has methods that return XSS
            exploits. Use the data generated here to test your application
            for XSS attacks. NOTE: these attacks were taken from rSnake and could
            be greatly improved for test automation by changing the typical
            alert(...) test to document.write( '&lt;div id="someknown_id"/&gt;' ) or
            some other method of writing an element to the DOM. Your tests could 
            then check the generated DOM for the element that was attempted to
            be injected. See FuzzyVectors.getDocWriteVectors() for a small example.
             
               
         
          
         