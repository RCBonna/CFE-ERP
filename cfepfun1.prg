*-----------------------------------------------------------------------------*
 static aVariavF1 := {.F.,0,.0,{}}
 //....................1..2..3..4
*-----------------------------------------------------------------------------*
#xtranslate _RT        => aVariavF1\[  1 \]
#xtranslate nX         => aVariavF1\[  2 \]
#xtranslate cLcto      => aVariavF1\[  3 \]
#xtranslate aFAT       => aVariavF1\[  4 \]

*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function FN_ATCONTA(VM_P1,VM_P2,VM_P3,VM_P4,VM_P5)
*-----------------------------------------------------------------------------*
// Atual saldo das Contas - 	VM_P1 - Conta 
//										VM_P2 - Valor
//										VM_P3 - Historico
//										VM_P4 - Data
//										VM_P5 - Nr lote
salvabd()
select ('CTADET')
dbsetorder(1)
if dbseek(str(VM_P1,4)).and.VM_P2#0
	if VM_P2>0
		VM_DSC='CD_DEB_'+pb_zer(month(VM_P4),2)
		replace &VM_DSC with &VM_DSC+abs(VM_P2)
	else
		VM_DSC='CD_CRE_'+pb_zer(month(VM_P4),2)
		replace &VM_DSC with &VM_DSC+abs(VM_P2)
	end
	//-------------------Movimentacao
	select('RAZAO')
	dbappend(.T.)
	replace  RZ_CONTA  with CTADET->CD_CONTA,;
				RZ_DATA   with VM_P4,;
				RZ_NRLOTE with VM_P5,;
				RZ_VALOR  with VM_P2,;
				RZ_HISTOR with VM_P3
end
salvabd(.F.)
return NIL

*-----------------------------------------------------------------------------*
 function FN_ICMS(VM_P1,P2)
*-----------------------------------------------------------------------------*
salvabd()
select('TABICMS')
if P2=='E'
	VM_P1:=TI_ENTR
else
	VM_P1:=TI_SAID
end
salvabd(.F.)
return(.T.)

*-----------------------------------------------------------------------------*
function FN_RTUNID(pProd)
*-----------------------------------------------------------------------------*
if PROD->(dbseek(str(pProd,L_P)))
	salvacor(SALVA)
	setcolor('GR+/R')
	@row()+1,51 say '['+PROD->PR_UND+'] saldo ['+transform(PROD->PR_QTATU,masc(5))+']'
	salvacor(RESTAURA)
	_RT:=.T.
else
	_RT:=.F.
	Alert('Produto nao encontrado: '+str(pProd,L_P))
end
return (.T.)

*-----------------------------------------------------------------------------*
function ChkProdArray(P1,P2,P3)
*-----------------------------------------------------------------------------*
_RT:=.T.
for nX:=1 to len(P2)
	if P2[nX,2]==P1.and.nX#P3
		Tone(1000,2)
		pb_msg('Produto j  incluso.',1,.T.)
		_RT:=.F.
	end
next
return (_RT)

*-----------------------------------------------------------------------------*
function FN_LIBCLI(P1)
*-----------------------------------------------------------------------------*
_RT:=.T.
if CLIENTE->CL_DTSPC#ctod('')
	beepaler()
	fn_cliobs(CLIENTE->CL_CODCL,CLIENTE->CL_DTSPC)
	_RT:=pb_sn(padc('ATENCAO',50,'.')+' cliente com data de registro no SPC <'+dtoc(CLIENTE->CL_DTSPC)+'. Continua a venda ?')
end
if CLIENTE->CL_DTBAIX#ctod('')
	alert('Cliente Inativo desde '+dtoc(CLIENTE->CL_DTBAIX)+';Nao pode haver venda')
	_RT:=.F.
end
return (_RT)

*-----------------------------------------------------------------------------*
function LIBFORN()
*-----------------------------------------------------------------------------*
_RT:=.T.
if CLIENTE->CL_DTBAIX#ctod('')
	alert('Fornecedor Inativo desde '+dtoc(CLIENTE->CL_DTBAIX)+';Nao pode haver movimentacao')
	_RT:=.F.
