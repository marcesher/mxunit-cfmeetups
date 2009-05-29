<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>

function genRandomStringTest() {
  var charSet = [];
  var s  = generator.genRandomString(50);
  debug(s);
  assert(50 == len(s));

  charset = ['a'];
  s = generator.genRandomString(10,charset);
  debug(s);
  assertEquals('aaaaaaaaaa',s,'should contain 10 lowercase a''s');

  charset = [1,2,3,4,5,6,7,8,9,0];
  s = generator.genRandomString(32,charset);
  debug(s);
  assert(32==len(s));


}

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