*-----------------------------------------------------------------------------*
function CFEP4530() // Correcao de Precos - PRODUTO									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_CODPR:=0
local VM_VLVEN:=0
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->GRUPOS',;
				'C->PROD'})
	return NIL
end
dbsetorder(2)
DbGoTop()
set decimals to 3
if xxsenha(ProcName(),'Correcao de Precos/PRODUTO')
	while lastkey()#27
		pb_box(17,25,,,,'Selecione')
		@19,26 say "Produto....:" get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,77).and.fn_rtunid(VM_CODPR).and.(VM_VLVEN:=PR_VLVEN)>=0.and.RecLock()
		@21,26 say "Vlr.Venda..:" get VM_VLVEN picture masc(27) valid VM_VLVEN>0
		read
		if if(lastkey()#K_ESC,pb_sn('Alterar para novo Valor:'+transform(VM_VLVEN,masc(53))),.F.)
			replace PR_VLVEN with VM_VLVEN
			dbskip()
			VM_CODPR:=PR_CODPR
		end
		dbrunlock(recno())
	end
end
setcolor(VM_CORPAD)
dbcloseall()
set decimals to 
return NIL
// eof //
