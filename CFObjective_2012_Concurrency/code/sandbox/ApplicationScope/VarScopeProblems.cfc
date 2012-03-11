<cfcomponent>

	<cffunction name="getArtist" output="false" access="public" returntype="any" hint="">
		<cfargument name="id" type="numeric" required="true"/>
		
		<cfquery datasource="cfartgallery" name="artist">
			select *
			from artists
			where artistid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer"/>
		</cfquery>
		
		<cfif artist.artistid neq arguments.id>
			<cfthrow message="WTF?! #artist.artistid# instead of #arguments.id#">
		</cfif>
		
		<cfreturn artist>
	</cffunction>
	
	<cffunction name="runALoop" output="false" access="public" returntype="any" hint="">   
		<cfargument name="goTo" type="numeric" required="false" default="100"/> 
    	<cfscript>
			for( i = 0; i < goTo; i++ ){}        	        
        </cfscript>
		
		<cfif i neq goto>
			<cfthrow message="ZOMG: i was       #i#      but goTo was #goTo# #chr(10)#">
		</cfif>
		<cfreturn i>
    </cffunction>


</cfcomponent>