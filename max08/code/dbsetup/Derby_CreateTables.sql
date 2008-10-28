CREATE TABLE Users
    (UserID INT PRIMARY KEY NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Username varchar(100),
    Password varchar(100)
);



CREATE TABLE Permissions
(
    PermissionID INT Primary Key NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    PermissionName varchar(50)
);  


CREATE TABLE J_Users_Permissions
(
    UserID INT,
    PermissionID INT,
    Primary key (UserID, PermissionID)
);  
