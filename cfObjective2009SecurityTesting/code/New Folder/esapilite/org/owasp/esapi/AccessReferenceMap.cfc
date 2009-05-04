<cfcomponent output="false">
<!--- 
 Functionally this works for all data types except arrays, where
 in CF they are passed by value. 
 
 @desc. given any object, creates an indirect reference to that
 object so that it can be stored in a session or retrieved later.
 
 Strings and numerics all return the same ids and should be able
 to be used across requests. Complex objects such as structs and
 cfcs will be unique.
 
 Usage example:
 
 user = createObect('component', 'User').init(name,email, address);
 
 instead of session['userInfo'] = user; do this instead:
 
 map =  createObect('component', 'org.owasp.esapi.AccessReferenceMap').init();
 indirectUser = map.addDirectReference(user);
 session['userInfo'] = indirectUser;
 
 later, when you need this, try this:
 
 user = map.getDirectReference( session['userInfo'] );
 --->
<cfscript>
  refMap = structNew();
  sys = createObject('java','java.lang.System');


  function init(o){
  	var id = '';
  	if(not isStruct(o)) $throw('Need a a struct');
  	$buildMap(o);
  	return this; //or id?
  }

  function addDirectReference(o){
    var identity = getIdentity(o) ;
    var randId = $genRandId( identity );
    refMap[randId] = o;
    refMap[identity] = randId;
    return randId;
	}

  function getIndirectReference(o){
    var lookup = getIdentity(o);
    return refMap[lookup];
  }

  function getDirectReference(id){
    try{
     return refMap[id];
    }
    catch(coldfusion.runtime.UndefinedElementException e){
      $throw();
    }

  }

  function getDirectRefMap(){
    return refMap;
  }

  function getIdentity(o){
    return sys.identityHashCode(o);
  }

  function removeDirectReference(o){
    var lookup = getIdentity(o);
    var inRef  = refMap[lookup];
    structDelete(refMap, lookup ,true);
    structDelete(refMap, inRef ,true);
    return true;
  }

  function update(o){
   $throw();
  }

	</cfscript>

 <cffunction name="$throw" access="private">
	 <cfthrow type="org.owasp.error.AccessControlException" message="#arguments[1]#" detail="To Do">
 </cffunction>

<cffunction name="$buildMap" access="private" hint="recurses over structs only.">
  <cfargument name="o" type="struct" />
 	<cfscript>
	 var key = '';
	 var item = chr(0);
	 var identity = $id(o);
	 var randId = $genRandId(identity);
     refMap[randId] = o;
	 refMap[identity] = randId;

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

<cffunction name="$genRandId" access="public">
  <cfargument name="seed" type="numeric"/>
   <cfscript>
	 var secRand = createObject('java','java.util.Random').init(seed);
     var bigInt = createObject('java','java.math.BigInteger').init(64,secRand).toString(32);
     return bigInt;
   </cfscript>
</cffunction>

<cffunction name="$id" access="private">
  <cfscript>
	return sys.identityHashcode(arguments[1]);
  </cfscript>
</cffunction>

</cfcomponent>
<!--- 

<cfcomponent output="false">
	<cffunction name="init" access="public" returntype="AccessReferenceMap" output="false">
		<cfargument name="directObjCollection" type="any" required="true" />
		
		<cfset variables.itod = createObject('java', 'java.util.HashMap').init() />
		<cfset variables.dtoi = createObject('java', 'java.util.HashMap').init() />
		
		<cfif IsArray(arguments.directObjCollection)>
			<cfset updateFrom Array(arguments.directObjCollection)>
		<cfelseif IsStruct(arguments.directObjCollection)>
			<cfset updateFromStruct(arguments.directObjCollection)>
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="updateFromArray" access="public" returntype="void" output="false">
		<cfargument name="directObjCollection" type="Array" required="true" default="#ArrayNew(1)#" />
		
		<cfset var dtoi_old = variables.dtoi.clone() />
		<cfset var i = "" />
		<cfset tempID = "" />
		
		<cfset variables.dtoi.clear() />
		<cfset variables.itod.clear() />
		
		<cfloop index="i" from="1" to="#ArrayLen(arguments.directObjCollection)#">
			
			<cfset tempID = dtoi_old.get(arguments.directObjCollection[i]) />
			
			<cfif NOT Len(tempID)><cfset tempID = createUUID()></cfif>
			
			<cfset variable.itod.put(tempID, arguments.directObjCollection[i]) />
			<cfset variable.dtoi.put(arguments.directObjCollection[i], tempID />
		</cfloop>
	</cffunction>
	
	<cffunction name="updateFromStruct" access="public" returntype="void" output="false">
		<cfargument name="directObjCollection" type="Struct" required="true" default="#StructNew()#" />
		
		<cfset var dtoi_old = variables.dtoi.clone() />
		<cfset var i = "" />
		<cfset tempID = "" />
		
		<cfset variables.dtoi.clear() />
		<cfset variables.itod.clear() />
		
		<cfloop item="directObject" collection="#arguments.directObjCollection#">
			<cfset tempID = dtoi_old.get(directObject) />
			
			<cfif NOT Len(tempID)><cfset tempID = createUUID()></cfif>
			
			<cfset tempID = CreateUUID />
			<cfset variable.itod.put(tempID, directObject) />
			<cfset variable.dtoi.put(directObject, tempID />
		</cfloop>
	</cffunction>
	
	<cffunction name="updateFromList" access="public" returntype="void" output="false">
		<cfargument name="directObjCollection" type="String" required="true" default="#StructNew()#" />
		
		<cfset var dtoi_old = variables.dtoi.clone() />
		<cfset var i = "" />
		<cfset tempID = "" />
		
		<cfset variables.dtoi.clear() />
		<cfset variables.itod.clear() />
		
		<cfloop list="#arguments.directObjCollection#" index="i">
			<cfset tempID = dtoi_old.get(i) />
			
			<cfif NOT Len(tempID)><cfset tempID = createUUID()></cfif>
			
			<cfset tempID = CreateUUID />
			<cfset variable.itod.put(tempID, i) />
			<cfset variable.dtoi.put(i, tempID />
		</cfloop>
	</cffunction>

</cfcomponent>
 --->
