*-----------------------------------------------------------------------------*
function CFEP4380()	//	Produtos Estoque Zerado											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_REL:= 'Produtos com Estoque Zerado'
local VM_PAG:=0

pb_lin4(VM_REL,ProcName())

if !abre({'R->PARAMETRO','R->PROD'})
	return NIL
end
dbsetorder(2);DbGoTop()
if pb_ligaimp(I15CPP)
	VM_LAR = 132
	while !eof()
		VM_PAG = pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4380A',VM_LAR)
		if PR_QTATU=0
			?  padr(pb_zer(PR_CODPR,L_P)+chr(45)+PR_DESCR,49)+space(1)
			?? PR_UND+space(6)
			?? PR_LOCAL+space(8)
			?? str(PR_ETMIN,7,2)+space(6)
			?? dtoc(PR_DTMOV)+space(5)
			?? dtoc(PR_DTCOM)+space(8)
			?? transform(PR_VLCOM,masc(2))
		end
		pb_brake()
	end									
	?replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	dbsetorder(1)
end
dbcloseall()
return NIL

function CFEP4380A()
? padr('Produto',50)+'Unidade'+space(4)+'Local'+space(6)+'Est.Minimo'
??space(3)+'Dt.Ult.Mov.  Data Compra  Vlr. Ult Compra'
? replicate('-',VM_LAR)
return NIL
