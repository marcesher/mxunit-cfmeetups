<!---

It's arguable that the duplicate prevention checking should be done external to this. I've decided to wrap it into here, because
file zipping by itself is a 3-line affair. Thus, the major responsibility of this component *is* preventing duplicate zips

This file is intended to be used as a singleton (i.e. application-scoped)

 --->

<cfcomponent accessors="true">

	<cfproperty name="outputPath">
	<cfproperty name="reapSeconds">

	<!---
		I'm using this data structure rather than a CF struct for the following reasons:

		1) it's thread-safe, which is critical since multiple concurrent tasks will use this file zipper
		2) provides the option, should we want it, to use a Comparator which will give us ordered traversal
		3) allows us to traverse the struct and at the same time delete from it

		if we need more performance, we could implement a comparator that compares on the timestamps of the entries put into this cache
		For now, we'll just loop over everything every time because it's so fast

		http://docs.oracle.com/javase/6/docs/api/java/util/concurrent/ConcurrentSkipListMap.html
	 --->
	<cfset variables.zipCache = createObject( "java", "java.util.concurrent.ConcurrentSkipListMap" ).init()>


	<cffunction name="init" output="false" access="public" returntype="any" hint="">
    	<cfargument name="outputPath" type="string" required="true"/>
		<cfargument name="reapSeconds" type="numeric" required="false" default="60" hint="how long, in seconds, we'll keep a record of previous zips"/>
		<cfset structAppend( variables, arguments )>
		<cfset createObject("java", "java.io.File").init(outputPath).mkDirs()>
		<cfreturn this>
    </cffunction>

    <cffunction name="zipFiles" output="false" access="public" returntype="any" hint="">
    	<cfargument name="key" type="string" required="true"/>
		<cfargument name="files" type="array" required="true"/>

    	<cfset var outputFile = "#variables.outputPath#/#arguments.key#.zip">

		<cfset reap()>

    	<!--- if we've zipped this key recently, simply ignore it as it's a double submission --->
    	<cfif isRecentlyProcessed( key )>
			<cfreturn createResult( false, outputFile, "This file appears to be a duplicate submission" )>
		</cfif>

		<cfset sow( key )>

		<cfset var z = "">
		<cfzip action="zip" file="#outputFile#" overwrite="false">
			<cfloop array="#files#" index="z">
				<cfzipparam source="#z#">
			</cfloop>
		</cfzip>

		<cfreturn createResult( true, outputFile )>
    </cffunction>

    <cffunction name="createResult" output="false" access="private" returntype="struct" hint="">
    	<cfargument name="success" type="boolean" required="true"/>
		<cfargument name="outputFile" type="string" required="true"/>
		<cfargument name="message" type="string" required="false" default=""/>
		<cfreturn arguments>
    </cffunction>

    <cffunction name="isRecentlyProcessed" output="false" access="private" returntype="boolean" hint="">
    	<cfargument name="key" type="string" required="true"/>
		<cfreturn getZipCache().containsKey( arguments.key )>
    </cffunction>


    <cffunction name="sow" output="false" access="private" returntype="any" hint="adds a key to the internal cache">
    	<cfargument name="key" type="string" required="true"/>

		<cfset getZipCache().put(key, now())>
    </cffunction>

    <cffunction name="reap" output="false" access="private" returntype="any" hint="removes old keys, based on the insertion time of the key">
		<cfset var targetTime = dateAdd("s", -variables.reapSeconds, now() )>
		<cfset var key = "">
		<cfset var cache = getZipCache()>
		<cfloop collection="#cache#" item="key">
			<cftry>
				<cfif dateCompare( targetTime, cache[key] ) eq 1>
					<cfset structDelete( cache, key )>
				</cfif>
			<cfcatch>
				<!---not a big deal... we might see this if we hammer the thing pretty hard, when multiple threads attempt to remove the same item, and both Thread 1 and Thread 2 still have the key when they start the loop, and then Thread 1 deletes it. When Thread 2 attempts to delete it, it will have already been removed --->
				<cflog text="Error reaping old stuff: #cfcatch.message#">
			</cfcatch>
			</cftry>

		</cfloop>
    </cffunction>

    <cffunction name="getZipCache" output="false" access="private" returntype="any" hint="">
    	<cfreturn variables.zipCache>
    </cffunction>


    <cffunction name="getVars" output="false" access="public" returntype="any" hint="for instructional purposes only, so you can easily visualize the guts of this thing">
    	<cfreturn variables>
    </cffunction>

</cfcomponent>