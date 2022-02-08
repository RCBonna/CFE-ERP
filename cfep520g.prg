*--------------------------------------------------------------------------*
*						ATUALIZACAO																*
*--------------------------------------------------------------------------*
*					Atualizar Estoque															*
*--------------------------------------------------------------------------*
 static aVariav := {'S',.F., 0,  0, 0, 0}
 //..................1...2...3...4..5..6...7...8...9, 10, 11, 12,13,14,15
*---------------------------------------------------------------------------*
#xtranslate nTpCTB   => aVariav\[  1 \]
#xtranslate Contabil => aVariav\[  2 \]
#xtranslate ORD      => aVariav\[  3 \]
#xtranslate VPis     => aVariav\[  4 \]
#xtranslate VCofins  => aVariav\[  5 \]
#xtranslate ValorCtb => aVariav\[  6 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
  function CFEP520G()
*-----------------------------------------------------------------------------*
local VM_QTATU
local VM_VLATU
local VM_VLMED
local VM_CXA:=0
local X
local VM_CTAS  :=array(40,13)
local VM_VLRS  :=array(41,13)

VPis   :={}
VCofins:={}

Contabil:=.T.
ORD     :=0

		aeval(VM_VLRS,{|DET|DET:=afill(DET,0)})

//		C-Conta Estoque..... 01
//		C-Conta ICMS-Recup.. 02
//		D-Conta ICMS-Desp... 03
//		C-Conta IPI -Recup.. 04
//		D-Conta IPI -Desp... 05
//		C-Conta COFINS-Pass. 06
//		D-Conta COFINS-Desp. 07
//		C-Conta PIS-Pass.... 08
//		D-Conta PIS-Desp.... 09
//		C-Conta Venda Vista. 10
//		C-Conta Venda Prazo. 11
//		D-Conta Custo Merc.. 12


	NATOP->(dbseek(str(PEDCAB->PC_CODOP,7)))
	BANCO->(dbseek(str(VM_BCO,2)))
	
	Contabiliza	:=!(NATOP->NO_FLCTB =='N')
	GeraFinanc	:=!(NATOP->NO_FINANC=='N')
	GeraEstoque	:=!(NATOP->NO_ESTOQ =='N')
	
	CdAtiv		:=max(CLIENTE->CL_ATIVID,1)
	salvabd(SALVA)
	select('CTACTB')
	DbGoTop()
	aeval(VM_CTAS,{|DET|afill(DET,0)})
	//----------------------------------------BUSCA CONTAS DE TRANSFERENCIAS
	if NATOP->NO_FLTRAN=='S'
		nTpCTB:='T' // Contabilizaizacao Tipo Transferencia-NÃO Contabiliza AGORA
	else
		nTpCTB:='S' // Contabilizaizacao Tipo Saidas Normal.
		dbseek(nTpCTB+str(CdAtiv,2)+str(0,2)+str(10,2),.T.)
		dbeval({||VM_CTAS[CC_TPEST,CC_SEQUE-10]:=CC_CONTA},,{||CC_TPMOV==nTpCTB.and.CC_TPCFO==CdAtiv})
		//............................................ CTA ESTOQUE, ICMS, IPI...
		aadd(VM_CTAS,{;
							fn_lecc(nTpCTB,CdAtiv,0, 0),;	// 1-CTA Cliente
							fn_lecc(nTpCTB,CdAtiv,0, 1),;	// 2-Juros Receb
							fn_lecc(nTpCTB,CdAtiv,0, 2),;	// 3-Desconto
							fn_lecc(nTpCTB,CdAtiv,0, 4);	// 4-Cta Adto Cliente
							})
		if NATOP->NO_FLCTB=='S'.and.NATOP->NO_FINANC=='N'.and.NATOP->NO_CTBDB>0
			VM_CTAS[41,1]:=NATOP->NO_CTBDB // usa CC da CFOP caso seja contabil = S e Financ = N
		end
	end

if PEDCAB->PC_FLSVC //..............É Servico ?
	//...........nao Contabilizaizado servicos aqui-- rotina de Contabilizaizacao A parte
