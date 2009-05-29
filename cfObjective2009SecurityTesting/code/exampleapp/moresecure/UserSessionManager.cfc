<cfcomponent output="false">
  <!---
    Ideally, you would abstract out all Session management to a
    separate object such as this. This allows you to control the
    session details much better. As a direct result, you can also
    test session management easier through the use of mocks.


    Example

    <cfscript>

    function setUserSession(userRef) {
      session.userRef = arguments.userRef;
    }

    function clearSession(){
      structClear(session)l
    }

    </cfscript>




   --->

</cfcomponent>