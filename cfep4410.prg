//-----------------------------------------------------------------------------*
  static aVariav := {{}, 0,'T',.F., 0,'',.T.,0,  0,'','','',.T.}
//....................1..2..3...4...5..6..7..8...9.10.11,12,13, 14,15
//-----------------------------------------------------------------------------*
#xtranslate aLinDet		=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate cTipoDev		=> aVariav\[  3 \]
#xtranslate lFlag			=> aVariav\[  4 \]
#xtranslate nOpc			=> aVariav\[  5 \]
#xtranslate cCor			=> aVariav\[  6 \]
#xtranslate lContinua	=> aVariav\[  7 \]
#xtranslate nVlrTotAd	=> aVariav\[  8 \]
#xtranslate nCodProd		=> aVariav\[  9 \]
#xtranslate dDtELeite	=> aVariav\[ 10 \]
#xtranslate dDtVLeite	=> aVariav\[ 11 \]
#xtranslate NrKeyNFE		=> aVariav\[ 12 \]
#xtranslate lRT			=> aVariav\[ 13 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'
*-----------------------------------------------------------------------------*
 function CFEP4410()	//	Movimentacoes do Estoque ENTRADAS							*
*-----------------------------------------------------------------------------*
if !abre({	'C->PARAMETRO',;
				'C->PARAMCTB',;
				'C->TABICMS',;
				'R->CODTR',;
				'C->DIARIO',;
				'C->ENTCAB',;
				'C->ENTDET',;
				'R->PEDCAB',; // Pesquisar NR.NF Devolução
				'R->PEDDET',; // Pesquisar ITENS Devolução
				'C->HISFOR',;
				'C->CTRNF',;
				'C->XOBS',;
				'C->OBS',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CAIXACG',;
				'R->NCM',;
          	'C->PROD',;
          	'R->FISACOF',;
          	'C->PROFOR',;
          	'C->DPFOR',;
				'C->BANCO',;
				'C->GRUPOS',;
				'R->CTACTB',;
				'C->MOVEST',;
				'C->PARALINH',;
				'C->ALIQUOTAS',;
				'C->UNIDADE',;
				'C->UNIDFAT',;
				'C->CTADET',;
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'C->NATOP'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
select('PROD')
ORDEM CODIGO
select('MOVEST')
ORDEM DTPROA

set relation to str(MOVEST->ME_CODPR,L_P) into PROD

select('ENTCAB')
ORDEM DTEDOC // Doc+Serie+Forn

set relation to str(EC_CODFO,5) into CLIENTE
DbGoTop()

if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
	pb_dbedit1('CFEP441','IncluiPesqu.ExcluiDevolv')  // TELA
else
	pb_dbedit1('CFEP441','IncluiPesqu.ExcluiDevolvNFLeit')  // TELA
end

set key K_ALT_X   to AjusteLeite2802()

dbedit(06,01,maxrow()-3,maxcol()-1,;
		{'EC_DTENT','EC_DOCTO','EC_TPDOC','EC_SERIE','pb_zer(EC_CODFO,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)','EC_CODOP','EC_CODTR','EC_TOTAL',  'EC_DESC', 'EC_IPI',    'EC_ICMSB','EC_ICMSP','EC_ICMSV'},;
		 'PB_DBEDIT2'                                                                                                                                                                                   ,;
		{ masc(08),   masc(09),      mUUU,      mUUU,                                                  mUUU,      mNAT,      mUUU,  masc(02),   masc(02), masc(02),      masc(02),  masc(20),  masc(02)},;
		{'Entrada', 'Docto',        'TPD',   'Serie',                                          'Fornecedor',  'Nat.OP',   'ClFis','Vlr Total','Vlr Desc','Vlr IPI','Vlr BaseICMS',  '% ICMS','Vlr ICMS'})

set key K_ALT_X to
set relation to
dbskip(0)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4411() // Rotina de Inclusäo
*-----------------------------------------------------------------------------*
private I_TRANS:=CFEPTRANL() // Inicializar Informações de Transporte Zerada
private aAdtos :={}
private VM_NSU :=0
SetKeyNFE() // colocar Zeros na NF-E para recuperar posteriormente ou receber zeros.

scroll(6,1,21,78,0)
setcursor(1)
select ('MOVEST')
**---------------------------------------------------------------Dados da NF-Cabec
	DADOC:={ PARAMETRO->PA_DATA,;	// 1 Data
				0,;						//	2-VM_DOCNF......= 2 DOC1
				0,;						//	3-Nat Oper NF...= 3 NAT
				0,;						//	4-VLR NF........= 4 VNF
				0,;						//	5-Vlr IPI.......= 5
				0,;						//	6-Vlr Funrural..= 6
				0,;						//	7-Vlr ICMS......= 7
				0,;						//	8-VLR DESC......= 8
				{||DADOC[NVNF]-DADOC[NDES]-DADOC[NVIPI]},;	//	VLR LIQNF= 9
				0,;						//	10-Parcelam.....=10 (0= a vista)
				0,;						//	11-Banco........=11
				0,;						//	12-Docto Parc...=12
				0,;						//	13-Fornecedor...=13
				0,;						//	14-%ICMS........=14
				'NF ',;					//	15-TP DOCTO.....=15
				'   ',;					//	16-Serie........=16
				0.00,;					//	17-Base ICMS....=17
				0.00,;					//	18-Vlr Acessorio=18 (soma outros valores Aces. Frete,Seguro,Outros Desp, ICMS ST Vlr)
				0,;						//	19-Código Caixa quando a Vista
				PARAMETRO->PA_DATA,;	// 20-Data Paramentros
				'N',;						// 21-Adiantamento Fornecedor?
				Space(25),;				// 22-Observação para Livros Fiscais
				Padr('0',44,'0'),;	// 23-Chave NFE
				0.00,;					//	24-Valor Acessorio-Frete
				0.00,;					//	25-Valor Acessorio-Seguro
				0.00,;					//	26-Valor Acessorio-Outras Despesas
				0.00,;					//	27-Base ICMS ST
				0.00,;					//	28-Valor ICMS ST
				{||DADOC[NVNF]-DADOC[NDES]+DADOC[NVIPI]+DADOC[NACFRETE]+DADOC[NACSEGUR]+DADOC[NACOUTRA]+DADOC[NICMSTVL]},;	//	29-Valor Contábil=//NVCTBIL
				Padr('0',44,'0');		//	30-Chave NF-e Devolução
				}
				
**-------------------------------------------------------DADOS DO FRETE-CABEC
	DADOF:={ PARAMETRO->PA_DATA,;					//	FDT = 1
				0,;										//	FNF = 2
				0,;										//	FNAT= 3
				0,;										//	FVNF= 4
				0,;										//	FVICM=5
				0,;										//	FDES= 6
				{||DADOF[FVNF]-DADOF[FVICMS]},;	//	FLIQ= 7
				{||pb_divzero(eval(DADOF[FLIQ]),eval(DADOC[NLIQ]))},;// % FRETE..= FPERC 8
				0,;										// 09-PARCELAMENTO (0=a vista)
				0,;										// 10-CODIGO DO BANCO
				0,;										// 11-DOCUMENTO DO PARCELAMENTO
				0,;										// 12-COD FORNECEDOR
				0,;										// 13-% ICMS FRETE
				0,;										// 14-
				'CT ',;									// 15-TIPO DE DOCUMENTO CT
				'   ',;									// 16-Serie Documento
				0,;										//	17-Base Icms
				0,;										//	18-NADA
				0,;										//	19-Codigo Caixa quando a vista
				PARAMETRO->PA_DATA,;					// 20-Data Paramentros
				'N',;										// 21-Adto Fornecedor
				Space(25),;								// 22-Observação para Livros Fiscais
				Padr('0',44,'0'),;					// 23-Chave CTe
				0.00,;									//	24-Valor Acessorio-Frete
				0.00,;									//	25-Valor Acessorio-Seguro
				0.00,;									//	26-Valor Acessorio-Outras Despesas
				0.00,;									//	27-Base ICMS ST
				0.00,;									//	28-Valor ICMS ST
				0.00,;									//	29-Valor Contábil
				Padr('0',44,'0');						//	30-Chave NF-e Devolução
				}
				
	DADOPC:={}	// parcelas do cabecalho
	DADOPF:={}	// parcelas do Frete
	
	PRODUTOS:=DetProdEnt('I') // INICIALIZAR
	
	VM_FAS  :={'Cabecalho',   'Frete    ',   'Produtos ',   'Grava/Sai'}
	VM_BLO  :={{||CFEP441C()},{||CFEP441F()},{||CFEP441P()},{||CFEP441G()}}
	VM_POS  :={  .T.,           .F.,           .F.,           .F. }
	lFechado:={  .F.,           .F.,           .F.,           .F. }
	//............1..............2..............3..............4.
	cCOR:={'B/W+*,W/B,,,W+/B'}
	nOPC:=1
//	keyboard chr(13)
	salvacor(SALVA)
	while .T.
		pb_box(05,00,10,14,'B/W+*','Menu NF Entrada')
		setcolor(cCOR[1])
		for nX:=1 to 4
			@05+nX,02 prompt VM_FAS[nX]+' '+if(VM_POS[nX],CHR(251),CHR(247))+' ' ;
			          message padR('Selecione uma Opcao ou <ESC> para Sair',maxcol())
		next
		menu to nOPC
		salvacor(RESTAURA)
		if nOPC>=1.and.nOPC<=3
			if VM_POS[nOPC]
				setcolor(VM_CORPAD)
				lFechado[nOPC]:=eval(VM_BLO[nOPC])
				if nOPC>1
					lFechado[04]:=FN_CHECAR() // Pode Sair ?
					VM_POS[04]  :=lFechado[04]
				end
				nOPC++
			else
				alert('Esta opcao e invalida;So opcoes com o simbolo ['+CHR(251)+'] estao habilitadas')
			end
		elseif nOPC==4
			if lFechado[04]
				eval(VM_BLO[nOPC])
				alert('Nota Fiscal Gravada')
				exit
			else
				alert('A Saida e Gravacao da NF so pode ser feita de pois de ser fechada;A opcao ainda nao esta Habilitada')
			end
		else
			if pb_sn('Abandonar Digitacao desta Nota Fiscal ?')
				exit
			end
		end
	end
dbunlockall()
select('ENTCAB')
return NIL

*-----------------------------------------------------------------------------
static function CFEP441C() // Rotina de cabecalho da Nota Fiscal
*-----------------------------------------------------------------------------
local PICMS			:=0
local FORNEC		:=DADOC[NFOR ]
local NATOP			:=DADOC[NNAT ]
local TIPODOC		:=DADOC[TPDOC]
local TSERIE		:=DADOC[SERIE]

private VM_DEVNNF	:=0
private VM_DEVSER	:='NFE'

lContinua:=.F.

	salvacor(SALVA)
	pb_box(6,0,22,79,,VM_FAS[1])
	@07,01 say 'Dt Emissao NF.:'					get DADOC[NDT ]		pict masc(07)	valid DADOC[NDT ]<=PARAMETRO->PA_DATA
	@07,32 say 'Dt Entrada:'						get DADOC[NDT1]		pict masc(07)	valid DADOC[NDT1]<=PARAMETRO->PA_DATA.and.DADOC[NDT1]>=DADOC[NDT ].and.year(DADOC[NDT1])==PARAMCTB->PA_ANO.and.ValidaMesContabilFechado(DADOC[NDT1],'NF DE ENTRADA') when pb_msg('Verifique se o Mes Contabil ja pode estar fechado-'+pb_zer(MESCTBFECHADO,2)+'/'+Str(PARAMCTB->PA_ANO,4))
	@08,01 say 'Nr.Documento..:'					get DADOC[NNF]			pict mI8			valid DADOC[NNF]>0
	@08,32 say 'CFOP......:'						get NATOP				pict mNAT		valid fn_codigo(@NATOP,{'NATOP',{||NATOP->(dbseek(str(NATOP,7)))},{||CFEPNATT(.T.)},{1,2,3,9,10}}).and.NATOP->NO_TIPO=='E'
	@09,01 say 'Tipo Docto....:'					get TIPODOC				pict mUUU		valid fn_codar (@TIPODOC,'TP_DOCTO.ARR')
	@09,55 say 'Serie:'								get TSERIE				pict mUUU		valid TSERIE==SCOLD.or.fn_codigo(@TSERIE,{'CTRNF',{||CTRNF->(dbseek(TSERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
	@10,01 say 'Emitente......:'					get FORNEC				pict masc(04)	valid fn_codigo(@FORNEC,{'CLIENTE',{||CLIENTE->(dbseek(str(FORNEC,5)))},{||CFEP3100T(.T.)},{2,1,8}}).and.LibForn().and.CONFNATOP(CLIENTE->CL_UF,'FORNECEDOR').and.fn_icms(@PICMS,'E').and.pb_ifcod2(str(DADOC[NNF],8)+TSERIE+str(FORNEC,5),'ENTCAB',.F.,1).and.len(aAdtos:=fn_aAdtos(FORNEC,'F'))>=0
	@10,68 say 'Bx Adto:'							get DADOC[NADTO]		pict mUUU		valid DADOC[NADTO]$'SN'  when pb_msg('Baixar Adiantamento?    <S>im   <N>ao').and.len(aAdtos)>0.and.(nVlrTotAd:=0)>=0.and.len(Aeval(aAdtos,{|DET|nVlrTotAd+=DET[4]*DET[7]}))>=0
	@11,01 say 'Tot.Merc.NF...:'					get DADOC[NVNF]		pict masc(05)	valid if(DADOC[NADTO]=='N',DADOC[NVNF] > 0,DADOC[NVNF] <= nVlrTotAd) .and. ;
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5))) ;
															when pb_msg('Valor das Mercadorias da NF'+if(DADOC[NADTO]=='S',' Maximo Adto:'+STR(nVlrTotAd,10,2),''))
	@11,32 say 'Vlr Desconto:'						get DADOC[NDES]		pict mD82		valid DADOC[NDES] >=0 .and. DADOC[NDES]<DADOC[NVNF].and. ;
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5))) ;
																						color 'GR+/G,R+/W'
	@12,01 say 'Vlr IPI.......:'					get DADOC[NVIPI]		pict masc(05)	valid DADOC[NVIPI] >=0.and.DADOC[NVIPI]<DADOC[NVNF].and.; //when DADOC[NVFUNR]=0.00
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5)))
	if PARAMETRO->PA_FUNRUR>0
		@12,32 say 'Vlr Funrural:'					get DADOC[NVFUNR]		pict mD82		valid DADOC[NVFUNR]>=0.and.DADOC[NVFUNR]<DADOC[NVNF]  color 'GR+/G,R+/W' when right(str(NATOP,7),1)=='9'.and.(DADOC[NVFUNR]:=round((DADOC[NVNF]-DADOC[NDES])*PARAMETRO->PA_FUNRUR/100,2))>=0
	end
