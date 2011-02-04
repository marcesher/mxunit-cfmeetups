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

	/* This is one way of getting around the error below*/
	transaction{
		entitySave(attendee);
	}


}

//load the event the attendee wants to view. pretend this is an object returned from a search
event = entityLoad("Event", {}, {maxresults=1})[1];

if( not event.hasAttendee(attendee)){
	event.addAttendee(attendee);
}

/**
* Oh Joy:
*
* The root cause of this exception was: coldfusion.orm.hibernate.HibernateSessionException: object references an unsaved transient instance - save the transient instance before flushing: Attendee.
*
*/



transaction{
	entitySave(event);
}

writeDump( var = event, top = 3 );
</cfscript>