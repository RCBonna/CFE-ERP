*-----------------------------------------------------------------------------*
function CFEPFAR0()	//	Associa Cliente & Funcionarios
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())
if !abre({	'C->PARAMETRO',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CLIENTE',;
				'C->CLICONV'})
	return NIL
end
salvacor(SALVA)
while .T.
	pb_box(18,20)
	VM_CLI:=0
	@20,22 say 'Empresa Conveniada.:' get VM_CLI pict masc(04) valid fn_codigo(@VM_CLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}) when pb_msg('Infome C¢digo da Empresa Conveniada')
	read
	if lastkey()#K_ESC
		if CLIENTE->CL_ATIVID#99
			alert('Este Cliente/Empresa nao esta conveniada,;No cadastro de Cliente, Campo de Atividade coloque 99')
			loop
		else
			exit
		end
	else
		dbcloseall()
		return nil
	end
end
salvacor(RESTAURA)
pb_tela()
pb_lin4(_MSG_+'-'+trim(CLIENTE->CL_RAZAO),ProcName())
set filter to FC_EMPRESA==VM_CLI
DbGoTop()
pb_dbedit1('CFEPFAX')
VM_CAMPO:=array(4)
VM_CAMPO[1] = 'FC_CODIGO'
VM_CAMPO[2] = 'left(FC_NOME,30)'
VM_CAMPO[3] = 'if(FC_ATIVO,"        ","Demitido")'
VM_CAMPO[4] = 'FC_DATAD'

VM_MUSC={masc(1),masc(1),masc(1),masc(1),masc(8)}
VM_CABE={'Codigo','Nome Funcionario','ATIVO','DT DEM' }

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

function CFEPFAX1() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPFAX0T(.T.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPFAX2() // Rotina de Alteracao
if reclock()
	CFEPFAX0T(.F.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPFAX0T(VM_FL)
local GETLIST:={},LCONT:=.T.
VM_CODIGO:=FC_CODIGO
VM_NOME  :=FC_NOME
VM_ATIVO :=if(VM_FL,'S',if(FC_ATIVO,'S','N'))
VM_DATAD :=FC_DATAD
pb_box(17,18,,,,'Funcionarios/Convenio')
@18,20 say 'Cod.Funcionario.:' get VM_CODIGO  pict masc(1) valid !empty(VM_CODIGO).and.pb_ifcod2(str(VM_CLI,5)+VM_CODIGO,NIL,.F.,1) when VM_FL
@19,20 say 'Nome Funcionario:' get VM_NOME    pict masc(1) valid !empty(VM_NOME)
@20,20 say 'Ativo (S/N).....:' get VM_ATIVO   pict masc(1) valid VM_ATIVO$'SN'
@21,20 say 'Data Demissao...:' get VM_DATAD   pict masc(8) when VM_ATIVO=='N'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_ATIVO:=(VM_ATIVO=='S')
		replace FC_EMPRESA with VM_CLI,;
				  FC_CODIGO  with VM_CODIGO,;
				  FC_NOME    with VM_NOME,;
				  FC_ATIVO   with VM_ATIVO,;
				  FC_DATAD   with VM_DATAD
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------------*

function CFEPFAX3() // Rotina de Pesquisa
local VM_CHAVE:=FC_CODIGO
pb_box(20,26)
@21,30 say 'Codigo: ' get VM_CHAVE pict masc(4)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CLI,5)+VM_CHAVE,.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEPFAX4() // Rotina de Exclusao
if reclock().and.pb_sn('Funcionario EMPRESA.: '+pb_zer(FC_EMPRESA,5)+'-'+FC_CODIGO+' '+FC_NOME)
	fn_elimi()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*

function CFEPFAX5() //  Impressao
local VM_CPO,VM_FL,X1,X2,VM_REL,VM_PAG
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	DbGoTop()
	VM_PAG:= 0
	VM_REL:= "FUNCIONARIOS :"+trim(CLIENTE->CL_RAZAO)
	VM_LAR:= 78
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPFAXC',VM_LAR)
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

function CFEPFAXC()  // Cabecalho
? space(9)+'Codigo     Nome do funcionario'
? replicate('-',VM_LAR)
return NIL