//	@13,01 say '% I.C.M.S.....:'					get DADOC[NPICMS]		pict masc(14) valid DADOC[NPICMS]>=0											when eval({||DADOC[NPICMS]:=PICMS})   >=0.00
//	@13,32 say 'Base ICMS:'							get DADOC[BICMS]		pict masc(05) valid DADOC[BICMS] >=0											when (DADOC[BICMS]:=eval(DADOC[NLIQ]))>=0.00
	@13,01 say 'Vlr ICMS......:'					get DADOC[NVICMS]		pict masc(05) valid DADOC[NVICMS]>=0
	
	pb_box(13,31,19,78,,'Vlr Acessorios')
//	@13,32 say 'Vlr Acessorio:'					get DADOC[VACES]  pict masc(05) valid DADOC[VACES]>=0    when pb_msg('Valor de Frete/Outro Valor destacado na NF')
	@14,32 say 'Frete.......:'						get DADOC[NACFRETE]	pict masc(05)	valid DADOC[NACFRETE]>=0 .and.;
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5)))
	@15,32 say 'Seguro......:'						get DADOC[NACSEGUR]	pict masc(05)	valid DADOC[NACSEGUR]>=0 .and.;  
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5)))
	@16,32 say 'Outras......:'						get DADOC[NACOUTRA]	pict masc(05)	valid DADOC[NACOUTRA]>=0.and.;
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5)))
	@17,32 say 'Base ICMS ST:'						get DADOC[NICMSTBA]	pict mD82		valid DADOC[NICMSTBA]>=0
	@18,32 say 'Vlr ICMS ST.:'						get DADOC[NICMSTVL]	pict mD82		valid DADOC[NICMSTVL]>=0.and.;
																													Mostra(19,01,'Total N.F.....:'+transform(eval(DADOC[NVCTBIL]),masc(5)))
	pb_box(14,01,18,30,,'NFe Devolucao')
	@15,02 say 'NF-e.Origem..:'					get VM_DEVNNF			pict mI6			valid VM_DEVNNF>0 ;
																											when 	NATOP->NO_DEVOL=='S';
																											color 'GR+/G,N/W,,,W+/G'
	@16,02 say 'Serie........:'					get VM_DEVSER			pict mUUU		valid pb_ifcod2(str(VM_DEVNNF,6)+VM_DEVSER,'PEDCAB',.T.,5)	.and. ;
																													pb_msg('Chave NF-e Devolucao:'+PEDCAB->PC_NFEKEY,5)	.and. ;
																													Mostra(17,02,'Data Emissao.:'+DtoC(PEDCAB->PC_DTEMI));
																											when 	NATOP->NO_DEVOL=='S';
																											color 'GR+/G,N/W,,,W+/G'
	@20,01 say 'OBS Livro Fisc:'					get DADOC[OBSLIV]		pict mUUU		when (DADOC[NFEKEY]:=IniNFeKey(FORNEC, DADOC[NDT ], TSERIE, DADOC[NNF],TIPODOC))>''
	@21,01 say 'Ch. Eletronica:'					get DADOC[NFEKEY] 	pict mCHNFE		valid ChkNFeKey(DADOC[NFEKEY]);
																											when pb_msg('Codigo NFE = UF+AAMM+CNPJ/CPF+55+SER+NR.NFE+NR.ESP+DV').and.right(str(NATOP,8),1) # '9'.and.TIPODOC$"NF #CT #" // Não Pedir Chave se NF for Impressao
	//.................................................................12 3456 78901234567890 12 345 678901234 567890123 4
	read
	salvacor(RESTAURA)
	if lastkey()#K_ESC
		VM_POS[2]    :=.T.	// Habilita Frete
		VM_POS[3]    :=.T.	// Habilita Produtos
		DADOC[BICMS] :=DADOC[NVNF] // Base ICMS
		DADOC[NPICMS]:=17 // Base ICMS
		DADOC[VACES] :=DADOC[NACFRETE]+DADOC[NACSEGUR]+DADOC[NACOUTRA]+DADOC[NICMSTVL] // Soma Valores Acessórios 
		DADOC[NFOR]  :=FORNEC
		DADOC[NNAT]  :=NATOP
		DADOC[TPDOC] :=TIPODOC
		DADOC[SERIE] :=TSERIE
		NATOP->(dbseek(str(DADOC[NNAT],7)))
		if NATOP->NO_DEVOL=='S'// Natureza é Devolução - Gravar chave da NFE Origem
			DADOC[NFEKEYDEV]:=PEDCAB->PC_NFEKEY // Chave NF-e
			SetProdDevol('S',str(VM_DEVNNF,6)+VM_DEVSER) // S=Saidas + Chave Busca Itens --> CFEPDEVO.PRG
		else
			SetProdDevol('X','') // X=Zerar Itens da NF --> CFEPDEVO.PRG
		end
		if NATOP->NO_FLTRAN=='S'
			lContinua :=.T.
		else
			lContinua :=CFEP441PC() // Parcelamento NF
		end
		
		CLIENTE->(dbseek(str(FORNEC,5)))
		I_TRANS[11]	:='Diversos'
		I_TRANS[12]	:='Diversos'
		I_TRANS[13]	:=0	// Peso Bruto
		I_TRANS[14]	:=0	// Peso Liquido
		I_TRANS:=CFEPTRANE(I_TRANS,.T.,'E') // Digitar Dados do transportador
		VM_POS[4]	:=.F.	// DesHabilita Parcelamento da NF
	else // Sair
		VM_POS[2]	:=.F.	// DesHabilita Frete
		VM_POS[3]	:=.F.	// DesHabilita Produtos
		VM_POS[4]	:=.F.	// DesHabilita Parcelamento da NF
	end
