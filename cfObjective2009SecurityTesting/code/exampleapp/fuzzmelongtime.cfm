Big window:<br />
<!--- Simple form --->
<form method="post" action="#">
<textarea name="fuzzme" cols="60" rows="10"></textarea>
<br />
<input type="submit" />
</form>
<hr />
<!--- Echoes directly back to user --->
<cfif structKeyExists(form, 'fuzzme')>
Results: <br />
<cfoutput>#form.fuzzme#</cfoutput>

<p><hr /></p>
<cfoutput>#htmlEditFormat(form.fuzzme)#</cfoutput>
</cfif>
