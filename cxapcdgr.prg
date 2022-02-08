*-----------------------------------------------------------------------------*
function CXAPCDGR()	//	Cadastro de Contas de Grupos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({'C->CAIXACG'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end
pb_dbedit1("CXAPCDGR")
VM_CAMPO = array(4)
afields(VM_CAMPO)
VM_CAMPO[3]:='if(CG_INFCX,"SIM","   ")'
VM_MUSC    :={     mI3,       mUUU, mUUU, mUUU}
VM_CABE    :={'C¢digo','Descri‡„o','Cxa?','Tipo'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
// dbcommit()
dbcloseall()
TIPOCAD:=2 // sub-grupo
return NIL

*-----------------------------------------------------------------------------*
 function CXAPCDGR1() && Rotina de Inclus„o
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CXAPCDGRT(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPCDGR2() && Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	CXAPCDGRT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPCDGRT(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST:= {}
local LCONT  :=.T.
local nX
local cY
for nX:=1 to fcount()
	cY:='VM'+substr(fieldname(nX),3)
	private &cY
	&cY=&(fieldname(nX))
next
if VM_FL
	dbsetorder(1)
	dbgobottom()
	VM_CODCG:=CG_CODCG + 1
end
VM_INFCX:=if(VM_INFCX,'S','N')
nX:=17
pb_box(nX++,18,,,,'CAIXA-Contas de Grupo')
@nX++,20 say 'Codigo........:' get VM_CODCG pict mI3 valid pb_ifcod2(str(VM_CODCG,3),NIL,.F.,1) when VM_FL
@nX++,20 say 'Descri‡„o.....:' get VM_DESCR pict mUUU valid !empty(VM_DESCR)
@nX++,20 say 'Tipo de Grupo.:' get VM_TIPOM pict mUUU valid VM_TIPOM$'RP ' when pb_msg('Tipo de Grupo : <R>ecebimento   <P>agamentos   < >Nenhum so registro')
@nX++,20 say 'Influi Caixa?.:' get VM_INFCX pict mUUU valid VM_INFCX$'SN'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_INFCX:=(VM_INFCX=='S')
		for nX:=1 to fcount()
			cY="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &cY
		next
		dbskip(0)
		dbcommit()
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPCDGR3() && Rotina de Pesquisa
*-----------------------------------------------------------------------------*
local VM_CHAVE:=CG_CODCG
pb_box(20,26)
@21,30 say 'Pesquisar CONTA-GRUPO..: ' get VM_CHAVE picture masc(12)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,3),.T.)
return NIL

*-----------------------------------------------------------------------------*
 function CXAPCDGR4() && Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir CONTA-GRUPO.: ' + transform(CG_CODCG,masc(12))+'-' +trim(CG_DESCR))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function CXAPCDGR5() && Impressao de grupos
*-----------------------------------------------------------------------------*
local VM_PAG:=0,X,CPO,;
		VM_REL:='Caixa-Grupos de Contas'
VM_LAR:= 78
if pb_ligaimp(C15CPP)
	DbGoTop()
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CXAPCDGRC',VM_LAR)
		? space(10) 
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
 function CXAPCDGR5A() && Cabecalho Lista Grupos
*-----------------------------------------------------------------------------*
?space(5)+'Grupo-Despesas'+space(4)+padr('Descricao',31)+'InCx'
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------------------------*
