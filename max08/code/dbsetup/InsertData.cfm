<cfsavecontent variable="sql">
insert into users(firstname,lastname,username,password)
values('Marc','Esher','mesher','mesher')
|
insert into users(firstname,lastname,username,password)
values('Bill','Shelton','bshelton','bshelton')
|
insert into permissions(PermissionName)
values('Kick it')
|
insert into permissions(PermissionName)
values('SmokeStogies')
|
insert into permissions(PermissionName)
values('BuyScotch')
|
insert into permissions(PermissionName)
values('Eat Ice Cream')
|
insert into permissions(PermissionName)
values('Eat Steak')
|
insert into permissions(PermissionName)
values('Play Hookie From Work')
|
insert into j_users_permissions(userid,permissionid)
values(1,1)
|
insert into j_users_permissions(userid,permissionid)
values(1,2)
|
insert into j_users_permissions(userid,permissionid)
values(2,2)
|
insert into j_users_permissions(userid,permissionid)
values(2,3)
</cfsavecontent>

<cfloop list="#trim(sql)#" index="idx" delimiters="|">
	
	<cfquery name="ins" datasource="UnitTest">
	<cfoutput>#trim(preserveSingleQuotes(idx))#</cfoutput>  
	</cfquery>

</cfloop>