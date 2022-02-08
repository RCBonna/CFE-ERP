//-----------------------------------------------------------------------------*
  static aVariav := {0,0,{}, 0,   0,  0,  0,  0, 0,    0,    0,  0}
//...................1..2.3..4....5...6...7...8..9....10....11..12
//-----------------------------------------------------------------------------*
#xtranslate ORD      => aVariav\[  1 \]
#xtranslate BICM     => aVariav\[  2 \]
#xtranslate aBASES   => aVariav\[  3 \]
#xtranslate vICMS    => aVariav\[  4 \]
#xtranslate BASE     => aVariav\[  5 \]
#xtranslate SODESG   => aVariav\[  6 \]
#xtranslate PERDES   => aVariav\[  7 \]
#xtranslate nBAICM   => aVariav\[  8 \]
#xtranslate MAIOR    => aVariav\[  9 \]
#xtranslate INDIC    => aVariav\[ 10 \]
#xtranslate nPesoTot => aVariav\[ 11 \]
#xtranslate vBASETOT => aVariav\[ 12 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function FATPGRPE(P1,P2) //-----------------------------------Gravar Pedidos *
*-----------------------------------------------------------------------------*

BICM     :=0
BASE     :=0
INDIC    :=0
PERDES   :=pb_divzero(VM_DESCG,VM_TOT)
SODESG   :=0.00
MAIOR    :=0.00
ORD      :=0
nPesoTot :=0
vBASETOT :=0

VM_ENCFI := if(type("VM_ENCFI") =='N',VM_ENCFI  ,0.00)
VM_TPTRAN:= if(type("VM_TPTRAN")=='N',VM_TPTRAN ,0   )
VM_LOTE  := if(type("VM_LOTE")  =='N',VM_LOTE   ,0   )
P1       := if(      P1         ==Nil, 'Novo'   ,P1  )
P2       := if(      P2         ==Nil, 'Produto',P2  )

salvabd(SALVA)
select('PEDCAB')
if P1=='Novo'
	while !AddRec();end
else
	if !dbseek(str(VM_ULTPD ,6))
		alert('FATPGRPE(Erro?)=Pedido '+str(VM_ULTPD ,6)+' em alteracao;nao foi encontrado no arquivo')
		return NIL
	end
	while !reclock();end
end

//-------------------------------------------------------EXCLUIR VALORES ANTERIORES DOS ITENS
select('PEDDET')
dbseek(str(VM_ULTPD,6),.T.)
while !eof().and.PD_PEDID==VM_ULTPD
	while !reclock();end
	dbdelete()
	dbskip()
end
select('PEDCAB')
//-------------------------------------------------------EXCLUIR VALORES ANTERIORES DOS ITENS
replace  PC_PEDID  with VM_ULTPD
replace  PC_CODCL  with VM_CLI
replace  PC_DTEMI  with PARAMETRO->PA_DATA
replace  PC_DESC   with VM_DESCG				//....................Vlr Desconto GERAL
replace  PC_DESCIT with VM_DESCIT			//....................Vlr Desconto Itens
replace  PC_TOTAL  with VM_TOT-VM_DESCG	//....................Liquido -> Pagar (desconto item já esta VM_TOT
replace  PC_VLRENT with VM_VLRENT			//....................Vlr Entrada
replace  PC_ENCFI  with VM_ENCFI				//....................Vlr Encargos Financeiros
replace  PC_CODOP  with VM_CODOP				//....................Natureza de Operacao (CFOP)
replace  PC_FATUR  with VM_PARCE
replace  PC_VEND   with VM_VEND
replace  PC_SERIE  with VM_SERIE
replace  PC_OBSER  with VM_OBS
replace  PC_CODFC  with VM_CODFC				//...................Cod.Funcionario p/Convenios
replace  PC_DESVC  with VM_SVC				//...................Descricao para servicos
replace  PC_NRCXA  with NUM_CXA				//...................param set -> numero do caixa para a venda
replace  PC_LOTE   with VM_LOTE
replace  PC_TPTRAN with VM_TPTRAN			//....................Tipo transferencia (1) ou (2)
replace  PC_FLAG   with .F.					//.........................NF nao impressa
replace  PC_FLSVC  with !(P2=='Produto')	//............é produto = falso
replace  PC_FLADTO with VM_FLADTO=='S'
replace  PC_GERAC  with 'G'
replace  PC_NFEDEV with VM_DEVNFE 			//............NFE Devolução (Chave)

