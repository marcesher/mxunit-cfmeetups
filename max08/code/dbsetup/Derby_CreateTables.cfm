
<cfset drops = "drop table j_users_permissions,drop table permissions,drop table users">

<cfloop list="#drops#" delimiters="," index="d">
	<cftry>
		<cfquery datasource="unittest" name="q">
		#d#	
		</cfquery>
	<cfcatch></cfcatch>
	</cftry>
</cfloop>


<cfquery datasource="unittest" name="q">
CREATE TABLE Users
    (UserID INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Username varchar(100),
    Password varchar(100)
)
</cfquery>

<cfquery datasource="unittest" name="q">
CREATE TABLE Permissions
(
    PermissionID INT Primary Key NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    PermissionName varchar(50)
)

</cfquery>

<cfquery datasource="unittest" name="q">
CREATE TABLE J_Users_Permissions
(
    UserID INT,
    PermissionID INT,
    Primary key (UserID, PermissionID)
) 

</cfquery>
