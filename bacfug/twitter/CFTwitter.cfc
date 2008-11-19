<cfcomponent output="false">
    <cfscript>
        
    this.twitterProps = createObject("component","Twitter");
    
    
    function setTwitterProperties(propObj){
     this.twitterProps = propObj;
    }
       
        
    function init(username,password){
      verifyCredentials(username,password);
      this.username = username;
      this.password = password;
      return this;
    }
    
    
    function getFriends(){
      //fail to do
    }
    
   function getMyTimeline(cnt){
      var count = iif(isdefined("arguments.cnt"),de(arguments.cnt),10);
      var x = fetch(url=this.twitterProps.myAtom & "?count=#count#",username=this.username,password=this.password);
      return cfFeedWrapper(xml=x);
    }
    
    function getFriendsTimeline(cnt){
      var count = iif(isdefined("arguments.cnt"),de(arguments.cnt),10);
      var x = fetch(url=this.twitterProps.friendsAtom & "?count=#count#",username=this.username,password=this.password);
      return cfFeedWrapper(xml=x);
    }
    
    function verifyCredentials(username,password){
     results = fetch(url=this.twitterProps.authUrl,username=username,password=password);
     if(!results.equals(this.twitterProps.authResponse)){
       throwException(type="cftwitter.exception.authexception",message="Authentication Failure", detail="Failure logging into Twitter for #arguments.username#");
     }
    }
    
  </cfscript>


   
 <cffunction name="printFriendsTimeline" access="public">
   <cfargument name="count" />
	 <cfscript>
	 var user = "";
	 var text = "";
	 var q = getFriendsTimeline(count);
	</cfscript>
	 <table border="0">
	 <cfoutput query="q">
	  <tr style="padding:4px;border-top:1px ridge gray">	
	       <cfscript>
		      user = listGetAt(q.title,1,":");
		      text = replace(q.title,user, '<a href="http://twitter.com/#user#">#user#</a>');
		    </cfscript>  
		   <td  valign="top">  
		    <img src="#listGetAt(q.linkhref,2)#" align="absmiddle"/>
		   </td> 
	       <td valign="top" style="position:relative;left:4;font-size:12px">#text#</td> 
	 </tr>
	 </cfoutput>
	 </table>

</cffunction> 
    
    
   <cffunction name="cfFeedWrapper" hint="cffeed wrapper for cfscript">
       <cfscript>
        //cffeed needs a file or url
        var f = getDirectoryFromPath(getCurrentTemplatePath()) & "/#createUUID()#.xml";    
        fileWrite(f,arguments.xml); 
       </cfscript>
       <cffeed  action="read" source="#f#" query="q" />
       <cfset fileDelete(f) />
       <cfreturn q />
   </cffunction> 
   
   <cffunction name="fetch" hint="http wrapper">
     <cfhttp url="#arguments.url#" username="#arguments.username#" password="#arguments.password#" /> 
     <cfreturn cfhttp.FileContent />
    </cffunction>
    
    <cffunction name="throwException" hint="exception wrapper">
        <cfthrow type="#arguments.type#" message="#arguments.message#" detail="#arguments.detail#">
    </cffunction>
   
</cfcomponent>