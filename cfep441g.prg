*-----------------------------------------------------------------------------*
 static aVariav1:= {0,0,.T.,0,0,'',.F.,.F.,.F. }
 //.................1.2..3..4.5..6..7...8...9
*-----------------------------------------------------------------------------*
#xtranslate nX        	=> aVariav1\[  1 \]
#xtranslate SCOM      	=> aVariav1\[  2 \]
#xtranslate lContinua 	=> aVariav1\[  3 \]
#xtranslate ORD       	=> aVariav1\[  4 \]
#xtranslate nX1       	=> aVariav1\[  5 \]
#xtranslate cOBSNFE   	=> aVariav1\[  6 \]
#xtranslate Contabiliza => aVariav1\[  7 \]
#xtranslate GeraFinanc	=> aVariav1\[  8 \]
#xtranslate GeraEstoque	=> aVariav1\[  9 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'
*-----------------------------------------------------------------------------*
 function CFEP441G() // Rotina de gravacao das entradas
*-----------------------------------------------------------------------------*

lContinua :={.T.,space(132)}
	
	SALVABANCO
	select('ENTCAB')
	dbgobottom()
	dbskip()
	RESTAURABANCO
	NATOP->(dbseek(str(DADOC[NNAT],7))) // procura Natureza de Operação
	
	Contabiliza:=if(NATOP->NO_FLCTB =='N',.F.,.T.)
	GeraFinanc :=if(NATOP->NO_FINANC=='N',.F.,.T.)
	GeraEstoque:=if(NATOP->NO_ESTOQ =='N',.F.,.T.)
	
	//...NATOP->NO_FLTRAN=='S'
	//...NATOP->NO_FLCTB=='N'

if right(str(DADOC[NNAT],8),1) == '9' // IMPRIME NF DE ENTRADA
	DADOC[NNF ]:=fn_psnf(DADOC[SERIE])	// busca número da próxima nota fiscal
	DADOC[NDOC]:=DADOC[NNF]
	for nX:=1 to len(DADOPC)
		DADOPC[nX,1]:=DADOC[NNF]*100+nX
	next
	beepaler()
	alert('IMPRIMIR NF DE ENTRADA;SERIE = '+DADOC[SERIE]+';Numero NF alterado '+pb_zer(DADOC[NNF],6))
	I_TRANS[15]:=DADOC[NFOR]

	CLIENTE->(dbseek(str(DADOC[NFOR],5)))
	setKeyNFE()
	lContinua    :=CFEP441I({'',''}) //..........Impressao OK (OBSERVACAO GERAL + OBSERVAÇAO VALORES NF LEITE
	if lContinua[1]
		DADOC[NFEKEY]:=GetKeyNFE() // Pegar Número da NF Gera (quando gerardo na Entrada)
	end
end

if lContinua[1]
	CFEP441G1(lContinua) // GRAVAR ESTOQUE
end
dbcommitall()
return lContinua[1] // Retorno    SIM  /  NAO

*--------------------------------------------------------------------------------
  function CFEP441G1(pContinua)
