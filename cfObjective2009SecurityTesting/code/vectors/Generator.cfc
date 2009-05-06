<cfcomponent>
<cfscript>
 loader = createObject('component' , 'cfobjective.code.esapilite.org.owasp.esapi.ClassLoader').init();
 randomizer = loader.create('org.owasp.esapi.ESAPI').randomizer();


 //generates a rando int between min and max
 function genRandomInteger(min,max){
   return randomizer.getRandomInteger(min,max);
 }


 //Generates a 12 character password with 2 ints, 4 upper&lower case charctes,
 // and 2 special characters
 //E.g., FcIJ6l6W=?eg 
 function genRandPassword(){
 	
   var aPwd = '';
   var aList = createObject('java','java.util.ArrayList');
   var it = '';
   aList.add( genRandomInteger(0,9) );
   aList.add( genRandomInteger(0,9) );
   aList.add( randomizer.getRandomString(1, upperCharset) );
   aList.add( randomizer.getRandomString(1, upperCharset) );
   aList.add( randomizer.getRandomString(1, lowerCharset) );
   aList.add( randomizer.getRandomString(1, lowerCharset) );
   aList.add( randomizer.getRandomString(1, upperCharset) );
   aList.add( randomizer.getRandomString(1, upperCharset) );
   aList.add( randomizer.getRandomString(1, lowerCharset) );
   aList.add( randomizer.getRandomString(1, lowerCharset) );
   aList.add( randomizer.getRandomString(1, specialCharset) );
   aList.add( randomizer.getRandomString(1, specialCharset) );
   createObject('java','java.util.Collections').shuffle(aList);
   
   it = aList.iterator();
   while(it.hasNext()){
    aPwd &= it.next();
   }

   return aPwd;

 }

 function getAnInt(){
  return genRandomInteger(0,9);
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