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
	//when using a linktable -- which you can ONLY realistically use when you have a simple 2-column join table,
	//you must specify the fkcolumn and the inversejoincolumn
	//for fun: remove "inversejoincolumn" and see what error you get when trying to add an attendee
	property name="attendees" fieldtype="one-to-many" cfc="Attendee"
		linktable="J_Events_Attendees"
		fkcolumn="EventID"
		inversejoincolumn="AttendeeID"
		singularname="attendee"
		cascade="all-delete-orphan";


	property name="eventComments" fieldtype="one-to-many" cfc="EventComment"
		fkcolumn="EventID"
		singularname="eventComment"
		cascade="all-delete-orphan"
		; //inverse="true";
}
