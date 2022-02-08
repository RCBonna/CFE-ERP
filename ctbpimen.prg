*-----------------------------------------------------------------------------*
 static aVariav := {'S',0, '', 0, '',0,.F.,.F.,.F.}
 //..................1..2..3...4..5..6..7...8...9
*-----------------------------------------------------------------------------*
#xtranslate nTpCTB		=> aVariav\[  1 \]
#xtranslate aPis			=> aVariav\[  2 \]
#xtranslate aCofins		=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate lFlag			=> aVariav\[  5 \]
#xtranslate FRETE			=> aVariav\[  6 \]
#xtranslate Contabiliza => aVariav\[  7 \]
#xtranslate GeraFinanc	=> aVariav\[  8 \]
#xtranslate GeraEstoque	=> aVariav\[  9 \]

#include 'RCB.CH'

 static VM_CTAS :={}
*-----------------------------------------------------------------------------> Integra NF-Entrada
 function CTBPIMEN(DATA,nLinha)	//	Integra do Entradas
*-----------------------------------------------------------------------------*
local TpFor   :=0
local ARQ     :=ArqTemp(,,'')
local VConta  :=0
local VHist   :=''
local TIPO    :=0
      FRETE   :={}
		
if DATA==NIL
	alert('Chamada ao programa incorreto;Atualize Menu;'+ProcName())
	return NIL
end
pb_msg(ProcName()+'.Processando Integracao das Entradas....('+ARQ+')')
dbcreate(ARQ,{ {'WK_CONTA','N',  4,0},;
					{'WK_DATA', 'D',  8,0},;
					{'WK_HIST', 'C', 60,0},;
					{'WK_VALOR','N', 12,2},;
					{'WK_CHAVE','C', 20,0}})
