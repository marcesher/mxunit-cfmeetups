<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>
root = '/cfobjective/esapilite';
configPath = ExpandPath('/#root#/esapi.xml');
</cfscript>

<cffunction name="testData" access="private">
<cf_querysim>
data
id,name,type,xdata
1|goodcc1|credit card|1234 9876 0000 0008
2|goodcc2|credit card|1234987600000008
3|baddcc1|credit card|12349876000000081
4|baddcc1|credit card|4417 1234 5678 9112
5|goodssn1|ssn|123-65-4569
6|badssn1|ssn|1236-5-5690
</cf_querysim>
<cfreturn data />
</cffunction>

<cffunction name="getItem" access="private">
 <cfargument name="name" />
 <cfset var data = testData() />
 <cfquery name="q" dbtype="query" maxrows="1">
     select * from data where name = '#arguments.name#'
 </cfquery>
 <cfreturn q.xdata />
</cffunction>

</cfcomponent>