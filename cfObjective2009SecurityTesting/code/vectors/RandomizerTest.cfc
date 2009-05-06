<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


function getRandomInt() {
	var found = false;
    for(i=1;i<10000;i++){
      //debug( generator.genRandomInteger(0,9) );
      num = generator.genRandomInteger(0,10); 
      if ( num eq 9) {
      	debug(i & ' ' & num); 
      	return;
      	}
     }
     
     fail('max not found @#i# iterations');

  }


  function genRandPwd() {
    for(i=1;i<100;i++){
      debug( generator.genRandPassword() );
    }
  }


  function peepWords(){
   words = generator.getWords();
   debug( words.recordCount );
  }

  function setUp(){
    generator = createObject( 'component', 'Generator' );
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>