end
return (_RT)

*-----------------------------------------------------------------------------*
function FN_PORTSER(P2,P3)
*-----------------------------------------------------------------------------*
local P4:=ascan(P2,{|DET|DET[1]==P3})
return(P2[P4,6])

*-----------------------------------------------------------------------------*
function FN_GRPARC(P1,P2)
*-----------------------------------------------------------------------------*
	salvabd(SALVA)
	select('PEDPARC')
	if !dbseek(str(P1,6)) // Já existe?
		while !AddRec();end
	else
		while !reclock();end
	end
	replace  PP_PEDID with P1,;
				PP_PARCE with P2
	salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
function FN_RETPARC(pPedido,pNrParc,pNrDup) // Retorna matriz com dados da fatura/duplicata
*-----------------------------------------------------------------------------*
aFAT:={}
salvabd(SALVA)
select('PEDPARC')
if dbseek(str(pPedido,6))
	for nX:=1 to pNrParc
		aadd(aFAT,{	pNrDup*100+nX,;
						ctod(substr(PP_PARCE,nX*22-21,10)),;
						val( substr(PP_PARCE,nX*22-11,11))/100})
	next
end
salvabd(RESTAURA)
return aFAT

*-----------------------------------------------------------------------------*
function FN_CODCP(P1,P2,P3,P4,P5)  // Condicoes de Pgto
*-----------------------------------------------------------------------------*
local   RT     :=.T.
local   TF     :=savescreen(5,0)
local   VM_MASC:={  masc(12),   masc(23),    masc(25), masc(12),     masc(25)}
local   VM_CAB :={     'Cod','Descricao',   'Entrada',   'Parc','VlrParcelas'}
private TOTV   :=P2
private VM_ROT:={||FATPCDCPT(.T.)}
private VM_ENTRADA:='(TOTV*(CP_PERENT/100))'
private VM_PARCELA:='pb_divzero((TOTV-(TOTV*(CP_PERENT/100)))*(1+CP_AUMENT/100),CP_PARC)'
private VM_CPO    :={'CP_CODCP', 'CP_DESCR',  VM_ENTRADA,'CP_PARC', VM_PARCELA}

salvabd(SALVA)
select('CONDPGTO')
salvacor()
if !dbseek(str(P1,3))
	DbGoTop()
	pb_box(05,00,22,78,,'Condicoes de Pagamento: Valor :'+transform(P2,masc(25)))
	pb_msg('Para incluir uma CONDICAO DE PAGAMENTO press <INS>',NIL,.F.)
	dbedit(06,01,21,77,VM_CPO,'FN_TECLAx',VM_MASC,VM_CAB)
	restscreen(5,0,,,TF)
	P1 :=CP_CODCP
end
	P3 :=trunca(TOTV*(CP_PERENT/100),2) //................ VLR DA ENTRADA
	P2 :=P3 + trunca((TOTV-P3)*(1+CP_AUMENT/100),2) //.....VLR TOTAL
	P4 :=CP_PARC
	P5 :=CP_DIAEPA
salvacor(.F.)
salvabd(RESTAURA)
return(RT)

*-----------------------------------------------------------------------------*
function ADDTEMP(P1,P2,P3) // grava temp
*-----------------------------------------------------------------------------*
salvabd(SALVA)
select('TEMP')
dbappend()
replace  XX_CHAVE with P1,;
			XX_ALIAS with upper(P2),;
			XX_RECNO with P3
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
function IMPRPRE(P1,P2,VM_REL) // produtos de entrada
*-----------------------------------------------------------------------------*
local FLAG:=.F.
local TOT :=0
salvabd(SALVA)
select('ENTDET')
dbseek(str(P1,8),.T.)
while !eof().and.P1==ED_DOCTO
	if ED_CODFO==P2
		if fn_vergrpr(ENTDET->ED_CODPR)
			if FLAG.and.VM_CPO[1]=='A'
				?space(18)
			end
			if VM_CPO[1]=='A'
				??padr('Venda de '+alltrim(str(ED_QTDE))+' '+trim(PROD->PR_UND)+' '+PROD->PR_DESCR,50)
				??transform(ED_VALOR,masc(2))
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXTRA',VM_LAR)
				FLAG  :=.T.
			end
			TOT+=ED_VALOR
		end
	end
	dbskip()
