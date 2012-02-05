<cfsetting enablecfoutputonly="false" >
<cfscript>

obj = new ThisScopeComponent();
value = 2;
expected = value + value;
obj.intprop = value;
writeOutput("input: #value# should be #expected#. It was: #obj.doubleMe()#<br>");

if(! structKeyExists( application, "doubleMeObj" )){
	application.doublemeobj = obj;
	writeLog("setting app obj");
}

for(i = 1; i <= 2; i++){
	
	thread action="run" name="#i#" input="#i#" {
		expected = input + input;
		application.doublemeobj.intprop = input;
		doubled = application.doublemeobj.doubleMe();
		if( expected != doubled ){
			throw("mismatch! input was #input#, expected was #expected# doubled was #doubled#");
		}
	}  
	
}
 	
</cfscript>
