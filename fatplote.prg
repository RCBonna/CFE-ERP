*-----------------------------------------------------------------------------*
 static aVariav := {0,0,0,{},0,'',0,.T.}
 //.................1.2.3.4..5..6.7..8
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]
#xtranslate nOPC       => aVariav\[  3 \]
#xtranslate aDATA      => aVariav\[  4 \]
#xtranslate nPag       => aVariav\[  5 \]
#xtranslate cRel       => aVariav\[  6 \]
#xtranslate nLar       => aVariav\[  7 \]
#xtranslate lFlag      => aVariav\[  8 \]

*-----------------------------------------------------------------------------*
function FATPLOTE()	//	Faturamento por Lote
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->CLIENTE',;
				'C->LOTEPAR'})
	return NIL
end
DbGoTop()
set relation to str(LOTEPAR->LP_CODCL,5) into CLIENTE

pb_dbedit1('FATPLOTE')
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)
VM_CAMPO[01]:='pb_zer(LP_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
						 {       mXXX, mI4,        mDT,    mDT , mUUU  },;
						 {'CdCliente','Lote','DtAbert','DtFech','Historico'})
						 //....1.......2.......3.......4.........5.......6
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
function FATPLOTE1() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FATPLOTET(.T.)
end
return NIL

*-----------------------------------------------------------------------------*
function FATPLOTE2() // Rotina de Alteracao
if reclock()
	FATPLOTET(.F.)
end
return NIL

*-----------------------------------------------------------------------------*
function FATPLOTET(VM_FL)
local GETLIST  := {}
local LCONT    :=.T.
for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
VM_DTABER:=if(empty(VM_DTABER),date(),VM_DTABER)
if VM_FL
	VM_PEND:=.T.
end
nX:=16
pb_box(nX++,24,,,,'Informe')
@nX++,25 say 'Associado....:' get VM_CODCL  pict mI5  valid fn_codigo(@VM_CODCL,  {'CLIENTE', {||CLIENTE->(dbseek(str(VM_CODCL,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}}) when VM_FL
@nX++,25 say 'Nr.Lote......:' get VM_NRLOTE pict mI4  valid VM_FL.and.pb_ifcod2(str(VM_CODCL,5)+str(VM_NRLOTE,4),NIL,.F.,1)                                           when VM_FL
@nX++,25 say 'Dt Abertura..:' get VM_DTABER pict mDT  valid !empty(VM_DTABER)
@nX++,25 say 'Dt Fechamento:' get VM_DTFECH pict mDT
@nX++,25 say 'Historico....:' get VM_HIST   pict mXXX
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for nX:=1 to fcount()
			X1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &X1
		next
	end
	dbcommit()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function FATPLOTE3() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
nX :=20
pb_box(nX++,30,,,,'Pesquisa Assoc')
@nX++,32 get nX pict mI5
read
setcolor(VM_CORPAD)
dbseek(str(nX,5),.T.)
return NIL

*-----------------------------------------------------------------------------*
 function FATPLOTE4() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
nOpc:=alert('Selecione...',{'Baixar','Excluir','Limpar Baixados'})
if nOPC==1
	if pb_sn('Baixar Lote/Parceria?;'+pb_zer(LP_CODCL,5)+chr(45)+alltrim(CLIENTE->CL_RAZAO,25)+';Nr.Lote :'+str(LP_NRLOTE,4)+';Data:'+dtoc(LP_DTABER))
		if reclock()
			replace LP_DTFECH with date()
		end
	end
elseif nOPC==2
	if pb_sn('Excluir Lote/Parceria?;'+pb_zer(LP_CODCL,5)+chr(45)+alltrim(CLIENTE->CL_RAZAO,25)+';Nr.Lote :'+str(LP_NRLOTE,4)+';Data:'+dtoc(LP_DTABER))
		if reclock()
			delete
			skip
		end
	end
elseif nOPC==3
	alert('Nao disponivel;avisar se for necessario')
end
skip
if EOF()
	go top
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function FATPLOTE5() //
*-----------------------------------------------------------------------------*
aData:={bom(date()),eom(date())}
nX   :=18
pb_box(nX++,10,,,,'Selecione Dt Abertura')
@20,12 say 'Data Inicial:' get aData[1] pict mDT
@21,12 say 'Data Final..:' get aData[2] pict mDT valid aData[2]>=aData[1]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	cRel :='Lotes/Parceria-'+dtoc(aData[1])+' a '+dtoc(aData[2])
	nPag :=0
	nLar :=80
	go top
	nOPC:=0
	while !eof()
		nPag:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'FATPLOTE5C',nLar)
		if nOPC#LP_CODCL
			?pb_zer(LP_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)
			nOPC:=LP_CODCL
		else
			?space(31)
		end
		??space(1)+str(LP_NRLOTE,4)
		??space(1)+dtoc(LP_DTABER)
		??space(5)+dtoc(LP_DTFECH)
		??space(1)+LP_HIST
		pb_brake()
	end
	? replicate('-',nLar)
	pb_deslimp(C15CPP)
	DbGoTop()
end

*-----------------------------------------------------------------------------*
 function FATPLOTE5C() // Cheques Emitidos
*-----------------------------------------------------------------------------*
?  padR('Associado',32)
?? 'Lote '
?? 'Dt Abertura '
?? 'Dt Fechamento '
?? 'Historico'
? replicate('-',nLar)
return NIL

*----------------------------------------------------------------------------------------------
 function FATPLOTEX(P1,P2)
*------------------------------------------------* Lote/Parceria
local ARQ:='LOTEPAR'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'LP_CODCL', 'N',  5, 0},;	// 01-Código Cliente
				 {'LP_NRLOTE','N',  4, 0},;	// 02-Número do Lote no Cliente
				 {'LP_DTABER','D',  8, 0},;	// 03-Data Abertura
				 {'LP_DTFECH','D',  8, 0},;	// 04-Data Fechamento
				 {'LP_HIST',  'C', 30, 0}},;	// 05-Histórico
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Natureza de Operacao - indices
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. CHEQUES PRE '+Str(LastRec(),7),NIL,.F.)
		pack
		Index on str(LP_CODCL,5)+str(LP_NRLOTE,4) tag CODIGO to (Arq) eval {||ODOMETRO()}
		close
	end
end
return NIL

//-----------------------EOF
