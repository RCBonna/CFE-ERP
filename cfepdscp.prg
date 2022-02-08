*-----------------------------------------------------------------------------*
function CFEPDSCP()	//	Edita valores das Sobras
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'E->COTASSO'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
pb_dbedit1("CFEPDSCP")
VM_CAMPO := array(6)
afields(VM_CAMPO)
VM_CAMPO[6]:="if(CP_DISTRI,'SIM','nao')"
VM_MUSC={  mI4,             mD132,           mD132,           mD102,           mD102,     mXXX,              mXXX}
VM_CABE={'ANO','Vlr Mov.Entradas','Vlr Mov.Saidas','Vlr Capitaliza','Vlr Distribuir',"Fechado",'Historico Padrao'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEPDSCP1() // Rotina de Inclus„o*-----------------------------------------------------------------------------*
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPDSCPT(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CFEPDSCP2() // Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	if .not. CP_DISTRI
		CFEPDSCPT(.F.)
		dbrunlock(recno())
	else
		alert('SOBRA ja distribuida;NAO PODE SER ALTERADA')
	end
end
return NIL

*-----------------------------------------------------------------------------*
function CFEPDSCPT(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST  := {},LCONT:=.T.,VM_X,VM_Y
for VM_X=1 to fcount()
	VM_Y :='VM'+substr(fieldname(VM_X),3)
	&VM_Y:=&(fieldname(VM_X))
next
if VM_FL
	VM_ANO :=year(PARAMETRO->PA_DATA)
end
pb_box(14,1,,,,'Cotas Parte-Digitacao das Sobras')
@15,02 say 'ANO...............:' get VM_ANO    pict mI4  valid VM_ANO>1900.and.pb_ifcod2(str(VM_ANO,4),NIL,.f.) when VM_FL
@17,02 say 'Vlr Capitalizacao.:' get VM_VALORD pict mD82 valid VM_VALORD>=0 when pb_msg('Valor da Sobra para Acumular no Extrato')
@18,02 say 'Historico Capit...:' get VM_HISTOR pict mXXX+'S40'
@20,02 say 'Vlr Distribuicao..:' get VM_VALORP pict mD82 valid VM_VALORP>=0 when pb_msg('Valor da Sobra para Distribuicao aos associados-Contas a Pagar')
@21,02 say 'Historico Distrib.:' get VM_HISTDS pict mXXX+'S40'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for VM_X:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(VM_X),3)
			replace &(fieldname(VM_X)) with &VM_Y
		next
		// dbcommit()
		dbskip(0)
	end
end
return NIL
*-----------------------------------------------------------------------------*
function CFEPDSCP3() // Rotina de Pesquisa
local VM_CHAVE:=CP_ANO
pb_box(20,26,,,,'Pesquisar')
@21,30 say 'Ano.: ' get VM_CHAVE pict mI4
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,4),.T.)
return NIL

*-----------------------------------------------------------------------------*
function CFEPDSCP4() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir sobras do ANO.: ' +str(fieldget(1),4))
	if !CP_DISTRI
		fn_elimi()
	else
		alert('SOBRA ja distribuida;NAO PODE SER EXCLUIDA')
	end
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function CFEPDSCP5() // Impressao de grupos
local VM_PAG:=0,X,VM_REL
if pb_ligaimp(C15CPP)
	VM_REL:='Lista de Sobras'
	VM_LAR:= 80
	DbGoTop()
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPDSCPC',VM_LAR)
		?
		? str(CP_ANO,4)+space(5)
		??transform(CP_VALORE,mD132)+space(3)
		??transform(CP_VALORS,mD132)+space(3)
		??transform(CP_VALORD,mD132)
		??transform(CP_VALORP,mD132)
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	set filter to 
	DbGoTop()
end

function CFEPDSCPC() // Cabecalho Lista Grupos
?'Ano   Valor das Entradas  Valor das Saidas    Vlr Sobra-Extr  Vlr Sobra-Distrib'
?replicate('-',VM_LAR)
return NIL

*-------------------------------------------------------------------------EOF----*
