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
 function CXAPPRE()	//	Acumular Cheque pré
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
private Cliente:=0
private NROCH:=0
private Valor:=0
private iData:={ctod(''),ctod('')}
Filtro       :=''

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->CLIENTE',;
				'C->CHPRE'})
	return NIL
end
DbGoTop()
set relation to str(CHPRE->C1_CODCL,5) into CLIENTE

pb_dbedit1('CXAPPRE')
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)
VM_CAMPO[01]:='C1_DTVEN'
VM_CAMPO[02]:='C1_NROCH'
VM_CAMPO[03]:='C1_VALOR'
VM_CAMPO[04]:='pb_zer(C1_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)'
VM_CAMPO[05]:='if(C1_PEND,"SIM","nao")'
VM_CAMPO[06]:='C1_CODBCO'
VM_CAMPO[07]:='C1_CODAGE'
VM_CAMPO[08]:='C1_CODCC'
VM_CAMPO[09]:='C1_DOCORI'
VM_CAMPO[10]:='C1_DTEMI'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
						 {     mDT,  mI6,    mD82 ,      mXXX,  mXXX,   mI6 ,   mI6 ,  mXXX ,     mI6 ,    mDT ,     mXXX  },;
						 {'Dt/Venc','NroCH','Valor','Cli/For','Pend','Banco','Agenc','CCorr', 'N.Orig','Dt Emi','Historico'})
						 //....1.......2.......3.......4.........5.......6.........7.........8.......9......10...........
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CXAPPRE1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CXAPPRET(.T.)
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPPRE2() // Rotina de Alteracao
if reclock()
	CXAPPRET(.F.)
end
return NIL

