component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="administratorName";
	property name="firstName";
	property name="lastName";

	// 1. Turn this into a one-to-many collection of Administered Events
	
	//one-to-many: This object can have many objects of this property's type
		// i.e. This 'administrator' can  have many 'events'
		
	//one-to-many properties are ALWAYS a collection. 
		//The "many" in a "one-to-many" indicates "many" objects
	
	property name="administeredEvents" persistent="false";// fieldtype="one-to-many" fkcolumn="ModifiedBy" cfc="Event" singlarName="administeredEvent";

	function init(){
		// 2. I always init any one-to-many properties with an empty array
		administeredEvents = [];
	}

}
