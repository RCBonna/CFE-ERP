*-----------------------------------------------------------------------------*
function CFEPIECP()	//	Edita Cota parte
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

ASSINATURA:=restarray('ASSINATU.ARR')

pb_box(19,20,,,,'Selecao Associado')
select CLIENTE
dbgobottom()
VM_CLI2:=CL_CODCL
DbGoTop()
VM_CLI1:=CL_CODCL
@20,22 say 'Inicial:' get VM_CLI1  pict mI5   valid fn_codigo(@VM_CLI1,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI1,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@21,22 say 'Final..:' get VM_CLI2  pict mI5   valid fn_codigo(@VM_CLI2,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI2,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.f.)
	REL:='Extrado Conta Parte'
	LAR:=80
	PAG:=0
	select COTAS
	dbseek(str(VM_CLI1,5),.T.)
	while !eof().and.CP_CODCL<=VM_CLI2
		VM_Q :=CP_CODCL
		TOTAL:=0
		if Cp_Tem_Saldo(VM_Q)
			dbseek(str(VM_Q,5),.T.)
			fn_cabec()
			while !eof().and.CP_CODCL==VM_Q
				if prow()>60
					eject
					fn_cabec()
				end
				? dtoc(CP_DATAE)+space(1)
				??left(CP_HISTOR,54)
				??transform(CP_VALOR,mD132)
				TOTAL+=CP_VALOR
				pb_brake()
			end
			?replicate('-',LAR)
			?padr('Total do Associado',65)+transform(TOTAL,mD132)
			?replicate('-',LAR)
			?
			?
			?ASSINATURA[1]
			?ASSINATURA[2]
			?ASSINATURA[3]
			eject
		else
			dbseek(str(VM_Q,5)+'ZZZ',.T.)
		end
	end
	pb_deslimp()
end
dbcloseall()
return NIL

static function FN_CABEC()
PAG++
?VM_EMPR+space(50)+'Folha :'+str(PAG,3)
?
?padc('Extrato de Cotas Parte',LAR)
?
?'Associado:'+INEGR+CLIENTE->CL_RAZAO+CNEGR+space(2)+'('+pb_zer(CP_CODCL,5)+')'
?
?'Data Lcto Historico'+space(56)+'Valor'
?replicate('-',LAR)
return NIL

*-------------------------------------------------------------------------------
function CP_TEM_SALDO(P1,P2)
*-------------------------------------------------------------------------------
local RT :=.T.
local Reg:=0
P2:=0.00
SALVABANCO
select COTAS
Reg:=RecNo()
dbseek(str(P1,5),.T.)
while !eof().and.CP_CODCL==P1
	P2+=CP_VALOR
	dbskip()
end
DbGoTo(Reg)
RESTAURABANCO
if str(P2,15,2)#str(0,15,2)
	RT:=.T.	// tem saldo
else
	RT:=.F.	// nao tem saldo
end
return RT
