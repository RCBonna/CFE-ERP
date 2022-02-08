*-----------------------------------------------------------------------------*
function CXAPSALD()	//	Cadastro de Contas de Grupos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({'C->CAIXASA'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())

pb_dbedit1("CXAPSALD")
VM_CAMPO := array(3)
afields(VM_CAMPO)
VM_MUSC={masc(30),  masc(02),  masc(03)}
VM_CABE={"Periodo","Saldo Final","Nr.Diario"}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
// dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CXAPSALD1() // Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CXAPSALDT(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPSALD2() //  Alteracao
if reclock()
	CXAPSALDT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPSALDT(VM_FL)
local GETLIST  := {},LCONT:=.T.
local X
for X=1 to fcount()
	VM_Y:='VM'+substr(fieldname(X),3)
	&VM_Y=&(fieldname(X))
next
if VM_FL
	dbsetorder(1)
	dbgobottom()
	VM_PERIOD:=val(SA_PERIOD)+1
	if VM_PERIOD%12>12
		VM_PERIOD+=88
	end
	VM_PERIOD:=str(VM_PERIOD,6)
end
pb_box(18,18,,,,'CAIXA-Saldo Mensal')
@19,20 say 'Periodo.......:' get VM_PERIOD pict masc(30) valid pb_ifcod2(VM_PERIOD,NIL,.F.,1) when VM_FL
@20,20 say 'Saldo.........:' get VM_SALDO  pict masc(05) valid VM_SALDO>=0
@21,20 say 'Nr.Diario.....:' get VM_DIARIO pict masc(12) valid VM_DIARIO>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for X=1 to fcount()
			VM_Y="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &VM_Y
		next
		dbskip(0)
		// dbcommit()
	end
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPSALD3() // Pesquisa
return NIL

*-----------------------------------------------------------------------------*
function CXAPSALD4() // Exclusao
if reclock().and.pb_sn('Excluir SALDO.: ' + transform(SA_SALDO,masc(02)))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function CXAPSALD5() // Impressao
return NIL
*-----------------------------------------------------------------------------*
