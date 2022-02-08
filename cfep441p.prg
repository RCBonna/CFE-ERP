*-----------------------------------------------------------------------------*
 static aVariav2:= {0,0,.T.,0 }
 //.................1.2..3..4
*-----------------------------------------------------------------------------*
#xtranslate nX        => aVariav2\[  1 \]
#xtranslate SCOM      => aVariav2\[  2 \]
#xtranslate lContinua => aVariav2\[  3 \]
#xtranslate STOT      => aVariav2\[  4 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'
*-----------------------------------------------------------------------------*
 function CFEP441P() //..................................... Digita Produtos
*-----------------------------------------------------------------------------*
local X
local VM_TF
local PROD
local QTD
local IPI
local COM
local VEN
local PIC
local VIP
local VIC
local VPDES
local CABEC:={'Sq','Prod.','Descricao','Qtde Entr.','Vlr Compra','Vlr Venda','% IPI','Vlr I.P.I.','% ICMS','Vlr ICMS','FRETE','Desconto','Unid','CodTrib','ICMS-FRETE','Acess','Cta-Debito','NatOpe','BaseIcms','Isento','Outros','Frete'}
//..............1......2............3...........4.............5...........6.......7............8........9.........10......11.........12.....13........14...........15......16...........17.......18.........19.......20.......21......22
CLIENTE->(dbseek(str(DADOC[NFOR],5)))
NATOP->(dbseek(str(DADOC[NNAT],7)))
SALVABANCO
salvacor(SALVA)
select('PROD')
while .T.
//	alert('Natureza:'+str(DADOC[NNAT],7)+' Transferencia='+NATOP->NO_FLTRAN)
	SomProdEnt()
	setcolor('W+/GR')
	pb_msg('Selecione um item e press <Enter> ou <ESC> para sair.',NIL,.F.)
	X:=abrowse(8,0,22,79,PRODUTOS,CABEC,;
				{ 3 ,    L_P ,    25 ,    10 ,    12 ,    12 ,      6 ,    12 ,   6 ,    12 ,             15 ,             15 ,  6 ,  3,   15,   10,  4,   8,   15,   15,   15,   15 },;
				{mI3,masc(21),masc(1),masc(6),masc(5),   mD83,masc(14),masc(5), mI62,masc(5),'999999999.9999','999999999.9999',mUUU,mI3,mI102,mI102,mI4,mNAT,mD112,mD112,mD112,mD112 },,VM_FAS[3])
				// 1       2       3       4       5        6       7       8      9     10               11               12    13  14    15  16,  17    18    19,   20    21....22
	if X>0.and.X<199
		if if(X>1,PRODUTOS[X-1,2]==0,.F.)
			alert('Preencha Sequencia Anterior <'+str(X-1,2,2)+'>')
			loop
		end
		salvacor(SALVA)
		PROD   :=PRODUTOS[X,02]
		QTD    :=PRODUTOS[X,04]
		COM    :=PRODUTOS[X,05]
		VEN    :=PRODUTOS[X,06]
		PIP    :=PRODUTOS[X,07]
		VIP    :=PRODUTOS[X,08]
		PIC    :=PRODUTOS[X,09]
		VIC    :=PRODUTOS[X,10]
		VPDES  :=PRODUTOS[X,12]
		VPFRE  :=PRODUTOS[X,34]
		CODCTB :=PRODUTOS[X,17] // Conta contábil de debito direto ou transferencia - DEBITO
		CCTRAC :=PRODUTOS[X,30] // Conta contábil de transferencia - CREDITO
		vBICM  :=PRODUTOS[X,19]
		vISEN  :=PRODUTOS[X,20]
		vOUTR  :=PRODUTOS[X,21]
		QtdNF  :=PRODUTOS[X,31]
		UniNF  :=PRODUTOS[X,32]
		FatConv:=PRODUTOS[X,33]
