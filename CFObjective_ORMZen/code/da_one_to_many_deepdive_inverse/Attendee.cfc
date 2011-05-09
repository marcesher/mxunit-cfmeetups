component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="firstName";
	property name="lastName";
	property name="company";
	
	property name="attendances" fieldtype="one-to-many" cfc="Attendance"
		fkcolumn="AttendeeID"
		singularname="attendance"
		//cascade="all" 
		;//inverse="true";
	
	
	
	
	/*
		This is wrong! We cannot use it to save the IsVIP and SignupDate fields!
		
	*/
	property name="IncorrectAttendances" fieldtype="one-to-many" cfc="Event"
	   fkcolumn="AttendeeID"
	   inversejoincolumn="EventID"
	   linktable="j_events_attendees";    
}
