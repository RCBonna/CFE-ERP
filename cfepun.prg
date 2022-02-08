//-----------------------------------------------------------------------------*
  static aVariav := {{}, 0,'T',.F.,0 ,'',.T.}
//.................1...2..3...4..5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate aLinDet    => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCONT      => aVariav\[  3 \]

*-----------------------------------------------------------------------------*
 function CFEPUN() // Cadastro unidades										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_FLAG:=.T.
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({'C->UNIDADE'})
	return NIL
end
DbGoTop()

pb_dbedit1('CFEPUN')  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_MUSC    :={   mUUU, mXXX,         mD83 }
VM_CABE    :={'Codig','Descricao',  'Peso'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEPUN1	() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPUNT(.T.)
end
return NIL

*-------------------------------------------------------------------* 
function CFEPUN2() // Rotina de Altera‡„o
if reclock()
	CFEPUNT(.F.)
end
return NIL

//-------------------------------------------------------------------* 
  function CFEPUNT(VM_FL)
//-------------------------------------------------------------------* 
local GETLIST := {}
local VM_Y
LCONT:=.T.
for nX:=1 to fcount()
	VM_Y:='VM'+substr(fieldname(nX),3)
	&VM_Y:=fieldget(nX)
next
nX:=16
pb_box(nX++,18,,,,'Cadastro Unidades')
nX++
@nX++,20 say padr('C¢digo'        ,15,'.') get VM_CODUN  pict mUUU valid !Empty(VM_CODUN).and.pb_ifcod2(VM_CODUN,NIL,.F.,1) when VM_FL
@nX++,20 say padr('Descri‡„o'     ,15,'.') get VM_DESCR  pict mXXX valid !Empty(VM_DESCR)
//@nX++,20 say padr('Peso'          ,15,'.') get VM_PESOKG pict mD83 valid VM_PESOKG>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for nX:=1 to fcount()
			VM_Y="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &VM_Y
		next
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL

//-------------------------------------------------------------------* 
 function CFEPUN3() // Rotina de Pesquisa
//-------------------------------------------------------------------* 
return NIL

//-------------------------------------------------------------------* 
  function CFEPUN4() && Rotina de Exclus„o
//-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar '+UN_CODUN+'-'+UN_DESCR+'?')
	fn_elimi()
end
dbrunlock()
return NIL

//-------------------------------------------------------------------* 
  function CFEPUN5() && Rotina de Impress„o
return NIL
//-------------------------------------------------------------------* 
//-------------------------------------------------------------------EOF--------------* 