if !net_use(ARQ,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
//...........1...2..3...4....5..6...7
	DbCloseAll()
	FileDelete (ARQ + '.*')
	return .F.
end
select WORK
Index on str(WK_CONTA,4)+dtos(WK_DATA)+WK_HIST tag CODIGO_CTB to (ARQ)
ordsetfocus('CODIGO_CTB')

beepaler()
if !abre({	'C->PARAMETRO',;
				'C->TABICMS',;
				'R->CODTR',;
				'C->DIARIO',;
				'C->ENTCAB',;
				'C->ENTDET',;
				'C->HISFOR',;
				'C->CTRNF',;
				'C->OBS',;
				'C->CLIENTE',;
				'C->CAIXACG',;
          	'C->PROD',;
          	'R->FISACOF',;
          	'C->PROFOR',;
          	'C->DPFOR',;
				'C->BANCO',;
				'C->GRUPOS',;
				'R->CTACTB',;
				'C->MOVEST',;
				'C->ALIQUOTAS',;
				'C->NATOP'})
else
	BuscBcoCx()
	select('PROD')
	ordem CODIGO
	select('ENTCAB')
	ORDEM DTEDOC
	DbGoTop()
	dbseek(dtos(DATA[1]),.T.)
	while !eof().and.ENTCAB->EC_DTENT<=DATA[2]
		@nLinha,40 say 'Entradas:'+dtoc(ENTCAB->EC_DTENT)
		NATOP->(dbseek(str(ENTCAB->EC_CODOP,7)))

		Contabiliza:=!(NATOP->NO_FLCTB =='N')
		GeraFinanc :=!(NATOP->NO_FINANC=='N')
		GeraEstoque:=!(NATOP->NO_ESTOQ =='N')

		if !ENTCAB->EC_FLCTB .and.;	// Registro Não Contabilizado 
			EC_TPDOC#'CT '    .and.;	// Tipo de Documento # CT (Frete)
			Contabiliza 					// CFOP Contabiliza?

			FRETE   :={0,0,0,0,0,0,'',0,''}
			if (ENTCAB->EC_FRDOC+ENTCAB->EC_FRFOR) > 0.00 // Tem Frete
				FRETE:=Entr_Frete(str(ENTCAB->EC_FRDOC,8)+ENTCAB->EC_FRSER+str(ENTCAB->EC_FRFOR,5))	// Buscar Inf Frete
			end
			CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
			TpFor   :=max(CLIENTE->CL_ATIVID,1)
			TpEmpr  :=CLIENTE->CL_TPEMPR

			VM_CTAS :=array(40,13)
			aeval(VM_CTAS,{|DET|afill(DET,0)})
			//....................................Busca Contas Contábeis
			select('CTACTB')
			DbGoTop()
			nTpCTB:='E' // Tipo Entrada
			// Tando para Transferencia como para Entrada deve pegar contas contabeis de Entrada
			dbseek(nTpCTB+str(TpFor,2)+str(0,2)+str(10,2),.T.)
			dbeval(	{||VM_CTAS[CC_TPEST,CC_SEQUE-10]:=CC_CONTA},,;
						{||CC_TPMOV==nTpCTB.and.CC_TPCFO==TpFor})
			//.......................................CTA ESTOQUE, ICMS, IPI
			aadd(VM_CTAS,{;//.............................................41...acrescentar linha padrão Fornecedor
							fn_lecc(nTpCTB,TpFor,0, 0),;	//..................41,1-CTA FORNEC (Credito')
							fn_lecc(nTpCTB,TpFor,0, 1),;	//..................41,2-JUROS
							fn_lecc(nTpCTB,TpFor,0, 2),;	//..................41,3-DESCONTO
							fn_lecc(nTpCTB,TpFor,0, 3),;	//..................41,4-FUNRURAL
							fn_lecc(nTpCTB,TpFor,0, 4)})	//..................41,5-Adiantamento Fornec
			//.......................................................contabilizar TOTAL NF - Conta de Fornecedores
			if NATOP->NO_FLTRAN=='S'//....................................Transferencia?
				nTpCTB:='T' // Tipo Transferencia(T)
			end
			VHist :='NF '
			if nTpCTB=='T'
				//.............................Nao contabiliza total e sim por item de compra
				CtbItens(	str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5),;
								ENTCAB->EC_DTENT,;
								FRETE)
			else
				if str(ENTCAB->EC_FATUR,3)==str(0,3) // a vista
					BANCO->(dbseek(STR(ENTCAB->EC_CODBC,2)))
					VConta:=BANCO->BC_CONTA // pagamento a vista
					if VConta==0.and.NATOP->NO_FLCTB=='S'
						VConta:=BuscBcoCx() //........Pagamento a vista
					end
					VHist :="Pago NF "
				end
				if ENTCAB->EC_FLADTO	//...................É Baixa de Adiantamento
					VConta:=VM_CTAS[41,5]
					VHist :="Receb.Merc.NF "
				end
				if NATOP->NO_FLCTB=='S'.and.NATOP->NO_FINANC=='N'.and.NATOP->NO_CTBCR>0
					VM_CTAS[41,01]:=NATOP->NO_CTBCR // usa CC da CFOP caso seja contabil = S e Financ = N
					VHist :="Ref.NF "
				end
				VConta:=VM_CTAS[41,1] // Atualiza Conta a Crédito depende do Lançamento				
				//................................Contabilizar Fornecedor
				Grava_Work({VConta,;
								ENTCAB->EC_DTENT,;
								VHist+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' de '+CLIENTE->CL_RAZAO,;
								CRE * (ENTCAB->EC_TOTAL - ENTCAB->EC_FUNRU - ENTCAB->EC_DESC + ENTCAB->EC_ACESS + ENTCAB->EC_IPI),;
								'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
								})
				//..............................contabilizar FUNRURAL -> toda a NOTA FISCAL
				Grava_Work({VM_CTAS[41,4],;
								ENTCAB->EC_DTENT,;
								'Retido NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' de '+CLIENTE->CL_RAZAO,;
								CRE * ENTCAB->EC_FUNRU,;
								'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
								})
				//....................................Contabilizar Itens
				CtbItens(	str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5),;
								ENTCAB->EC_DTENT,;
								FRETE)
				//.....................................Tem FRETE............Contabilizar Fornecedor/Pgto
				if FRETE[1]>0
					CLIENTE->(dbseek(str(FRETE[4],5)))
					TpFor   :=max(CLIENTE->CL_ATIVID,1)
					aadd(VM_CTAS,{;//.............................................42/
										fn_lecc('E',TpFor,0, 0),;	//..................42,1-CTA FORNEC
										fn_lecc('E',TpFor,0, 1),;	//..................42,2-JUROS
										fn_lecc('E',TpFor,0, 2),;	//..................42,3-DESCONTO
										fn_lecc('E',TpFor,0, 3)})	//..................42,4-FUNRURAL
					VConta:=VM_CTAS[42,1]
					VHist :="NFF "
					if str(FRETE[6],3)==str(0,3) // Numero parcelas = a vista ?
						BANCO->(dbseek(STR(FRETE[5],2)))
						VConta:=BANCO->BC_CONTA // pagamento a vista
						if VConta = 0
							VConta:=BuscBcoCx()
						end
						VHist :="Pago NFF."
					end
					//.....................................................................Contabiliza fornecedor Frete - 
					Grava_Work({VConta,;
									ENTCAB->EC_DTENT,;
									VHist+alltrim(str(FRETE[8]))+'/'+alltrim(FRETE[9])+' de '+FRETE[7],;
									CRE * (FRETE[2]),;
									'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
									})
				end
			end
			select('ENTCAB')
			if ENTCAB->(reclock())
				replace ENTCAB->EC_FLCTB with .T. 
			end
			wContabilizar()
		end
		dbskip()
	end
