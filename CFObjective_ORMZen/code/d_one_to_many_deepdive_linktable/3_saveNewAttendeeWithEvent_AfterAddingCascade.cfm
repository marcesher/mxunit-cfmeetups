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

	/* NO NEED FOR THIS NOW THAT WE HAVE CASCADE SET ON EVENT'S ATTENDEES PROPERTY!
	transaction{
		entitySave(attendee);
	}
	*/

}

//load the event the attendee wants to view. pretend this is an object returned from a search
event = entityLoad("Event", {}, {maxresults=1})[1];

if( not event.hasAttendee(attendee)){
	event.addAttendee(attendee);
}

/* NOTE: if this still errors, it's because "cascade=all" is still not set on the Event.cfc's "attendees property"*/
transaction{
	entitySave(event);
}

</cfscript>