end
if VM_CPO[1]=='S'.and.TOT>0
	??padr('Vendas',50)
	??transform(TOT,masc(2))
end
salvabd(RESTAURA)
return TOT

*-----------------------------------------------------------------------------*
function IMPRPRS(P1,VM_REL) // produtos de saida
*-----------------------------------------------------------------------------*
local FLAG:=.F.
local TOT :=0
salvabd(SALVA)
select('PEDDET')
dbseek(str(P1,6),.T.)
while !eof().and.P1==PD_PEDID
	if fn_vergrpr(PEDDET->PD_CODPR)
		if FLAG.and.VM_CPO[1]=='A'
			?space(18)
		end
		if VM_CPO[1]=='A'
			??padr('Compra de '+alltrim(str(PD_QTDE))+' '+trim(PROD->PR_UND)+' '+PROD->PR_DESCR,63)
			??transform(round(PD_VALOR*PD_QTDE,2)-PD_DESCV-PD_DESCG,masc(2))
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPEXTRA',VM_LAR)
			FLAG  :=.T.
		end
		TOT+=round(PD_VALOR*PD_QTDE,2)-PD_DESCV-PD_DESCG
	end
	dbskip()
end
if VM_CPO[1]=='S'.AND.TOT>0
	??padr('Compras',63)
	??transform(TOT,masc(2))
end
salvabd(RESTAURA)
return TOT

*-----------------------------------------------------------------------------*
function CFEPEXTRA()
*-----------------------------------------------------------------------------*
//if TIPOREL=='A'
//	? 'Associado.: '
//	??pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
//elseif TIPOREL=='C'
//	? 'Cliente...: '
//	??pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
//elseif TIPOREL=='F'
//	? 'Fornecedor: '
//	??pb_zer(VM_CLI,5)+'-'+CLIENTE->CL_RAZAO
//end
//?
?'  Data   Document Historico'+space(49)+'  Venda       Compra'
?replicate('-',VM_LAR)
return NIL

*----------------------------------------------------------------------------*
function FN_SELGRU(P1,P2)
*-----------------------------------------------------------------------------*
local OPC    :=1
local TF     :=savescreen()
local Getlist:={}
if P1=='S'
	while OPC>0
		OPC:=ABROWSE(10,0,22,48,P2,;
										{ 'Grupo','Descri‡Æo'},;
										{     8  , 35},;
										{masc(13),masc(1)},,'SelecÆo de Grupos')
		if OPC>0
			VM_CODGR:=P2[OPC,1]
			@row(),2 get VM_CODGR pict masc(13) valid fn_codigo(@VM_CODGR,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_CODGR,6)))},{||CFEP4100T(.T.)},{2,1}}).and.VM_CODGR%10000#0
			read
			if lastkey()#K_ESC
				P2[OPC,1]:=VM_CODGR
				P2[OPC,2]:=GRUPOS->GE_DESCR
			end			
		else
			exit
		end
	end
end
restscreen(,,,,TF)
return(.T.)

*----------------------------------------Conferencia nat.operacao para venda e compra
function CONFNATOP(P1,P2)
*-------------------------------------------------------------------------------------
_RT:=.T.
if NATOP->NO_FLTRAN#'S'
	if NATOP->NO_TPOPER // INTERESTADUAL
		if P1 == PARAMETRO->PA_UF
			alert('Natureza de Operacao para;Operacoes Interestaduais;'+P2+' de '+P1)
			_RT:=.F.
		end
	else
		if  P1 # PARAMETRO->PA_UF
				alert('Natureza de Operacao para;Operacoes Estaduais;'+P2+' de '+P1)
			_RT:=.F.
		end
	end