end
dbcloseall()
FileDelete (ARQ + '.*')
return .T.

*-----------------------------------------------------------------------------*
 static function CtbItens(P1,pData,P3)
*-----------------------------------------------------------------------------*
local X
local TpEst
local VM_VLRS:=Array(41,13)
local    TOT :={0,0,0,0,0}
local LctoDir:={}

aPis   :={}
aCofins:={}

//alert('Entrou em itens')

aeval(VM_VLRS,{|DET|DET:=afill(DET,0)})
select('ENTDET')
dbseek(P1,.T.)
while !eof().and.str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)==P1
	PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
	TpEst     :=max(PROD->PR_CTB,1)
	if PROD->PR_CTB > 0.and.PROD->PR_CTB < 41																// Estoq COM controle Saldo
		if PROD->PR_MODO=='D'.or.NATOP->NO_FLTRAN=='S'	//.....................................Debito Direto ?
			aadd(LctoDir,{ ENTDET->ED_CTACTB,;	//..............................................1-CONTA CONTABIL (Dest-despesas)
								ENTDET->ED_VALOR,;	//..............................................2-VLR Mercadorias
								ENTDET->ED_VLICM,;	//..............................................3-VLR ICMS
								ENTDET->ED_IPI,;		//..............................................4-IPI
								trunca(ENTDET->ED_VALOR/ENTCAB->EC_TOTAL*ENTCAB->EC_DESC ,2),;	//....5-Vlr Desc  Prop
								trunca(ENTDET->ED_VALOR/ENTCAB->EC_TOTAL*ENTCAB->EC_ACESS,2),;	//....6-Vlr Acess Prop
								trunca(ENTDET->ED_VALOR/ENTCAB->EC_TOTAL*P3[2]				,2),;	//....7-Vlr FRETE Prop
								VM_CTAS[TpEst,02],; //...............................................8-Conta Contabil Icms
								VM_CTAS[TpEst,01],; //...............................................9-Conta Contabil Debito
								ENTDET->ED_DESTRAC}) //.............................................10-Conta Contabil Transferencia-Credito
		else	//...............................................................................NAO É DEBITO DIRETO
			VM_VLRS[TpEst,01]+=(	ENTDET->ED_VALOR-;
										ENTDET->ED_VLICM-;
										ENTDET->ED_VLPIS-;
										ENTDET->ED_VLCOFI-;
										if(FRETE[1]>0,ENTDET->ED_FVLPIS, 0)-;
										if(FRETE[1]>0,ENTDET->ED_FVLCOFI,0))	//......................1-VLR MEDIO
			VM_VLRS[TpEst,02]+=(ENTDET->ED_VLICM)//.............................................2-VLR ICMS
			VM_VLRS[TpEst,03]+=(ENTDET->ED_IPI)//...............................................3-VLR IPI
			VM_VLRS[TpEst,05]+=trunca( ENTDET->ED_VALOR/ENTCAB->EC_TOTAL*ENTCAB->EC_DESC ,2)	// 5-Vlr Desc  Prop
			VM_VLRS[TpEst,06]+=trunca( ENTDET->ED_VALOR/ENTCAB->EC_TOTAL*ENTCAB->EC_ACESS,2)	// 6-Vlr Acess Prop
			if NATOP->NO_FLPISC=='S' // tem PIS x Cofins
				addPisCofins(	ENTDET->ED_CODCOF,;
									ENTDET->ED_VLPIS+ENTDET->ED_FVLPIS,;
									ENTDET->ED_VLCOFI+ENTDET->ED_FVLCOFI)
			end
		end
	end
	dbskip()
