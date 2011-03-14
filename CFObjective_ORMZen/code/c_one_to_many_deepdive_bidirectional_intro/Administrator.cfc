component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="administratorName";
	property name="firstName";
	property name="lastName";
	property name="ModifiedBy";

	// 1. Turn this into a one-to-many collection of Administered Events
	
	property name="administeredEvents" persistent="false";// fieldtype="one-to-many" fkcolumn="ModifiedBy" cfc="Event";

	function init(){
		// 2. I always init any one-to-many properties with an empty array
		administeredEvents = [];
	}

}
