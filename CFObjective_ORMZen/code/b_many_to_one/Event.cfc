component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="eventName";
	property name="eventDate";
	property name="isActive";

	// 1. Turn this into a many-to-one relationship with an Administrator object

	property name="ModifiedBy"; // fieldtype="many-to-one" fkcolumn="ModifiedBy" cfc="Administrator";
}
