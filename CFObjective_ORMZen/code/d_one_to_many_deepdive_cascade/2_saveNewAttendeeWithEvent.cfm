<cfscript>
ormReload();

//fake an attendee lookup
formStruct = { firstName = "Homer_#getTickCount()#", lastname = "Simpson", company = "Power Plant"};

potentialAttendee = entityLoad("Attendee", {firstname = formStruct.firstName, lastname = formStruct.lastname });
if( arrayLen(potentialAttendee) ){
	attendee = potentialAttendee[1];
} else {
	attendee = new Attendee();
	attendee.setFirstName(formStruct.firstName);
	attendee.setLastName(formStruct.lastName);
	attendee.setCompany(formStruct.company);
	entitySave(attendee);
	transaction{};
}

//load the event the attendee wants to view. pretend this is an object returned from a search
event = entityLoad("Event", {}, {maxresults=1})[1];

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
* The root cause of this exception was: coldfusion.orm.hibernate.HibernateSessionException: object references an unsaved transient instance - save the transient instance before flushing: Attendee.
*

*/
transaction{
	entitySave(attendee);
}

writeDump( var = attendee, top = 3 );
</cfscript>