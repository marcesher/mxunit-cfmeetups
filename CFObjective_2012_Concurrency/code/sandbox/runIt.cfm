<cfscript>
obj = new GetterSetterComponent();
value = "hi";
obj.setProp(value);
writeOutput("value #value# should be #obj.getProp()#<br>");




application.obj = obj;

for(i = 1; i <= 100; i++){
	
	thread action="run" name="#i#" input="#i#" {
		application.obj.setProp(input);
		retrieved = application.obj.getProp();
		if( input != retrieved ){
			throw("mismatch! input was #input#, retrieved was #retrieved#");
		}
	}  
	
}
 	
</cfscript>
