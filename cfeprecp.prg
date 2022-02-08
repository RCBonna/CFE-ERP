*-----------------------------------------------------------------------------*
function CFEPRECP()	//	Edita Cota parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'E->COTAS'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
set relation to str(COTAS->CP_CODCL,5) into CLIENTE

pb_box(17,00,,,,'Selecao Impressao')
VM_CLI1:=0
VM_CLI2:=99999
VM_DATA:={boy(boy(date()-1)),eoy(boy(date()-1))}
@18,02 say 'Assoc.Inicial:' get VM_CLI1  pict mI5   valid VM_CLI1==0    .or.fn_codigo(@VM_CLI1,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI1,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@19,02 say 'Assoc.Final..:' get VM_CLI2  pict mI5   valid VM_CLI2==99999.or.fn_codigo(@VM_CLI2,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI2,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@20,02 say 'Data Inicial.:' get VM_DATA[1] pict mDT
@21,02 say 'Data Inicial.:' get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.f.)
	set filter to  CP_CODCL>=VM_CLI1.and.;
						CP_CODCL<=VM_CLI2.and.;
						CP_DATAE>=VM_DATA[1].and.;
						CP_DATAE<=VM_DATA[2]
	DbGoTop()
	REL:='Resumo Conta Parte'
	LAR:=80
	PAG:=0
	TOTALG:=0.00
	while !eof()
		PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPRECPA',LAR)
		VM_Q  :=CP_CODCL
		TOTAL :=0.00
		STOTAL:=0
		if CP_TEM_SALDO(VM_Q,@STOTAL)
			?'Associado:'+CLIENTE->CL_RAZAO+space(2)+'('+pb_zer(CP_CODCL,5)+')'
			while !eof().and.CP_CODCL==VM_Q
				PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPRECPA',LAR)
				? dtoc(CP_DATAE)+space(1)
				??left(CP_HISTOR,54)
				??transform(CP_VALOR,mD132)
				TOTAL+=CP_VALOR
				pb_brake()
			end
		else
			dbseek(str(VM_Q,5)+'ZZZZZZZ',.T.)
		end
		?space(10)+padr('Total',55)+transform(TOTAL,mD132)
		?replicate('-',LAR)
		TOTALG+=TOTAL
	end
	PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPRECPA',LAR)
	?padr('T O T A L   G E R A L',65)+transform(TOTALG,mD132)
	?replicate('-',LAR)
	?'Impresso as '+time()
	pb_deslimp()
end
dbcloseall()
return NIL

function CFEPRECPA()
?'Data Lcto  Historico'+space(55)+'Valor'
?replicate('-',LAR)
return NIL