end

aeval(VM_VLRS,{|DET|TOT[5]+=(DET[1]+DET[2])}) //..........................Total 

VFrPrIcms :=Trunca(pb_divzero(P3[3],TOT[5]),5) //* % Icms Frete
aeval(VM_VLRS,{|DET|DET[4]:=Trunca((DET[1]+DET[2])*VFrPrIcms,2)}) // Total 

VFrPrIcms :=Trunca(pb_divzero((P3[2]-P3[3]),TOT[5]),5) //* % Tot Frete
aeval(VM_VLRS,{|DET|DET[7]:=Trunca((DET[1]+DET[2])*VFrPrIcms,2)}) // Total 

aeval(VM_VLRS,{|DET|TOT[1]+=DET[5]}) //......................Total 
aeval(VM_VLRS,{|DET|TOT[2]+=DET[6]}) //......................Total Vlr Acess
aeval(VM_VLRS,{|DET|TOT[3]+=DET[4]}) //......................Total ICMS FRETE
aeval(VM_VLRS,{|DET|TOT[4]+=DET[7]}) //......................Total VLR FRETE

//.........10..............9.99 = 0.01
TOT[1]:=(ENTCAB->EC_DESC -TOT[1])	//.......................Arredondamento Desc NF
TOT[2]:=(ENTCAB->EC_ACESS-TOT[2])	//.......................Arredondamento Acessorio NF
TOT[3]:=(P3[3]           -TOT[3])	//.......................Arredondamento Frete Icms
TOT[4]:=(P3[2]-P3[3]     -TOT[4])	//.......................Arredondamento Vlr Frete

