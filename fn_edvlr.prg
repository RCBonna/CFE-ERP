/*---------------------------------------------------------------------------*/
static VLR:={}
static NUMEROS:={	{'     ??','???????','???????','??   ??','???????','???????','???????','???????','???????','???????','  ','  '},;
						{'     ??','     ??','     ??','??   ??','??     ','??     ','     ??','??   ??','??   ??','??   ??','  ','  '},;
						{'     ??','???????','???????','???????','???????','???????','     ??','???????','???????','??   ??','  ','  '},;
						{'     ??','??     ','     ??','     ??','     ??','??   ??','     ??','??   ??','     ??','??   ??','  ','??'},;
						{'     ??','???????','???????','     ??','???????','???????','     ??','???????','     ??','???????','  ',' ?'}}

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
//function FN_EDVLR()

static function MOSTRAV(P1,P2,DESC,TOTAL)
local DD
local X,X1,X2:={07,11}
set deci to 5
TOTAL:=round(P1[1]*P2[1,1]+;
				 P1[2]*P2[2,1]+;
				 P1[3]*P2[3,1]+;
				 P1[4]*P2[4,1]+;
				 P1[5]*P2[5,1]+;
				 P1[6]*P2[6,1]+;
				 P1[7]*P2[7,1]+;
				 P1[8]*P2[8,1]+;
				 P1[9]*P2[9,1],3)-DESC
DD   :=str(TOTAL,6,2)
set deci to
for X:=1 to len(DD)
	X1:=at(substr(DD,X,1),'1234567890 .')
	X1:=if(X1<1,11,X1)
	for X3:=1 to 5
		@X2[1],X2[2] say NUMEROS[X3,X1]+space(2)
		X2[1]++
	next
	X2[1]:=7
	X2[2]+=len(NUMEROS[1,X1])+1
next
return .T.

//------------------------------------------------------------------------
function MOSTRA_NUM(LINHA,DD)
local X,X1,X2:={LINHA,2}
salvacor(SALVA)
setcolor('R/W*,R/W,,,R/W*')
scroll(1,1,5,58)
for X:=1 to len(DD)
	X1:=at(substr(DD,X,1),'1234567890 .')
	X1:=if(X1<1,11,X1)
	for X3:=1 to 5
		@X2[1],X2[2] say NUMEROS[X3,X1]+space(2)
		X2[1]++
	next
	X2[1]:=LINHA
	X2[2]+=len(NUMEROS[1,X1])+1
next
salvacor(RESTAURA)
return .T.
