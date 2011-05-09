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

	
	transaction{
		entitySave(event);
	}

	/* 1. Run this and see the concurrentModificationException */
	
	for( comment in event.getEventComments() ){
		if( true ){ // in real life this would be replaced by some logic determining whether to remove the object
			event.removeEventComment(comment);
		}
	}
	
	
	/* 2. Uncomment this and see how to delete without error 
	
	comments = event.getEventComments();
	writeOutput("Found #arrayLen(comments)# comments");
	for( c = 1; c <= arrayLen(comments); c++ ){
		if( c mod 2 eq 0 ){
			arrayDeleteAt( comments, c );
		}
	}
	*/
	transaction{
		entitySave(event);
	}
	
	/* 3. For fun... why doesn't this work?
	
	comments = event.getEventComments();
	writeOutput("Found #arrayLen(comments)# comments");
	for( c = 1; c <= arrayLen(comments); c++ ){
		if( c mod 2 eq 0 ){
			transaction{
				entityDelete( comments[c] );
			}
		}
	}
	*/
	

</cfscript>