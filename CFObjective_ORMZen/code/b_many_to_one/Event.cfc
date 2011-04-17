component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="eventName";
	property name="eventDate";
	property name="isActive";

	// 1. Turn this into a many-to-one relationship with an Administrator object
	
	//many-to-one: Many events can have this one Administrator; 
		//Or, this one administrator can modify many events
	//many-to-one properties are ALWAYS a single object, not a collection. 
		//The "one" in "many-to-one" indicates "one" object

	property name="ModifiedBy"
		; // fieldtype="many-to-one" fkcolumn="ModifiedBy" cfc="Administrator";
}
