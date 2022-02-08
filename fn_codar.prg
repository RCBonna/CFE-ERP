*-----------------------------------------------------------------------------*
* FUNCAO CODIGO DE ARRAY																		*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

function FN_CODAR(P1,P2)

local P3:=restarray(P2)
local RT:=.T.
local TF:=savescreen(5,0,17,60)
local P4:=ascan(P3,{|DET|DET[1]==P1})
if P4==0
	salvacor(SALVA)
	setcolor('W+/RB')
	P4:=abrowse(5,0,17,60,P3,{'Cod.','Descri‡„o'},{5,len(P3[1,2])},{'99999','@KX'})
	restscreen(5,0,17,60,TF)
	salvacor(RESTAURA)
	if P4>0
		keyboard chr(13)
		RT:=.F.
	else
		P4=1
	end
	P1=P3[P4,1]
else
	@row(),col() say '-'+P3[P4,2]
end
return (RT)
*------------------------------------------------EOF---------------------------------------
