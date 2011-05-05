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
	* 1. LOOK AT THE CONSOLE OUTPUT... SEE 
		A SELECT
		THE INSERT
		AND THEN THE UPDATE, IF YOU DON'T USE INVERSE=TRUE
	*/
	transaction{
		entitySave(event);
	}

/* 
	2. Does absence of inverse=true have any effect on updates? UnComment to find out
	comment.setComment("The more I think about it, the more I did not like it");
	transaction{
		entitySave(event);
	}
*/

/*
	3. Uncomment this, ensuring inverse=true is not on. BOOM. coldfusion.orm.hibernate.HibernateSessionException: Column 'EventID' cannot be null.
	event.removeEventComment(comment);
	comment.setEvent(javacast("null",""));
	transaction{
		entitySave(event);
	}
*/


	//writedump( var = comment, top = 5 );
</cfscript>