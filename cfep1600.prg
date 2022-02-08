*-----------------------------------------------------------------------------*
function CFEP1600() // Cadastro de Moedas													*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({'R->PARAMETRO','C->MOEDA'})
	return NIL
end
DbGoTop()

pb_dbedit1('CFEP160')  && tela
VM_CAMPO:=array(fcount()-1)
afields(VM_CAMPO)

VM_MUSC:={masc(7),masc(2)}
VM_CABE:={'Data',PARAMETRO->PA_MOEDA,'Valor U.R.V.'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
// dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim

function CFEP1601() && Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP1600T(.T.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEP1602() && Rotina de Altera‡„o
if reclock()
	CFEP1600T(.F.)
end
return NIL

*-------------------------------------------------------------------* 
function CFEP1600T(VM_FL)
local GETLIST := {},X,Y,LCONT:=.T.
for X:=1 to fcount()
	Y:='VM'+substr(fieldname(X),3)
	&Y:=&(fieldname(X))
next
pb_box(18,45,,,,'Cadastro de Moedas')
@19,46 say padr('Data',12,'.')+':'                    get VM_DATA picture masc(11) valid pb_ifcod2(dtos(VM_DATA),NIL,.F.) when VM_FL
@20,46 say padr(trim(PARAMETRO->PA_MOEDA),12,'.')+':' get VM_VLMOED1 picture masc(5) valid VM_VLMOED1>0
@21,46 say padr('Vlr URV',12,'.')+':'                 get VM_VLMOED2 picture masc(5) valid VM_VLMOED2>0 when VM_DATA<ctod('01/07/94')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_VLMOED2:=if(VM_VLMOED2>0,VM_VLMOED2,1)
		for X:=1 to fcount()
			Y:="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &Y
		next
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL
*-------------------------------------------------------------------* 

function CFEP1603() && Rotina de Pesquisa
local VM_CHAVE:= &(fieldname(1))
pb_box(20,20,,,,'Procurar DATA')
@21,22 get VM_CHAVE picture masc(7)
read
setcolor(VM_CORPAD)
dbseek(dtos(VM_CHAVE),.T.)
return NIL
*-------------------------------------------------------------------* 

function CFEP1604() && Rotina de Exclus„o
if reclock().and.pb_sn('Eliminar data '+transform(MO_DATA,masc(7))+'?')
	fn_elimi()
end
dbrunlock()
return NIL
*-------------------------------------------------------------------* 

function CFEP1605() && Rotina de Impress„o
if pb_ligaimp(C15CPP)
	if !pb_sn('Listar a partir desta data '+transform(MO_DATA,masc(7))+'?')
		DbGoTop()
	end
	VM_PAG = 0
	VM_REL = 'Cadastro de Moedas'
	VM_LAR = 80
	while !eof()
		VM_PAG = pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP1605A',VM_LAR)
		?  space(20)+transform(MO_DATA,masc(7))+space(5)
		?? transform(MO_VLMOED1,masc(2))
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------* 
function CFEP1605A
? space(21)+'D a t a'+padL(trim(PARAMETRO->PA_MOEDA),22)
?replicate('-',VM_LAR)
return NIL
*-------------------------------------------------------------------* 
