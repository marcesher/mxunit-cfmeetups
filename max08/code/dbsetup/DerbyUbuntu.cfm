
<cfparam name="url.drop" default="false" />
<cfset dsn = "UnitTest">
  

<cfif url.drop>
	<cfquery name="q" datasource="#dsn#">
	 drop TABLE Users
	</cfquery>
	
	<cfquery name="q" datasource="#dsn#">
	 drop TABLE Permissions
	</cfquery>
	
	<cfquery name="q" datasource="#dsn#">
	 drop TABLE J_Users_Permissions
	</cfquery>
</cfif>



<cfquery name="q" datasource="#dsn#">
CREATE TABLE Users
(
   UserID INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Username varchar(100),
    Password varchar(100)
)
</cfquery>

<cfquery name="q" datasource="#dsn#">
CREATE TABLE Permissions
(
    PermissionID INT Primary Key NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    PermissionName varchar(50)
)
</cfquery>


<cfquery name="q" datasource="#dsn#">

CREATE TABLE J_Users_Permissions
(    
    UserID INT,
    PermissionID INT,
    Primary key (UserID, PermissionID)
)

</cfquery>

