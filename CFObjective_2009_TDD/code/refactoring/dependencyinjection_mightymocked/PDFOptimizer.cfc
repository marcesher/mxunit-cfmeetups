<cfcomponent>
	
	<cffunction name="optimize" output="false" access="public" returntype="any" hint="">
		<cfargument name="inFile" type="string" required="true" hint="the file to optimize"/>
		<cfargument name="outFile" type="string" required="false" default="#inFile#" hint="the full output path for the optimized file. Can be the same as the input file"/>
		<!--- do badass stuff here --->
		
		<cfreturn outFile>
	</cffunction>
	
</cfcomponent>