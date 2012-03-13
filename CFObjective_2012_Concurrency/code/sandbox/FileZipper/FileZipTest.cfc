component extends="mxunit.framework.TestCase"{
	
	outputDir = getDirectoryFromPath(getCurrentTemplatePath()) & "/unittestzipoutput/";
	
	function setUp(){
		fileZip = new DuplicatePreventingFileZipper( outputDir ); 
	}
	
	function tearDown(){
		if( directoryExists(outputDir) ){
			directoryDelete(outputDir, true);
		}
	}
	
	function fileZip_should_zip_files(){
		var key = "unittest_#createUUID()#";
		fileZip.zipFiles(key, [getCurrentTemplatePath()] );
		var expectedFilePath = outputDir & key & ".zip";
		assertTrue( fileExists( expectedFilePath ) );
		var fileInfo = getFileInfo(expectedFilePath);
		debug(fileInfo);
		assertTrue( fileInfo.size GT 0 );
	}
	
	function fileZip_should_ignore_obvious_duplicate_submissions(){
		var key = "unittest_#createUUID()#";
		var result = fileZip.zipFiles(key, [getCurrentTemplatePath()] );
		var expectedFilePath = outputDir & key & ".zip";
		assertTrue( fileExists( expectedFilePath ) );
		assertTrue( result.success );
		
		var duperesult = fileZip.zipFiles(key, [getCurrentTemplatePath()] );
		assertFalse( duperesult.success );
		assertTrue( len(duperesult.message) gt 0 );
		
	}
	
	function add_log_space(){
		for(i=1; i <= 5; i++){
			writeLog("");
		}
	}
}