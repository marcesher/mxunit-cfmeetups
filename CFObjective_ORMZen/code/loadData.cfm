<!---
in cfadmin, for this datasource, click "advanced" and then add allowMultiQueries=true in the "connectstring" box
--->


<cfquery datasource="events" name="load">
delete from eventcomment;
delete from j_events_attendees;
delete from event;
delete from attendee;
delete from administrator where modifiedby is not null;
delete from administrator;


insert into administrator(administratorname,firstname,lastname)
values
	('mesher', 'marc', 'esher')
	,('bob', 'bob', 'israd')
	,('bill', 'bill', 'iscool');

insert into attendee(firstname,lastname,company)
values
	('attendee1', 'mcghee', 'radco')
	,('attendee2', 'mcgillicuddy', 'lameco')
</cfquery>

<cfquery datasource="events" name="getadministratorID">
select min(id) as id from administrator
</cfquery>
<cfset administratorID = getadministratorID.id>

<cfquery datasource="events" name="getAttendee">
select min(id) as id from attendee
</cfquery>
<cfset attendeeID = getAttendee.id>

<cfquery datasource="events" name="updateadministrators">
update administrator set modifiedby = #administratorID#
where id != #administratorID#
</cfquery>

<cfquery datasource="events" name="load">
insert into event(eventname, eventdate, modifiedby)
values
	('event1', #now()#, #administratorID#)
	,('event2', #dateAdd('d', 5, now())#, #administratorID#)
	,('event3', #now()#, #administratorID#)
</cfquery>

<cfquery datasource="events" name="getEventID">
select min(id) as id from event
</cfquery>
<cfset eventID = getEventID.id>

<cfquery datasource="events" name="load">
insert into j_events_attendees(eventid, attendeeid, isVIP, SignupDate)
values
	(#eventID#,#attendeeID#,1, <cfqueryparam value="#now()#" cfsqltype="cf_sql_date" /> );

insert into eventcomment(eventid, attendeeid, Comment, CreateDate)
values
	(#eventID#,#attendeeID#, 'This event rocked!', <cfqueryparam value="#now()#" cfsqltype="cf_sql_date" />);
insert into eventcomment(eventid, attendeeid, Comment, CreateDate)
values
	(#eventID#,#attendeeID#, 'This event was lame!', <cfqueryparam value="#now()#" cfsqltype="cf_sql_date" />);
</cfquery>
