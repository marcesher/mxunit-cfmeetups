<!--- of course you'd never write this kind of form deal in the real world and would be using MVC with a controller, view, and service layer. 
but this is a demo, so....
 --->

<cfparam name="url.AttendeeID" default="1">
<cfparam name="form.EventID" default="">
<cfset attendee = entityLoadByPK("Attendee", url.AttendeeID)>

<cfif structkeyExists( form, "submit" )>
	<cfscript>
	ormReload();
	
	//array of Event IDs that are selected on the form
	eventIDs = listToArray(form.eventID);
	
	//array of Event IDs that are already associated with this Attendee
	alreadyLinked = [];	
	for( attendance in attendee.getAttendances() ){
		arrayAppend(alreadyLinked, attendance.getEvent().getID());
	}
	
	writeOutput("Currently linked: #arrayToList(alreadyLinked)#. Incoming EventIDs: #arrayToList(eventIDs)#");
	
	//loop from the bottom and unlink if a currently linked event is no longer selected
	for( i = arrayLen( attendee.getAttendances() ); i > 0; i-- ){
		thisAttendance = attendee.getAttendances()[i];
		if( NOT arrayFind( eventIDs , thisAttendance.getEvent().getId() ) ){
			//unset both sides!
			thisAttendance.setAttendee( javacast("null","") );
			attendee.removeAttendance( thisAttendance );
		}
	}
	
	//link any events which the user has selected and which are not already belonging to the user
	for( id in eventIDs ){
		if( NOT arrayFind(alreadyLinked, id) ){
			attendance = new Attendance();
			//set both sides!
			attendance.setAttendee( attendee );
			attendee.addAttendance( attendance ); 
			
			attendance.setEvent( entityLoadByPK("Event", id) );
			attendance.setSignupDate( now() );
		}
	}
	
	
	//commit; we don't need entitySave because the Attendee object came from entityLoad and thus was already in the session
	transaction{}
	</cfscript>
</cfif>

<cfquery name="getMyEvents">
select e.id as EventID, e.EventName, e.EventDate, a.id as AttendeeID, a.FirstName, a.LastName
from event e
left outer join j_events_attendees j on e.id = j.EventID
  and j.AttendeeID = <cfqueryparam value="#url.attendeeID#" cfsqltype="cf_sql_integer" />
left outer join attendee a on j.AttendeeID = a.id
</cfquery>

<h1>Events for Attendee <cfoutput>#attendee.getFirstName()# #attendee.getLastName()#</cfoutput></h1>
<form action="" method="post">
	
	<cfoutput query="getMyEvents">
		<cfset checked = isNumeric(getMyEvents.AttendeeID[currentRow])>
		<input type="checkbox" name="eventID" value="#EventID#" #IIF( checked , DE('checked'), DE('') )#>	
			<b>#EventName#</b> -- #dateFormat(eventDate, "short" )#
			<br>
	</cfoutput>
	
	<input type="submit" name="submit" value="Update">
</form>