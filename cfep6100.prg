*-----------------------------------------------------------------------------*
function CFEP6100()	//	Cadastro da Tabela de ICMS-Entrada/Saida					*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->TABICMS'})
	return NIL
end
pb_tela()
pb_lin4('Tabela de ICMS-Entrada/Saida',ProcName())

pb_dbedit1('CFEP610')
VM_CAMPO = array(3)
afields(VM_CAMPO)

VM_MUSC={masc(1),masc(14),masc(14)}
VM_CABE={'UF','%Entrada','%Saida'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
// dbcommit()
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

function CFEP6101() && Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP6100T(.T.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEP6102() && Rotina de Alteracao
if reclock()
	CFEP6100T(.F.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEP6100T(VM_FL)
local GETLIST := {},LCONT:=.T.
VM_UF   := TI_UF
VM_ENTR := TI_ENTR
VM_SAID := TI_SAID

pb_box(17,28)
@18,30 say '[Tabela ICMS % Entrada/Saida]'
@19,30 say 'UF.......:' get VM_UF   picture masc(1) valid pb_uf(@VM_UF).and.pb_ifcod2(VM_UF,NIL,.F.,1) when VM_FL
@20,30 say '%Entrada.:' get VM_ENTR picture masc(14) valid VM_ENTR>=0
@21,30 say '%Saida...:' get VM_SAID picture masc(14) valid VM_SAID>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		replace TI_UF   with VM_UF,;
				  TI_ENTR with VM_ENTR,;
				  TI_SAID with VM_SAID
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------------*

function CFEP6103() && Rotina de Pesquisa
VM_CHAVE=TI_UF
pb_box(20,26)
@21,30 say 'Pesquisar UF.:' get VM_CHAVE picture masc(1)
read
setcolor(VM_CORPAD)
dbseek(VM_CHAVE,.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEP6104() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir UF.: '+TI_UF)
	fn_elimi()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*

function CFEP6105() && Impressao de grupos
if pb_ligaimp(C15CPP)
	VM_PAG = 0
	VM_LAR = 80
	VM_REL = 'Tabela de ICMS %Entrada %Saida'
	DbGoTop()
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6105A',VM_LAR)
		?  space(8)+TI_UF+space(8)+transform(TI_ENTR,masc(14))
		?? space(8)+transform(TI_SAID,masc(14))
		pb_brake()
	end
	DbGoTop()
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
return NIL

function CFEP6105A() && Cabecalho Lista Grupos
?space(8)+'UF'+space(5)+'%Entrada'+space(6)+'%Saida'
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------------------------*