else // Nota Fiscal Normal
	for ORD:=1 to len(VM_DET)
		if VM_DET[ORD,02]>0 //..................................................Tem produto?
			select('PROD')
			if dbseek(str(VM_DET[ORD,2],L_P)) //..... Pesquisa Produto
				while !reclock();end
				TpProd  :=max(PROD->PR_CTB,1) //.................................Conta estoque
				VM_VLMED:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)//............Valor Médio
				VM_QTATU:=Trunca(PROD->PR_QTATU-VM_DET[ORD,4],2) //..............Diminui QTD
				if str(VM_QTATU,15,3)==str(0,15,3)//.............................Saldo Zerado
					VM_VLATU  := 0
					VM_VLRSAIM:= PROD->PR_VLATU  //...............................Vlr Médio de saida TOT
				else
					VM_VLRSAIM:= VM_VLMED*VM_DET[ORD,4]//.........................Vlr Médio de saida Parcial
					VM_VLATU  := PROD->PR_VLATU - VM_VLRSAIM//....................Diminui VLR
					if VM_VLATU<0
						VM_VLATU:=0
					end
					if VM_QTATU<0
						VM_QTATU:=0
					end
				end
				VM_VLRSAIM := Round(VM_VLRSAIM,2) //............................Total em 2 casas
				if str(PROD->PR_CTB,2)=='97'.or.;
					str(PROD->PR_CTB,2)=='99'.or.;
					PROD->PR_CTRL      =='N' //...................................Não Controla Estoque
					VM_QTATU   := PROD->PR_QTATU
					VM_VLATU   := PROD->PR_VLATU
					VM_VLRSAIM := 0
				else //..........................................................Tem Controle Estoque
					if GeraEstoque	//.............................................Contabilizaizar no Estoque?
						replace  PROD->PR_QTATU with VM_QTATU,;
									PROD->PR_VLATU with VM_VLATU
					end
				end
//				alert('Valor Medio Saida Estoque='+str(VM_VLRSAIM)+';Valor Medio='+str(VM_VLMED)+';Quantidade='+str(VM_DET[ORD,4]))
				if TpProd<41//........................................................Estoque com controle de saldo
					VM_VLRS[TpProd,01]+=VM_VLRSAIM//...................................VLR MEDIO
					VM_VLRS[TpProd,02]+=VM_DET[ORD,15]//...............................VLR ICMS
					VM_VLRS[TpProd,03]+=VM_DET[ORD,15]//...............................VLR ICMS
					VM_VLRS[TpProd,10]+=if(PEDCAB->PC_FATUR>0,0,(Trunca(VM_DET[ORD,05]*VM_DET[ORD,04],2)))
					VM_VLRS[TpProd,11]+=if(PEDCAB->PC_FATUR=0,0,(Trunca(VM_DET[ORD,05]*VM_DET[ORD,04],2)))
					VM_VLRS[TpProd,12]+=VM_VLRSAIM//...................................VLR MEDIO
					VM_VLRS[TpProd,10]-=VM_DET[ORD,06]+VM_DET[ORD,30]//................Retirar o Descontos (Item+Geral)
					VM_VLRS[TpProd,11]-=VM_DET[ORD,06]+VM_DET[ORD,30]//................Retirar o Descontos (Item+Geral)
//					alert(str(TpProd,2)+'-Desc:'+str(VM_VLRS[X,13]))
				end
				if GeraEstoque	//.............................................Contabilizaizar no Estoque?
					replace PR_DTMOV with PEDCAB->PC_DTEMI
				end
				