return NIL

*------------------------------------------------------------------------------
 function IniNFeKey(pFornec,pDTE,pSerie,pNRNF,pTipoDoc) 
*-------------------------------------------------------------------------------
if pTipoDoc$"NF #CT #"
	CLIENTE->(dbseek(str(pFornec,5)))
	NrKeyNFE:=Left(pb_zer(CLIENTE->CL_CDIBGE,7),2)
	NrKeyNFE+=Right(pb_zer(year(pDTE),4),2)
	NrKeyNFE+=pb_zer(month(pDTE),2)
	NrKeyNFE+=pb_zer(val(SONUMEROS(CLIENTE->CL_CGC)),14)
	if pTipoDoc=='CT ' // se for frete = 57
		NrKeyNFE+='57'
	else // se for outra NF-E = 55
		NrKeyNFE+='55'
	end
	NrKeyNFE+=pb_zer(max(val(SONUMEROS(pSerie)),1),3)
	NrKeyNFE+=pb_zer(pNRNF,9)
	NrKeyNFE+=pb_zer(    0,9)
	NrKeyNFE+='0' // Dígito
else
	NrKeyNFE:=Padr('0',44,'0')
end
return NrKeyNFE

*------------------------------------------------------------------------------
 function ChkNFeKey(pNFeKey) 