*--------------------------------------------------------------------------------
local   MAIOR
local   INDIC
local   VM_PARCE
local   CONTINUAR		:=.T.
local   PERFRETE		:=0.00
local   PERDESC		:=0.00
local   PERICMFRETE	:=0.00
local   PERACES		:=0.00
private VM_NSU			:=RT_NSU() // retornar o nr do NSU do programa de impressao de nf entrada

	NATOP->(dbseek(str(DADOC[NNAT],7))) // procura Natureza de Operação
	Contabiliza:=if(NATOP->NO_FLCTB =='N',.F.,.T.)
	GeraFinanc :=if(NATOP->NO_FINANC=='N',.F.,.T.)
	GeraEstoque:=if(NATOP->NO_ESTOQ =='N',.F.,.T.)

	SALVABANCO

	MAIOR           :=0.00
	INDICE          :=0
	PRODUTOS[200,11]:=0.00
	PRODUTOS[200,12]:=0.00
	PRODUTOS[200,15]:=0.00
	PRODUTOS[200,16]:=0.00
	PERFRETE        :=pb_divzero((DADOF[FVNF]-DADOF[FVICMS]),(DADOC[NVNF]-DADOC[NDES]-DADOC[NVIPI]-DADOC[NVICMS]))	// %FRETE
	PERDESC         :=pb_divzero( DADOC[NDES],DADOC[NVNF]) // % desconto
	PERICMFRETE     :=pb_divzero( DADOF[FVICMS],(DADOC[NVNF]-DADOC[NVIPI])) //% icms frete
	PERACES         :=pb_divzero( DADOC[VACES],DADOC[NVNF])	// % Vlr.ACESS
	pb_msg('Gravando dados da ENTRADA. Aguarde...',NIL,.F.)
	for nX:=1 to len(PRODUTOS)-1
		if PRODUTOS[ nX, 2]>0
			PRODUTOS[ nX,11]:=trunca(PERFRETE   *PRODUTOS[nX,5],2) // FRETE Proporc
			PRODUTOS[ nX,12]:=trunca(PERDESC    *PRODUTOS[nX,5],2) // DESC. Proporc
			PRODUTOS[ nX,15]:=trunca(PERICMFRETE*PRODUTOS[nX,5],2) // Icms FRETE Pr
			PRODUTOS[ nX,16]:=trunca(PERACES    *PRODUTOS[nX,5],2) // Vlr.ACESS Proporc
			PRODUTOS[200,11]+=PRODUTOS[nX,11]	// Somar frete prop
			PRODUTOS[200,12]+=PRODUTOS[nX,12]	// Somar desc prop
			PRODUTOS[200,15]+=PRODUTOS[nX,15]	// Somar icms frete
			PRODUTOS[200,16]+=PRODUTOS[nX,16]	// Somar desp acessorias
			if PRODUTOS[nX,5]>MAIOR
				MAIOR:=PRODUTOS[nX,5]
				INDIC:=nX
			end
			if DADOC[NADTO]=='S' // .................................É Adiantamento
				ORD:=aScan(aAdtos,{|DET|DET[2]==PRODUTOS[nX][2]})
				if ORD>0
					if !str(aAdtos[ORD][4],15,3)>=str(PRODUTOS[nX][04],15,3)
						Alert('Produto '+str(aAdtos[ORD][2],L_P)+'-'+trim(aAdtos[ORD][3])+;
						';sem saldo suficiente em ADIANTAMENTO para compra;Continuando sem baixar adto;N:'+;
						str(nX,3)+';QA'+str(aAdtos[ORD][4],15,3)+';QD'+str(PRODUTOS[ORD][04],15,3))
					else
						aAdtos[ORD][04]  -=PRODUTOS[nX][04]	// Diminuir no Saldo
						aAdtos[ORD][08]  +=PRODUTOS[nX][04]	// Somar em Qtd Entrada
						aAdtos[ORD][09]  :=.T.					// Registro Alterado
						aAdtos[ORD][11]  +=PRODUTOS[nX][05]	// Somar em Vlr Retirada
						PRODUTOS[nX][25] := aAdtos[ORD][01]	// Numero Adiantamento
					end
				end
			end
		end
	next
	if INDIC>0
		PRODUTOS[INDIC,11]+=(DADOF[FVNF  ] - DADOF[FVICMS] - PRODUTOS[200,11])
		PRODUTOS[INDIC,12]+=(DADOC[NDES  ] - PRODUTOS[200,12])
		PRODUTOS[INDIC,15]+=(DADOF[FVICMS] - PRODUTOS[200,15])
		PRODUTOS[INDIC,16]+=(DADOC[VACES ] - PRODUTOS[200,16])
	end
	CLIENTE->(dbseek(str(DADOC[NFOR],5)))
