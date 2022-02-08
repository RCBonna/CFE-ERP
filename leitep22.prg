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
	function LeiteP22()	//	TABELA de Preco Litro por Volume
//-------------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIVOL'})
	return NIL
end
pb_dbedit1('LeiteP22')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{			  mI5,			mI5,			  mI74},;
			{'Qtd Inicial', 'Qtd Final','Vlr p/Litro'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP221() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP22T(.T.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP222() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if RecLock()
	LeiteP22T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP223() // Rotina de Pesquisa
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP224() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem: Qtd.Inical='+str(FieldGet(1),6)+' a '+str(FieldGet(2),6))
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP22T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=17
pb_box(nX++,20,,,,'LEITE-TABELA de Preco Litro por Volume')
 nX++
@nX++,22 say 'Qtdade Inicial.....:' get VM_QTLIT1		pict mI5	valid VM_QTLIT1>=0			.and.chkFaixa(VM_QTLIT1,VM_QTLIT2,VM_FL,'I') when VM_FL
@nX++,22 say 'Qtdade Final.......:' get VM_QTLIT2		pict mI5	valid VM_QTLIT2>=VM_QTLIT1	.and.chkFaixa(VM_QTLIT2,VM_QTLIT2,VM_FL,'F') when VM_FL
@nX++,22 Say 'Valor por Litro....:' get VM_VLRPLT		pict mI74	;
																		when pb_msg('Valor por Litro na Faixa de Quantidade')
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
	function LeiteP225() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
