<cfsetting showdebugoutput="false">
<cfscript>

	/*obj = new ThisScopeComponent();
	value = 2;
	expected = value + value;
	obj.intprop = value;
	writeOutput("input: #value# should be #expected#. It was: #obj.doubleMe()#<br>");
	
	if(! structKeyExists( application, "doubleMeObjEgads" )){
		application.doubleMeObjEgads = obj;
		writeLog("setting app egads obj");
	}*/
	
	input = randRange(1, 100);
	expected = input * 2;
	/**/expected2 = application.doubleMeObjEgads.doubleInput(input);
	
	if( expected != expected2 ){
		throw ("what in the F? for input #input#, #expected# != #expected2#");
	}
	
	application.doubleMeObjEgads.intprop = input;
	doubled = application.doubleMeObjEgads.doubleMe();
	if( expected != doubled ){
		throw("mismatch! input was #input#, expected was #expected# doubled was #doubled#");
	}

 	
</cfscript>
