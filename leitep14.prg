//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,.T.}
//....................1.2..3...4
//-----------------------------------------------------------------------------*
#xtranslate cArq			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate lCONT			=> aVariav\[  3 \]
#xtranslate lRT			=> aVariav\[  4 \]

#include 'RCB.CH'
//-----------------------------------------------------------------------------*
	function LeiteP14()	//	Cadastro Tabela ESD-Extrato Seco Desengordurado
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIESD'})
	return NIL
end
pb_dbedit1('LeiteP14')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{			  mI52,			mI52,			  mI74},;
			{'% ESD Inicio', '% ESD Fim','Vlr p/Litro'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP141() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP14T(.T.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP142() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP14T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP143() // Rotina de Pesquisa
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP144() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem: Faixa ESD='+str(FieldGet(1),6,2)+'% a '+str(FieldGet(2),6,2)+'%')
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP14T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=17
pb_box(nX++,20,,,,'LEITE-TABELA ESD-Extrato Seco Desengordurado')
 nX++
@nX++,22 say '% E.S.D. Inicio....:' get VM_PRESD1		pict mI52	valid VM_PRESD1>=0			.and.chkFaixa(VM_PRESD1,VM_PRESD2,VM_FL,'I') when VM_FL
@nX++,22 say '% E.S.D. Fim.......:' get VM_PRESD2		pict mI52	valid VM_PRESD2>=VM_PRESD1	.and.chkFaixa(VM_PRESD1,VM_PRESD2,VM_FL,'F') when VM_FL
@nX++,22 Say 'Valor por Litro....:' get VM_VLRPLT		pict mI74	valid VM_VLRPLT>=0;
																		when pb_msg('Valor sera acumulado ao valor por quantidade')
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
	function LeiteP145() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