*----------------------------------------------------------------------------Grava Nota Entrada
	select('ENTCAB')
	VM_PARCE:=''
	aeval(DADOPC,{|DET|VM_PARCE+=pb_zer(DET[1],8)+dtos(DET[2])+str(DET[3],12,2)})
	while !AddRec();end
	replace  EC_DOCTO  with DADOC[NNF],;
				EC_CODFO  with DADOC[NFOR],;
				EC_CODBC  with DADOC[NBAN],;
				EC_DOCBC  with DADOC[NDOC],;
				EC_DTEMI  with DADOC[NDT],;
				EC_DTENT  with DADOC[NDT1],;
				EC_TOTAL  with DADOC[NVNF],;
				EC_DESC   with DADOC[NDES],;
				EC_FUNRU  with DADOC[NVFUNR],;
				EC_ICMSP  with DADOC[NPICMS],;
				EC_ICMSB  with DADOC[BICMS],;
				EC_ICMSV  with DADOC[NVICMS],;
				EC_IPI    with DADOC[NVIPI],;
				EC_CODOP  with DADOC[NNAT],;
				EC_FATUR  with DADOC[NPARC],;
				EC_TPDOC  with DADOC[TPDOC],;
				EC_SERIE  with DADOC[SERIE]

	replace	EC_GERAC  with 'G',; //...............DADOS GERADOS PELO SISTEMA
				EC_NSU    with VM_NSU,;//.............Numero Sequencial Unico para fisco SC
				EC_FLADTO with DADOC[NADTO]=='S',;//..Baixa de adiantamento ?
				EC_CODTR  with PRODUTOS[01,14],;
				EC_ACESS  with DADOC[VACES],; 		//...21-Valor despesas acessorias
				EC_ACFRET with DADOC[NACFRETE],; 	//...22-Despesas Acessorias-Frete
				EC_ACSEGU with DADOC[NACSEGUR],;		//...23-Despesas Acessorias-Seguro
				EC_ACOUTR with DADOC[NACOUTRA],;		//...24-Despesas Acessorias-Outras
				EC_ICMSTB with DADOC[NICMSTBA],;		//...25-ICMS ST Base
				EC_ICMSTV with DADOC[NICMSTVL],;		//...26-ICMS ST Valor
				EC_PARCE  with VM_PARCE,;
				EC_FRDOC  with DADOF[FNF],;
				EC_FRSER  with DADOF[SERIE],;
				EC_FRFOR  with DADOF[FFOR],;
				EC_OBSLIV with DADOC[OBSLIV]
				
	replace	EC_OBSNFE with pContinua[2],;
				EC_NFEDEV with DADOC[NFEKEYDEV] // Gravar Nr chave NF-e Devolução

	if left(DADOC[NFEKEY],2)#'00'
		replace	EC_NFEKEY with DADOC[NFEKEY] // Digitado
	else
		replace	EC_NFEKEY with GetKeyNFE() // buscar da impressão - nfe entrada impressa 
	end
	
	CFEPTRANG('E',I_TRANS)
	dbrunlock(recno())
	*----------------------------------------------------------------------Grava Nota FRETE <- não tem linha de itens
	if DADOF[FNF]>0	// DOCTO FRETE ?
		pb_msg('ENTRADA-FRETE',NIL,.F.)
		VM_PARCE:=''
		aeval(DADOPF,{|DET|VM_PARCE+=pb_zer(DET[1],8)+dtos(DET[2])+str(DET[3],12,2)})
		while !AddRec();end
		replace  EC_DOCTO  with DADOF[FNF],;
					EC_SERIE  with DADOF[SERIE],;
					EC_CODFO  with DADOF[FFOR],;
					EC_NSU    with VM_NSU,;
					EC_CODBC  with DADOF[FBAN],;
					EC_DOCBC  with DADOF[FDOC],;
					EC_DTEMI  with DADOF[FDT],;
					EC_DTENT  with DADOF[FDT1],;
					EC_TOTAL  with DADOF[FVNF],;
					EC_ICMSP  with DADOF[FPICMS],;
					EC_ICMSB  with DADOF[BICMS],;
					EC_ICMSV  with DADOF[FVICMS],;
					EC_CODOP  with DADOF[FNAT],;
					EC_FATUR  with DADOF[FPARC],;
					EC_TPDOC  with DADOF[TPDOC],;
					EC_FLADTO with .F.,;//.......FRETE nao tem adiamento.
					EC_GERAC  with 'G',;//.......NF Gerada pelas entradas normais
					EC_CODTR  with '000',;
					EC_PARCE  with VM_PARCE,;
					EC_FRDOC  with 0,;
					EC_FRSER  with '',;
					EC_FRFOR  with 0,;
					EC_NFEKEY with DADOF[NFEKEY] // Digitado na tele de Frete
		dbrunlock(recno())
	end
