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
  function LeiteP12()	//	Cadastro Tabela Gordura
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIGORD'})
	return NIL
end
pb_dbedit1('LeiteP12')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{				 mI52,			mI52,					  mI74},;
			{'% Gordura Inicial', '% Gordura Fim','Vlr p/Litro'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP121() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	LeiteP12T(.T.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP122() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if reclock()
	LeiteP12T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP123() // Rotina de Pesquisa
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP124() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Mensagem: Faixa Gordura='+str(FieldGet(1),6,2)+'% a '+str(FieldGet(2),6,2)+'%')
return NIL

//-----------------------------------------------------------------------------*
	function LeiteP12T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
private nX1
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=17
pb_box(nX++,20,,,,'LEITE-TABELA VLR GORDURA')
 nX++
@nX++,22 say '% Gordura Inicio...:' get VM_GORDL1		pict mI52	valid VM_GORDL1>=0			.and.chkFaixa(VM_GORDL1,VM_GORDL2,VM_FL,'I') when VM_FL
@nX++,22 say '% Gordura Fim......:' get VM_GORDL2		pict mI52	valid VM_GORDL2>=VM_GORDL1	.and.chkFaixa(VM_GORDL1,VM_GORDL2,VM_FL,'F') when VM_FL
@nX++,22 Say 'Valor por Litro....:' get VM_VLRPLT		pict mI74	;
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
	function LeiteP125() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL


//-----------------------------------------------------------------------------*
	function chkFaixa(P_FAIXA1,P_FAIXA2,P_FL,P_TP)
//-----------------------------------------------------------------------------*
nRecAnt	:=RecNo()
lRT		:=.T.
dbGoTop()
while !eof().and.lRT
	if P_TP=='I'
		if P_FAIXA1>=FieldGet(1).and.P_FAIXA1<=FieldGet(2)
			lRT:=.F.
		end
	end
	if P_TP=='F'
		if P_FAIXA2>=FieldGet(1).and.P_FAIXA2<=FieldGet(2)
			lRT:=.F.
		end	
	end
	skip
end
if lRT==.F.
	Alert('ATENCAO;Uma das informacoes da faixa;ja esta cadastrada em outra faixa.')
end
dbGoTo(nRecAnt)
return lRT

//------------------------------------------------------------------EOF
