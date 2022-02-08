//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.}
//.................1....2..4
//-----------------------------------------------------------------------------*
#xtranslate cArq       => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCont      => aVariav\[  3 \]
 
#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function LeiteP02()	//	Rota Por Transportador
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'	,;
				'C->CLIENTE'	,;
				'C->LEIROTA'	,; // criado arquivo no LEITEP00.PRG
				'C->LEITRANS'	;	// criado arquivo no LEITEP00.PRG
			})
	return NIL
end
aCAMPO:=Array(FCount())
afields(aCAMPO)
set relation to str(LT_CDTRAN,5) into CLIENTE
aadd(aCAMPO,'CLIENTE->CL_RAZAO')

pb_dbedit1('LEITEP02')  // tela
dbedit(06,01,maxrow()-3,maxcol()-1,;
			aCAMPO,;
			'PB_DBEDIT2',;
			{     mI6 ,       mI5 , mXXX},;
			{'CodRota','CodTransp','Nome Transportador'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LEITEP021() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
dbgobottom()
dbskip()
LEITEP02T(.T.)
return NIL
//-----------------------------------------------------------------------------*
  function LEITEP022() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LEITEP02T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LEITEP023() // Rotina de Pesquisa
  return NIL
  
//-----------------------------------------------------------------------------*
  function LEITEP024() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG(' Transportador:'+str(LT_CDTRAN,5)+'-'+CLIENTE->CL_RAZAO)
return NIL

//-----------------------------------------------------------------------------*
  function LEITEP02T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
LCont:=.T.
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=17
pb_box(nX++,10,,,,'LEITE Cadastro de Transportadores')
 nX++
@nX++,12 say 'Cod.Rota.........:'	get VM_CDROTA 	pict mI6  	valid fn_codigo(@VM_CDROTA,{'LEIROTA',{||LEIROTA->(dbseek(str(VM_CDROTA,6)))},{||NIL},{2,1}}) when VM_FL
@nX++,12 say 'Cod.Transportador: '	get VM_CDTRAN 	pict mI5  	valid fn_codigo(@VM_CDTRAN,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CDTRAN,5)))},{||NIL},{2,1}}).and.;
																								pb_ifcod2(str(VM_CDROTA,6)+str(VM_CDTRAN,5),'LEITRANS',!VM_FL,1);
																								when VM_FL
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
dbrunlock(recno())
return NIL

//-----------------------------------------------------------------------------*
  function LEITEP025() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')

return NIL

//------------------------------------------------------------------EOF