*-------------------------------------------------------------------------------
lRT:=.T.
NrKeyNFE:=Left(pNFeKey,43)+CalcDg(Left(pNFeKey,43)) // Retira o Dígito
if NrKeyNFE#pNFeKey
	BEEPERRO()
	pb_msg('Digito da chave NAO confere - rever codigo digitado')
	lRT:=.F.
end
return lRT

*------------------------------------------------------------------------------
function CFEP441F() // Frete--Frete--Frete--Frete--Frete--Frete--Frete--Frete--
*-------------------------------------------------------------------------------
local PICMS      :=0,;
		FORNEC     :=DADOF[FFOR],;
		NATOP      :=DADOC[NNAT],;
		TIPODOC    :=DADOF[TPDOC],;
		TSERIE     :=DADOF[SERIE]
		DADOF[FDT1]:=DADOC[NDT1]
	salvacor()
	pb_box(7,10,17,79,,VM_FAS[2])
	@08,12 say padr('Dt Emissao',14,'.')		get DADOF[FDT ]   pict mDT			valid DADOF[FDT ]<=PARAMETRO->PA_DATA
	@08,45 say padr('Dt Entrada',14,'.')		get DADOF[FDT1]   pict mDT			valid DADOF[FDT1]<=PARAMETRO->PA_DATA when .F.
	@09,12 say padr('Documento',14,'.')			get DADOF[FNF]    pict mI8			valid DADOF[FNF] > 0
	@09,45 say padr('Nat.Operacao',14,'.')		get NATOP         pict mNAT		valid fn_codigo(@NATOP,{'NATOP',{||NATOP->(dbseek(str(NATOP,7)))},{||CFEPNATT(.T.)},{1,2,3}}).and.NATOP->NO_TIPO=='E'  when DADOF[FNF]>0
	@10,12 say padr('Tipo Docto',14,'.')		get TIPODOC       pict mUUU		valid fn_codar(@TIPODOC,'TP_DOCTO.ARR') 					when .F.
	@10,55 say 'Serie :'								get TSERIE        pict mUUU		valid TSERIE==SCOLD.or.fn_codigo(@TSERIE,{'CTRNF',{||CTRNF->(dbseek(TSERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
	@11,12 say padr('Emitente',14,'.')			get FORNEC        pict masc(04)	valid fn_codigo(@FORNEC,{'CLIENTE',{||CLIENTE->(dbseek(str(FORNEC,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.(CONFNATOP(CLIENTE->CL_UF,'FORNECEDOR').OR..T.).and.fn_icms(@PICMS,'E').and.pb_ifcod2(str(DADOF[FNF],8)+TSERIE+str(FORNEC,5),'ENTCAB',.F.,1) when DADOF[FNF]>0
	@12,12 say padr('Valor Frete',14,'.')		get DADOF[FVNF]   pict masc(05)	valid DADOF[FVNF]	>=0											when 	DADOF[FNF]>0
	@13,12 say padr('% I.C.M.S',14,'.')			get DADOF[FPICMS] pict masc(14)	valid DADOF[FPICMS]>=0											when 	DADOF[FNF]>0.and.eval({||DADOF[FPICMS]:=PICMS})>=0
	@14,12 say padr('Base ICMS',14,'.')			get DADOF[BICMS]  pict masc(05)	valid DADOF[BICMS]	>=0										when 	(DADOF[BICMS]:=DADOF[FVNF])>=0.00
	@15,12 say padr('Vlr ICMS',14,'.')			get DADOF[FVICMS] pict masc(05)	valid DADOF[FVICMS]>=0											when 	DADOF[FNF]>0.and.eval({||DADOF[FVICMS]:=round(DADOF[BICMS]*DADOF[FPICMS]/100,2)})>=0.and.;
																																														(DADOF[NFEKEY]:=IniNFeKey(FORNEC, DADOF[FDT ], TSERIE, DADOF[FNF],TIPODOC))>''
	@16,12 say padr('Chave Eletr.:',14,'.')	get DADOF[NFEKEY] pict '@R 99.9999.99999999999999.99.999.999999999.999999999.9';
																										valid ChkNFeKey(DADOF[NFEKEY]);
																										when 	pb_msg('Codigo CTe = UF+AAMM+CNPJ/CPF+55+SER+NR.NFE+NR.ESP+DV').and.;
																												right(str(NATOP,8),1) # '9'
	read
	if lastkey()#K_ESC
		DADOF[FFOR]     :=FORNEC
		DADOF[FNAT]     :=NATOP
		DADOF[TPDOC]    :=TIPODOC
		DADOF[SERIE]    :=TSERIE
		if DADOF[FNF]==0
			DADOF[FVNF]  :=0
			DADOF[FFOR]  :=0
			DADOF[FPICMS]:=0
			DADOF[FVICMS]:=0
			DADOF[BICMS] :=0
			DADOF[FNAT]  :=0
			VM_POS[5]    :=.F.		//........... Desabilita Frete Parcelado
		else
			CFEP441PF() // PARCELAMENTO DE FRETE
		end
	end
return lContinua

*-----------------------------------------------------------------------------*
 static function FN_CHECAR()
*-----------------------------------------------------------------------------*
lFlag:=.F.
NATOP->(dbseek(str(DADOC[NNAT],7))) // BUSCA NATUREZA OPERACAO
if DADOC[NVNF] > 0
//	if str(PRODUTOS[len(PRODUTOS),5]-(DADOC[NVNF]-DADOC[NVIPI]),15,2)== str(0,15,2) 2014-11-27
	if str(PRODUTOS[len(PRODUTOS),5]-(DADOC[NVNF]),15,2)== str(0,15,2)
		if str(PRODUTOS[len(PRODUTOS),8]-DADOC[NVIPI],15,2)           == str(0,15,2)
			if str(PRODUTOS[len(PRODUTOS),10]-DADOC[NVICMS],15,2)      == str(0,15,2)
				if if(PARAMETRO->PA_CONTAB==USOMODULO,NATOP->NO_FLTRAN=='S'.or.DADOC[NBAN] > 0,.T.)
					if if(PARAMETRO->PA_CONTAB==USOMODULO,NATOP->NO_FLTRAN=='S'.or.DADOF[FVNF]==0.or.DADOF[FBAN]>0,.T.)
						lFlag:=.T.
					else
						pb_msg('1-Codigo do Banco/Caixa nao definido para Frete.',3,.T.)
					end
				else
					pb_msg('2-Codigo do Banco/Caixa nao definido para Nota Fiscal.',3,.T.)
				end
			else
				alert('4410-Valor do ICMS nao Fechado;'+;
						';Informado NF:'+str(DADOC[NVICMS]             ,15,2)+;
						';Calc.Produto:'+str(PRODUTOS[len(PRODUTOS),10],15,2))
			end
		else
			alert('4410-Valor de IPI nao Fechado;'+;
					';Informado NF:'+str(DADOC[NVIPI]             ,15,2)+;
					';Calc.Produto:'+str(PRODUTOS[len(PRODUTOS),8],15,2))
		end
	else
		if str(PRODUTOS[len(PRODUTOS),5],15,2) > str(0,15,2)
			alert('4410-Valor NF nao Fechado com Dig.Produtos;'+;
					';(+)Informado NF.:'+str(DADOC[NVNF]              ,15,2)+;
					';(-)Informado IPI:'+str(DADOC[NVIPI]             ,15,2)+;
					';(=)Calc.Produto.:'+str(PRODUTOS[len(PRODUTOS),5],15,2))
		end
	end
else
	pb_msg('Valor de COMPRA nao Informado = Zero.',3,.T.)
end
return(lFlag)

*-------------------------------------------------
	function DetProdEnt(pTp,pChave)
*-------------------------------------------------
aLinDet:={}
if pTp='I'
	for nX:=1 to 199
	*..................1......2..........3.....4........5........6....7......8.....9....10....11....12.......13........14........15...16..17....18....19....20.....21.....22....23......24.....25........26......27.............28......29.............30......31.......32........33.....34...35....
	*.................SQ,    Pr, Descricao,Quant,VlrCompr,VlrVenda,%IPI,VlrIPI,%ICMS,VICMS,Frete, Desc, Unidade, Cod.Trib,IcmsFrete,Aces,ctb,NATOP,ICMSB,INSEN,Outros,CodCof,VlPis,VlCofis,NrAdto, ClFisIPI,CContab,Transf FVlrPis,FVlrCof,CC-Transf-Cred,QtdEntr,UnidComp,FatorConv.PesoPr...
		aadd(aLinDet,{ nX,     0, space(30),    0,       0,       0,   0,     0,    0,    0,    0,    0, '     ',     '   ',    0.00,0.00,  0,    0, 0.00, 0.00,  0.00, '   ',    0,      0,     0,space(10),      0,             0,      0,             0,  0.000, '     ', 1.000000,  0.00,0.00})
		*...............1......2..........3.....4........5........6....7......8.....9....10....11....12.......13........14........15...16..17....18....19....20.....21.....22....23......24.....25........26......27.............28......29.............30......31.......32.......33......34...35
	next
		aadd(aLinDet,{200, 99999,'Total...',    0,       0,       0,   0,     0,    0,    0,    0,    0, '     ',     '   ',     0.00,0.00,  0,      0, 0.00, 0.00,  0.00, '   ',    0,      0,     0,space(10),      0,             0,      0,             0,  0.000, '     ',1.000000,0.00,0.00})
elseif pTp='R'

end
return aLinDet

*-------------------------------------------------
	static function AjusteLeite2802()
*-------------------------------------------------
if pb_sn('Ajuste valores NF Leite - a Pagar')
	pb_box(18,0)
	dDtELeite:=ctod('28/02/2014')
	dDtVLeite:=ctod('31/03/2014')
	@19,2 say 'Informe a Data Emissão das NF geradas do Leite...:' get dDtELeite pict mDT
	@20,2 say 'Informe a Data Vencimento das NF geradas do Leite:' get dDtVLeite pict mDT
	read
	if lastkey()#K_ESC
		nCodProd:=30910
		select('ENTCAB')
		ordem DTEDOC // Data+Doc
		set relation to
		dbseek(dtos(dDtELeite),.F.)
		while !eof().and.dtos(ENTCAB->EC_DTENT)==dtos(dDtELeite)
			pb_msg('Avaliando e gerando registros na NrNF:'+str(EC_DOCTO,8))
			if EC_CODOP==1102009 // só para este CFOP
				select('ENTDET')
								
				dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5))
				while !eof().and.	str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5)==;
										str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)
					if ENTDET->ED_CODPR==nCodProd // é NF de Leite
						PROD->(dbseek(str(nCodProd,L_P)))
						CLIENTE->(dbseek(ENTCAB->EC_CODFO,5))
						select('PROD')
						if RecLock()
							if PROD->PR_MODO<>'D'
								if PROD->PR_CTB#99 .and. PROD->PR_CTB#97 // Com Contole de Estoque
									replace	PROD->PR_QTATU with PROD->PR_QTATU+ENTDET->ED_QTDE,;
												PROD->PR_VLATU with PROD->PR_VLATU+ENTDET->ED_VALOR-ENTCAB->EC_FUNRU
									GravMovEst({nCodProd,;				// 1-Cod.Produto
													ENTCAB->EC_DTENT,;	// 2-Data Entrada
													ENTCAB->EC_DOCTO,;	// 3-NR.NF-e
													ENTDET->ED_QTDE,;		// 4-Qtdade
													ENTDET->ED_VALOR,; 	// 5-Medio Total-ICMS-IPI+FRETE+FUNRUR-ICMS.FRETE+ACESS-PIS-COFINS
													ENTDET->ED_VENDA,;	// 6-Vlr Venda
													'E',;						// 7-Cod Entrada (Tipo Movimento)
													ENTCAB->EC_SERIE,;	// 8-Serie
													ENTCAB->EC_CODFO})	// 9-Codigo Fornecedor
									DADOPC         :={}
									aadd(DADOPC,{	ENTCAB->EC_DOCTO*100,;
														dDtVLeite,; // Data de Vencimento
														ENTCAB->EC_TOTAL-ENTCAB->EC_FUNRU})

									select('DPFOR')
									SCOM:=0
									while !AddRec();end
									replace 	DP_DUPLI with DADOPC[1,1],;
												DP_CODFO with if(empty(CLIENTE->CL_MATRIZ),ENTCAB->EC_CODFO,CLIENTE->CL_MATRIZ),;
												DP_DTEMI with dDtELeite,;
												DP_CODBC with 10,;
												DP_DTVEN with DADOPC[1,2],;
												DP_VLRDP with DADOPC[1,3],;
												DP_MOEDA with 1,;
												DP_NRNF  with ENTCAB->EC_DOCTO,;
												DP_SERIE with ENTCAB->EC_SERIE,;
												DP_ALFA  with CLIENTE->CL_RAZAO
									dbrunlock(RecNo())
								end
							end
							dbrunlock(recno())
						end
					end
					select('ENTDET')
					skip
				end
				select('ENTCAB')
			end
			skip
		end
	end
	ALERT('Fim processamento')
	ORDEM DTEDOC // doc+serie+forn
	set relation	to str(EC_CODFO,5) into CLIENTE,;
						to str(EC_CODOP,7) into NATOP
end

keyboard chr(27)+chr(27)
return NIL
 
//-----------------------------------------------------------------------------
//-------------------------continua em CFEP4415
//-----------------------------------------------------------------------------
