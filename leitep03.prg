//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.}
//.................1....2..4
//-----------------------------------------------------------------------------*
#xtranslate cArq       => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCont      => aVariav\[  3 \]
 
#include 'RCB.CH'
//-----------------------------------------------------------------------------*
  function LeiteP03()	//	Cadastro de Veículos / Transportador
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'	,;
				'C->CLIENTE'	,;
				'C->LEIROTA'	,; // Criado arquivo no LEITEP00.PRG
				'C->LEITRANS'	,; // Criado arquivo no LEITEP00.PRG
				'C->LEIVEIC'	;	// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
set relation to str(LEIVEIC->LV_CDTRAN,5) into CLIENTE

aCAMPO:=Array(fCount())
afields(aCAMPO)
aCAMPO[1]:='str(LEIVEIC->LV_CDTRAN,5)+chr(45)+left(CLIENTE->CL_RAZAO,30)'
pb_dbedit1('LeiteP03')  // Tela
dbedit(06,01,maxrow()-3,maxcol()-1,;
			aCAMPO,;
			'PB_DBEDIT2',;
			{          mXXX , mPLACA,	mUUU,		   mUUU,			mUUU,  mI4,		mI6  ,   mI2},;
			{'Transportador','Placa',  'UF','Tipo Veic','Tp Tanque','Ano','Capacid','NrTq'};
			)
dbcommit()
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP031() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
dbgobottom()
dbskip()
LeiteP03T(.T.)
return NIL
//-----------------------------------------------------------------------------*
  function LeiteP032() // Rotina de Altera‡„o
//-----------------------------------------------------------------------------*
if RecLock()
	LeiteP03T(.F.)
end
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP033() // Rotina de Pesquisa
  return NIL
//-----------------------------------------------------------------------------*
  function LeiteP034() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
ELIMINA_REG('Transportador/Veiculo:'+str(LV_CDTRAN,5)+'/Placa:'+LV_PLACA)
return NIL

//-----------------------------------------------------------------------------*
  function LeiteP03T(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST	:= {}
private nX1
LCont				:=.T.
for nX :=1 to fcount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next

nX:=13
pb_box(nX++,10,,,,'LEITE Transportador x Veiculos')
@nX++,12 say 'Cod.Transportador:'	get VM_CDTRAN 	pict mI5			valid fn_codigo(@VM_CDTRAN,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CDTRAN,5)))},{||NIL},{2,1}}).and.;
																								ChkTranspRota(VM_CDTRAN);
																						when VM_FL
@nX++,12 say 'Placa Veiculo....:'	get VM_PLACA	 	pict mPLACA	valid !empty(VM_PLACA).and.;
																								pb_ifcod2(mPLACA,'LEIVEIC',.F.,2);
																						when VM_FL
@nX++,12 say 'UF-Placa.........:'	get VM_UFPLACA	 	pict mXXX	valid pb_uf(@VM_UFPLACA)	when pb_msg('UF da Placa Veiculo')
@nX++,12 say 'Tipo  Veiculo....:'	get VM_VEITPV	 	pict mXXX	valid !empty(VM_VEITPV)		when pb_msg('Marca / Modelo / ...')
@nX++,12 say 'Ano   Veiculo....:'	get VM_VEIANOV	 	pict mI4		valid VM_VEIANOV>1900		when pb_msg('Ano de Veiculo')
@nX++,12 say 'Tp Tanque Armazen:'	get VM_VEITPT	 	pict mUUU	valid !empty(VM_VEITPT)		when pb_msg('Tipo de Tanque do Veiculo')
@nX++,12 say 'Capacidade Tanque:'	get VM_VEICAPL	 	pict mI6		valid !empty(VM_VEICAPL)	when pb_msg('Capacidade em Litros de Leite do Caminho')
@nX++,12 say 'Numero de Tanques:'	get VM_VEINRT	 	pict mI2		valid !empty(VM_VEINRT)		when pb_msg('Numero de Tanques do Veiculo')
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

//-----------------------------------------------------------------------------*
	function LeiteP035() // Impressão
//-----------------------------------------------------------------------------*
NAO('IMPRESSAO')
return NIL

//-----------------------------------------------------------------------------*
	function ChkTranspRota(pCODTRAN)
//-----------------------------------------------------------------------------*
LCont:=.F.
SALVABANCO
select LEITRANS
dbgotop()
while !eof()
	if LEITRANS->LT_CDTRAN==pCODTRAN
		LCont:=.T.
	end
	skip
end
if !LCont
	pb_msg('Transportador nao cadastrado em nenhuma ROTA')
end
RESTAURABANCO
return LCont
//--------------------------------------------EOF-------------------------------*
