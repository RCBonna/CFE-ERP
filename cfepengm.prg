//-----------------------------------------------------------------------------*
  static aVariav:= {.T.,0,.F.,'', 500,0,.F.,0,0,{},.T.,'', 0, '', 80, 0, {}, '' }
//...................1.2...3..4....5..6..7..8.9.10..11.12.13..14..15.16, 17..18
//-----------------------------------------------------------------------------*
#xtranslate lRT      => aVariav\[  1 \]
#xtranslate nX       => aVariav\[  2 \]
#xtranslate lCont    => aVariav\[  3 \]
#xtranslate ArqTmp   => aVariav\[  4 \]
#xtranslate nLimite  => aVariav\[  5 \]
#xtranslate nAux     => aVariav\[  6 \]
#xtranslate lProc    => aVariav\[  7 \]
#xtranslate nVlrEst  => aVariav\[  8 \]
#xtranslate nQtdEst  => aVariav\[  9 \]
#xtranslate aData    => aVariav\[ 10 \]
#xtranslate lSair    => aVariav\[ 11 \]
#xtranslate cTpLista => aVariav\[ 12 \]
#xtranslate nProdPai => aVariav\[ 13 \]
#xtranslate cRel     => aVariav\[ 14 \]
#xtranslate nLar     => aVariav\[ 15 \]
#xtranslate nPag     => aVariav\[ 16 \]
#xtranslate aCusFix  => aVariav\[ 17 \]
#xtranslate cLote		=> aVariav\[ 18 \]

*-----------------------------------------------------------------------------*
 function CFEPENGM()	// Cadastro de Itens de Engenharia 								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'C->PARALINH' ,;
				'R->CODTR'    ,;
				'R->ALIQUOTAS',;
				'C->DIARIO',	;
				'C->XOBS'     ,;
				'C->GRUPOS'   ,;
				'C->PROD'     ,;
				'C->ENGPAI'   ,;
				'C->ENGFIL'   ,;
				'C->MOVEST'})
	return NIL
end
cLote:=SONUMEROS(Time())
select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0
select('PROD')
ORDEM CODIGO
DbGoTop()
select('MOVEST')
ORDEM DTCOD
pb_tela()
pb_lin4(_MSG_,ProcName())
VM_CAMPO:={ fieldname(7),;	// Tipo
				fieldname(2),; // Data
				'str(MOVEST->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,22)',;
				fieldname(3),; // Docto
				fieldname(4),; // Qtde
				fieldname(5);	// Vlr Mov Médio
				}
VM_CABE    :={'T','Dt Movto','Produto','Dcto','Qtde.','Vlr.Est.'}

while .T.
	lSair      :=.T.
	set relation to str(MOVEST->ME_CODPR,L_P) into PROD
	go top
	pb_dbedit1('CFEPENGM','EntradLista Ajuste')
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
	if lSair
		exit
	end
end
dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGM1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
local GETLIST := {}
lCont    := .T.
VM_CODPR :=0
VM_VERSAO:=0
VM_DTMOV :=PARAMETRO->PA_DATA
VM_DOCTO :=val(dtos(VM_DTMOV))
VM_QTDE  :=0

pb_box(05,00,10,79,,'Entrada Producao')
@06,01 say 'C¢d.Produto...:' get VM_CODPR   pict masc(21) 	valid fn_codpr(@VM_CODPR,78).and.EngVersao(VM_CODPR,@VM_VERSAO).and.VM_VERSAO>0;
																				when pb_msg('Informe Codigo Produto Pai')
