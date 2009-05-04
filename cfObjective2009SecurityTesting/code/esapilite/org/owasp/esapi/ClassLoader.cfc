<cfcomponent output="false">
<!-----------------------------------------------------------------------
           Loads all jars located in root/lib.
 ------------------------------------------------------------------------>
<cfscript>
  //To Do: This root, should probably be read from a confi file.

  fileSep = createObject('java','java.lang.System').getProperty('file.separator');
  variables.root =  'cfobjective.code.esapilite';
  variables.libDir = expandPath('#fileSep#cfobjective#fileSep#code#fileSep#esapilite#fileSep#lib');
  variables.paths = arrayNew(1);
  variables.jarsToInclude = '';
  variables.loadFromList = false;
</cfscript>

<cffunction name="init" access="public" returntype="component">
  <cfargument name="libDirectory"  type="string" required="false" default="" hint="The fully qualified path to the a directory containing jars to load." />
  <cfargument name="jarsToInclude" type="string" required="false" default="" hint="A list of jars to load. Default is all in libDirectory." />

  <cfif arguments.libDirectory is not ''>
   <cfset variables.libDir = arguments.libDirectory />
  </cfif>
    <!--- <cfif arguments.jarsToInclude is not ''>
   <cfset variables.jarsToInclude = arguments.jarsToInclude />
   <cfset variables.loadFromList = true />
  </cfif> --->

  <cfset loadClasses() />
  <cfset variables.loader = createObject('component' , root & '.javaloader.JavaLoader').init(paths,true) />
  <cfreturn variables.loader />
</cffunction>


<cffunction name="loadClasses" returntype="any">
  <cfdirectory name="dir" directory="#variables.libDir#" />
  <cfoutput query="dir">
    <cfif type is 'File'>
      <cfif ucase(right(name,3)) is 'JAR'>
       <cfset variables.paths.add(directory & fileSep & name) />
       </cfif>
    </cfif>
  </cfoutput>
</cffunction>

</cfcomponent>