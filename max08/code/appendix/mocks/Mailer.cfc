<cfcomponent displayname="Mailer CFC" HINT="For all mail-oriented functions" OUTPUT="No">

	<cffunction name="sendEmails" access="public" hint="sends out an email, currently this is low-tech, event">
		<cfargument name="Recipients" required="Yes" type="string">
		<cfargument name="From" required="Yes" type="string">
		<cfargument name="Subject" required="Yes" type="string">
		<cfargument name="Content" required="Yes" type="string">
		<cfargument name="Type" required="No" type="string" default="html">

		<cfloop list="#arguments.Recipients#" index="SendTo">
			<cfmail to="#SendTo#" from="#arguments.From#" subject="#arguments.Subject#" type="#arguments.Type#">
				#arguments.Content#
			</cfmail>
		</cfloop>
			
	</cffunction>

</cfcomponent>