//		alert("Incluir na entradam - novos campos - entrada - detalhe")
//		CODCTB:=PRODUTOS[X,27]				// P/ctas contabeis transferencia

		VLVEN :=0
		CDT   :=if(empty(trim(PRODUTOS[X,14])),"000",PRODUTOS[X,14])
		pb_box(09,13,,,'W+/G,R/W*,,,W+/G',VM_FAS[3])
		@10,15 say padr(CABEC[02],11,'.') get PROD    pict masc(21) valid fn_codpr(@PROD,78)				.and.;
																								ChkProdNFDev(@PROD)				.and.;
																								ChkProdArray(PROD,PRODUTOS,X)	.and.;
																								ChkAdtoPrd(PROD,DADOC[NADTO]) .and.;
																								ChkPisCofinsP(PROD->PR_CODCOE)
		@11,15 say padr(CABEC[14],11,'.') get CDT     pict mI3      valid fn_codigo(@CDT,{'CODTR',{||CODTR->(dbseek(CDT))},{||NIL},{2,1,3}}) when (CDT:=if(empty(PROD->PR_CODTRE),CDT,PROD->PR_CODTRE))>=''.and.pb_msg('Codigo Tributário para este produto')
		@12,15 say padr(CABEC[17],11,'.') get CODCTB  pict mI4      valid fn_ifconta(,@CODCTB)                                               when pb_msg('Conta Contabil para Debito direto ou Transferencia - depende da Natureza Operacao/Produto').and.PROD->PR_MODO=='D'.or.NATOP->NO_FLTRAN=='S'
		@13,15 say "Cta-Credito"          get CCTRAC  pict mI4      valid fn_ifconta(,@CCTRAC)                                               when pb_msg('Conta Contabil para Credito de Nat.Oper. de Transferencia').and.NATOP->NO_FLTRAN=='S'

		@14,15 say "Qtde NF...."          get QtdNF   pict mD112    valid QtdNF>0.00                                                         when pb_msg('Quantidade comprada que esta na NF').and.NATOP->NO_FLTRAN#'S'
		@14,40 say "Unid NF."             get UniNF   pict mUUU     valid fn_codigo(@UniNF,{'UNIDADE',{||UNIDADE->(dbseek(UniNF))},{||CFEPUNT(.T.)},{2,1}}).and.if(UniNF#PROD->PR_UND,ChkUnNFUnEstoque(UniNF,PROD->PR_UND),.T.) when pb_msg('Unidade que foi comprado o item que esta na NF').and.NATOP->NO_FLTRAN#'S'
		@15,15 say padr(CABEC[04],11,'.') get QTD     pict mD112    valid QTD>0.00 										.and.;
																								ChkQtdeNFDev(QTD)								.and.;
																								ChkAdtoQtd(PROD,DADOC[NADTO],QTD,@VLVEN);
																						when 	pb_msg('Unidade '+PROD->PR_UND+' - Quantidade Total Entrada do produto - Fator '+str(UNIDFAT->UN_FATOR)).and.;
																								(QTD:=if(UniNF==PROD->PR_UND,QtdNF,QtdNF*UNIDFAT->UN_FATOR))>=0
		@16,15 say padr(CABEC[05],11,'.') get COM     pict mD112    valid fn_vlrcom(COM,PROD).and.COM>0.00                                   when pb_msg('Valor das Mercadorias com ICMS menos IPI').and.(COM:=if(DADOC[NADTO]=='S',QTD*VLVEN,COM))>=0

		@16,55 say padr(CABEC[12],11,'.') get VPDES   pict mD112    when (VPDES:=Trunca(DADOC[NDES]/DADOC[NVNF]    *COM,2))<0
		@17,55 say padr(CABEC[22],11,'.') get VPFRE   pict mD112    when (VPFRE:=Trunca(DADOC[NACFRETE]/DADOC[NVNF]*COM,2))<0

		//--------------------------------------------
		@17,15 say padr(CABEC[07],11,'.') get PIP     pict mI52     valid PIP>=0     when (PIP:=0)>=0.and.DADOC[NVIPI] >0.and.pb_msg('Percentual do IPI deste produto')  .and.(PIP:=PROD->PR_PIPI)                     >=0
		@18,15 say padr(CABEC[08],11,'.') get VIP     pict mD112    valid VIP>=0     when (VIP:=0)>=0.and.DADOC[NVIPI] >0.and.pb_msg('Valor Total do IPI deste produto') .and.(VIP:=Trunca((COM-VlDesc(COM))*PIP/100,2))>=0.00
		//--------------------------------------------
		@19,15 say padr(CABEC[09],11,'.') get PIC     pict mI52     valid PIC >=0    when (PIC:=0)>=0.and.DADOC[NVICMS]>0.and.pb_msg('% de ICMS deste produto')          .and.right(CDT,2)$"00-10-20".and.(PIC:=PROD->PR_PICMS)>=0.00
		@20,15 say padr(CABEC[10],11,'.') get VIC     pict mD112    valid VIC >=0    when (VIC:=0)>=0.and.DADOC[NVICMS]>0.and.pb_msg('Valor ICMS deste produto')         .and.right(CDT,2)$"00-10-20".and.(VIC:=Trunca((COM+DADOC[NACFRETE]-VlDesc(COM))*PIC/100*(PROD->PR_PTRIB/100),2))>=0.00

		//--------------------------------------------
		@21,15 say padr(CABEC[06],11,'.') get VEN     pict ;
															if(PARAMETRO->PA_NRDECVE==3, mD83, mD82 );
																						valid VEN  >=0               when fn_vlven(@VEN,(COM/QTD),PROD,eval(DADOF[FPERC])*COM/QTD,PIC,(VIP/QTD))                                                                               .and. pb_msg('Valor venda deste produto. Atual:'+str(PROD->PR_VLVEN,12,3))
		@18,55 say padr(CABEC[19],11,'.') get vBICM   pict mD112    valid vBICM>=0;	/*.and.str(COM+VPFRE-VPDES,		15,2)>=str(vBICM      ,15,2)*/ 
																						when (vBICM:=0)>=0.and. right(CDT,2)$"00-10-20-30-------70---" .and. VlBaseI(CDT,VIC,PIC,COM+VPFRE-VlDesc(COM),@vBICM)          .and. pb_msg('Base ICMS deste produto').and.DADOC[NVICMS]>0
		@19,55 say padr(CABEC[21],11,'.') get vOUTR   pict mD112    valid vOUTR>=0;	/* .and.str(COM+VPFRE-VPDES-VIP,	15,2)==str(vBICM+vOUTR,15,2)*/ 
																						when (vOUTR:=0)>=0.and.(right(CDT,2)$"---------50-51-60-70-90" .or.  VIP>0).and.(vOUTR:=max(COM-vBICM+VIP-VPDES,0))>=0.00 .and. pb_msg('Valor Total de Outros para Livros Fiscais')
		@20,55 say padr(CABEC[20],11,'.') get vISEN   pict mD112    valid vISEN>=0;	/*.and.str(COM+VPFRE-VPDES,		15,2)==str(vBICM+vISEN,15,2) */ 
																						when (vISEN:=0)>=0.and. right(CDT,2)$"------20-30-40-41------" .and.(vISEN:=max(COM-vBICM-VPDES,0))                >=0.00 .and. pb_msg('Valor Total de Isentas para Livros Fiscais')
		read
		salvacor(RESTAURA)
		if lastkey()#K_ESC.and.pb_sn()
			PRODUTOS[X,02]:=PROD
			PRODUTOS[X,03]:=padr(PROD->PR_DESCR,40)
			PRODUTOS[X,04]:=QTD
			PRODUTOS[X,05]:=COM											// Vlr Mercadorias - PIS (TOTAL)
			PRODUTOS[X,06]:=VEN
			PRODUTOS[X,07]:=PIP											// %   IPI
			PRODUTOS[X,08]:=VIP											// Vlr IPI
			PRODUTOS[X,09]:=PIC
			PRODUTOS[X,10]:=VIC
			PRODUTOS[X,11]:=trunca(eval(DADOF[FPERC])*COM,2)	// FRETE Proporc
			PRODUTOS[X,12]:=VPDES										// DESC. Proporc
			PRODUTOS[X,34]:=VPFRE										// FRETE. Proporc
			PRODUTOS[X,13]:=PROD->PR_UND
			PRODUTOS[X,14]:=CDT											// Cod Tributario
			PRODUTOS[X,15]:=trunca(DADOF[FVICMS]/(DADOC[NVNF]-DADOC[NVIPI])*COM,2)	//	Icms FRETE Pr
			PRODUTOS[X,17]:=CODCTB																	// P/Ctas Contabeis
			PRODUTOS[X,18]:=DADOC[NNAT]
			PRODUTOS[X,19]:=vBICM
			PRODUTOS[X,20]:=vISEN
			PRODUTOS[X,21]:=vOUTR
			PRODUTOS[X,22]:=PROD->PR_CODCOE	// Codigo Pis+Cofins <Entrada>
			PRODUTOS[X,26]:=PROD->PR_CFISIPI
			PRODUTOS[X,27]:=CODCTB				// P/Ctas Contabeis Tansferencia - DEBITO
			PRODUTOS[X,30]:=CCTRAC				// Conta contábil de transferencia - CREDITO
			if UniNF==PROD->PR_UND
				PRODUTOS[X,31]:=QTD
				PRODUTOS[X,32]:=PROD->PR_UND
				PRODUTOS[X,33]:=1
			else
				PRODUTOS[X,31]:=QtdNF
				PRODUTOS[X,32]:=UniNF
				PRODUTOS[X,33]:=pb_divzero(QTD,QtdNF)
			end
			PRODUTOS[X,34]:=PROD->PR_PESOKG*QTD // Guarda Peso Total
			if NATOP->NO_FLPISC=='S'.and.CLIENTE->CL_TPEMPR#5 // Considerar PIS+COFINS (Empresa deve ser #5=SuperSimples)
				SALVABANCO
				select FISACOF
				if dbseek(PRODUTOS[X,22]+CLIENTE->CL_TIPOFJ)
					PRODUTOS[X,23]:=trunca((PRODUTOS[X,05])*FISACOF->CO_PERC1/100,2)	// Vlr PIS
					PRODUTOS[X,24]:=trunca((PRODUTOS[X,05])*FISACOF->CO_PERC2/100,2)	// Vlr Cofins
				else
					PRODUTOS[X,23]:=0
					PRODUTOS[X,24]:=0
				end
				RESTAURABANCO
			end
			//------------------------------------------trata adiantamento
			keyboard replicate(chr(K_DOWN),X)
		end
	else
		PRODUTOS[001,12]+=DADOC[NDES]-PRODUTOS[200,12]
		PRODUTOS[200,12]:=DADOC[NDES]
		exit
	end
end
salvacor(RESTAURA)
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
function CFEP441PC() // Rotina de parcelamento do cabecalho
*-----------------------------------------------------------------------------*
local QTD :=DADOC[NPARC]
local COM :=DADOC[NBAN]
local DOC :=if(empty(DADOC[NDOC]),DADOC[NNF],DADOC[NDOC])
local TOT :=DADOC[NVNF]-DADOC[NDES]-DADOC[NVFUNR]+DADOC[VACES]+DADOC[NVIPI]
local CXA :=DADOC[CCXA]
SCOM      :=0
if DOC>999999
	DOC:=val(right(pb_zer(DOC,10),6))
end
if CXA==0
	CXA        :=BuscTipoCx('P')
	DADOC[CCXA]:=CXA
end
if COM==0
	COM         :=BuscBcoCx()
	DADOC[NBAN] :=COM
end
lContinua := .F.
if DADOC[NADTO]=='S' // É baixa de adiantamento ..... nao precisa parcelar.
	return lContinua
end
pb_box(09,0,22,55,'W+/BG,,,,W+/BG','Parcelamento NF Entrada')
@10,1 say 'Valor Total: '+transform(TOT,masc(5))
@11,1 say 'Cod.Caixa..:' get CXA picture mI2      valid fn_codigo(@CXA,{'CAIXACG',{||CAIXACG->(dbseek(str(CXA,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when USACAIXA
@12,1 say 'N.Parcelas.:' get QTD picture mI2 valid QTD>=0
@13,1 say 'Cod.Banco..:' get COM picture mI2 valid fn_codigo(@COM,{'BANCO',{||BANCO->(dbseek(str(COM,2)))},{||CFEP1500T(.T.)},{2,1}})
@14,1 say 'N.Documento:' get DOC picture mI6 valid DOC>=0.and. DOC<=999999
read
if lastkey()#27
	DADOC[NPARC]:=QTD
	DADOC[NBAN] :=COM
	DADOC[NDOC] :=DOC
	DADOC[CCXA] :=CXA
	if QTD>0
		if QTD # len(DADOPC)
			DADOPC:={}
			for nX :=1 to QTD
				aadd(DADOPC,{DOC*100+nX,DADOC[NDT]+nX*30,int(TOT/QTD*100)/100})
				SCOM+=DADOPC[nX,3]
			next
			DADOPC[QTD,3]+=(TOT-SCOM)
		end
		while .T.
			nX:=abrowse(15,0,22,35,DADOPC,	{'Documento','DtVenc','Valor' },;
														{         10,      10,    12  },;
														{   masc(16), masc(7), masc(5)})
			if nX>0
				DOC:=DADOPC[nX,1]
				COM:=DADOPC[nX,2]
				QTD:=DADOPC[nX,3]
				@row(),01 get DOC picture masc(16) valid DOC>=0
				@row(),12 get COM picture masc(07) valid COM>=PARAMETRO->PA_DATA
				@row(),23 get QTD picture masc(05) valid QTD>=0
				read
				if lastkey()#K_ESC
					DADOPC[nX,1]=DOC
					DADOPC[nX,2]=COM
					DADOPC[nX,3]=QTD
					keyboard replicate(chr(K_DOWN),nX)
				end
			else
				SCOM:=0
				aeval(DADOPC,{|DET|SCOM+=DET[3]})
				if str(SCOM,15,2)#str(TOT,15,2)
					if pb_sn('Valores näo fechados. Abandonar ?')
						keyboard chr(27)+chr(27)+CHR(27)+chr(13)
						exit
					end
					loop
				elseif pb_sn('Parcelamento DPL(NF) OK ?')
					lContinua := .T.
					exit
				end
			end
		end
	end
end
return lContinua

*-----------------------------------------------------------------------------*
	function CFEP441PF() // Rotina de parcelamento do frete
*-----------------------------------------------------------------------------*
local QTD:=DADOF[FPARC]
local COM:=DADOF[FBAN]
local DOC:=if(empty(DADOF[FDOC]),DADOF[NNF],DADOF[FDOC])
local TOT:=DADOF[FVNF]
local CXA:=DADOF[CCXA]
if DOC>999999
	DOC:=val(right(pb_zer(DOC,10),6))
end
if CXA==0
	CXA:=BuscTipoCx('P')
end
if COM==0
	COM:=BuscBcoCx()
end

lContinua := .F.
pb_box(09,20,22,79,'W+/BG,,,,W+/BG','Parcelamento Frete Entrada')
@10,23 say 'Valor Total: '+transform(TOT,masc(5))
@11,23 say 'Cod.Caixa..:' get CXA picture mI2 valid fn_codigo(@CXA,{'CAIXACG',{||CAIXACG->(dbseek(str(CXA,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when USACAIXA.and.pb_msg('Codigo para Lancamento no Caixa')
@12,23 say 'N.Parcelas.:' get QTD picture mI2 valid QTD>=0
@13,23 say 'Cod.Banco..:' get COM picture mI2 valid fn_codigo(@COM,{'BANCO',{||BANCO->(dbseek(str(COM,2)))},{||CFEP1500T(.T.)},{2,1}})
@14,23 say 'N.Documento:' get DOC picture mI6 valid DOC>=0.and. DOC<=999999
read
if lastkey()#27
	DADOF[FPARC]:=QTD
	DADOF[FBAN] :=COM
	DADOF[FDOC] :=DOC
	DADOF[CCXA] :=CXA
	if QTD>0
		if QTD # len(DADOPF)
			DADOPF:={}
			SCOM:=0
			for nX:=1 to QTD
				aadd(DADOPF,{DOC*100+nX,DADOC[FDT]+nX*30,int(TOT/QTD*100)/100})
				SCOM+=DADOPF[nX,3]
			next
			DADOPF[QTD,3]+=(TOT-SCOM)
		end
		while .T.
			nX:=abrowse(15,40,22,75,DADOPF,	{'Documento','DtVenc','Valor'},;
														{         10,      10,    12 },;
														{       mDPL, masc(7),masc(5)})
			if nX>0
				DOC:=DADOPF[nX,1]
				COM:=DADOPF[nX,2]
				QTD:=DADOPF[nX,3]
				@row(),41 get DOC picture mDPL     valid DOC>=0
				@row(),52 get COM picture masc(07) valid COM>=PARAMETRO->PA_DATA
				@row(),63 get QTD picture masc(05) valid QTD>=0
				read
				if lastkey()#27
					DADOPF[nX,1]=DOC
					DADOPF[nX,2]=COM
					DADOPF[nX,3]=QTD
					keyboard replicate(chr(K_DOWN),nX)
				end
			else
				SCOM:=0
				aeval(DADOPF,{|DET|SCOM+=DET[3]})
				if str(SCOM,15,2)#str(TOT,15,2)
					beeperro()
					if pb_sn('Valores näo fechados. Abandonar ?')
						keyboard chr(27)+chr(27)+CHR(27)+chr(13)
						exit
					end
					loop
				elseif pb_sn('Parcelamento DPL(Frete) OK ?')
					lContinua := .T.
					exit
				end
			end
		end
	end
end
return lContinua

*-----------------------------------------------------------------------------*
  static function VlBaseI(P1, P2, P3, P4,   P5)
*								 CDT,VIC,PIC,COM,@BICM
*-----------------------------------------------------------------------------*
if right(P1,2)$"00-10"
	P5:=P4
else
	P5:=Trunca(P2/P3*100,2)
end
return .T.

*-----------------------------------------------------------------------------*
 static function VlDesc(VCom)
*-----------------------------------------------------------------------------*
SCOM:=trunca(DADOC[NDES]/DADOC[NVNF]*VCom,2)
return SCOM

*-------------------------------------------------------------------
 function SomProdEnt()
*-------------------------------------------------------------------
               SCOM:=0
	PRODUTOS[200,04]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[04]}) // SOMA DAS QUANTIDADES
	PRODUTOS[200,04]:=SCOM
               SCOM:=0
	PRODUTOS[200,05]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[05]}) // VLR TOT PRODUTO
	PRODUTOS[200,05]:=SCOM
		         SCOM:=0
	PRODUTOS[200,08]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[08]})	// VLR IPI
	PRODUTOS[200,08]:=SCOM
		         SCOM:=0
	PRODUTOS[200,10]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[10]})	//	VLR ICMS
	PRODUTOS[200,10]:=SCOM
		         SCOM:=0
	PRODUTOS[200,11]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[11]})	//	VLR FRETE
	PRODUTOS[200,11]:=SCOM
		         SCOM:=0
	PRODUTOS[200,12]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[12]})	//	VLR DESCONTO
	PRODUTOS[200,12]:=SCOM
		         SCOM:=0
	PRODUTOS[200,15]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[15]})	//	VLR ICMS FRETE
	PRODUTOS[200,15]:=SCOM

               SCOM:=0
               STOT:=PRODUTOS[200,05]
               PPIS:=0.0165
               PCOF:=0.0760
	PRODUTOS[200,28]:=0
	aeval(PRODUTOS,{|DET|DET[28]:=trunca(pb_divzero(DET[5],STOT)*DADOF[FVNF]*PPIS,2)}) // VLR PIS FRETE
//	aeval(PRODUTOS,{|DET|SCOM+=DET[28]})	//	VLR SOMA PIS FRETE
//	PRODUTOS[200,05]:=SCOM

	PRODUTOS[200,29]:=0
	aeval(PRODUTOS,{|DET|DET[29]:=trunca(pb_divzero(DET[5],STOT)*DADOF[FVNF]*PCOF,2)}) // VLR COFINS FRETE

					SCOM:=0
	PRODUTOS[200,34]:=0
	aeval(PRODUTOS,{|DET|SCOM+=DET[34]}) // QTDADE TOT PRODUTO
	PRODUTOS[200,34]:=SCOM

	//.............................// Para nota de transporte
//	I_TRANS[10]:=PRODUTOS[200,04]	// Quantidade deixar o que foi digitado
//	I_TRANS[11]:='Diversos'
//	I_TRANS[12]:='Diversos'
//	I_TRANS[13]:=PRODUTOS[200,34]	// Peso Bruto
//	I_TRANS[14]:=PRODUTOS[200,34]	// Peso Liquido

return NIL
*---------------------------------------EOF-----------------------------------------
