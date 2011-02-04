<cfscript>
	ormReload();

	event = entityLoad("Event", {}, {maxresults=1} )[1];
	attendee = entityLoad("Attendee", {}, {maxresults=1} )[1];
	comment = new EventComment();
	comment.setComment("We loved it! #getTickCount()#");
	comment.setCreateDate(now());

	comment.setAttendee(attendee);
	comment.setEvent(event);

	transaction{
		entitySave(comment);
	}

	writedump( var = comment, top = 5 );
</cfscript>