//--------------Busca contas contábeis para PIS e COFINS - e o valor para débito e crédito
				if PARAMETRO->PA_CONTAB==USOMODULO.and.TpProd<41
					if NATOP->NO_FLPISC=='S'
						if FISACOF->(dbseek(PROD->PR_CODCOS+CLIENTE->CL_TIPOFJ)) // só Contabilizaizas se tiver cadastro de produto
							aadd(vPis,   {VM_CTAS[TpProd,9],VM_CTAS[TpProd,8],VM_DET[ORD,26],str(VM_DET[ORD,2],L_P)+'|'+PROD->PR_CODCOS+'|'+CLIENTE->CL_TIPOFJ})	// % e Vlr Pis
							aadd(vCofins,{VM_CTAS[TpProd,7],VM_CTAS[TpProd,6],VM_DET[ORD,27],str(VM_DET[ORD,2],L_P)+'|'+PROD->PR_CODCOS+'|'+CLIENTE->CL_TIPOFJ})	// % e Vlr Cofins
						else
							alert('PRODUTO='+pb_zer(VM_DET[ORD,2],L_P)+';CDPISCF='+PROD->PR_CODCOS+';CLI-TIP='+CLIENTE->CL_TIPOFJ+';Erro PIS/COFINS na NF-Saida;Falta ajuste no cadastro')
						end
					end
				end
				dbrunlock(recno())
				if GeraEstoque
					GravMovEst({VM_DET[ORD,2],;								//	1 Cod Produto
									PEDCAB->PC_DTEMI,;							//	2 Data
									VM_ULTNF,;										//	3 Documento
									VM_DET[ORD,4],;								//	4 Qtdade
									VM_VLRSAIM,;									// 5 Vlr Mov Est Medio(Total)
									Trunca(VM_DET[ORD,5]*VM_DET[ORD,4],2),;// 6 Vlr Mov Est Venda(Total)
									'S',; 											// 7-Saida Estoque
									VM_SERIE,;										//	8
									0})												//	9
				end
				select('PEDDET')
				if PARAMETRO->PA_CONTAB==chr(255)+chr(25)
					DbGoTo(VM_DET[ORD,13]) // ir no registro do pedido-detalhe
					if RecLock()
						replace PD_VLRMD with VM_VLRSAIM // Gravar Vlr Médio Total
					end
					dbrunlock(RecNo())
				end
			else
				pb_msg('Erro ['+ProcName()+pb_zer(VM_DET[ORD,2],7)+'] anote, avise respons vel.',0,.T.)
			end
		end
	next
	//...............................................Somado todos os itens da nota
	*-----------------------------------------------------------------------------*
	*                         Contabilização													*
	*-----------------------------------------------------------------------------*
	if PARAMETRO->PA_CONTAB==USOMODULO .and.;
		Contabiliza .and.;
		nTpCTB=='S'
		//..........................................................
		for X:=1 to 40
			VM_VLRS[41,01]:=0 //	VM_VLRS[X,01]		// Estoque/
			VM_VLRS[41,02]:=0 //	VM_VLRS[X,02]		// ICMS Recuperar
			VM_VLRS[41,03]:=0 //	VM_VLRS[X,03]		// ICMS Despesas
			VM_VLRS[41,10]:=0 //	VM_VLRS[X,10]		// Venda Prazo
			VM_VLRS[41,11]:=0 //	VM_VLRS[X,11]		// Venda Vista
			VM_VLRS[41,12]:=0 //	VM_VLRS[X,12]		// Custo
			VM_VLRS[41,13]:=0 //	VM_VLRS[X,13]		// Soma dos Descontos
			for Y:=X to 40
				for Z:=1 to 13
					if VM_CTAS[ X,Z]==VM_CTAS[Y,Z] // Conta Contábil =
						VM_VLRS[41,Z]+=VM_VLRS[Y,Z]
						VM_VLRS[ Y,Z]:=0
					end
				next
			next
