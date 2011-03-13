<cfscript>
	ormReload();

	event = entityLoad("Event", {}, {maxresults=1} )[1];
	attendee = entityLoad("Attendee", {}, {maxresults=1} )[1];
	comment = new EventComment();
	comment.setComment("We loved it! #getTickCount()#");
	comment.setCreateDate(now());

	comment.setAttendee(attendee);
	comment.setEvent(event);
	event.addEventComment(comment);

	/**
	* LOOK AT THE CONSOLE OUTPUT... SEE THE INSERT, AND THEN THE UPDATE, IF YOU DON'T USE INVERSE=TRUE
	*/
	transaction{
		entitySave(event);
	}

/*
	comment.setComment("The more I think about it, the more I did not like it");
	transaction{
		entitySave(event);
	}
*/
	
	for( comment in event.getEventComments() ){
		if( true ){ // in real life this would be replaced by some logic determining whether to remove the object
			event.removeEventComment(comment);
		}
	}

/*
	event.removeEventComment(comment);
	comment.setEvent(javacast("null",""));
	transaction{
		entitySave(event);
	}
*/


	//writedump( var = comment, top = 5 );
</cfscript>