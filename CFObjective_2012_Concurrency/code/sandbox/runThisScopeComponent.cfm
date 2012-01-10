<cfscript>
obj = new ThisScopeComponent();
value = "hi";
obj.prop = value;
writeOutput("value #value# should be #obj.prop#<br>");

application.obj = obj;

for(i = 1; i <= 100; i++){
	
	thread action="run" name="#i#" input="#i#" {
		application.obj.prop = input;
		retrieved = application.obj.prop;
		if( input != retrieved ){
			throw("mismatch! input was #input#, retrieved was #retrieved#");
		}
	}  
	
}
 	
</cfscript>
