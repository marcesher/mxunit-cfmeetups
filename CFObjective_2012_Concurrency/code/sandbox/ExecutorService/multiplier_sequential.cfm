<cfscript>

goTo = 10000;
result = 0;

startTS = getTickCount();

for( i = 1; i <= goTo; i++ ){
	result += ( i * (i+1) );
}

totalMS = getTickCount() - startTS;

</cfscript>

<cfoutput>
Result #result# in #totalMS# ms	
</cfoutput>