*-----------------------------------------------------------------------------*
function CFEPCP01()	//	Lista Cota parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_TPLI:='S'
if !abre({	'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'E->COTAS'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
pb_box(18,20,,,,'Selecione Associados')
select CLIENTE
dbgobottom()
VM_CLI2:=CL_CODCL
DbGoTop()
VM_CLI1:=CL_CODCL

@19,22 say 'Inicial......:' get VM_CLI1  pict mI5   valid fn_codigo(@VM_CLI1,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI1,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@20,22 say 'Final........:' get VM_CLI2  pict mI5   valid fn_codigo(@VM_CLI2,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI2,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@21,22 say 'Tipo Listagem:' get VM_TPLI  pict mUUU  valid VM_TPLI $'ST'  when pb_msg('<S>o Associados com Saldo  <T>odos associados')
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.f.)
	REL  :='Saldo Conta Parte'
	LAR  :=78
	PAG  := 0
	TOTAL:= 0
	dbseek(str(VM_CLI1,5),.T.)
	while !eof().and.CL_CODCL<=VM_CLI2
		PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPCP01C',LAR)
		STOTAL:=0
		if CP_Tem_Saldo(CL_CODCL,@STOTAL).or.VM_TPLI=='T'
			? space(2)+pb_zer(CL_CODCL,5)
			??' - '
			??CL_RAZAO
			??transform(STOTAL,mD132)
			TOTAL+=STOTAL
		end
		pb_brake()
	end
	?replicate('-',LAR)
	?space(2)+padr('Total Cota Parte',53)+transform(TOTAL,mD132)
	?replicate('-',LAR)
	pb_deslimp()
end
dbcloseall()
return NIL

function CFEPCP01C()	//	Lista Cota parte
?space(2)+padr('Associado',57)+'Valor Saldo'
?replicate('-',LAR)
return NIL
