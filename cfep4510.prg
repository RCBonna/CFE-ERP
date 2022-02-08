*-----------------------------------------------------------------------------*
function CFEP4510()	// Correcao de Precos - GERAL										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_PERCE:= 0.00
local VM_DATA 
pb_lin4(_MSG_,ProcName())
if !abre({'R->PARAMETRO','E->PROD'})
	return NIL
end
if xxsenha(ProcName(),'Correcao de Precos/GERAL')
	pb_box(18,25)
	VM_DATA := PARAMETRO->PA_DATA-7
	@19,26 say 'Percentual..........:'  get VM_PERCE picture masc(6)
	@20,26 say 'Adquiridos antes de.: ' get VM_DATA  picture masc(7)
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		dbsetorder(2)
		DbGoTop()
		pb_msg('AGUARDE, Atualizando Vlr.Venda.',NIL,.F.)
		dbeval({||CFEP4511(VM_DATA,VM_PERCE)})
	end
end
setcolor(VM_CORPAD)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP4511(P1,P2)
if PR_DTCOM<=P1
	@21,26 say str(PR_CODPR,5)+' - '+PR_DESCR
	replace PR_VLVEN with round((PR_VLVEN+(PR_VLVEN*(P2/100))),2)
end
return NIL
