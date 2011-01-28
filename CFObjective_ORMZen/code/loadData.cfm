<!---
in cfadmin, for this datasource, click "advanced" and then add allowMultiQueries=true in the "connectstring" box
--->


<cfquery datasource="events" name="load">
delete from j_events_attendees;
delete from event;
delete from attendee;
delete from user where modifiedby is not null;
delete from user;


insert into user(username,firstname,lastname)
values
	('mesher', 'marc', 'esher')
	,('bob', 'bob', 'israd')
	,('bill', 'bill', 'iscool');

insert into attendee(firstname,lastname,company)
values
	('attendee1', 'mcghee', 'radco')
	,('attendee2', 'mcgillicuddy', 'lameco')
</cfquery>

<cfquery datasource="events" name="getUserID">
select min(id) as id from user
</cfquery>
<cfset userID = getUserID.id>

<cfquery datasource="events" name="updateUsers">
update user set modifiedby = #userID#
where id != #userID#
</cfquery>

<cfquery datasource="events" name="load">
insert into event(eventname, eventdate, modifiedby)
values
	('event1', #now()#, #userID#)
	,('event2', #dateAdd('d', 5, now())#, #userID#)
	,('event3', #now()#, #userID#)
</cfquery>

<cfquery datasource="events" name="getEventID">
select min(id) as id from event
</cfquery>
<cfset eventID = getEventID.id>