@07,01 say 'Versao Formula:' get VM_VERSAO  pict mI3                                             when .F.
@07,48 say 'Dt.Movimento:'   get VM_DTMOV   pict mDT        valid VMP_DTVALI<=PARAMETRO->PA_DATA when .F.
@08,48 say 'Documento...:'   get VM_DOCTO   pict mI8                                             when .F.
@08,01 say 'Qtde Produzir.:' get VM_QTDE    pict mI8        valid VM_QTDE > 0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)

	Conta1:=Plinha('ContaCustoFixoMO' ,0,'N')
	Conta2:=Plinha('ContaCustoFixoOUT',0,'N')
	Conta3:=Plinha('ContaCustoFixoEst',0,'N')
	Valor1:=Plinha('VlrCustoFixoMO'   ,0,'N')
	Valor2:=Plinha('VlrCustoFixoOUT'  ,0,'N')

	aCusFix:={{'Custo Fixo MO.:',   trunca(VM_QTDE*Valor1/1000,2)},;
				 {'Custo Fixo Outros:',trunca(VM_QTDE*Valor2/1000,2)}}

	@09,01 say aCusFix[1,1]+str(aCusFix[1,2],12,2) color 'W+/G'
	@09,48 say aCusFix[2,1]+str(aCusFix[2,2],12,2) color 'W+/G'

	select('ENGPAI')
	dbseek(str(VM_CODPR,L_P)+str(VM_VERSAO,3))
	if ENGPAI->ITP_VLIMIT>0
		nLimite :=ENGPAI->ITP_VLIMIT
	end

	ArqTmp  :=ArqTemp(,,'') // Gera Nome Arq Temporário
	lRT     :=.T.
	select('MOVEST')
	copy Structure to (ArqTmp)
	if !net_use(ArqTmp,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
		lRT:=.F.
	end
	if lRT // Continua ?
		nAux := {0,0}
		
		select('ENGFIL')
		dbseek(str(VM_CODPR,L_P)+str(VM_VERSAO,3),.T.)
		while !eof().and.str(VM_CODPR,L_P)+str(VM_VERSAO,3)==str(ITF_CODPRP,L_P)+str(ITF_VERSAO,3) // prod filhos
			select('WORK')
			PROD->(dbseek(str(ENGFIL->ITF_CODPR,L_P)))
			while !PROD->(reclock());end
			set Decimals to 5
			pPerc:= ENGFIL->ITF_QTDADE/nLimite // Percentual do Produto que compoem a Fórmula
			AddRec(,{ENGFIL->ITF_CODPR,;//............................1
						VM_DTMOV,;//.....................................2
						VM_DOCTO,;//.....................................3
						trunca(pPerc*VM_QTDE,3),;//......................4-Qtde Mov
						0,; //...........................................5-Vlr Medio - Calc Abaixo
						0,;//............................................6
						'S',;//..........................................7 Saida
						PROD->PR_CTB,;//.................................8 
						'EPR',;//........................................9 Engenharia Produto (Serie)
						VM_CODPR,;//....................................10-Codigo Pai (CodFO)
						0,;//...........................................11
						0,;//...........................................12
						PROD->PR_QTATU*10,;//...........................13 Estoque do Produto (*10 POR causa da 3.casa decimal)
						.F.,;//.........................................14 Contabilizado
						'S'})//.........................................15 Forma "S-Saida"
			replace WORK->ME_VLEST with trunca(pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*WORK->ME_QTD,2)
			nAux[1]+=WORK->ME_QTD
			select('ENGFIL')
			skip
		end
		select('WORK')
		if nAux[1]>0
			if str(nAux[1],12,3)#str(VM_QTDE,12,3)
				replace WORK->ME_QTD with WORK->ME_QTD+(VM_QTDE-nAux[1])
			end
			lProc:=.F.
			CFEPENGMX()
		else
			Alert('Problemas com formula solicitada')
		end
	end
	select WORK
	Close
	FileDelete (ArqTmp + '.*')
	select('MOVEST')
	dbUnLockAll()
	keyboard '0'
	lSair :=.F.
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGM2() // Lista 
*-----------------------------------------------------------------------------*
aData   :={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
cRel    :='Mov.Producao ('
nPag    :=0
nLar    :=80
cTpLista:='S'
pb_box(17,20,,,,'Selecao')
@19,22 say 'Data Inicial............:' get aData[1] pict mDT
@20,22 say 'Data Final..............:' get aData[2] pict mDT  valid aData[2]>=aData[1]
@21,22 say 'Imprimir Resumo ?        ' get cTpLista pict mUUU valid cTpLista$'SN'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cRel  +=dtoc(aData[1])+ ' a ' + dtoc(aData[2])+')'
	lRT   :=.T.
	SALVABANCO
	ArqTmp:=ArqTemp(,,'') // Gera Nome Arq Temporário
	dbcreate(ArqTmp,{ {'WK_CODPRP','N',L_P,0},;//1
							{'WK_CODPRF','N',L_P,0},;//2
							{'WK_QTDE',  'N', 12,3},;//3
							{'WK_VLR1',  'N', 15,2};// 4
							})
	if !net_use(ArqTmp,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
		lRT:=.F.
	else
		Index on str(WK_CODPRP,L_P)+str(WK_CODPRF,L_P) tag CODIGO1 to (ArqTmp)
		Index on str(WK_CODPRF,L_P)                    tag CODIGO2 to (ArqTmp)
		OrdSetFocus('CODIGO1')
	end
	RESTAURABANCO
	if lRT
		lRT:=.F.
		select('MOVEST')
		go top
		dbseek(dtos(aData[1]),.T.)
		pb_msg('Gerando dados....')
		while !eof().and.ME_DATA<=aData[2]
			if ME_SERIE=='EPR'.and.ME_TIPO=='S' // Só Producao <S>aidas
				select('WORK')
				if !dbseek(str(MOVEST->ME_CODFO,L_P)+str(MOVEST->ME_CODPR,L_P))
					AddRec(,{MOVEST->ME_CODFO,;//........1-Pai
								MOVEST->ME_CODPR,;//........2-Produto Usado
								0,;
								0,;
								})
				end
				replace 	WK_QTDE with WK_QTDE + MOVEST->ME_QTD,;
							WK_VLR1 with WK_VLR1 + MOVEST->ME_VLEST
				select('MOVEST')
				lRT:=.T.
			end
			skip
		end
		if lRT.and.pb_ligaimp(C15CPP)
			select('WORK')
			go top
			nProdPai:=0
			nAux    :={0,0}
			while !eof()
				nPag    := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'CFEPENGM2C',nLar)
				if nProdPai#WORK->WK_CODPRP
					if nProdPai # 0
						?
						?space(11+L_P)+padr('Sub-Total',30)+str(nAux[2],11,3)+str(nAux[1],13,2)
						?
					end
					nProdPai:=WORK->WK_CODPRP
					nAux    :={0,0}
					PROD->(dbseek(str(nProdPai,L_P)))
					? str(nProdPai,L_P)+'-'+PROD->PR_DESCR
				end
				PROD->(dbseek(str(WORK->WK_CODPRF,L_P)))
				? space(10)+str(WORK->WK_CODPRF,L_P)+'-'+left(PROD->PR_DESCR,30)
				??str(WORK->WK_QTDE,11,3)+str(WORK->WK_VLR1,13,2)
				nAux[1]+=WORK->WK_VLR1
				nAux[2]+=WORK->WK_QTDE
				skip
			end
			?
			?space(11+L_P)+padr('Sub-Total',30)+str(nAux[2],11,3)+str(nAux[1],13,2)
			?
			if cTpLista=='S'
				SetPrc(60,0)
				nPag    := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'CFEPENGM2C',nLar)
				?padc('RESUMO DA UTILIZACAO DOS PRODUTOS INSUMOS',nLar)
				?
				OrdSetFocus('CODIGO2')
				go top
				nVlrEst:=0
				nAux   :={0,0}
				while !eof()
					nProdPai:=WORK->WK_CODPRF
					nVlrEst :=0
					nQtdEst :=0
					while !eof().and.nProdPai==WORK->WK_CODPRF
						nVlrEst+=WORK->WK_VLR1
						nQtdEst+=WORK->WK_QTDE
						skip
					end
					PROD->(dbseek(str(nProdPai,L_P)))
					? space(05)+str(nProdPai,L_P)+'-'+left(PROD->PR_DESCR,30)
					??str(nQtdEst,11,2)+str(nVlrEst,13,2)+str(PROD->PR_QTATU,13,2)
					nAux[1]+=nVlrEst
					nAux[2]+=nQtdEst
				end
				?replicate('-',nLar)
				?space(11+L_P)+padr('Total Geral',25)+str(nAux[2],11,2)+str(nAux[1],13,2)
			end
			?replicate('-',nLar)
			eject
			pb_deslimp(C15CPP)
		end
	end
	select WORK
	Close
	FileDelete (ArqTmp + '.*')
	select('MOVEST')
	go top
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGM2C() // Insumos
*-----------------------------------------------------------------------------*
?'Produto Produzido'
?space(05)+padr('Produto Insumo',L_P+32)+'Quantidade Vlr MovEstoq Sld Estoque'
?replicate('-',nLar)
return nil

*-----------------------------------------------------------------------------*
 function CFEPENGM3() // Rotina de Ajuste
*-----------------------------------------------------------------------------*
if pb_sn('Eliminar registros incorretos?')
	go top
	nX:=1
	while !eof()
		if empty(ME_CODPR).or.;
			empty(ME_TIPO) .or.;
			empty(ME_VLEST).or.;
			empty(ME_QTD)  .or.;
			empty(ME_DATA)
			if RecLock()
				pb_msg('Nro Registro de movimento eliminados'+str(nX,5))
				delete
				nX++
			end
		end
		skip
	end
	DbRUnLock()
	DbCommitAll()
end
go top
return nil

*-----------------------------------------------------------------------------*
 static function CFEPENGMX()
*-----------------------------------------------------------------------------*
nAux:=1000

set relation to str(WORK->ME_CODPR,L_P) into PROD
VM_CAMPOF:={	'str(WORK->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,25)+chr(45)+WORK->ME_FORMA',;
					fieldname(04),; //........Qtde
					fieldname(13)+'/10',; //..Saldo Prd
					fieldname(05); //.........Vlr Mov Médio
					}

VM_CABECF:={'Produto','Qtde Usada','Saldo Est','Vlr.Custo' }
aMascara :={    mUUU ,		mI113  ,    mI113  ,   mI102    }
while .T.
	go top
	pb_dbedit1('CFEPENGMX','ProcesAjuste')
	dbedit(11,01,maxrow()-3,maxcol()-1,VM_CAMPOF,'PB_DBEDIT2',aMascara,VM_CABECF)
	if nAux==1000.and.pb_sn('Abandonar Processamento ?')
		exit
	elseif nAux#1000
		exit
	end
end
set relation to
Keyboard '0'
lSair :=.F.
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGMX1() // Processar Entrada/Saidas Producao
*-----------------------------------------------------------------------------*
nAux:=0
go top
while !eof()
	if str(WORK->ME_QTD,12,3) > str(WORK->ME_VICMS/10,12,3).or.str(WORK->ME_VLEST,12,2) == str(0,12,2)
		nAux++
	end
	skip
end
if nAux>0
	alert('*** ERRO ***;Exitem Produtos sem Saldo ou Custo Zerado;para processar este pedido;Processamento Cancelado')
else
	if pb_sn('Processar Entrada de Producao ?')
		ProcesProd()
		keyboard '0'
	end
end
go top
return NIL

*-----------------------------------------------------------------------------*
	function CFEPENGMX2() // Ajustes antes de Processar Produção
*-----------------------------------------------------------------------------*
if pb_sn('E possivel nao descontar itens do estoque;Neste processamento voce deseja NAO baixar estoque;do produto:'+str(WORK->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,25))
	replace WORK->ME_FORMA with "*"
end
go top
return NIL

*-----------------------------------------------------------------------------*
	static function ProcesProd() // Processar Produção
*-----------------------------------------------------------------------------*
private VM_VLRV:= 0
        nVlrEst:= aCusFix[1,2]+aCusFix[2,2] // Custo Fixo
        nQtdEst:= 0
go top
while !eof()
	if !(	str(ME_QTD,12,3) > str(WORK->ME_VICMS/10,12,3).or.;
			str(WORK->ME_VLEST,12,2) == str(0,12,2))
		if WORK->ME_FORMA=='S'
			PROD->(dbseek(str(WORK->ME_CODPR,L_P)))
			replace 	PROD->PR_VLATU with max(PROD->PR_VLATU-WORK->ME_VLEST,0),;
						PROD->PR_QTATU with max(PROD->PR_QTATU-WORK->ME_QTD,0),;
						PROD->PR_DTMOV with VM_DTMOV
			select('MOVEST')
			AddRec(,{WORK->(FieldGet(01)),;//..........1-CodProduto
						WORK->(FieldGet(02)),;//..........2-Data
						WORK->(FieldGet(03)),;//..........3-Docto
						WORK->(FieldGet(04)),;//..........4-Qtd Movimentada
						WORK->(FieldGet(05)),; //.........5-Vlr Medio
						WORK->(FieldGet(05)),;//..........6-Vlr Venda
						WORK->(FieldGet(07)),;//..........7 Tipo <S>aida <E>ntrada
						WORK->(FieldGet(08)),;//..........8 
						WORK->(FieldGet(09)),;//..........9 Engenharia Produto (Serie)
						WORK->(FieldGet(10)),;//.........10
						WORK->(FieldGet(11)),;//.........11
						WORK->(FieldGet(12)),;//.........12
						0,;//............................13 Valor ICMS ()
						WORK->(FieldGet(14)),;//.........14 Contabilizado
						WORK->(FieldGet(15));//..........15 Forma
						})
			nVlrEst+=WORK->(FieldGet(05))
			nQtdEst+=WORK->(FieldGet(04))
		end
		select('WORK')
	end
	skip
end
if nVlrEst+nQtdEst>0
	fn_vlven(@VM_VLRV,(nVlrEst/VM_QTDE),VM_CODPR,0,0,0)
	PROD->(dbseek(str(VM_CODPR,L_P)))
	while !PROD->(reclock());end
	replace 	PROD->PR_VLATU with max(PROD->PR_VLATU+nVlrEst,0),;
				PROD->PR_QTATU with max(PROD->PR_QTATU+VM_QTDE,0),;
				PROD->PR_DTMOV with VM_DTMOV
	if str(PROD->PR_VLVEN,12,2) == str(0,15,2)
		replace PROD->PR_VLVEN with VM_VLRV
	end
	select('MOVEST')
	AddRec(,{VM_CODPR,;//.........1
				VM_DTMOV,;//.........2
				VM_DOCTO,;//.........3
				VM_QTDE,;//..........4-Qtd Movimentada
				nVlrEst,; //.........5-Vlr Medio
				nVlrEst,;//..........6-Vlr Venda
				'E',;//..............7 Tipo <S>aida <E>ntrada
				PROD->PR_CTB,;//.....8 
				'EPR',;//............9 Engenharia Produto (Serie)
				VM_VERSAO,;//.......10 Codigo Versao Prod Pai
				0,;//...............11
				0,;//...............12
				0,;//...............13 Estoque do produto
				.F.,;//.............14 Contabilizado
				'S'})//.............15 Forma <Silo>
	ProdContabiliza()
end
alert('Producao processada;Movimentacao no Estoque concluida.')
return NIL

*----------------------------------------------------------------
static function ProdContabiliza()
*----------------------------------------------------------------
	fn_atdiario(VM_DTMOV,;
					Conta1,;	// CTA Estoque
					CRE*aCusFix[1,2],;
					'Apropriacao Custo Fixo ref.Ord.Producao',;
					'PRO/'+pb_zer(VM_DOCTO,8)+':'+cLote)

	fn_atdiario(VM_DTMOV,;
					Conta2,;	// CTA Estoque
					CRE*aCusFix[2,2],;
					'Apropriacao Custo Fixo ref.Ord.Producao',;
					'PRO/'+pb_zer(VM_DOCTO,8)+':'+cLote)

	fn_atdiario(VM_DTMOV,;
					Conta3,;	// CTA Estoque
					DEB*aCusFix[1,2]+aCusFix[2,2],;
					'Apropriacao Custo Fixo ref.Ord.Producao',;
					'PRO/'+pb_zer(VM_DOCTO,8)+':'+cLote)
return NIL

//-----------------------------------EOF-------------------------------------
