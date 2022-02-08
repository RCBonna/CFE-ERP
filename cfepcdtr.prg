*-----------------------------------------------------------------------------*
 static aVariav := {0, 0,.F.,'',78,0}
 //.................1..2..3..4..5..6...7...8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate lCont      => aVariav\[  3 \]
#xtranslate cChave     => aVariav\[  4 \]
#xtranslate nLarg      => aVariav\[  5 \]
#xtranslate nPag       => aVariav\[  6 \]
#xtranslate cRelat     => aVariav\[  4 \]

*-----------------------------------------------------------------------------*
 function CFEPCDTR() // Cadastro Situacao Tributarias
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({'C->CODTR'})
	return NIL
end
DbGoTop()

pb_dbedit1('CFEPCTR')  && tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_MUSC:={mI3,   mXXX,      mI62}
VM_CABE:={'Cod','Descricao','%Trib'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------*
 function CFEPCTR1() && Rotina de Inclus„o
*-------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPCTRT(.T.)
end
return NIL

*-------------------------------------------------------------------* 
 function CFEPCTR2() && Rotina de Altera‡„o
*-------------------------------------------------------------------*
if reclock()
	CFEPCTRT(.F.)
end
return NIL

*-------------------------------------------------------------------* 
 function CFEPCTRT(VM_FL)
*-------------------------------------------------------------------*
local GETLIST := {}
local cY
lCont:=.T.
for nX:=1 to fcount()
	cY :='VM'+substr(fieldname(nX),3)
	private &cY
	&cY:=FieldGet(nX)
next
pb_box(18,0,,,,'C¢digo Tribut rio')
@19,2 say padr('C¢digo'     ,15,'.') get VM_CODTR  pict mI3  valid len(alltrim(VM_CODTR))==3.and.pb_ifcod2(VM_CODTR,NIL,.F.,1) when VM_FL
@20,2 say padr('Descri‡„o'  ,15,'.') get VM_DESCR  pict mXXX valid !empty(VM_DESCR)
@21,2 say padr('%Tributa‡Æo',15,'.') get VM_PERC   pict mI62 valid VM_PERC>=0.and.VM_PERC<=100
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		lCont:=AddRec()
	end
	if lCont
		for nX:=1 to fcount()
			cY:="VM"+substr(fieldname(nX),3)
			FieldPut(nX,&cY)
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL

*-------------------------------------------------------------------* 
 function CFEPCTR3() && Rotina de Pesquisa
*-------------------------------------------------------------------* 
cChave = &(fieldname(1))
pb_box(20,20)
@21,22 say 'Procurar :' get cChave picture mI3
read
setcolor(VM_CORPAD)
dbseek(cChave,.T.)
return NIL

*-------------------------------------------------------------------* 
 function CFEPCTR4() && Rotina de Exclus„o
*-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar :'+CT_CODTR+'-'+trim(CT_DESCR)+' ?')
	fn_elimi()
end
dbrunlock()
return NIL

*-------------------------------------------------------------------* 
 function CFEPCTR5() && Rotina de Impress„o
*-------------------------------------------------------------------* 
if pb_ligaimp(C15CPP)
	cRelat:= 'Lista Codigo Tributario'
	nLarg := 78
	nPag  := 0
	DbGoTop()
	while !eof()
		nPag := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRelat,nPag,'CFEPCTR5A',nLarg)
		?  CT_CODTR+space(5)
		?? CT_DESCR+space(5)
		?? transform(CT_PERC,mI62)
		pb_brake()
 	end
	?replicate('-',nLarg)
	?'Impresso as '+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------* 
 function CFEPCTR5A
*-------------------------------------------------------------------* 
? 'Cod'+space(5)+padr('Descricao',65)+'%Trib'
?replicate('-',nLarg)
return NIL
*-------------------------------------------------------------------* 
