<cfparam name="url.showsql" default="false">
<cfsetting showdebugoutput="false">
<cfsilent>

<cfsavecontent variable="sql">
select distinct PhysicalFileName

from j_templatesections_attachmentlocations_locationtypes big
		join attachmentlocations al on big.locationid = al.locationid
		join j_templatesections_attachmentlocations_attachments big2 on 
big.locationid=big2.locationid
		join attachments a on big2.attachmentid=a.attachmentid
		where locationtypeid=1
</cfsavecontent>

<cfquery datasource="#url.dsn#" name="q">
#sql#
</cfquery>
<cfset str = ValueList(q.PhysicalFileName)>
<cfif url.showsql>
<cfset str = sql & "<br><br>" & str>
</cfif>
</cfsilent>
<cfoutput>#str#</cfoutput>