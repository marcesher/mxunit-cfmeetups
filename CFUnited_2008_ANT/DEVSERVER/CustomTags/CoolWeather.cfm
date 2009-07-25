<!--- 

	Weather 
	
	The purpose of this custom tag is to pull the weather from weather.com
	and return the data into a dynamic query that is set by the calling tag
	
	Please see the example file that came with the tag for all the details
	
	The information we get will be returned 

--->

<!--- Let's set some default values --->
<cfif ParameterExists(attributes.timeout)>
	<cfset li_timeout = #attributes.timeout#>
<cfelse>
	<cfset li_timeout = "60">
</cfif>
<cfif ParameterExists(attributes.days)>
	<!--- Ok so they picked the days let's make sure they didn't go too high --->
	<cfif attributes.days gt 10>
		<!--- Well even though I told them they went too high, so let's cut it back --->
		<cfset attributes.days = "10">
	</cfif>
<cfelse>
	<cfset attributes.days = "5">
</cfif>


<!--- Let's pull the current Forecast from the big page --->
<cfhttp url="http://www.weather.com/weather/local/#attributes.zipcode#" method="get" port="80" timeout="#li_timeout#" resolveurl="true">

<!--- Let's make sure we got data back --->
<cfif cfhttp.filecontent is "Connection Failure">
	<!--- Well for some reason we didn't get data back so let's show an error --->
	Sorry, we had trouble connecting to weather.com
	<cfabort>
</cfif>

<!--- Let's set a variable with the data --->
<cfset ls_forCon = cfhttp.filecontent>

<!--- Now let's get the current conditions --->
<!--- First let's strip everything up to the image --->
<cfset ls_forCon = mid(ls_forCon,Find("CENTER><IMG",ls_forCon,1)+7,len(ls_forCon)+100000)>
<!--- Now let's get the actual image --->
<cfset ls_currentImage = mid(ls_forCon,1,find("</TD>",ls_forCon,1)-1)>

<!--- Let's see if they wanted to resize the images or not --->
<cfif ParameterExists(attributes.imagesize)>
	<!--- Ok if it does let's resize it --->
	<cfset ls_currentImage = replace(ls_currentImage,"=52","=#attributes.imagesize#","ALL")>
</cfif>

<!--- Now let's strip up to the current tempature --->
<cfset ls_forCon = mid(ls_forCon,find("TempTextA>",ls_forCon,1)+10,len(ls_forCon)+100000)>
<!--- Now let's set the tempature for right now --->
<cfset ls_currTemp = mid(ls_forCon,1,find("</B>",ls_forCon,1)-1)>
<!--- Now let's strip up to the current conditions --->
<cfset ls_forCon = mid(ls_forCon,find("obsTextA>",ls_forCon,1)+9,len(ls_forCon)+100000)>
<!--- Now let's set the current Conditions --->
<cfset ls_currCon = mid(ls_forCon,1,find("</B>",ls_forCon,1)-1)>
<!--- Now let's strip up to what it feels like outside --->
<cfset ls_forCon = mid(ls_forCon,find("obsTextA>",ls_forCon,1)+9,len(ls_forCon)+100000)>
<!--- Now let's set what it feels like out side --->
<cfset ls_feelsLike = mid(ls_forCon,1,find("</B>",ls_forCon,1)-1)>
<!--- Now let's strip out that <BR> --->
<cfset ls_feelsLike = replace(ls_feelsLike,"Feels Like<BR>","","ALL")>

<!--- Let's create an array to add the data to --->
<cfset arWeather=ArrayNew(2)>

<!--- Let's drop the information into the array --->
<cfset arWeather[arraylen(arWeather) + 1][1]="Current">
<cfset arWeather[arraylen(arWeather)][2]="Today">
<cfset arWeather[arraylen(arWeather)][3]="#ls_currCon#">
<cfset arWeather[arraylen(arWeather)][4]="#ls_currTemp#">
<cfset arWeather[arraylen(arWeather)][5]="HIGH">
<cfset arWeather[arraylen(arWeather)][6]="LOW">
<cfset arWeather[arraylen(arWeather)][7]="#ls_currentImage#">
<cfset arWeather[arraylen(arWeather)][8]="#ls_feelsLike#">

<!--- Let's narrow down what we're looking at --->
<cfset start = find('<!-- begin loop -->',ls_forCon)>
<cfset end = find('Time',ls_forCon,start)>
<cfset ls_forCon = mid(ls_forCon,start,end-start)>

<!--- Let's set the day for today --->
<cfset ls_today = #DateFormat(Now(),"ddd")#>

<!--- Let's find the first Forecast and strip everything before it --->
<cfset ls_forCon = mid(ls_forCon,Find("11>",ls_forCon,1),1000000)>

