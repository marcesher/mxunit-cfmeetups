							
								<cfset beginformatTags = "<bulletlist>">
								<cfset endFormatTags = "">
								<cfset inBulletList = True>
								<cfset bulletGroup = ""><!--- formatArray[tmpIdx].BulletGroup> --->
								<cfloop condition="(InBulletList EQ True) and (tmpIdx LE indexMax)">
									<cfIf formatArray[tmpIdx].bulletGroup NEQ bulletGroup>
										<cfset beginFormatTags = beginFormatTags & "<bullet>">
										<cfset bulletGroup = formatArray[tmpIdx].bulletGroup>
									</cfif>
									<cfloop index="bullIdx" list="#formatArray[tmpIdx].format#">
										<cfif ((bullIdx NEQ "@b") and (bullIdx NEQ "@bi"))>
											<cfset beginFormatTags = beginFormatTags & "<" & bullIdx & ">">
											<cfset endFormatTags = "</" & bullIdx & ">" & endFormatTags>
										</cfif>
									</cfloop>
									<cfset returnString =returnString & beginFormatTags & ArrayText & endFormatTags>
									<cfset beginFormatTags = "">
									<cfset endFormatTags = "">
									<cfset tmpIdx=tmpIdx + 1>
									<cfif tmpIdx LE indexMax>
										<cfif ListContainsNoCase(formatArray[tmpIdx].format, "@b") EQ 0>
											<cfset inBulletList=False>
										<cfelse>
											<cfset ArrayText = formatArray[tmpIdx].text>
										</cfif>
									</cfif>								
								</cfloop>
								<cfset returnString = returnString & "</bulletlist>">
							