*---------------------------------------------------------------DETALHE ENTRADA
	select('ENTDET')
	for nX:=1 to len(PRODUTOS)-1
		if PRODUTOS[nX,2]>0
			//............................................Verifica Adiantamento
			while !AddRec();end
			replace  ED_DOCTO   with DADOC[NNF]     ,;
						ED_SERIE   with DADOC[SERIE]   ,;
						ED_CODFO   with DADOC[NFOR]    ,;
						ED_ORDEM   with nX             ,;
						ED_CODPR   with PRODUTOS[nX,02],;
						ED_QTDE    with PRODUTOS[nX,04],;
						ED_VALOR   with PRODUTOS[nX,05],;
						ED_PCICM   with PRODUTOS[nX,09],;
						ED_VLICM   with PRODUTOS[nX,10],;
						ED_PIPI    with PRODUTOS[nX,07],;
						ED_IPI     with PRODUTOS[nX,08],;
						ED_VENDA   with PRODUTOS[nX,06],;
						ED_BICMS   with PRODUTOS[nX,19],;	// 12-Base ICMS
					 	ED_ISENT   with PRODUTOS[nX,20],;	// 13-Valor Isentas
						ED_OUTRA   with PRODUTOS[nX,21],;	// 14-Valor Outras
						ED_CODOP   with PRODUTOS[nX,18],;
						ED_CODTR   with PRODUTOS[nX,14],;
						ED_CTACTB  with PRODUTOS[nX,17],;
						ED_CODCOF  with PRODUTOS[nX,22],;	// Codigo PIS+COFINS
						ED_VLPIS   with PRODUTOS[nX,23],;	// Vlr Pis NF
						ED_VLCOFI  with PRODUTOS[nX,24],;	// Vlr Cofins NF
						ED_NROADT  with PRODUTOS[nX,25],;
						ED_CFISIPI with PRODUTOS[nX,26],;
						ED_DESTRAN with PRODUTOS[nX,27],;	// Conta Contábil de transferencia-DEBITO
						ED_FVLPIS  with PRODUTOS[nX,28],;	// Vlr PIS Frete
						ED_FVLCOFI with PRODUTOS[nX,29],;	// Vlr Cofins Frete
						ED_DESTRAC with PRODUTOS[nX,30],;	// Conta Contábil de transferencia-CREDITO
						ED_QTDENTR with PRODUTOS[nX,31],;	// 26-Quantidade original entrada
						ED_UNIENTR with PRODUTOS[nX,32],;	// 27-Unidade original entrada
						ED_FATENTR with PRODUTOS[nX,33]		// 28-Fator de conversao usado na entrada para inventário
						
			dbrunlock(recno())
			SALVABANCO
			select('PROFOR')
			if !dbseek(str(PRODUTOS[nX,02],L_P)+str(DADOC[NFOR],5)+descend(dtos(DADOC[NDT])))
				while !AddRec();end
				replace PF_CODPR with PRODUTOS[nX,02],;
				        PF_CODFO with DADOC[NFOR],;
						  PF_DATA  with DADOF[FDT]
			end
			if reclock()
				replace 	PF_PRECO with pb_divzero(PRODUTOS[nX,05],PRODUTOS[nX,04]),;
							PF_OBS   with if(DADOC[NPARC]=0,'A Vista',str(DADOC[NPARC],2)+' Parc')+'/'+if(DADOF[FDOC]>0,'+frete','Sem Frete')
							
			end
			RESTAURABANCO
		end
	next
	GraAdtos(DADOC[NADTO]) // verificar e grava se for adiantamento. tem q ter aAdtos atualizado

*------------------------------------------------------------ESTOQUE----------*
	for nX:=1 to len(PRODUTOS)-1
		if PRODUTOS[nX,2]>0	//	EXISTE Cod. Produto
			select('PROD')
			if !dbseek(str(PRODUTOS[nX,2],L_P))	// Produto
				alert('Produto '+str(PRODUTOS[nX,2],L_P)+' com problema cadastro;'+ProcName(),0,.T.)
				loop
			end
			while !reclock(30);end
			if PROD->PR_CTB==0
				replace PROD->PR_CTB with 4
			end
			VM_PRCTB:=min(PR_CTB,40)
			VM_VLRPR:=PRODUTOS[nX,05]		//..............	VLR ENTRADA PRODUTOS
			VM_VLRPR+=PRODUTOS[nX,11]		//..............	VLR PROP FRETE LIQ
			VM_VLRPR+=PRODUTOS[nX,16]		//..............	VLR PROP DESP ACESSORIAS
			VM_VLRPR+=PRODUTOS[nX,08]		//..............	VLR PROP IPI
			VM_VLRPR-=PRODUTOS[nX,10]		//...............	VLR ICMS
			VM_VLRPR-=PRODUTOS[nX,12]		//...............	VLR PROP DESC
			VM_VLRPR-=PRODUTOS[nX,23]		//............... VLR PIS
			VM_VLRPR-=PRODUTOS[nX,24]		//............... VLR COFINS