end
return (_RT)

*----------------------------------------Verifica Nat.OP x CC x Lote
function CONFLOTCCNAT(pCodCli,pLote)
*-------------------------------------------------------------------------------------
_RT:=.T.
if pLote>0
	if !LOTEPAR->(dbseek(str(pCodCli,5)+str(pLote,4)))
		alert('Lote nao cadastrado para este cliente.')
		_RT:=.F.
	else
		if !empty(LOTEPAR->LP_DTFECH)
			Alert('Lote cadastrado mas já fechado '+dtoc(LOTEPAR->LP_DTFECH))
			_RT:=.F.
		end
	end
elseif pLote<0
	alert('Lote deve ser ZERO para transferencia normais ou Maior que ZERO.')
	_RT:=.F.
end
if _RT.and.pLote>0.and.NATOP->NO_FLTRAN=='S'
	if CLIENTE->CL_CCTRA1==0.and.PARAMETRO->PA_CONTAB==USOMODULO
		alert('Transferencia;Cliente sem Conta Contabil cadastrada;Cadastro de cliente')
		_RT:=.F.
	end
end
return (_RT)

*--------------------------------------------------------------------------------------
function LinDetProd(P1)
*--------------------------------------------------------------------------------------
return ({P1,; 							//  1 -Seq
			 0,;							//  2 -Prod
			 replicate('.',20),;		//  3 -Descr
			 0.00,;						//  4 -Qtde
			 0.000,;						//  5 -Vlr unit venda
			 0.00,;						//  6 -Vlr Desconto
			 0.00,;						//  7 -Vlr Enc Financ
			 CODTR->CT_CODTR,;		//  8 -Cod tributario
			 0.00,;						//  9 -% ICMS
			 ' ',;						// 10 -Unidade
			 100.00,;					// 11 -% Tributacao
			 0.00,;						// 12 -Qtd anterior
			 0,;							// 13 -Registro->alteracao
			 0.00,;						// 14 -Preco medio
			 0.00,;						// 15 -Vlr ICMS
			 0.00,;						// 16 -BASE Icms
			 NATOP->NO_CODIG,;		// 17 -Cod-Nat.Operacao
			 'II',;						// 18 -Codigo impress Fiscal
			 0,;							// 19 -Nro Adiantamento
			 space(10),;				// 20 -Classificação Fiscal
			 0,;							// 21 -Grupo-Dest-Transf-DEBITO
			 0,;							// 22 -Grupo-Dest-Transf-CREDITO
			 '   ',;						// 23 -Código PIS (interno)
			 0,;							// 24 -% PIS
			 0,;							// 25 -Base PIS
			 0,;							// 26 -Valor PIS
			 0,;							// 27 -% Cofins
			 0,;							// 28 -Base Cofins
			 0,;							// 29 -Valor Cofins
			 0})							// 30 -Vlr Desconto Geral Proporcional

*-------------------------------------------------------------*
function BuscTipoCx(pTipo)
*-------------------------------------------------------------*
cLcto:=0
SALVABANCO
select CAIXACG
GO TOP
while !eof()
	if CG_TIPOM == pTipo
		if cLcto == 0
			cLcto := CG_CODCG
		else
			cLcto := 99999
		end
	end
	skip
end
RESTAURABANCO
if cLcto == 99999
	cLcto := 0
end
Return (cLcto)

*-------------------------------------------------------------*
function BuscBcoCx()
*-------------------------------------------------------------*
cLcto:=0
SALVABANCO
select BANCO
GO TOP
dbeval({||cLcto:=BANCO->(RECNO())},{||BANCO->BC_CAIXA.and.cLcto==0})
BANCO->(DbGoTo(cLcto))
RESTAURABANCO
Return (BANCO->BC_CODBC)
*------------------------------------------------------------------EOF
