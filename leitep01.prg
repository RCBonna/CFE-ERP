//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.}
//.................1....2..4
//-----------------------------------------------------------------------------*
#xtranslate cArq       => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCont      => aVariav\[  3 \]
 
#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function LeiteP01()	//	Cadastro Rota
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIROTA'})
	return NIL
end
pb_dbedit1('LEITEP01')  // tela
aCAMPO:=Array(FCount())
afields(aCAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			aCAMPO,;
			'PB_DBEDIT2',;
			{  mI6 ,          mXXX},;
			{'CodRota','Descricao'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP011() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
dbgobottom()
dbskip()
LeiteP01T(.T.)
return NIL
//-----------------------------------------------------------------------------*
  function LeiteP012() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP01T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP013() // Rotina de Pesquisa
  return NIL
//-----------------------------------------------------------------------------*
  function LeiteP014() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG(' Rota :'+str(LEIROTA->LR_CDROTA,6)+'-'+LEIROTA->LR_DESCR)
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP015() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP01T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
LCont:=.T.
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=15
pb_box(nX++,00,,,,'LEITE ROTAS de Coleta')
@nX++,02 say 'Cod.Rota.........:' get VM_CDROTA		pict mI6		valid VM_CDROTA>0.and.pb_ifcod2(str(VM_CDROTA,6),NIL,.F.,1) when VM_FL
@nX++,02 Say 'Descricao........:' get VM_DESCR		pict mXXX	valid !empty(VM_DESCR)
@nX++,02 Say 'Dt Validade Rota.:' get VM_DTVALID	pict mDT		valid VM_DTVALID>=date()
nX++

read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCont:=AddRec()
	end
	if LCont
		for nX:=1 to fcount()
			nX1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &nX1
		next
		dbcommit()
	end
end
dbrunlock(RecNo())
return NIL

//------------------------------------------------------------------EOF
