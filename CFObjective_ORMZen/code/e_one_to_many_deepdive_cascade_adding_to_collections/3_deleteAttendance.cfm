<cfscript>
ormReload();

event = entityLoad("Event", {}, {maxresults=1})[1];
attendee = entityLoad("Attendee", {}, {maxresults=1})[1];

//create the entity which "wraps" this relationship and enables additional data
attendance = new Attendance();
attendance.setIsVIP(true);
attendance.setSignupDate(now());
attendance.setEvent(event);

//set BOTH sides of the relationship!
attendance.setAttendee(attendee);
attendee.addAttendance(attendance);
entitySave(attendance);
transaction{}

/*
* 1. Column 'AttendeeID' cannot be null. 

NOW: Remove the attendance from the attendee

*/

attendee.removeAttendance(attendance);
attendance.setAttendee(javacast("null","null"));
transaction{}

writeDump( var = attendee, top = 3 );
</cfscript>