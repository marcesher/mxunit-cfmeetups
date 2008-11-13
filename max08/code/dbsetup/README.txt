--------------------------------
Installing the database
--------------------------------

1) Derby (if you're running cf8)

	You'll need to know where the built-in Derby databases are installed. To do that, simply go into CFAdministrator, go into Datasources, and click on the ArtGallery datasource. This path will be something like:
	
	C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\WEB-INF\cfusion\db\CfArtGallery
	
	The important part here is everything EXCEPT the last folder

	a) in CFAdministrator, create a new Datasource named "UnitTest" with "Apache Derby Embedded" as the type. Click Submit
	b) in the "Folder" field, paste the path to the derby databases, like: C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\WEB-INF\cfusion\db\
		and then add a folder name, like 'UnitTestDatabase'. The folder name doesn't matter. 
	c) click Submit. You now have a datasource.
	d) Open Derby_CreateTables.cfm in a web browser. This will create the tables you'll need.
	e) Open InsertData.cfm in a web browser. This will insert the data.
	
	
2) MySQL
	a) In CFAdministrator, create a new MySQL datasource named "UnitTest".
	b) In MySQL Query Browser or DBVisualizer or whatever it is you use to interact with mysql, run the scripts in MySQL_CreateTables.sql
	c) Open InsertData.cfm in a web browser. This will insert the data.
	
	
VALIDATE:
Run the ValidateDataInsertsTest.cfc testcase in eclipse or a web browser. this will return successful tests if the inserts were successful.