//--------------------------------Ratear Desconto Geral para Itens
for ORD:=1 to len(VM_DET)
	if VM_DET[ORD,02]	#0 .and. VM_DET[ORD,04]>0		// Produto e quantidade > 0
		VM_DET[ORD,30]	:=Trunca(VLRLIQ(ORD)*PERDES)	// Guarda Rateio Desconto Geral
		SODESG			+=VM_DET[ORD,30]
		if VLRLIQ(ORD)	>MAIOR
			MAIOR			:=VLRLIQ(ORD)
			INDIC			:=ORD
		end
	end
next

//.....................100    99
if INDIC>0
	VM_DET[INDIC,30]+=(VM_DESCG-SODESG) // colocar diferenca no item de maior valor
end
if P2 == 'Servico'
	//--------------------------------Gravar Detalhes Servicos
	select('PEDSVC')
	for ORD:=1 to len(VM_DET)
		if VM_DET[ORD,02]#0.and.VM_DET[ORD,04]>0 // Produto e Quantidade > 0
			nBAICM :=round((VLRLIQ(ORD)-VM_DET[ORD,30])*VM_DET[ORD,11]/100,2)
			while !AddRec(30);end
			replace  PS_PEDID  with VM_ULTPD //.........
			replace	PS_ORDEM  with ORD //..............
			replace	PS_CODSVC with VM_DET[ORD,02] //...
			replace	PS_QTDE   with VM_DET[ORD,04] //...Quantidade Vendida
			replace	PS_VALOR  with VM_DET[ORD,05] //...Unitario Venda
			replace	PS_DESCV  with VM_DET[ORD,06] //...Desc do Item
			replace	PS_DESCG  with VM_DET[ORD,30] //...Desc geral proporcional
			replace	PS_ICMSP  with VM_DET[ORD,09] //...% Icms
			replace	PS_CODTR  with VM_DET[ORD,08] //...codigo triburario
			replace	PS_PTRIB  with VM_DET[ORD,11] //...% Tributacao 
			replace	PS_BAICM  with nBAICM //.........
			replace	PS_VLICM  with round(nBAICM*VM_DET[ORD,9]/100,2)
			replace	PS_CODOP  with VM_DET[ORD,17]
			replace  PS_CODCOF with '099'
			dbskip(0)
			dbcommit()
			VM_DET[ORD,13]:=recno()
		end
	next
