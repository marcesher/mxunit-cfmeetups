<cfscript>
	ormReload();

	event = entityLoad("Event", {}, {maxresults=1} )[1];
	attendee = entityLoad("Attendee", {}, {maxresults=1} )[1];
	
	attendance = new Attendance();
	attendance.setIsVIP(true);
	attendance.setSignupDate(now());
	attendance.setEvent(event);
	
	//set BOTH sides of the relationship!
	attendance.setAttendee(attendee);
	attendee.addAttendance(attendance);
	
	entitySave(attendee);
	transaction{}

	/* 1. Run this and see the concurrentModificationException 
	
	for( attendance in attendee.getAttendances() ){
		if( true ){ // in real life this would be replaced by some logic determining whether to remove the object
			attendance.setAttendee(javacast("null",""));
			attendee.removeAttendance(attendance);
		}
	}
	*/
	
	/* 2. Uncomment this and see how to delete without error 
	
	loop from the bottom and unlink if a currently linked event is no longer selected
	
	*/
	writeOutput("Found #arrayLen(attendee.getAttendances())# attendances");
	
	for( i = arrayLen( attendee.getAttendances() ); i > 0; i-- ){
		thisAttendance = attendee.getAttendances()[i];
		if( i mod 2 eq 0 ){
			//unset both sides!
			thisAttendance.setAttendee( javacast("null","") );
			attendee.removeAttendance( thisAttendance );
		}
	}
	
	entitySave(attendee);
	transaction{}
	

</cfscript>