for X:=1 to 41
	if str(VM_VLRS[X,01]+VM_VLRS[X,02]+VM_VLRS[X,03]+VM_VLRS[X,04]+VM_VLRS[X ,05]+VM_VLRS[X ,06]+VM_VLRS[X ,07],15,2)#str(0,15,2)
		if TOT[1]#0
			if str(VM_VLRS[X,5]-TOT[1],15,2)>=str(0,15,2)
				VM_VLRS[X,5]+=TOT[1]
				TOT[1]:=0
			end
		end
		if TOT[2]#0
			if str(VM_VLRS[X,6]-TOT[2],15,2)>=str(0,15,2)
				VM_VLRS[X,6]+=TOT[2]
				TOT[2]:=0
			end
		end
		if TOT[3]#0
			if str(VM_VLRS[X,4]-TOT[3],15,2)>=str(0,15,2)
				VM_VLRS[X,4]+=TOT[3]
				TOT[3]:=0
			end
		end
		if TOT[4]#0
			if str(VM_VLRS[X,7]-TOT[4],15,2)>=str(0,15,2)
				VM_VLRS[X,7]+=TOT[4]
				TOT[4]:=0
			end
		end

		if nTpCTB=='E'
			//..............................contabilizar ESTOQUE NF
			Grava_Work({VM_CTAS[X,01],;
							pData,;
							'Adq.NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+if(ENTCAB->EC_FRDOC>0,' e Frete','')+' de '+CLIENTE->CL_RAZAO,;
							DEB * VM_VLRS[X,01] + VM_VLRS[X ,03] - VM_VLRS[X ,05] + VM_VLRS[X ,06] + VM_VLRS[X,07],;
							'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
							})
			//..............................contabilizar ICMS NF e FRETE=VM_VLRS[X,04]
			Grava_Work({VM_CTAS[X,02],;
							pData,;
							'NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+if(ENTCAB->EC_FRDOC>0,' e Frete','')+' de '+CLIENTE->CL_RAZAO,;
							DEB * VM_VLRS[X,02] + VM_VLRS[X,04],;
							'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
							})

			//..............................contabilizar IPI NF (NÃO TEM IPI->SOMA NO ESTOQUE
//			Grava_Work({VM_CTAS[X,03],;
//							pData,;
//							'Adq.NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+if(ENTCAB->EC_FRDOC>0,' e Frete','')+' de '+CLIENTE->CL_RAZAO,;
//							DEB * VM_VLRS[X,03],;
//							'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
//							})
			//===========================================================================================================
			//..............................VLR FRETE + ICMS FRETE CONTABILIZADO JUNTO...................................
		end
	end
next

if NATOP->NO_FLCTB=='S'.and.NATOP->NO_FLTRAN=='S'	//...................Contabiliza Transferencias
	for nX:=1 to len(LctoDir)
		// INVERTE OS LANCAMENTOS DA INTEGRACAO CONTÁBIL
		Grava_Work({LctoDir[nX,01],;
						pData,;
						'Transf.NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' de '+CLIENTE->CL_RAZAO,;
						DEB * LctoDir[nX,02],;
						'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
						})
		if LctoDir[nX,10]>0
			Grava_Work({LctoDir[nX,10],;
							pData,;
							'Transf.NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' para '+CLIENTE->CL_RAZAO,;
							CRE * LctoDir[nX,02],;
							'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
							})
		else
			Grava_Work({LctoDir[nX,09],;
							pData,;
							'Transf.NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' para '+CLIENTE->CL_RAZAO,;
							CRE * LctoDir[nX,02],;
							'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
							})
		end
	next
else	//..........................................................Contabiliza Débido direto
	for nX:=1 to len(LctoDir)
		//..............................contabilizar DEBITO Direto
		Grava_Work({LctoDir[nX,01],;
						pData,;
						'Adquirido NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' de '+CLIENTE->CL_RAZAO,;
						DEB * LctoDir[nX,02] - LctoDir[nX,05] - LctoDir[nX,03],;
						'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
						})
		//..............................contabilizar DEBITO Direto / Frete
		Grava_Work({LctoDir[nX,01],;
						pData,;
						'Frete NF '+alltrim(str(P3[8]))+'/'+alltrim(P3[9])+' de '+P3[7],;
						DEB * LctoDir[nX,07],;
						'ENT/'+str(P3[8],8)+':'+P3[9];
						})
	
		//..............................contabilizar ICMS NF (direto)
		Grava_Work({LctoDir[nX,8],;
						pData,;
						'NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+' de '+CLIENTE->CL_RAZAO,;
						DEB * LctoDir[nX,03],;
						'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
						})
	next
end

