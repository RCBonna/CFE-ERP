*-----------------------------------------------------------------------------*
function FISPOBS()	//	Tabela de Observacoes Curtas
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->XOBS'})
	return NIL
end

pb_tela()
pb_lin4('Cadastro de Observa‡”es/Curtas',ProcName())

pb_dbedit1('FISPOBS')  && tela
VM_CAMPO :=array(fcount())
afields(VM_CAMPO)
VM_CAMPO[2]:='Left(OB_DESCR,65)'
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',{mXXX,mXXX},{'Cod','Descri‡„o'})
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function FISPOBS1() && Rotina de Inclus„o
*-------------------------------------------------------------------* 
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FISPOBST(.T.)
end
return NIL

*-------------------------------------------------------------------* 
function FISPOBS2() && Rotina de Altera‡„o
*-------------------------------------------------------------------* 
if reclock()
	FISPOBST(.F.)
end
return NIL

*-------------------------------------------------------------------* 
function FISPOBS3() && Rotina de Pesquisa
*-------------------------------------------------------------------* 
local VM_CHAVE:= OB_CODOBS
pb_box(20,40)
@21,42 say 'Pesquisar:' get VM_CHAVE picture mXXX
read
setcolor(VM_CORPAD)
dbseek(trim(VM_CHAVE),.T.)
return NIL

*-------------------------------------------------------------------* 
function FISPOBS4() && Rotina de Exclus„o
*-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar ('+OB_CODOBS+'-'+trim(OB_DESCR)+')?')
	fn_elimi()
end
dbrunlock()
return NIL

*-------------------------------------------------------------------* 
function FISPOBS5() // Rotina de Impress„o
*-------------------------------------------------------------------* 
local   VM_PAG := 0
local   VM_REL := 'OBSERVACOES curtas'
private VM_LAR := 120
if pb_ligaimp(I15CPP)
	DbGoTop()
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'FISPOBS5A',VM_LAR)
		? OB_CODOBS + "-" + OB_DESCR
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
function FISPOBS5A()
*-------------------------------------------------------------------* 
?'C - Descricao'
?replicate('-',VM_LAR)
return NIL

*-------------------------------------------------------------------* 
 function FISPOBST(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST:={}
local LCONT  :=.T.
local X
local Y
for X:=1 to fcount()
	Y :='VM'+substr(fieldname(X),3)
	PRIVATE &Y
	&Y:=FieldGet(X)
next

pb_box(19,1,,,,'Observa‡„o')
@20,02 say 'C¢digo Obs.:' get VM_CODOBS pict mXXX valid !empty(VM_CODOBS).and.pb_ifcod2(VM_CODOBS,'XOBS',.F.,2) when VM_FL
@21,02 say 'Descricao..:' get VM_DESCR  pict mXXX+'S60' valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for X:=1 to fcount()
			Y:="VM"+substr(fieldname(X),3)
			FieldPut(X, &Y)
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------------*
