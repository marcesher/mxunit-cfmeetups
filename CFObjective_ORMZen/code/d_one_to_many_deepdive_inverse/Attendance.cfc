component persistent="true" accessors="true" table="j_events_attendees"{

	property name="id" fieldtype="id" generator="native";
	property name="event" fieldtype="many-to-one" fkcolumn="EventID" cfc="Event";  
	
	//this is one side of the bidirectional relationship; 
	//the one-to-many attendances property in Attendee.cfc is the other side
	property name="attendee" fieldtype="many-to-one" fkcolumn="AttendeeID" cfc="Attendee";
		
	   
	property name="isVIP" type="boolean";
	property name="signupDate" type="date";        
}   