*-----------------------------------------------------------------------------*
function CTBP1140()	//	ATUALIZACAO DE CADASTROS DE HISTORICO PADRAO				*
*								Roberto Carlos Bonanomi - Jun/93					         *
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({'C->HISPAD'})
	return NIL
end
pb_dbedit1('CTBP114')  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_CABE:={'C¢digo','Descri‡„o'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",{mI2,mXXX},VM_CABE)
dbcloseall()
return NIL
*---------------------------------------------------------------------* FIM

function CTBP1141() // Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	CTBP1140T(.T.)
end
return NIL
*---------------------------------------------------------------------*

function CTBP1142() // Rotina de Altera‡„o
if reclock()
	CTBP1140T(.F.)
end
return NIL
*---------------------------------------------------------------------*

function CTBP1143() // Rotina de Pesquisa
local VM_HISTOR:= HP_HISTOR
pb_box(20,40)
@21,42 say "Hist¢rico.:" get VM_HISTOR picture masc(12)
read
setcolor(VM_CORPAD)
dbseek(str(VM_HISTOR,3),.T.)
return NIL
*---------------------------------------------------------------------*

function CTBP1144() // Rotina de Exclus„o
if reclock().and.pb_sn("Eliminar ("+transform(HP_HISTOR,masc(12))+" "+trim(HP_DESCR)+") ?")
	fn_elimi()
end
dbrunlock()
return NIL
*---------------------------------------------------------------------*

function CTBP1145() // Rotina de Impress„o
if pb_ligaimp(chr(18))
	DbGoTop()
	VM_PAG = 0
	VM_REL = "Historico Padrao"
	VM_LAR = 80
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1145A",VM_LAR)
		? space(10)+transform(HP_HISTOR, masc(12))+space(4)+"- "+HP_DESCR
		pb_brake()
 	end
	?replicate("-",VM_LAR)
	?"Impresso as "+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL
*---------------------------------------------------------------------*

function CTBP1145A()
?space(9) + VM_CABE[1]+" - "+VM_CABE[2]
?replicate("-",VM_LAR)
return NIL
*---------------------------------------------------------------------*

function CTBP1140T(VM_FL)
local   GETLIST :={},LCONT:=.T.
private VM_DESCR:=HP_DESCR,VM_HISTOR:=HP_HISTOR
pb_box(19,05,,,,'Cadastro de Hist¢ricos')
@20,07 say padr('C¢digo',10,'.')    get VM_HISTOR picture mI2    valid pb_ifcod2(str(VM_HISTOR,3),NIL,.F.) when VM_FL
@21,07 say padr('Descri‡„o',10,'.') get VM_DESCR  picture mXXX   valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		replace HP_HISTOR with VM_HISTOR,HP_DESCR with VM_DESCR
	end
	// dbcommit()
end
dbrunlock(recno())
return NIL
*---------------------------------------------------------------------*
