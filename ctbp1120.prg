*-----------------------------------------------------------------------------*
 function CTBP1120()	// ATUALIZACAO DE CADASTROS DE CONTAS TITULO					*
*								Roberto Carlos Bonanomi - Maio/90							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({'C->CTATIT'})
	return NIL
end
pb_dbedit1('CTBP112')  && tela
VM_CAMPO=array(2)
afields(VM_CAMPO)

VM_CABE={'Conta','Descri‡„o'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",{MASC_CTB,masc(23)},VM_CABE)
// dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim

function CTBP1121() && Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CTBP1120T(.T.)
end
return NIL

*-------------------------------------------------------------------* 
 function CTBP1122() && Rotina de Altera‡„o
*-------------------------------------------------------------------* 
if reclock()
	CTBP1120T(.F.)
end
return NIL

*-------------------------------------------------------------------* 
 function CTBP1123() && Rotina de Pesquisa
*-------------------------------------------------------------------* 
local VM_CONTA:=CT_CONTA
pb_box(20,40)
@21,42 say "Pesquisar CONTA..:" get VM_CONTA picture MASC_CTB
read
setcolor(VM_CORPAD)
dbseek(VM_CONTA,.T.)
return NIL

*-------------------------------------------------------------------* 
 function CTBP1124() // Rotina de Exclus„o
*-------------------------------------------------------------------* 
Elimina_Reg("Eliminar Conta:"+transform(CT_CONTA,MASC_CTB)+chr(45)+trim(CT_DESCR))
return NIL

*-------------------------------------------------------------------* 
 function CTBP1125() // Rotina de Impress„o
*-------------------------------------------------------------------* 
if pb_ligaimp(chr(18))
	DbGoTop()
	VM_PAG := 0
	VM_REL := "Contas Titulo"
	VM_LAR := 80
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1125A",VM_LAR)
		? space(20)+transform(CT_CONTA,MASC_CTB)+" - "+CT_DESCR
		pb_brake()
 	end
	?replicate("-",VM_LAR)
	?"Impresso as "+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------* 
 function CTBP1125A()
*-------------------------------------------------------------------* 
?space(20)+padr(VM_CABE[1],VM_LENMAS+3)+VM_CABE[2]
?replicate("-",VM_LAR)
return NIL

*-------------------------------------------------------------------* 
 function CTBP1120T(VM_FL)
*-------------------------------------------------------------------* 

local GETLIST:={}
local VM_CONTA:=if(VM_FL,replicate("0",VM_MASTAM),CT_CONTA)
local VM_DESCR:=CT_DESCR
local LCONT:=.T.
local aConta:={CT_CONTA,,recno()}

pb_box(19,33,,,,'Contas T¡tulo')
@20,35 say padr('Conta',10,".")+":"     get VM_CONTA pict MASC_CTB valid if(VM_FL,;
																									pb_ifcod2(VM_CONTA,NIL,.F.).and.fn_cta(VM_CONTA),;
																									VM_CONTA==aConta[1].or.(pb_ifcod2(VM_CONTA,NIL,.F.).and.fn_cta(VM_CONTA)))
@21,35 say padr('Descri‡„o',10,".")+":" get VM_DESCR pict masc(23) valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		if !VM_FL
			go aConta[3]
		end
		replace 	CT_CONTA with VM_CONTA,;
					CT_DESCR with VM_DESCR
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------------*
