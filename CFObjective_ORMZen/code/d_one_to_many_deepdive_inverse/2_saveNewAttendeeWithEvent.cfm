<cfscript>
ormReload();

//load the event the attendee wants to view. pretend this is an object returned from a search
event = entityLoad("Event", {}, {maxresults=1})[1];

//create and save an attendee
attendee = new Attendee();
attendee.setFirstName('Homer #getTickCount()#');
attendee.setLastName('Simpson');
attendee.setCompany('Power Plant');
entitySave(attendee);
transaction{}

//create the entity which "wraps" this relationship and enables additional data
attendance = new Attendance();
attendance.setIsVIP(true);
attendance.setSignupDate(now());
attendance.setEvent(event);

//set BOTH sides of the relationship!
attendance.setAttendee(attendee);
attendee.addAttendance(attendance);

/* 1. This is one way of getting around the error below, but often we might not want to do this, 
			so we need to learn how to properly handle 'transient' joined entities

entitySave(attendance);
transaction{}
*/	


/**

	2. SUFFERING!

* Oh Joy:
*
* The root cause of this exception was: 
	coldfusion.orm.hibernate.HibernateSessionException: 
	object references an unsaved transient instance - 
	save the transient instance before flushing: Attendee.
*

*/
entitySave(attendee);
transaction{}





writeDump( var = attendee, top = 3 );
</cfscript>

