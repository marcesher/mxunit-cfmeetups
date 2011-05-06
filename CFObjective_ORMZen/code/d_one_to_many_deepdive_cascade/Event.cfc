component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="eventName";
	property name="eventDate";
	property name="isActive";

	//many-to-one: Many events can have this one Administrator; Or, this one administrator can modify many events
	//many-to-one properties are ALWAYS a single object, not a collection. The "one" in "many-to-one" indicates "one" object
	property name="ModifiedBy" fieldtype="many-to-one" fkcolumn="ModifiedBy" cfc="Administrator";

	//one-to-many: This object can have many objects of this property's type
	//one-to-many properties are ALWAYS a collection. The "many" in a "one-to-many" indicates "many" objects
	//Not using "linktable" because our relationship requires more data... (isVIP, signupDate)
	property name="attendees" fieldtype="one-to-many" cfc="Attendance"
		fkcolumn="EventID"
		singularname="attendee"
		;//cascade="all-delete-orphan";
}
