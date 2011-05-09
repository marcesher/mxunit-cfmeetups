<cfscript>
ormReload();

//I'm cheating here
attendance = entityLoad("Attendance", {}, {maxresults=1})[1];
event = attendance.getEvent();
attendee = attendance.getAttendee();

//always set both sides of the relationship
attendance.setAttendee(javacast("null",""));
attendee.removeAttendance(attendance);


/**
	1. SUFFERING!  With inverse=true not turned on:

		The root cause of this exception was: 
		coldfusion.orm.hibernate.HibernateSessionException: 
		Column 'AttendeeID' cannot be null. 
*/
entitySave(attendee);
transaction{}

writeDump( var = attendee, top = 3 );
</cfscript>