*-----------------------------------------------------------------------------*
 function CXAPPRET(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST  := {}
local LCONT    :=.T.
for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
VM_DTEMI:=if(empty(VM_DTEMI),date(),VM_DTEMI)
if VM_FL
	VM_PEND:=.T.
end
pb_box(13,24,,,,'Informe')
@14,25 say 'Cli/Fornec:' get VM_CODCL  pict mI5  valid fn_codigo(@VM_CODCL,  {'CLIENTE', {||CLIENTE->(dbseek(str(VM_CODCL,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}}) when VM_FL
@15,25 say 'Banco.....:' get VM_CODBCO pict mI3                                                                                                                  when pb_msg('informe codigo febraban do banco do cheque pre-datado').and.VM_FL
@15,42 say 'Agencia:'    get VM_CODAGE pict mXXX                                                                                                                 when pb_msg('informe Agencia do Cheque pre-datata')
@15,62 say 'CC:'         get VM_CODCC  pict mXXX                                                                                                                 when pb_msg('informe Conta Corrente do Cheque pre-datado')
@16,25 say 'Nro Cheque:' get VM_NROCH  pict mI6  valid VM_FL.and.pb_ifcod2(str(VM_CODCL,5)+str(VM_CODBCO,3)+str(VM_NROCH,6),NIL,.F.,3)                           when VM_FL
@16,50 say 'Doc Origem:' get VM_DOCORI pict mI6
@18,25 say 'Vlr Cheque:' get VM_VALOR  pict mD82
@19,25 say 'Dt.Emissao:' get VM_DTEMI  pict mDT
@20,25 say 'Dt.Vencim.:' get VM_DTVEN  pict mDT valid VM_DTEMI<=VM_DTVEN
@21,25 say 'Historico.:' get VM_HIST   pict mXXX
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
 function CXAPPRE3() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
nX1:='N'
nX :=15
pb_box(nX++,10,,,,'Informe')
nX++
@nX++,12 say 'Mostrar Tudos Lancamentos ?' get nX1 pict mUUU valid nX1$'SN' when pb_msg('<S>im Mostrar todos lançamentos (pendentes/nao pendente) - <N>ao So mostrar Pendentes')
nX++
@nX++,12 Say 'Numero Cheque:' get NROCH    Pict mI6   when nX1=='N'
@nX++,12 Say 'Valor........:' get Valor    Pict mD82  when nX1=='N'
@nX  ,12 Say 'Limite Data..:' get iData[1] Pict mDT   when nX1=='N'
@nX++,42 Say ' ate '          get iData[2] Pict mDT   when nX1=='N'
read
setcolor(VM_CORPAD)
ORDEM DTVENC
set filter to
if !empty(NROCH)
	Filtro+='CHPRE->C1_NROCH==NROCH'
end
if !empty(VALOR)
	Filtro+=iif(len(Filtro)>0,'.AND.','')+'CHPRE->C1_VALOR==Valor'
end
if !empty(iData[1])
	Filtro+=iif(len(Filtro)>0,'.AND.','')+'CHPRE->C1_DTVEN>=iData[1]'
end
if !empty(iData[2])
	Filtro+=iif(len(Filtro)>0,'.AND.','')+'CHPRE->C1_DTVEN<=iData[2]'
end
if nX1=='S'
	ORDEM DTVENG
	set filter to
else
	set filter to &Filtro
end
go top
pb_lin4(_MSG_+Filtro,ProcName())
return NIL

*-----------------------------------------------------------------------------*
 function CXAPPRE4() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
nOpc:=alert('Selecione...',{'Baixar','Excluir','Limpar Baixados'})
if nOPC==1
	if C1_PEND.and.pb_sn('Baixar cheque pre-datado?;'+pb_zer(C1_CODCL,5)+chr(45)+alltrim(CLIENTE->CL_RAZAO,25)+';Cheque :'+str(C1_NROCH,6)+';Valor:'+transform(C1_VALOR,mD82))
		if reclock()
			replace C1_PEND with .F.
		end
	end
elseif nOPC==2
	if pb_sn('EXCLUIR cheque pre-datado?;'+pb_zer(C1_CODCL,5)+chr(45)+alltrim(CLIENTE->CL_RAZAO,25)+';Cheque :'+str(C1_NROCH,6)+';Valor:'+transform(C1_VALOR,mD82))
		if reclock()
			delete
			skip
		end
	end
elseif nOPC==3
	aData:=bom(date()-30)-1
	if pb_sn('EXCLUIR cheque pre-datado baixados anteritor a '+ dtoc(aData)+' ?')
		ORDEM DTVEN
		go top
		while !eof().and.C1_DTVEN < aData
			if reclock()
				delete
			end
			skip
		end
	end
end
set filter to
skip
if EOF()
	go top
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function CXAPPRE5() // Impressao de cheques
*-----------------------------------------------------------------------------*
nOPC :="A"
aData:={date()-1,date(),date()}
pb_box(18,10,,,,'Selecione')
@19,12 say 'Cheques Pre......:' get nOpc     pict mUUU valid nOPC$'ABT' when pb_msg('<A>tivos  <B>aixados  <T>odos cheques')
@20,12 say 'Data Venc Inicial:' get aData[1] pict mDT
@21,12 say 'Data Venc Final..:' get aData[2] pict mDT valid aData[2]>=aData[1]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	cRel :='Cheques Pre-Datados de '+dtoc(aData[1])+' a '+dtoc(aData[2])
	nPag :=0
	nLar :=132
	aData[3]:=ctod('31/01/1900')
	ORDEM DTVENG
	if nOPC=='A'
		set filter to C1_PEND 
	elseif nOPC=='B'
		set filter to !C1_PEND 
	end
	go top
	dbseek(dtos(aData[1]),.T.)
	nOPC:=0
	while !eof().and.C1_DTVEN<=aData[2]
		nPag:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'CXAPPRE5C',nLar)
		if aData[3]#C1_DTVEN
			?'Data: '+dtoc(C1_DTVEN)
			aData[3]:=C1_DTVEN
		end
		? pb_zer(C1_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)
		??space(1)+str(C1_CODBCO,3)
		??space(1)+C1_CODAGE
		??space(1)+C1_CODCC
		??space(1)+str(C1_NROCH,6)
		??space(1)+str(C1_DOCORI,6)
		??space(1)+transform(C1_VALOR,mD82)
		??space(1)+dtoc(C1_DTEMI)
		??space(1)+if(C1_PEND,'SIM','nao')
		??space(1)+C1_HIST
		nOPC+=C1_VALOR
		skip
	end
	? replicate('-',nLar)
	?padr('Total',74)+transform(nOPC,mD112)
	? replicate('-',nLar)
	pb_deslimp(C15CPP)
	set filter to
	ORDEM CODIGO
	DbGoTop()
end

*-----------------------------------------------------------------------------*
 function CXAPPRE5C() // Cheques Emitidos
*-----------------------------------------------------------------------------*
? 'Data Vencimento'
? 'Cliente'+space(25)+'Bco Agencia'
??space(4)+'C.Corrente'+space(1)+'NrCheque DcOrig'+space(8)+'Valor'+space(2)+'DtEmissao Pend Historico'
? replicate('-',nLar)
return NIL

*----------------------------------------------------------------------------------------------
 function CXAPPREX(P1,P2)
*------------------------------------------------* NATUREZA OPERACAO - Arquivos
local ARQ:='CXAAPRE'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'C1_CODCL', 'N',  5, 0},;	// 01-Código Cliente
				 {'C1_CODBCO','N',  3, 0},;	// 02-Código Banco
				 {'C1_CODAGE','C', 10, 0},;	// 03-Código Agencia
				 {'C1_CODCC', 'C', 12, 0},;	// 04-Código Conta Corrente
				 {'C1_NROCH', 'N',  6, 0},;	// 05-Nro do Cheque
				 {'C1_DOCORI','N',  6, 0},;	// 06-Documento Origem
				 {'C1_VALOR', 'N', 12, 2},;	// 07-Valor cheque
				 {'C1_DTEMI', 'D',  8, 0},;	// 08-Data Emissao
				 {'C1_DTVEN', 'D',  8, 0},;	// 09-Data Validade
				 {'C1_PEND',  'L',  1, 0},;	// 10-Cheque pre-datado ativo ?
				 {'C1_HIST',  'C', 30, 0}},;	// 11-Histórico
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Natureza de Operacao - indices
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. CHEQUES PRE - Reg:'+str(LastRec(),7))
		pack
		Index on dtos(C1_DTVEN)+str(C1_NROCH,6)                   tag DTVENC to (Arq) eval {||ODOMETRO('Dt.Venc/Pend')} for C1_PEND
		Index on dtos(C1_DTVEN)+str(C1_NROCH,6)                   tag DTVENG to (Arq) eval {||ODOMETRO('Dt.Venc/CH')}
		Index on str(C1_CODCL,5)+str(C1_CODBCO,3)+str(C1_NROCH,6) tag CODIGO to (Arq) eval {||ODOMETRO('Cli/Bco/Ch')}
		close
	end
end
return NIL

//-----------------------EOF
