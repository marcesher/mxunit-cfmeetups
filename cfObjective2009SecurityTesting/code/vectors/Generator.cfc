<cfcomponent>
<cfscript>
 loader = createObject('component' , 'cfobjective.code.esapilite.org.owasp.esapi.ClassLoader').init();
 randomizer = loader.create('org.owasp.esapi.ESAPI').randomizer();


 function genRandomInteger(min,max){
   return randomizer.getRandomInteger(min,max);
 }

 function genRandPassword(){
   var anInt = genRandomInteger(0,9);
   var anUpper = randomizer.getRandomString(1, upperCharset);
   var aLower = randomizer.getRandomString(1, lowerCharset);
   var special = randomizer.getRandomString(1, specialCharset);
   var temp = randomizer.getRandomString(6, asciiCharset);
   var pwd = anUpper & special & temp & anInt & aLower;
   pwd = randomizer.getRandomString(10, pwd.toCharArray());
   return pwd;

 }

 function getAnInt(){
  return genRandomInteger(0,9);
 }

</cfscript>

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