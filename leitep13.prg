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
  function LeiteP13()	//	Cadastro Tabela Proteina
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIPROT'})
	return NIL
end
pb_dbedit1('LeiteP13')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{				 mI62,			mI62,			  mI74},;
			{'% Proteina Inicial', '% Proteina Fim','Vlr p/Litro'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP131() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP13T(.T.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP132() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP13T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP133() // Rotina de Pesquisa
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP134() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem: Faixa Proteina='+str(FieldGet(1),6,2)+'% a '+str(FieldGet(2),6,2)+'%')
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP13T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=17
pb_box(nX++,20,,,,'LEITE-TABELA VLR PROTEINA')
 nX++
@nX++,22 say '% Proteina Inicio..:' get VM_PROTE1		pict mI52	valid VM_PROTE1>=0			.and.chkFaixa(VM_PROTE1,VM_PROTE2,VM_FL,'I') when VM_FL
@nX++,22 say '% Proteina Fim.....:' get VM_PROTE2		pict mI52	valid VM_PROTE2>=VM_PROTE1	.and.chkFaixa(VM_PROTE1,VM_PROTE2,VM_FL,'F') when VM_FL
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
	function LeiteP135() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//------------------------------------------------------------------EOF
