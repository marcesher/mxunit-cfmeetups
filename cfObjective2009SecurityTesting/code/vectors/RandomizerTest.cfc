<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>


function getRandomInt() {

    for(i=1;i<100;i++){
      debug( generator.genRandomInteger(0,9) );
    }

  }


  function genRandPwd() {

    for(i=1;i<100;i++){
      debug( generator.genRandPassword() );
    }

  }



  function setUp(){
    generator = createObject( 'component', 'Generator' );
  }

  function tearDown(){

  }


</cfscript>
</cfcomponent>