//			VM_VLRPR-=PRODUTOS[nX,28]		//............... VLR PIS = FRETE    ??????
//			VM_VLRPR-=PRODUTOS[nX,29]		//............... VLR COFINS = FRETE ??????
			
			if GeraEstoque	// Verifica se deve alterar estoque (CFOP)
				replace	PR_VLVEN with PRODUTOS[nX,06],;
							PR_DTCOM with DADOC[NDT],;
							PR_VLCOM with round(VM_VLRPR/PRODUTOS[nX,4],4) // CUSTO
				if PROD->PR_MODO<>'D'
					if PROD->PR_CTB#99.and.PROD->PR_CTB#97 // com contole de estoque
						replace	PR_QTATU with PR_QTATU+PRODUTOS[nX,4],;
									PR_VLATU with PR_VLATU+VM_VLRPR
					end
				end
				dbrunlock(recno())
				*------------------------------------------------------------Movimentacao-------
				GravMovEst({PRODUTOS[nX,2],;		// 1-Cod.Produto
								DADOC[NDT1],;			// 2-Data Entrada
								DADOC[NNF],;			// 3-NR.NF-e
								PRODUTOS[nX,4],;		// 4-Qtdade
								VM_VLRPR,; 				// 5-Medio Total-ICMS+IPI+FRETE+FUNRUR-ICMS.FRETE+ACESS-PIS-COFINS
								PRODUTOS[nX,6],;		// 6-Vlr Venda
								'E',;						// 7-Cod Entrada (Tipo Movimento)
								DADOC[SERIE],;			// 8-Serie
								DADOC[NFOR]})			// 9-
				if PROD->PR_MODO=='D'//.........................COMPRA DIRETA
					GravMovEst({PRODUTOS[nX,2],;	// 1
									DADOC[NDT1],;		// 2
									DADOC[NNF],;		// 3
									PRODUTOS[nX,4],;	// 4
									VM_VLRPR,; 			// 5-Medio Total-ICMS+IPI+FRETE+FUNRUR-ICMS.FRETE+ACESS-PIS-COFINS
									PRODUTOS[nX,6],;	// 6-vlr venda
									'S',;					// 7-Cod Entrada (Tipo Movimento)
									DADOC[SERIE],;		// 8
									DADOC[NFOR]})		// 9
				end
				if DADOF[FNF]>0	//...........................DOCTO FRETE ?
					GravMovEst({PRODUTOS[nX,2],;	// 1-Cod.Prod.
									DADOC[NDT1],;		// 2-Data Movimento
									DADOF[FNF],;		// 3-Docto
									0,;					// 4-Quantidade
									PRODUTOS[nX,11],;	// 5-Vlr Proporcional-FRETE
									0,;					// 6-Vlr a Venda
									'F',;					// 7-Frete (tipo movimento)
									DADOF[SERIE],;		// 8
									DADOF[FFOR]})		// 9
				end
			end
		end
	next
*----------------------------------------------------------------------------DLP-NOTA FISCAL
	pb_msg('Atualizando DPL/NFS',NIL,.F.)
