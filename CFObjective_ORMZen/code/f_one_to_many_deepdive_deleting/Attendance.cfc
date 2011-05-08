component persistent="true" accessors="true" table="j_events_attendees"{

	property name="id" fieldtype="id" generator="native";
	
	property name="attendee" fieldtype="many-to-one" fkcolumn="AttendeeID" cfc="Attendee";
		
	property name="event" fieldtype="many-to-one" fkcolumn="EventID" cfc="Event" cascade="all";     
	property name="isVIP" type="boolean";
	property name="signupDate" type="date";        
}   