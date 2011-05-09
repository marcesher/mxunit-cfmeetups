<cfscript>
	ormReload();

	//load the event and attendee objects
	event = entityLoad("Event", {}, {maxresults=1} )[1];
	attendee = entityLoad("Attendee", {}, {maxresults=1} )[1];
	
	// create a new EventComment object
	comment = new EventComment();
	comment.setComment("We loved it! #getTickCount()#");
	comment.setCreateDate(now());

	//populate the many-to-one relationships
	comment.setAttendee(attendee);
	comment.setEvent(event);

	// 3. Save this and inspect the SQL output... notice a single Insert
	transaction{
		entitySave(comment);
	}
	
	/*transaction{
		entityDelete(comment);
	}*/

	writedump( var = comment, top = 5 );
</cfscript>