else
	//--------------------------------Gravar Detalhes

	select('PEDDET')
	for ORD:=1 to len(VM_DET)
		if VM_DET[ORD,02]#0.and.VM_DET[ORD,04]>0 // Produto e Quantidade > 0
			BASE  :=Trunca(VLRLIQ(ORD)-VM_DET[ORD,30],2) // Base Icms Menos Descontos
			vICMS :=Trunca(BASE*(VM_DET[ORD,09]/100)*(VM_DET[ORD,11]/100),2)
			aBASES:=CalcSitTr(VM_DET[ORD][08],BASE,VM_DET[ORD,09],vICMS,VM_DET[ORD,11]/100,0)
			//.................CST............BASE,% ICMS.......Vlr ICMS,%Trib,      IPI
			while !AddRec(30);end
			PROD->(dbseek(str(VM_DET[ORD,02],L_P)))
			GRUPOS->(dbseek(str(PROD->PR_CODGR,6)))
			NATOP->(dbseek(str(VM_DET[ORD,17],7)))
			VM_DET[ORD,26]:=0 // % Pis
			VM_DET[ORD,27]:=0	// % Cofins
			if NATOP->NO_FLPISC=='S'
				if FISACOF->(dbseek(PROD->PR_CODCOS+CLIENTE->CL_TIPOFJ))
					VM_DET[ORD,26]:=Trunca(BASE*FISACOF->CO_PERC1/100,2)	// % e Vlr Pis
					VM_DET[ORD,27]:=Trunca(BASE*FISACOF->CO_PERC2/100,2)	// % e Vlr Cofins
				else
	//				alert('PRODUTO='+pb_zer(VM_DET[nX,2],L_P)+';CDPISCF='+PROD->PR_CODCOS+';CLI-TIP='+CLIENTE->CL_TIPOFJ+';Erro PIS/COFINS na NF-Saida')
				end
			end
			*------------------------------------------------> Falta gravar o pis+cofins
			replace  PD_PEDID   with VM_ULTPD
			replace  PD_ORDEM   with ORD
			replace  PD_CODPR   with VM_DET[ORD,02]	// Cod Produto
			replace 	PD_QTDE    with VM_DET[ORD,04]	// Quantidade Vendida
			replace 	PD_VALOR   with VM_DET[ORD,05]	// Vlr Unitario Venda ( 4 CASAS)
			replace 	PD_VLRMD   with VM_DET[ORD,14]	// Vlr Unitario Medio Venda
			replace 	PD_DESCV   with VM_DET[ORD,06]	// Vlr Desconto Proporcional Item
			replace 	PD_DESCG   with VM_DET[ORD,30]	// Vlr Desconto Geral - Proporcional por Item
			replace  PD_ICMSP   with VM_DET[ORD,09]	// % Icms
			replace  PD_CODTR   with VM_DET[ORD,08]	// Codigo Triburario
			replace  PD_PTRIB   with VM_DET[ORD,11]	// % Tributacao 
			replace  PD_BAICM   with aBASES[01]			// BASE ICMS CALCULADO ANTES NESTA ROTINA
			replace  PD_VLROU   with aBASES[03]			// VALOR OUTROS
			replace  PD_VLRIS   with aBASES[02]			// VALOR ISENTOS
			replace  PD_VLICM   with vICMS
			replace  PD_CODOP   with VM_DET[ORD,17]	// CFOP
			replace  PD_NROADT  with VM_DET[ORD,19]
			replace  PD_CFISIPI with VM_DET[ORD,20]
			replace  PD_DESTRAN with VM_DET[ORD,21]
			replace  PD_DESTRAC with VM_DET[ORD,22]
			replace  PD_VLCOMIS with Trunca((PD_QTDE*PD_VALOR-PD_DESCV-PD_DESCG+PD_ENCFI)*(PROD->PR_PRVEN+GRUPOS->GE_PERVEN)/100,2)//calculo comissao
			replace  PD_CODCOF  with PROD->PR_CODCOS
			replace  PD_VLPIS   with VM_DET[ORD,26]
			replace  PD_VLCOFI  with VM_DET[ORD,27]
			replace  PD_UNIDEST with PROD->PR_UND // Unidade Prod no Estoque
			replace  PD_UNIDVEN with PROD->PR_UND // Unidade Prod na Venda
			
			nPesoTot+=VM_DET[ORD,04]*PROD->PR_PESOKG
			
			dbskip(0)
			dbcommit()
			VM_DET[ORD,13]:=RecNo()
		end
	next
	replace  PEDCAB->TR_PBRU with nPesoTot//....................Peso Buto
	replace  PEDCAB->TR_PLIQ with nPesoTot//....................Peso Liq	replace  PEDCAB->TR_PLIQ with vBASETOT//....................Base Total
end
salvabd(RESTAURA)
dbcommitall()
dbunlockall()
return NIL

*----------------------------------------------------------------------------------
	static function VLRLIQ(pOrd)
*----------------------------------------------------------------------------------
return (Trunca(VM_DET[pOrd,05]*VM_DET[pOrd,04])-VM_DET[pOrd,06]+VM_DET[pOrd,07])
*--------------VALOR           QTD                DESC Item       ACRESC
//-----------------------------------------EOF-------------------------------------*
