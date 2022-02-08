*-----------------------------------------------------------------------------*
function CFEP6300()	//	Tabela de Observacoes
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->OBS'})
	return NIL
end

pb_tela()
pb_lin4('Cadastro de Observa‡”es',ProcName())

pb_dbedit1('CFEP630')  && tela
VM_CAMPO={	'Substr(OB_DESCR,001,075)',;
				'Substr(OB_DESCR,076,070)',;
				'Substr(OB_DESCR,151,070)',;
				'Substr(OB_DESCR,226,075)';
			}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',{mXXX,mXXX,mXXX,mXXX},;
												{'Descri‡„o-P1','Descri‡„o-P2','Descri‡„o-P3','Descri‡„o-P4'})
// dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim

function CFEP6301() && Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP6300T(.T.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEP6302() && Rotina de Altera‡„o
if reclock()
	CFEP6300T(.F.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEP6303() && Rotina de Pesquisa
VM_CHAVE = OB_DESCR
pb_box(20,40)
@21,42 say 'Pesquisar:' get VM_CHAVE picture MASCP[1]
read
setcolor(VM_CORPAD)
dbseek(trim(VM_CHAVE),.T.)
return NIL
*-------------------------------------------------------------------* 

function CFEP6304() && Rotina de Exclus„o
if reclock().and.pb_sn('Eliminar ('+trim(OB_DESCR)+')?')
	fn_elimi()
end
dbrunlock()
return NIL
*-------------------------------------------------------------------* 

function CFEP6305() && Rotina de Impress„o
if pb_ligaimp(I15CPP)
	DbGoTop()
	VM_PAG = 0
	VM_REL = 'Listagem do OBSERVACOES'
	VM_LAR = 132
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6305A',VM_LAR)
		? OB_DESCR
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	DbGoTop()
end
return NIL
*-------------------------------------------------------------------* 

function CFEP6305A()
?'Descricao'
?replicate('-',VM_LAR)
return NIL
*-------------------------------------------------------------------* 

function CFEP6300T(VM_FL)
local GETLIST:={},VM_DESCR:=OB_DESCR,LCONT:=.T.
pb_box(20,0,,,,'Observa‡„o')
@21,1 get VM_DESCR picture masc(1)+'S78' valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		replace OB_DESCR with VM_DESCR
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL
*--------------------------------------------------------------------eof---------*
