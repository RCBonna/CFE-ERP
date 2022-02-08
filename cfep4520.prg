*-----------------------------------------------------------------------------*
function CFEP4520() // Correcao de Precos GRUPOS										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_PERCE
local VM_DATA
private VM_GRINI
private VM_GRFIN
pb_lin4(_MSG_,ProcName())
if !abre({'R->PARAMETRO','R->GRUPOS','E->PROD'})
	return NIL
end
dbsetorder(1);DbGoTop()
VM_PERCE=0
VM_DATA=PARAMETRO->PA_DATA-7
VM_GRINI=0
VM_GRFIN=0
if xxsenha(ProcName(),'Correcao de Precos - GRUPOS')
	pb_box(15,25,,,,'Selecione')
	@16,26 say 'Percentual.........:' get VM_PERCE picture masc(6)
	@17,26 say 'Adquiridos antes de: ' get VM_DATA picture masc(7)
	@20,26 say 'Grp INICIAL........:' get VM_GRINI picture masc(13) valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},,{2,1}})
	@21,26 say 'Grp FINAL..........:' get VM_GRFIN picture masc(13) valid fn_codigo(@VM_GRFIN,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIN,6)))},,{2,1}})
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		dbseek(str(VM_GRINI,6),.T.)
		pb_msg('AGUARDE ... Atualizando Vlr.Venda',1,.F.)
		dbeval({||CFEP4511(VM_DATA,VM_PERCE)},,{||PR_CODGR<=VM_GRFIN})
	end
end
setcolor(VM_CORPAD)
dbcloseall()
return NIL
