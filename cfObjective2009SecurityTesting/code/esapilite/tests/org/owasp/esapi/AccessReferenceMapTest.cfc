<cfcomponent output="false" extends="BaseTest">
<cfscript>
/*------------------------------------------------------------------
                       Constants
------------------------------------------------------------------*/
   s = {file='file',bar='bar',n1=123,n2=0.0001,n3=-981,a1=['a','c'],s={foobar='meh'},file1=$file()};
   a = [1,2,3,4,'snook','tarpon',{foo='bar'}];
   MAX_INT = createObject('java','java.lang.Integer').MAX_VALUE;
   MIN_INT  = createObject('java','java.lang.Integer').MIN_VALUE;
   str = 'file=bar';
   l = 'item1,item2,item3';
   sys = createObject('java','java.lang.System');
  //char 48..57:0-9, 65..90: A-Z, 97-122:a-z



/*------------------------------------------------------------------*/
 function setUp(){
   arm = createObject('component', 'cfobjective.code.esapilite.org.owasp.esapi.AccessReferenceMap');
  }
/*------------------------------------------------------------------*/


  function $AccessRefMapIntegrationTest(){
    var map = arm.init(s);
    session['map'] = map;
    debug(session);
    topKey = map.getIndirectReference(s);
    debug(topKey);
    actual = map.getDirectReference(topKey);
    assertSame(s,actual, 'DR list not same');

    o = s['s'];
    ir = map.getIndirectReference( o );
    actual = map.getDirectReference(ir);
    debug(o);
    assertSame( o, actual, 'nested structs are not same' );

    o = s['file1'];
    ir = map.getIndirectReference(o);
    actual = map.getDirectReference(ir);
    debug(o);
    assertSame( o, actual, 'file refs are not same' );

    o = s['n2'];
    ir = map.getIndirectReference(o);
    actual = map.getDirectReference(ir);
    debug(o);
    assertSame( o, actual, 'floats are not same' );



  }



   function genRandIdShouldBePrettyFast(){
    var a = structKeyArray(s);
    var id = $id(s);
    //slow, but better than secure rand!
    var newid = '';
    var i = 1;
    var MAX = 1000;
    var start = getTickCount();
    for(i; i < MAX; i++){
       newid = arm.$genRandId(id);
     }
    debug(getTickCount()-start);
    debug(newid);
   }


  function initShouldSetAnyObjectInTheRefMap(){
    var map = arm.init(s);
    var id = map.getIndirectReference(s);
    debug(id);
    debug(map.getDirectRefMap());
  }


  function getIdentityShouldReturnSameIdentityHash(){
   var i = 1;
   var start = getTickCount();
   var id = 0;
   var MAX = 250;
   for(i; i < MAX; i++){
    id =  arm.getIdentity(s);
    assertEquals( sys.identityHashCode(s), id , 'Failed on iteration #i#, for #s.toString()#' );

    id =  arm.getIdentity(i);
    assertEquals( sys.identityHashCode(i), id , 'Failed on iteration #i#, for #i#' );

    id =  arm.getIdentity(str);
    assertEquals( sys.identityHashCode(str), id , 'Failed on iteration #i#, for #str#' );

    id =  arm.getIdentity(l);
    assertEquals( sys.identityHashCode(l), id , 'Failed on iteration #i#, for #l#' );

    id =  arm.getIdentity(this);
    assertEquals( sys.identityHashCode(this), id , 'Failed on iteration #i#, for #this.tostringValue()#' );
   }

   debug(getTickCount()-start);
  }


   function provesUUIdIsDogSlow(){
    var i = 1;
    var MAX = 10; //try 1000
    debug('Bark ... createUUID(). Maybe use $getRandId() instead?');
    start = getTickCount();
    for(i; i < MAX; i++){
      createUUID();
    }
   debug(getTickCount()-start);
  }



  function addDirectReferenceShouldGenRandIDAndHaveSameIdentityAsSource() {
    var id = arm.addDirectReference(s);
    var dr = arm.getDirectReference(id);
    var expected = $id(s);
    var actual = $id(dr);
    debug(dr);
    assertTrue( id != expected );
    assertSame( s , dr );
  }



  function givenAnIdGetDirectReferenceShouldReturnSameObject() {
    var id = arm.addDirectReference(s);
    var dr = arm.getDirectReference(id);
    debug(id);
    debug(dr);
    debug(s);
    assertSame( s, dr );
  }



  function getIndirectReferenceShouldReturnSameRef(){
    var id = arm.addDirectReference(s);
    var actual = arm.getDirectReference(id);
    assertSame(s,actual ,'structs not same');

    id =  arm.addDirectReference(l);
    actual = arm.getDirectReference(id);
    assertSame(l,actual,'list not same');

    id =  arm.addDirectReference(str);
    actual = arm.getDirectReference(id);
    assertSame(str,actual,'list not same');


   try{
      id =  arm.addDirectReference(a);
      actual = arm.getDirectReference(id);
      assertSame(a,actual,'array not same');

      fail('I wish this would not get here.');
    }
    catch(mxunit.exception.CannotCompareArrayReferenceException e){
      debug(a);
    }

  }


  function removeDirectReferenceShouldPurgeCollection(){
     var map =  arm.init(s);
     var id = map.getIndirectReference(s);
     var actual = arm.removeDirectReference(s);
     debug(arm.getDirectRefMap());
     assertTrue(actual);
     try{
		   actual = arm.getDirectReference(id);
		   fail('should not get here');
		  }
		  catch(org.owasp.error.AccessControlexception e){
		  }


  }


 function attempToAccessNonExistantReferenceShouldThrowAccessException(){
  try{
   actual = arm.getDirectReference(-1231231.23123);
   fail('should not get here');
  }
  catch(org.owasp.error.AccessControlexception e){
  }
 }

 function updateShouldReplaceExistingRefMap(){
  fail('to do');
 }

  function tearDown(){}


</cfscript>


<!--------------------------------------------------------------------
                     Utilities

--------------------------------------------------------------------->
<cffunction name="$id" access="private">
	<cfscript>
	 return sys.identityHashcode(arguments[1]);
	</cfscript>
</cffunction>



<cffunction name="$file" access="private">
	<cffile action="read" variable="f" file="#expandPath('/cfesapi/tests/fixture/file1.txt')#">
	<cfreturn cffile />
</cffunction>

</cfcomponent>