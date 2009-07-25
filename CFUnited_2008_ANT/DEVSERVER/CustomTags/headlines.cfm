<cfparam name="news" default="topstories">
<cfsetting enablecfoutputonly="yes">
<!-------
     CF_HEADLINES v1.1 (Freeware) - Released 07/09/2001
     Written by Wes Royer - work@openupandsay.com 
     Copyright © 2001 NetworkOfMinds.com  All rights reserved.
     Note1: go to BigNewsNetwork.com for your 'news' variable options.
     Note2: latest version added Dave Barry headlines pulled from Miami Herald; use 'davebarry' as your 'news' variable.
------->
<cfif news eq "davebarry">
     <cfset set_http = "http://www.miami.com/herald/special/features/barry/">
<cfelse>
     <cfset set_http = "http://www.bignewsnetwork.com/archive/headlines/livenews.html/t3/mnews-index_" & #news# & ".html&maxheadlines=5">
</cfif>
<cfhttp url="#set_http#" method="get" resolveurl="yes" timeout="20"></cfhttp>
     <cfif #news# eq "davebarry">
          <cfset list_headlines = QueryNew("headlines_url, headlines_title")>
          <cfset posurl = "http://www.miami.com/herald/special/features/barry/">
          <cfset dbstart = #find('Recent Columns', cfhttp.filecontent, 1)#>
          <cfset dbend = #find('Past Columns', cfhttp.filecontent, 1)#>
          <cfset set_content = #mid(cfhttp.filecontent, dbstart, dbend - dbstart)#>
     <cfelse>
          <cfset list_headlines = QueryNew("headlines_url, headlines_title, headlines_extra")>
          <cfset posurl = "http://c.moreover.com/click/here.pl?">
          <cfset set_content = #cfhttp.filecontent#>
     </cfif>
     <cfset posend = "0">
     <cfset posstart = #FindNoCase(posurl, set_content, posend + 1)#>
     <cfif #posstart# eq "0">
          <cfset posurl = "http://www.miami.com:80/herald/special/features/barry/">
          <cfset posstart = #FindNoCase(posurl, set_content, posend + 1)#>
     </cfif>
<cfloop condition="posstart gt 0">
     <cfset endurl = #find('"', set_content, posstart)#>
     <cfif #endurl# gt "0">
          <cfset this_url = #ReplaceNoCase(mid(set_content, posstart, endurl - posstart), ":80", "", "one")#>
     <cfelse>
          <cfset this_url = "">
     </cfif>

     <cfset starttitle = #find('>', set_content, endurl)#>
     <cfif #starttitle# gt "0">
          <cfset starttitle = #starttitle# + 1>
          <cfset endtitle = #FindNoCase('</a>', set_content, starttitle)#>
          <cfset this_title = #mid(set_content, starttitle, endtitle - starttitle)#>
     <cfelse>
          <cfset this_title = "">
     </cfif>

     <cfif news eq "davebarry">
          <cfif #this_url# neq "" and #this_title# neq "">
               <cfset temprow = #QueryAddRow(list_headlines, 1)#>
               <cfset temp = #QuerySetCell(list_headlines, 'headlines_url', this_url)#>
               <cfset temp = #QuerySetCell(list_headlines, 'headlines_title', this_title)#>
          </cfif>
     <cfelse>
          <cfif #this_url# neq "">
               <cfset startextra = #find('(', cfhttp.filecontent, endtitle)#>
               <cfif #startextra# gt "0">
                    <cfset startextra = #startextra# + 1>
                    <cfset endextra = #find(')', cfhttp.filecontent, startextra)#>
                    <cfset this_extra = #mid(cfhttp.filecontent, startextra, endextra - startextra)#>
               <cfelse>
                    <cfset this_extra = "">
               </cfif>
          <cfelse>
               <cfset this_extra = "">
          </cfif>

          <cfif #this_url# neq "" and #this_title# neq "" and #this_extra# neq "">
               <cfset temprow = #QueryAddRow(list_headlines, 1)#>
               <cfset temp = #QuerySetCell(list_headlines, 'headlines_url', this_url)#>
               <cfset temp = #QuerySetCell(list_headlines, 'headlines_title', this_title)#>
               <cfset temp = #QuerySetCell(list_headlines, 'headlines_extra', this_extra)#>
          </cfif>
     </cfif>

     <cfset posend = #endurl#>
     <cfset posstart = #Find(posurl, set_content, posend + 1)#>
</cfloop>
<cfsetting enablecfoutputonly="no">

<cfif #list_headlines.recordcount# neq "0">
     <cfoutput query="list_headlines">
          <li><p align="left"><a href="#headlines_url#" target="_blank">#headlines_title#</a><br><font face="verdana,arial,helvetica" size="-2" color="808080">(#headlines_extra#)</font></p></li>
     </cfoutput>
<cfelse>
     <p align="center"><font color="#ff0000">Sorry. No headlines to display. Please try again later.</font></p>
</cfif>


