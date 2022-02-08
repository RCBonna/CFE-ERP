*-----------------------------------------------------------------------------*
function CFEPCLCV()	//	Associa Prod & Fornecedor										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CLICONV'})
	return NIL
end

set relation to str(FC_EMPRESA,5) into CLIENTE

pb_dbedit1('CFEPCLC')
VM_CAMPO:=array(5)
VM_CAMPO[1] = 'padr(pb_zer(FC_EMPRESA,5)+chr(45)+CLIENTE->CL_RAZAO,29)'
VM_CAMPO[2] = 'FC_CODIGO'
VM_CAMPO[3] = 'left(FC_NOME,30)'
VM_CAMPO[4] = 'if(FC_ATIVO,"        ","Demitido")'
VM_CAMPO[5] = 'FC_DATAD'

VM_MUSC={masc(1),masc(1),masc(1),masc(1),masc(1)}
VM_CABE={'Empresa','Codigo','Cliente/Convenio','ATIVO','DT DEM' }

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

function CFEPCLC1() // Rotina de Inclus„o
VM_EMPRESA:= FC_EMPRESA
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPCLC0T(.T.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPCLC2() // Rotina de Alteracao
if reclock()
	VM_EMPRESA:= FC_EMPRESA
	CFEPCLC0T(.F.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPCLC0T(VM_FL)
local GETLIST:={},LCONT:=.T.
VM_CODIGO:=FC_CODIGO
VM_NOME  :=FC_NOME
VM_ATIVO :=if(VM_FL,'S',if(FC_ATIVO,'S','N'))
VM_DATAD :=FC_DATAD
pb_box(16,18)
@17,20 say 'Cod.Empresa.....:' get VM_EMPRESA pict masc(4) valid fn_codigo(@VM_EMPRESA,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_EMPRESA,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@18,20 say 'Cod.Funcionario.:' get VM_CODIGO  pict masc(1) valid !empty(VM_CODIGO).and.pb_ifcod2(str(VM_EMPRESA,5)+VM_CODIGO,NIL,.F.,1) when VM_FL
@19,20 say 'Nome Funcionario:' get VM_NOME    pict masc(1) valid !empty(VM_NOME)
@20,20 say 'Ativo (S/N).....:' get VM_ATIVO   pict masc(1) valid VM_ATIVO$'SN'
@21,20 say 'Data Demissao...:' get VM_DATAD   pict masc(8)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_ATIVO:=(VM_ATIVO=='S')
		replace FC_EMPRESA with VM_EMPRESA,;
				  FC_CODIGO  with VM_CODIGO,;
				  FC_NOME    with VM_NOME,;
				  FC_ATIVO   with VM_ATIVO,;
				  FC_DATAD   with VM_DATAD
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------------*

function CFEPCLC3() // Rotina de Pesquisa
VM_CHAVE  = FC_EMPRESA
pb_box(20,26)
@21,30 say 'Empresa: ' get VM_CHAVE pict masc(4)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,5),.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEPCLC4() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir EMPRESA.: '+pb_zer(FC_EMPRESA,5)+'-'+FC_CODIGO+' '+FC_NOME)
	fn_elimi()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*

function CFEPCLC5() //  Impressao
local VM_CPO,VM_FL,X1,X2,VM_REL,VM_PAG
DbGoTop()
VM_EMPRESA:=FC_EMPRESA
pb_box(20,19)
@21,21 say "Empresa..:" get VM_EMPRESA pict masc(4) valid fn_codigo(@VM_EMPRESA,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_EMPRESA,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	VM_PAG:= 0
	VM_REL:= "LISTA DE FUNCIONARIOS "+CLIENTE->CL_RAZAO
	VM_LAR:= 78
	
	dbseek(str(VM_EMPRESA,5),.T.)
	
	while !eof().and.FC_EMPRESA==VM_EMPRESA
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPCLCC',VM_LAR)
		? space(5)+FC_CODIGO
		??space(5)+FC_NOME
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
return NIL

function CFEPCLCC()  // Cabecalho
? space(5)+'Codigo    Nome do funcionario'
? replicate('-',VM_LAR)
return NIL
