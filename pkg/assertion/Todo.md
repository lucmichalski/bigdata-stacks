# Assert todo

Equal == EQ

Test OK
a == a
[x,y] == [x,y]
[c,a,t] == [t,a,s]

Test KO
b == a
[c,d] == a
[a,b,c] == [x,y,z]
[d,o,g] == [o,g]
[c,c,a,t] == [c,a,t]


Ordered Equal #== OEQ

Test OK
a #== a
[x,y] #== [x,y]

Test KO
[v,l] #== [l,v]

Contains $$ CTN

Le contenu de ASRT doit être présent dans RTRN
Si RTRN posséde plus de valeurs que ASRT => Contains est OK

Test OK
a $$ a
g $$ [d,o,g]
[x,y] $$ [y,x]
[c,a,t] $$ [c,a,t,s]

Test KO
[c,a,t] $$ [d,o,g]
[cat] $$ [c,a,t]
c $$ [d,o,g]
[c,a,t] $$ d


Strictly Contains [$$] SCTN
Le contenu de RTRN doit être présent dans ASSRT
Si RTRN posséde plus de valeurs que ASRT => Contains est OK

Test OK
a $$ a
g $$ [d,o,g]
[x,y] $$ [x,y]
[c,a,t] $$ [t,a,s]

Test KO
[c,a,t] $$ [d,o,g]
[cat] $$ [c,a,t]
c $$ [d,o,g]
[c,a,t] $$ d

SubString Contains s$$ sCTN
Le contenu de ASRT doit être présent dans RTRN
Si RTRN posséde plus de valeurs que ASRT => Contains est OK