component  persistent="true" accessors="true"{
	property name="id" fieldtype="id" generator="native";
	property name="administratorName";
	property name="firstName";
	property name="lastName";
	
	// 3. how do we turn this into an object and not a simple property, i.e. have ModifiedBy be another Administrator?
	property name="ModifiedBy";
}
