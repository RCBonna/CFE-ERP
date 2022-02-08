*-----------------------------------------------------------------------------*
function fn_mkdel()	//	GRAVA O NUMERO DE REGISTROS DELETADOS POR DBF			*
*-----------------------------------------------------------------------------*
local P1:=padr(alias(),20)
local P2:=restarray('MARKDEL.ARR')
local P3
	P3:=ascan(P2,{|DET|DET[1]==P1})
	if P3==0
		aadd(P2,{P1,0})
		P3:=len(P2)
	end
	P2[P3,2]++
	savearray(P2,'MARKDEL.ARR')
return NIL
