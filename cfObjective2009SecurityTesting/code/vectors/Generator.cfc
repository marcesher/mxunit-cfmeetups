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
<cfset asciiCharset = listToArray(valueList(randChars.chars)) />
<cfset upperCharset = listToArray(valueList(allcaps.chars)) />
<cfset specialCharset = listToArray(valueList(specialChars.chars)) />
<cfset lowerCharset = listToArray(valueList(lowerCase.chars)) />
</cfcomponent>