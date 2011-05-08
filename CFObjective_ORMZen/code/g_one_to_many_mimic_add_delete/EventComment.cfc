component persistent="true"{
	property name="id" fieldtype="id" generator="native";
	property name="comment" type="string";
	property name="isVisible" type="boolean" default="true";
	property name="createDate" type="date";

	property name="attendee" fieldtype="many-to-one" cfc="Attendee" fkcolumn="attendeeID";
	property name="event" fieldtype="many-to-one" cfc="Event" fkcolumn="eventID";

}