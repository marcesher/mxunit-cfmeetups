<cfcomponent output="false">

    <cfscript>
        
    ini = expandPath("/bacfug/ui/credentials");
    
    function getUsernameFromIni(){
      return getProfileString(ini,"section","u");
    }
    
    
    function getPasswordFromIni(){
      return getProfileString(ini,"section","p");    
    }
    
    function getIniPath(){
    	return ini;
    }
    
    </cfscript>

</cfcomponent>