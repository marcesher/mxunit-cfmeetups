<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
   s = {file='file',bar='bar',n1=123,n2=0.0001,n3=-981,a1=['a','c'],s={foobar='meh',nested={barbar='lafoot'}}};
   refMap = structNew();
   sys = createObject('java','java.lang.System');


  function build() {
     debug(s);
     $buildMap(s.clone());
     debug(refMap);
  }

</cfscript>

<cffunction name="$buildMap" access="private">
  <cfargument name="o" type="struct" />
 	<cfscript>
	 var key = '';
	 var item = chr(0);
	 var identity = '';
	 var randId = '';

	 for(key in o){
	 	item = o[key];
	 	identity = $id(item);
	 	randId = $genRandId(identity);
	 	refMap[randId] = item;
	  refMap[identity] = randId;
  	if(isStruct(item)) {
	 		 $buildMap(item);
	 	}
	 }
	</cfscript>
 </cffunction>

<cffunction name="$id" access="private">
	<cfscript>
	 return sys.identityHashcode(arguments[1]);
	</cfscript>
</cffunction>

<cffunction name="$genRandId" access="private">
	<cfargument name="seed" type="numeric"/>
	<cfscript>
	 var secRand = createObject('java','java.util.Random').init(seed);
   var bigInt = createObject('java','java.math.BigInteger').init(64,secRand).toString(32);
   return bigInt;
	</cfscript>
</cffunction>

</cfcomponent>