//			alert(STR(X,2)+'-Total Desc.Geral:'+str(VM_VLRS[41,13])+;
//								';TotalNF.V:'+str(VM_VLRS[41,10])+;
//								';TotalNF.P:'+str(VM_VLRS[41,11])) // retirar
			fn_atdiario(PEDCAB->PC_DTEMI,;
							VM_CTAS[X,01],;	// CTA Estoque
							CRE*VM_VLRS[41,01],;
							'NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' a '+CLIENTE->CL_RAZAO,;
							'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)

			fn_atdiario(PEDCAB->PC_DTEMI,;
							VM_CTAS[X,02],;	// CTA ICMS RECUP
							CRE*VM_VLRS[41,02],;
							'Recuperado da NNF '+alltrim(str(VM_ULTNF))+'/'+alltrim(VM_SERIE)+' a '+CLIENTE->CL_RAZAO,;
							'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)

			fn_atdiario(PEDCAB->PC_DTEMI,;
							VM_CTAS[X,03],;	// CTA ICMS DESP
							DEB*VM_VLRS[41,03],;
							'NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' a '+CLIENTE->CL_RAZAO,;
							'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)

			if PEDCAB->PC_FATUR>0 // A Prazo
				fn_atdiario(PEDCAB->PC_DTEMI,;
								VM_CTAS[X,11],;	// CTA VENDA A Prazo (Receita)
								CRE*(VM_VLRS[41,11]),; // Sem Descontos - Thiago
								'NFF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' a '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			else // A Vista
				fn_atdiario(PEDCAB->PC_DTEMI,;
								VM_CTAS[X,10],;	// CTA VENDA A VISTA (Receita)
								CRE*(VM_VLRS[41,10]),;  // Sem Descontos - Thiago
								'NF. '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' a '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			end

			fn_atdiario(PEDCAB->PC_DTEMI,;
							VM_CTAS[X,12],;	// CTA CUSTO MERC VENDIDA
							DEB*VM_VLRS[41,12],;
							'NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' a '+CLIENTE->CL_RAZAO,;
							'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
		next
		
		if VM_FLADTO#'S' //..........................................NÃO Baixa de Adiantamento
			if PEDCAB->PC_FATUR < 1  //------------------------------------< A VISTA >
				fn_atdiario(PEDCAB->PC_DTEMI,;
								BANCO->BC_CONTA,;	// CTA CXA
								DEB*(PEDCAB->PC_TOTAL),;//..Já com Desconto -PEDCAB->PC_DESC-PEDCAB->PC_DESCIT
								'Recebido NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			else	//.................................................... Prazo
				fn_atdiario(PEDCAB->PC_DTEMI,;
								VM_CTAS[41,01],;	// CTA CLIENTE
								DEB*(PEDCAB->PC_TOTAL),;//..Já com Desconto -PEDCAB->PC_DESC-PEDCAB->PC_DESCIT
								'Venda NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			end
		else //..........................................É Baixa de Adiantamento
			fn_atdiario(PEDCAB->PC_DTEMI,;
							VM_CTAS[41,04],;	// CTA ADIANTAMENTO CLIENTE
							DEB*(PEDCAB->PC_TOTAL),;//..Já com Desconto -PEDCAB->PC_DESC-PEDCAB->PC_DESCIT
							'Adto Receb.NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
							'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
		end

		//............................................retirar contabilização dos descontos - thiago - 18/10/2014
//		fn_atdiario(PEDCAB->PC_DTEMI,;
//						VM_CTAS[41,03],;	// CTA Desconto
//						DEB*(PEDCAB->PC_DESC+PEDCAB->PC_DESCIT),;
//						'Concedido NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
//						'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)

*------------------------------------------------------VALOR PIS
		for X:=1 to len(vPis)
			ValorCtb:=vPis[X,3]
			for Y:=X+1 to len(vPis)
				if vPis[Y,1]>0.and.str(vPis[X,1],8)==str(vPis[Y,1],8) // conta contábil igual a posterior
					ValorCtb +=vPis[Y,3] // soma valor pis
					vPis[Y,1]:=0 // zerar conta
				end
			next
			if ValorCtb>0.and.vPis[X,1]>0 //valor e conta maior que zero
				fn_atdiario(PEDCAB->PC_DTEMI,;
								vPis[X,1],;	// CTA PIS
								DEB*ValorCtb,;
								'Ref.NNF.'+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			end
			
			ValorCtb:=vPis[X,3]
			for Y:=X+1 to len(vPis)
				if vPis[Y,2]>0.and.str(vPis[X,2],8)==str(vPis[Y,2],8) // conta contábil igual a posterior
					ValorCtb +=vPis[Y,3] // soma valor
					vPis[Y,2]:=0 // zerar conta
				end
			next
			if ValorCtb>0.and.vPis[X,2]>0 //valor e conta maior que zero
				fn_atdiario(PEDCAB->PC_DTEMI,;
								vPis[X,2],;	// CTA PIS
								CRE*ValorCtb,;
								'Ref.NNF.'+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			end
		next
		*------------------------------------------------------VALOR COFINS
		for X:=1 to len(vCofins)
			ValorCtb:=vCofins[X,3]
			for Y:=X+1 to len(vCofins)
				if vCofins[Y,1]>0.and.str(vCofins[X,1],15,2)==str(vCofins[Y,1],15,2) // conta contábil igual a posterior
					ValorCtb +=vCofins[Y,3] // soma valor pis
					vCofins[Y,1]:=0 // zerar conta
				end
			next
			if ValorCtb>0.and.vCofins[X,1]>0 //valor e conta maior que zero
				fn_atdiario(PEDCAB->PC_DTEMI,;
								vCofins[X,1],;	// CTA COFINS
								DEB*ValorCtb,;
								'Ref.NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			end
			ValorCtb:=vCofins[X,3]
			for Y:=X+1 to len(vCofins)
				if vCofins[Y,2]>0.and.str(vCofins[X,2],15,2)==str(vCofins[Y,2],15,2) // conta contábil igual a posterior
					ValorCtb +=vCofins[Y,3] // soma valor
					vCofins[Y,2]:=0 // zerar conta
				end
			next
			if ValorCtb>0.and.vCofins[X,2]>0 //valor e conta maior que zero
				fn_atdiario(PEDCAB->PC_DTEMI,;
								vCofins[X,2],;	// CTA COFINS
								CRE*ValorCtb,;
								'Ref.NNF '+alltrim(str(VM_ULTNF))+'/'+VM_SERIE+' de '+CLIENTE->CL_RAZAO,;
								'FAT/'+pb_zer(VM_ULTNF,6)+':'+VM_SERIE)
			end
		next
	end
end

*-----------------------------------------------------------------------------*
*										 Contas a Receber											*
*-----------------------------------------------------------------------------*
if nTpCTB=='S'.and.; //.............Movimentação Somente SAIDAS
	GeraFinanc //....................Verifica se gera Duplicatas no Financeiro
	select('DPCLI')
	if PEDCAB->PC_FATUR # len(VM_FAT)
		Alert('Nao encontrado registros no arquivo;de parcelamento para NF : '+;
				str(VM_ULTNF,6)+';Pedido:'+str(PEDCAB->PC_PEDID,6))
		replace PEDCAB->PC_FATUR with len(VM_FAT)
	end
	for ORD:=1 to PEDCAB->PC_FATUR
		while !AddRec(30);end
		replace  DR_DUPLI  with VM_FAT[ORD,1],;
					DR_CODCL  with PEDCAB->PC_CODCL,;
					DR_DTEMI  with PEDCAB->PC_DTEMI,;
					DR_DTVEN  with VM_FAT[ORD,2],;
					DR_VLRDP  with VM_FAT[ORD,3],;
					DR_CODBC  with VM_BCO,;
					DR_MOEDA  with 1,;
					DR_NRNF   with VM_ULTNF,;
					DR_SERIE  with VM_SERIE,;
					DR_ALFA   with VM_NOMNF,;
					DR_JUROSD with fn_perfin(VM_SERIE),;
					DR_DPDR	 with 'R',;
					DR_ATIVID with CLIENTE->CL_ATIVID
	next
end
*-----------------------------------------------------------------------------*
*										Hist Clientes												*
*-----------------------------------------------------------------------------*
if PEDCAB->PC_FATUR < 1 .and.; //...NF a VISTA
	GeraFinanc .and.; //.............Verifica se gera Duplicatas no Financeiro
	nTpCTB=='S'	//...................Somente Saidas - não transferencias
	if !PEDCAB->PC_FLADTO //.........Não é adiantamento então gera lancamento
		SALVABANCO
		select HISCLI
		while !AddRec(30);end
		replace  HC_CODCL with PEDCAB->PC_CODCL
		replace  HC_DUPLI with VM_ULTNF*100
		replace  HC_DTEMI with PEDCAB->PC_DTEMI
		replace  HC_DTVEN with PEDCAB->PC_DTEMI
		replace  HC_DTPGT with PEDCAB->PC_DTEMI
		replace  HC_VLRDP with PEDCAB->PC_TOTAL	// Vlr Liq
		replace  HC_VLRPG with PEDCAB->PC_TOTAL	// Vlr Liq
		replace  HC_VLRMO with pb_divzero(PEDCAB->PC_TOTAL,PARAMETRO->PA_VALOR)
		replace  HC_CXACG with VM_CODCG
		replace  HC_CDCXA with VM_BCO
		replace  HC_NRNF  with VM_ULTNF
		replace  HC_SERIE with VM_SERIE
		RESTAURABANCO
	end
end
if PEDCAB->PC_FATUR >0 .and.;	// A prazo
	PEDCAB->PC_VLRENT>0 .and.;	// Parte A vista
	GeraFinanc.and.; //...........Verifica se gera Duplicatas no Financeiro
	nTpCTB=='S'	//................Somente saidas - não transferencias
	salvabd()
	select('HISCLI')
	while !AddRec(30);end
	// Grava Histórico da parte de entrada na NF (ENTRADA)
	replace  HC_CODCL with PEDCAB->PC_CODCL,;
				HC_DUPLI with VM_ULTNF*100,;
				HC_DTEMI with PEDCAB->PC_DTEMI,;
				HC_DTVEN with PEDCAB->PC_DTEMI,;
				HC_DTPGT with PEDCAB->PC_DTEMI,;
				HC_VLRDP with PEDCAB->PC_VLRENT,;
				HC_VLRPG with PEDCAB->PC_VLRENT,;
				HC_VLRMO with pb_divzero(PEDCAB->PC_VLRENT,PARAMETRO->PA_VALOR),;
				HC_CDCXA with VM_BCO,;
				HC_CXACG with VM_CODCG,;
				HC_NRNF  with VM_ULTNF,;
				HC_SERIE with VM_SERIE

//	Grav_Bco(VM_BCO,; // ......................TIRADO EM 13/01/2014
//				PEDCAB->PC_DTEMI,;
//	         VM_ULTNF,;
//	         'REC '+VM_NOMNF,;
//	         +PEDCAB->PC_VLRENT,;
//				'FT')
	salvabd(.F.)
end

*-----------------------------------------------------------------------------*
*												Parametros											*
*-----------------------------------------------------------------------------*

*-----------------------------------------------------------------------------*
*												Pedidos												*
*-----------------------------------------------------------------------------*
select('PEDCAB')
replace  PC_CODBC with VM_BCO,;
			PC_DTEMI with VM_DTEMI,;
			PC_DTSAI with VM_DTSAI,;
			PC_NRDPL with VM_ULTDP*100,;
			PC_NRNF  with VM_ULTNF,;
			PC_CODCG with VM_CODCG,;
			PC_TPDOC with 'NF',;
			PC_FLAG  with .T.,;			// Atualizado
			PC_SERIE with VM_SERIE,;
			PC_OBSER with VM_OBS,;
			PC_FLCTB with !Contabiliza // é ao contrário -> se Contabilizaiza informa que a nf não esta Contabilizaizada

replace  PC_NSU    with VM_NSU
replace  PC_NFEKEY with GetKeyNFE() // buscar da impressão.

if nTpCTB=='T'	// ..............TRANSFERENCIA
	replace PC_FLCTB with .F. // transferencia não Contabilizaizar agora - depois na rotina de Contabilizaização
end

GraAdtos(VM_FLADTO) // Verificar e Grava se for adiantamento. tem q ter aAdtos atualizado
GraUltCom(PEDCAB->PC_CODCL,PEDCAB->PC_DTEMI) // Gravar Dt Ultima Compra Cliente
select('CTRNF')
while !reclock();end
CTRNF->NF_SITUA:='F'
select('PEDDET')
dbcommitall()
dbUnlockAll()
return NIL
//--------------------------------------------------EOF---------------------------------------