*-------------------------------------------------------------------------------------------*
if GERAFINANC //.......................................CFOP GERA MOVIMENTACAO FINANCEIRA
	if str(DADOC[NPARC],3)==str(0,3) //................ PAGO NF A VISTA
		if DADOC[NADTO]=='N'	//..........................NAO É ADIANTAMENTO DEVE GERAR HISTORICO FORNEC
			CLIENTE->(dbseek(str(DADOC[NFOR],5)))
			select('HISFOR')
			while !AddRec(30);end
			replace 	HF_CODFO with if(empty(CLIENTE->CL_MATRIZ),DADOC[NFOR],CLIENTE->CL_MATRIZ),;
						HF_DUPLI with if(DADOC[NDOC]>0,DADOC[NDOC],DADOC[NNF]),;
						HF_DTEMI with DADOC[NDT1],;
						HF_DTVEN with DADOC[NDT1],;
						HF_DTPGT with DADOC[NDT1],;
						HF_VLRDP with DADOC[NVNF]-DADOC[NDES]-DADOC[NVFUNR]+DADOC[NVIPI],;
						HF_VLRPG with DADOC[NVNF]-DADOC[NDES]-DADOC[NVFUNR]+DADOC[NVIPI],;
						HF_NRNF  with DADOC[NNF],;
						HF_SERIE with DADOC[SERIE],;
						HF_CXACG with DADOC[CCXA],;
						HF_VLRMO with pb_divzero(DADOC[NVNF]-DADOC[NDES]-DADOC[NVFUNR],PARAMETRO->PA_VALOR),;
						HF_CDCXA with DADOC[NBAN]
			dbrunlock(recno())
		end
	else //..................................NF A PRAZO
		CLIENTE->(dbseek(str(DADOC[NFOR],5)))
		select('DPFOR')
		SCOM:=0
		for nX:=1 to DADOC[NPARC]
			while !AddRec(30);end
			replace	DP_DUPLI  with DADOPC[nX,1]
			replace	DP_CODFO  with if(empty(CLIENTE->CL_MATRIZ),DADOC[NFOR],CLIENTE->CL_MATRIZ)
			replace	DP_DTEMI  with DADOC[NDT1]
			replace	DP_CODBC  with DADOC[NBAN]
			replace	DP_DTVEN  with DADOPC[nX,2]
			replace	DP_VLRDP  with DADOPC[nX,3]
			replace	DP_MOEDA  with 1
			replace	DP_NRNF   with DADOC[NNF]
			replace	DP_SERIE  with DADOC[SERIE]
			replace	DP_ALFA   with CLIENTE->CL_RAZAO
			replace	DP_ATIVID with CLIENTE->CL_ATIVID

			SCOM+=DADOPC[nX,3]
			dbrunlock(RecNo())
		next
	end
	*------------------------------------------------------------------NF FRETE
	pb_msg('DPL/FRETE',NIL,.F.)
	if DADOF[FDOC]>0 //.............................................. TEM FRETE
		CLIENTE->(dbseek(str(DADOF[FFOR],5)))
		if DADOF[FPARC]=0	//.......... A VISTA
			select('HISFOR')
			while !AddRec();end
			replace 	HF_CODFO with if(empty(CLIENTE->CL_MATRIZ),DADOF[FFOR],CLIENTE->CL_MATRIZ),;
						HF_DUPLI with if(DADOF[FDOC]>0,DADOF[FDOC],DADOF[FFN]),;
						HF_DTEMI with DADOF[FDT1],;
						HF_DTVEN with DADOF[FDT1],;
						HF_DTPGT with DADOF[FDT1],;
						HF_VLRDP with DADOF[FVNF],;
						HF_VLRPG with DADOF[FVNF],;
						HF_NRNF  with DADOF[FNF],;
						HF_SERIE with DADOF[SERIE],;
						HF_CXACG with DADOF[CCXA],;
						HF_VLRMO with pb_divzero(DADOF[FVNF],PARAMETRO->PA_VALOR),;
						HF_CDCXA with DADOF[FBAN]
			dbrunlock(recno())
		else //........................FRETE A PRAZO
			CLIENTE->(dbseek(str(DADOF[FFOR],5)))
			select('DPFOR')
			SCOM:=0
			for nX:=1 to DADOF[FPARC]
				while !AddRec();end
				replace 	DP_DUPLI  with DADOPF[nX,1],;
							DP_CODFO  with if(empty(CLIENTE->CL_MATRIZ),DADOF[FFOR],CLIENTE->CL_MATRIZ),;
							DP_DTEMI  with DADOF[FDT1],;
							DP_CODBC  with DADOF[FBAN],;
							DP_DTVEN  with DADOPF[nX,2],;
							DP_VLRDP  with DADOPF[nX,3],;
							DP_MOEDA  with 1,;
							DP_NRNF   with DADOF[FNF],;
							DP_SERIE  with DADOF[SERIE],;
							DP_ALFA   with CLIENTE->CL_RAZAO,;
							DP_DPDR	 with 'P',;
							DP_ATIVID with CLIENTE->CL_ATIVID
				SCOM+=DADOPF[nX,3]
				dbrunlock(recno())
			next
		end
	end
end
RESTAURABANCO
return NIL
*---------------------------------------------EOF------------------*
