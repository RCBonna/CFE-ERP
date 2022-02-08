//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.}
//....................1.2..3
//-----------------------------------------------------------------------------*
#xtranslate cArq       => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCONT      => aVariav\[  3 \]
 
#include 'RCB.CH'
//-----------------------------------------------------------------------------*
  function LeiteP05()	//	Cadastro Motivo Rejeitado
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIMOTIV'})
	return NIL
end
pb_dbedit1('LeiteP05')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{  mI4 ,     mXXX},;
			{'COD','Descricao'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP051() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP05T(.T.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP052() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP05T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP053() // Rotina de Pesquisa
  return NIL

//-----------------------------------------------------------------------------*
  function LeiteP054() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem:'+str(LM_CDMOTIV,4)+'-'+trim(LM_DESCR))
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP05T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=18
pb_box(nX++,20,,,,'LEITE-MOTIVOS REJEITADOS')
 nX++
@nX++,22 say 'Codigo....:' get VM_CDMOTIV		pict mI4		valid VM_CDMOTIV>=0.and.pb_ifcod2(str(VM_CDMOTIV,2),NIL,.F.,1) when VM_FL
@nX++,22 Say 'Descricao.:' get VM_DESCR		pict mXXX	valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for nX:=1 to fcount()
			nX1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &nX1
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP055() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