for nX:=1 to len(aPis)
	//..............................PIS
	Grava_Work({aPis[nX,1],;
					pData,;
					'NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+if(ENTCAB->EC_FRDOC>0,' e Frete','')+' de '+CLIENTE->CL_RAZAO,;
					DEB * aPis[nX,02],;
					'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
					})
next
for nX:=1 to len(aCofins)
	//..............................COFINS
	Grava_Work({aCofins[nX,1],;
					pData,;
					'NF '+alltrim(str(ENTCAB->EC_DOCTO))+'/'+alltrim(ENTCAB->EC_SERIE)+if(ENTCAB->EC_FRDOC>0,' e Frete','')+' de '+CLIENTE->CL_RAZAO,;
					DEB * aCofins[nX,02],;
					'ENT/'+str(ENTCAB->EC_DOCTO,8)+':'+ENTCAB->EC_SERIE;
					})
next
return NIL

*-----------------------------------------------------------------------------*
 static function Entr_Frete(P1)
*-----------------------------------------------------------------------------*
local RegFrete :=ENTCAB->(RecNo())
local RegFornec:=CLIENTE->(RecNo())
local Det      :={0,0,0,0,0,0,'',0,''}
ORDEM DOCSER
DbGoTop()
if dbseek(P1)
	if !ENTCAB->EC_FLCTB
		if ENTCAB->(reclock())	// Nao contabilizado  e TEM FRETE
			CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
			Det     :={ RegFrete,; //...................1-Nr Reg Anterior
							ENTCAB->EC_TOTAL,;//............2-Vlr Total do Frete
							ENTCAB->EC_ICMSV,;//............3-Vlr ICMS do Frete
							ENTCAB->EC_CODFO,;//............4-Cod Fornecedor Frete
							ENTCAB->EC_CODBC,;//............5-Cod Banco Lancamento
							ENTCAB->EC_FATUR,;//............6-Nr Parcelas
							CLIENTE->CL_RAZAO,;//...........7-Nome do Fornecedor
							ENTCAB->EC_DOCTO,;//............8-Codigo do Documento
							ENTCAB->EC_SERIE}//.............9-Serie da NF
			replace ENTCAB->EC_FLCTB with .T.
		else
		end
	else
	end
end
CLIENTE->(DbGoTo(RegFornec))
ORDEM DTEDOC
DbGoTo(RegFrete)
return DET

*----------------------------------------------------------------
  static function addPisCofins(pCodCof,pVPis,pVCof)
*----------------------------------------------------------------
//alert(' CTBPIMEN(1) - TEM COD PIS/COFINS :'+pCodCof+' VLR PIS:'+STR(pVPis,10,2)+'VLR COFINS:'+STR(pVCof,10,2))
if !empty(pCodCof).and.str(pVPis+pVCof,15,2)>str(0,15,2).and.FISACOF->(dbseek(pCodCof+CLIENTE->CL_TIPOFJ))
//	alert(' CTBPIMEN(2) - TEM COD PIS/COFINS + VALORES + TEM O CADASTRO FISACOF')
	//---------------------------------------------------PIS
	lFlag:=.F.
	for nX:=1 to len(aPis)
		if aPis[nX][1]==FISACOF->CO_CCTB1
			aPis[nX][2]+=pVPis
			nX         :=100
			lFlag      :=.T.
		end
	next
	if !lFlag
		aadd(aPis,{FISACOF->CO_CCTB1,pVPis})
	end
	//----------------------------------------------------COFINS
	lFlag:=.F.
	for nX:=1 to len(aCofins)
		if aCofins[nX][1]==FISACOF->CO_CCTB2
			aCofins[nX][2]+=pVCof
			nX            :=100
			lFlag         :=.T.
		end
	next
	if !lFlag
		aadd(aCofins,{FISACOF->CO_CCTB2,pVCof})
	end
end

return NIL
*----------------------------------------------------------------------EOF------------------------