<!--- Let's loop through what is left finding as many days as they wanted up to 10 --->
<cfloop from="1" to="#attributes.days#" index="li_ctr">
	<!--- <cfoutput> --->
		<!--- First let's strip out everything up to the point where we get the image --->
		<cfset ls_forCon = mid(ls_forCon,find("5>",ls_forCon,1)+2,10000000)>
		<!--- Now let's grab the image --->
		<cfset ls_dayIcon = mid(ls_forCon,1,find("</TD>",ls_forCon,1)-1)>
		
		<!--- Let's see if they wanted to resize the images or not --->
		<cfif ParameterExists(attributes.imagesize)>
			<!--- Ok if it does let's resize it --->
			<cfset ls_dayIcon = replace(ls_dayIcon,"=31","=#attributes.imagesize#","ALL")>
		</cfif>
		
		<!--- Now let's strip out up to the daily Forecast --->
		<cfset ls_forCon = mid(ls_forCon,find("5>",ls_forCon,1)+2,10000000)>
		<!--- Now let's set the daily Forecast --->
		<cfset ls_dayForecast = mid(ls_forCon,1,find("</TD>",ls_forCon,1)-1)>
		
		<!--- Now let's strip out up to the daily high --->
		<cfset ls_forCon = mid(ls_forCon,find("><B>",ls_forCon,1)+4,10000000)>
		<!--- Now let's set the daily high --->
		<cfset ls_dayHigh = mid(ls_forCon,1,find("deg;",ls_forCon,1)-2)>
		
		<!--- Now we need to know if they stopped showing the daily high because we've already passed it --->
		<cfset ls_findLow = find("&deg;/",ls_forCon,1)>
		
		<!--- If they've stopped showing it the next tempature will be FAR away so let's look --->
		<cfif ls_findLow gt 10>
			<!--- If they've stopped showing it what we say before is really the low not the high --->
			<cfset ls_dayLow = ls_dayHigh>
			<cfset ls_dayHigh = "-">
		<cfelse>
			<!--- Now let's strip out up to the daily low --->
			<cfset ls_forCon = mid(ls_forCon,find("deg;/",ls_forCon,1)+5,10000000)>
			<!--- Now let's set the daily low --->
			<cfset ls_dayLow = mid(ls_forCon,1,find("deg;<",ls_forCon,1)-2)>
		</cfif>
					
		<!--- Now let's stip to the end of this day so we can begin again --->
		<cfset ls_forCon = mid(ls_forCon,find("</TR>",ls_forCon,1)+5,100000000)>
		
		<!--- Let's populate our array from earlier with all the new informaiton --->
		<cfset arWeather[arraylen(arWeather) + 1][1]="Forecast">
		<cfset arWeather[arraylen(arWeather)][2]="#DateFormat(DateAdd("d",li_ctr -1,Now()),"dddd")#">
		<cfset arWeather[arraylen(arWeather)][3]="#ls_dayForecast#">
		<cfset arWeather[arraylen(arWeather)][4]="TEMP">
		<cfset arWeather[arraylen(arWeather)][5]="#ls_dayHigh#">
		<cfset arWeather[arraylen(arWeather)][6]="#ls_dayLow#">
		<cfset arWeather[arraylen(arWeather)][7]="#ls_dayIcon#">
		<cfset arWeather[arraylen(arWeather)][8]="#ls_feelsLike#">

	<!--- </cfoutput> --->
</cfloop>

<!--- So first let's build the new query with the details --->
<cfset getWeather = QueryNew("Type,Day,Forecast,CurrentTemp,High,Low,Icon,FeelsLike")>

<!--- So now let's populate the query with the data to pass back to them --->
<cfloop from="1" to="#arraylen(arWeather)#" index="li_ctr">
	<!--- Let's add a blank row with each loop to put the data in --->
	<cfset record = QueryAddRow(getWeather,1)>

	<!--- Let's add the information to the query column by column --->
	<cfset record = QuerySetCell(getWeather,"Type",#arWeather[li_ctr][1]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"Day",#arWeather[li_ctr][2]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"Forecast",#arWeather[li_ctr][3]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"CurrentTemp",#arWeather[li_ctr][4]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"High",#arWeather[li_ctr][5]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"Low",#arWeather[li_ctr][6]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"Icon",#arWeather[li_ctr][7]#,li_ctr)>
	<cfset record = QuerySetCell(getWeather,"FeelsLike",#arWeather[li_ctr][8]#,li_ctr)>
</cfloop>

<!--- Now let's pass the query back to the caller --->
<cfset "Caller.#attributes.QueryName#" = getWeather>














