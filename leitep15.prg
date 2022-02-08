//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,.T.}
//....................1.2..3...4
//-----------------------------------------------------------------------------*
#xtranslate cArq			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate lCONT			=> aVariav\[  3 \]
#xtranslate lRT			=> aVariav\[  4 \]

#include 'RCB.CH'
//-------------------------------------------------------------------------------*
	function LeiteP15()	//	Cadastro Tabela CCS-Contagens Celulas Somaticas * 1000
//-------------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEICCS'})
	return NIL
end
pb_dbedit1('LeiteP15')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{			  mI5,			mI5,			  mI74},;
			{'% CCS Inicio', '% CCS Fim','Vlr p/Litro'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP151() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP15T(.T.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP152() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP15T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP153() // Rotina de Pesquisa
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP154() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem: Nr.CCS='+str(FieldGet(1),6)+' a '+str(FieldGet(2),6))
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP15T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=17
pb_box(nX++,20,,,,'LEITE-TABELA CCS-Contagens Celulas Somaticas * 1000')
 nX++
@nX++,22 say '% C.C.S. Inicio....:' get VM_NRCSS1		pict mI5	valid VM_NRCSS1>=0			.and.chkFaixa(VM_NRCSS1,VM_NRCSS2,VM_FL,'I') when VM_FL
@nX++,22 say '% C.C.S. Fim.......:' get VM_NRCSS2		pict mI5	valid VM_NRCSS2>=VM_NRCSS1	.and.chkFaixa(VM_NRCSS1,VM_NRCSS2,VM_FL,'F') when VM_FL
@nX++,22 Say 'Valor por Litro....:' get VM_VLRPLT		pict mI74	;
																		when pb_msg('Valor sera Acumulado/Descontado ao valor por quantidade')
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
	function LeiteP155() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
