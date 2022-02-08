*-----------------------------------------------------------------------------*
function FATPCDCP() // Condicoes de Pagamento
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->CONDPGTO'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())

pb_dbedit1("FATPCDCP")
VM_CAMPO = array(fcount())
afields(VM_CAMPO)
VM_MUSC={masc(12), masc(01),  masc(12),masc(29),   masc(12),        masc(12)}
VM_CABE={   "C¢d","Descri‡„o","Parc",   "%Aumento","%Entrada","Dias"}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
// dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function FATPCDCP1() && Rotina de Inclus„o
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FATPCDCPT(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function FATPCDCP2() && Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	FATPCDCPT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function FATPCDCPT(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST  := {},LCONT:=.T.
for VM_X=1 to fcount()
	VM_Y='VM'+substr(fieldname(VM_X),3)
	&VM_Y=&(fieldname(VM_X))
next
if VM_FL
	dbsetorder(1)
	dbgobottom()
	VM_CODCP:=CP_CODCP + 1
end
pb_box(15,10,,,,'Condicoes de Pagamento')
@16,12 say 'Codigo...........:' get VM_CODCP  pict masc(12) valid pb_ifcod2(str(VM_CODCP,3),NIL,.F.,1) when VM_FL
@17,12 say 'Descri‡„o........:' get VM_DESCR  pict masc(01) valid !empty(VM_DESCR)
@18,12 say '%Entrada.........:' get VM_PERENT pict masc(12) valid VM_PERENT>=0
@19,12 say 'Nr.Parcelas......:' get VM_PARC   pict masc(12) valid VM_PARC>=0    when VM_PERENT<100
@20,12 say 'Nr.Dias Parcelas.:' get VM_DIAEPA pict masc(12) valid VM_DIAEPA>=0  when pb_msg('Numero de dias entre as parcelas').and.VM_PERENT<100
@21,12 say '%Aumento.........:' get VM_AUMENT pict masc(29) valid VM_AUMENT>=0  when pb_msg('% de aumento no produto para este parcelamento (-Vlr Entrada)').and.VM_PERENT<100
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for VM_X=1 to fcount()
			VM_Y="VM"+substr(fieldname(VM_X),3)
			replace &(fieldname(VM_X)) with &VM_Y
		next
		dbskip(0)
		// dbcommit()
	end
end
return NIL

*-----------------------------------------------------------------------------*
function FATPCDCP3() && Rotina de Pesquisa
*-----------------------------------------------------------------------------*
VM_CHAVE:=CG_CODCP
pb_box(20,26)
@21,30 say 'Pesq.Condicoes de Pagamento.: ' get VM_CHAVE picture masc(12)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,3),.T.)
return NIL

*-----------------------------------------------------------------------------*
function FATPCDCP4() && Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir COND.PGTO.: ' + transform(CP_CODCP,masc(12))+'-' +trim(CP_DESCR))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function FATPCDCP5() && Impressao de grupos
*-----------------------------------------------------------------------------*
local VM_PAG:=0,X,CPO,;
		VM_REL:='Condicoes de Pagamento'
VM_LAR:= 78
if pb_ligaimp(C15CPP)
	DbGoTop()
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'FATPCDCPC',VM_LAR)
		? space(2)
		for X:=1 to len(VM_CAMPO)
			CPO:=VM_CAMPO[X]
			??&CPO + space(5)
		next
		pb_brake()
	end
	DbGoTop()
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end

*-----------------------------------------------------------------------------*
function FATPCDCPCC() && Cabecalho Lista Grupos
*-----------------------------------------------------------------------------*
?'Codigo/Descricao                 Parc   %Aumento %Entrada Dias'
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------EOF-------------------------------------------*
