//-----------------------------------------------------------------------------*
  static aVariav := {'S'}
//....................1..2..3...4...5..6..7..8...9.10.11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate cContinua		=> aVariav\[  1 \]
*-----------------------------------------------------------------------------*
 function CFEP5100()	//	Digitacao de vendas												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->PARAMETRO',;
			'C->DIARIO',;
			'C->CTRNF',;
			'C->GRUPOS',;
			'R->NCM',;
			'C->PROD',;
			'C->MOVEST',;
			'C->TABICMS',;
			'C->CLIENTE',;
			'C->CLIOBS',;
			'C->DPCLI',;
			'C->HISCLI',;
			'C->BANCO',;
			'C->VENDEDOR',;
			'C->OBS',;
			'C->CAIXACG',;
			'C->CAIXAMB',;
			'C->CONDPGTO',;
			'C->PEDPARC',;
			'C->XOBS',;
			'R->CODTR',;
			'R->ENTCAB',; // Buscar NFE-Devolução
			'R->ENTDET',; // Buscar NFE-Devolução - itens da NF
			'C->PEDCAB',;
			'C->PEDDET',;
			'C->PEDSVC',;
			'C->CTADET',;
			'C->CTACTB',;
			'R->LOTEPAR',;
			'C->PARALINH',;
			'C->FISACOF',;
			'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
			'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
			'C->NATOP'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
select('ENTCAB')
ordem FORDTE

select('PROD')
ordem CODIGO // Ordem Produtos
select('PEDCAB')
dbsetorder(2) // Pedido  Cabec
set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()

pb_dbedit1('CFEP510','IncluiAlteraExcluiLista TMP   Atuali')  // tela
dbedit(06,01,maxrow()-3,maxcol()-1,;
		{'PC_SERIE','PC_PEDID','pb_zer(PC_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,30)','PC_DTEMI', 'PC_CODOP','PC_NRNF','PC_TOTAL','if(PC_FLSVC,"Serv","Prod")','if(PC_FLADTO,"Sim","Nao")'},;
		'PB_DBEDIT2',;
		{ mUUU,           mI6 ,                                                  mXXX ,      mDT ,       mNAT,     mI6 ,     mD112,     mXXX,                        mXXX                  },;
		{'Ser',       'Pedido',                                              'Cliente','Dt Emiss',   'NatOpe',   'NrNF',   'Total',    'TpNF',                       'Adt'                 } )
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP5101()
*-----------------------------------------------------------------------------*
local X
local XLin
cContinua:=' '
private VM_CODOP :=5102000
private VM_OPC   :=0
private VM_CLI   :=0
private VM_TOT   :=0
private VM_ICMSPG:=0
private VM_PARCE :=0
private VM_VEND  :=0
private VM_RT    :=.T.
private VM_OBS   :=space(300)
private VM_OBSLIV:=space(024)
private VM_SVC   :=space(080)
private VM_DET   :={}
private VM_SERIE :=space(003)
private VM_CODFC :=space(010)
private VM_ULTPD :=0
private VM_NSU   :=0
//.....................................DEVOLUÇÃO
private VM_DEVNFE:=padr('0',44,'0') //.Nr Chave NFE
private VM_DEVNNF:=0 //................Nr NF
private VM_DEVSER:=space(003) //.......Serie
private VM_DEVDTE:=ctod('')//..........DT Emissão
//............................................................
private VM_NOMNF :=''
private VM_ENCFI :=0
private VM_ICMSS :={0,0,0} // Vlr Base, % Icms, Valor Icms
private VM_ICMS  :={} // %ICMS,BASE
private VM_LOTE  :=-1
private VM_TPTRAN:=0
private aAdtos   :={}
private VM_FLADTO:='N'
private VM_DESCG :=0

setcolor(VM_CORPAD)
pb_tela()
pb_lin4('Digitacao de Pedidos',ProcName())
scroll(6,1,21,78,0)
setcolor('W+/B,N/W,,,W+/B')
CODTR->(DbGoTop())

NATOP->(dbseek(str(VM_CODOP,7)))

*--------------------------------------------> Pegar padrao do Micro se Houver
VM_SERIE:=padr(RtVarAmb('CFE','SERIE:'),3)
VM_ULTPD:=fn_psnf('PED')
ORDEM GPEDIDO
while dbseek(str(VM_ULTPD,6))
	VM_ULTPD:=fn_psnf('PED')
end
ORDEM FPEDIDO
@06,01 say 'Pedido...: '+pb_zer(VM_ULTPD,6)
@07,01 say 'Cliente..:'		get VM_CLI    pict mI5		valid fn_codigo(@VM_CLI,  {'CLIENTE', {||CLIENTE-> (dbseek(str(VM_CLI,5)))},         {||CFEP3100T(.T.)},{2,1,8,7}}).and.fn_libcli().and.eval({||VM_VEND:=CLIENTE->CL_VENDED})>=0.and.len(aAdtos:=fn_aAdtos(VM_CLI,'C'))>=0
@08,01 say 'Vendedor.:  '	get VM_VEND   pict mI3		valid fn_codigo(@VM_VEND, {'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_VEND,3)))},        {||CFEP5610T(.T.)},{2,1}})																							when PARAMETRO->PA_VENDED==USOMODULO.and.((CLIENTE->CL_VENDED==0).or.('VEND'$RT_FUN_ESP().and.pb_msg('So altere se for venda com suporte')))
@06,20 say 'Serie:'			get VM_SERIE  pict mUUU		valid VM_SERIE==SCOLD.or.(fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}).and.CTRNF->NF_NRLIN>0) color 'R/W'
@06,45 say 'CFOP.....:'		get VM_CODOP  pict mNAT		valid fn_codigo(@VM_CODOP,{'NATOP',   {||NATOP->   (dbseek(str(VM_CODOP,7)))},       {||CFEPNATT (.T.)},{1,2,3}}).and.NATOP->NO_TIPO$'S'.and.ConfNatOp(CLIENTE->CL_UF,'CLIENTE')	when VM_SERIE#'ADT'
@07,65 say 'Lote :'			get VM_LOTE   pict mI4		valid CONFLOTCCNAT(VM_CLI,VM_LOTE)																																																when NATOP->NO_FLTRAN=='S'.and.pb_msg('Informe o numero do lote de transferencia')
@08,65 say 'TipoTransf:'	get VM_TPTRAN pict mI1		valid VM_TPTRAN==1.or.VM_TPTRAN==2																																																when NATOP->NO_FLTRAN=='S'.and.pb_msg('Opcoes:  <1>Transferencia Preco Custo  <2>Transferencia Preco Venda')
@09,65 say 'Baixa Adto:'	get VM_FLADTO pict mUUU		valid VM_FLADTO$'SN'																																																					when NATOP->NO_FLTRAN #'S'.and.len(aAdtos)>0.and.pb_msg('Baixar Adiantamento do Cliente ?    <S>im   <N>ao')
pb_box(10,01,14,64,'W+/B,N/W,,,W+/B','NFE Devolucao')
  @11,02 say 'Nr.NF....:'	get VM_DEVNNF pict mI8																											when NATOP->NO_DEVOL=='S' color 'GR+/B,N/W,,,W+/B'
  @11,25 say 'Serie:'		get VM_DEVSER pict mUUU		valid pb_ifcod2(str(VM_DEVNNF,8)+VM_DEVSER+str(VM_CLI,5),'ENTCAB',.T.,1)	when NATOP->NO_DEVOL=='S' color 'GR+/B,N/W,,,W+/B'
  @12,02 say 'Chave NFE:'	get VM_DEVNFE pict mCHNFE	valid .T.  																						when len((VM_DEVNFE:=ENTCAB->EC_NFEKEY))<0.and.		NATOP->NO_DEVOL=='S' color 'GR+/B,N/W,,,W+/B'
  @11,42 say 'Dt Entrada:' get VM_DEVDTE pict mDT		valid .T. 																						when len(dtoc(VM_DEVDTE:=ENTCAB->EC_DTEMI))<0.and.	NATOP->NO_DEVOL=='S' color 'GR+/B,N/W,,,W+/B'
  @13,02 say 'Continuar ?' get cContinua pict mUUU		valid cContinua$'SN'																			when	NATOP->NO_DEVOL=='S' color 'GR+/B,N/W,,,W+/B'
read
if lastkey()==K_ESC.or.cContinua=='N'
	fn_backnf('PED',VM_ULTPD)
	DbGoTop()
	dbunlockall()
	return NIL
end
if NATOP->NO_DEVOL=='S'// Natureza é Devolução - Gravar chave da NFE Origem
	SetProdDevol('E',str(VM_DEVNNF,8)+VM_DEVSER+str(VM_CLI,5)) // E=Entradas + Chave Busca Itens --> CFEPDEVO.PRG
else
	SetProdDevol('X','') // X=Zerar Itens da NF --> CFEPDEVO.PRG
end
salvabd(SALVA)
VM_LOTE:=max(0,VM_LOTE) // Eliminar lotes negativos

*---------------------------------------> Preencher Linhas Detalhe Zerada
if VM_SERIE==SCOLD
	xLin:=20
else
	xLin:=CTRNF->NF_NRLIN
end
for X:=1 to xLin
	aadd(VM_DET,LinDetProd(X))
next
@16,01 to 16,78
if NATOP->NO_TIPO=='S' //............................. Venda de Produtos = S=Saida ?
	while .T.
		pb_msg('Selecione um item e press <Enter> ou <ESC> para sair.',NIL,.F.)
		X:=abrowse(8,1,16,78,;
						VM_DET,;
					{    'Sq', 'Prod.','Descricao',    'Qtdade',   'VlrVendaUnit','Vlr Desconto','EncFin',    'CTR',   '%ICMS', 'Unid','%Tribut'},;
					{       2,     L_P,         20,          10,               13,            12,       6,      24,         5,      6,       6 },;
					{     mI2,masc(21),       mXXX, masc(6)+'9',     masc(25)+'9',      masc(25), masc(20),masc(11), masc(14),   mUUU, masc(20)})
		if X>0		//...1........2...........3...........4.............5..............6.........7..........8...........9......10........11
			CFEP5110(VM_DET,X,.T.,@VM_TOT,{VM_CODOP}) // editar * retorna ICMS *
			keyboard replicate(chr(K_DOWN),X)
		else
			exit
		end
	end
	keyboard chr(0)
	
else //................................................. VENDA DE SERVICOS
	alert('Nota de servico deve ser feita em rotina especifica')
	salvacor(SALVA)
	pb_box(9,0,12,79,,'Descricao dos Servicos')
	set function 10 to '+'+chr(13)
	pb_msg('F10 para Descricao dos Servicos',NIL,.F.)
	@11,01 say 'OBS' 				get VM_SVC			pict masc(23)+'S74'	valid !empty(VM_SVC).and.fn_obs(@VM_SVC)
	@17,27           				get VM_TOT 			pict masc(05)			valid VM_TOT>0
	@18,01 say 'Base ICMS..:'	get VM_ICMSS[1]	pict mI102				valid VM_ICMSS[1]>=0
	@19,01 say '% ICMS.....:'	get VM_ICMSS[2]	pict mI62				valid VM_ICMSS[2]>=0
	@20,01 say 'Vlr ICMS...:'	get VM_ICMSS[3]	pict mI102				valid VM_ICMSS[3]>=0 when (VM_ICMSS[3]:=round(VM_ICMSS[1]*VM_ICMSS[2]/100,2))>=0
	read
	set function 10 to
	salvacor(RESTAURA)
	VM_DET[1,02]:=-1   // PRODUTO
	VM_DET[1,04]:= 1   // QUANTIDADE
	VM_DET[1,05]:=VM_TOT
	VM_DET[1,09]:=VM_ICMSS[2]
	VM_DET[1,15]:=VM_ICMSS[3]
	VM_DET[1,16]:=VM_ICMSS[2]
end
*---------------------------------------------------------------Roda pe da NOTA
if VM_TOT>0
	if !FinalPedido('Novo','Produto')
		fn_backnf('PED',VM_ULTPD)
	end
else
	fn_backnf('PED',VM_ULTPD)
end
dbgobottom()
dbunlockall()
return NIL

*----------------------------------------------------Fechamento
 function FinalPedido(pTipo,P2)
*----------------------------------------------------
local VM_RETORN
private FLAG     :=.F.
private VM_CARNE :='N'
private TXTPARC  :=''
private VM_FAT   :={}
private VM_CODCP :=0
private VM_VLRENT:=0
private VM_DESCIT:=0
private VM_NOMNF :=CLIENTE->CL_RAZAO
private VM_DIAS  :=30
private VM_TOTA  :=VM_TOT // GUARDAR VALOR MERCADORIAS

	aeval(VM_DET,{|DET|VM_DESCIT+=DET[6]}) // Soma Descontos dos Itens
	if PARAMETRO->PA_CFTIPOF==0
		if !PARAMETRO->PA_EMCUFI // Para Coolacer
			FLAG     :=.T.
			if NATOP->NO_FLTRAN#'S' // Nao necessario para transferencias
				if pTipo=='Novo'
					VM_PERDES:=0.00
					VM_DESCG :=0.00
				else // Altera
					VM_PERDES:=Trunca(VM_DESCG/VM_TOT*100,2) // Proporcional Desconto Geral
				end
				pb_msg('Preencha o rodape do PEDIDO, ou <ESC> para cancelar. F10 para OBS',NIL,.F.)
				set function 10 to '+'+chr(13)
				pb_box(14,0,22,79,'W+/BG,R/W,,,W+/BG','Total da Venda-Y')
				//-------------------------------------------------------------->>> AVALIAR CREDITO E DUPLICATAS A PAGAR EM ATRASO
				@15,01 say 'Parcelamento..:'    get VM_PARCE  pict mI2         valid VM_PARCE>=0 when pb_msg('Informe parcelamento para venda (0,1,2,3,4...)').and.VM_SERIE#'ADT'
				@16,01 say 'Vlr.Produtos..: '+  transform(VM_TOT+VM_DESCIT,mD132)
				@17,01 say '(%) Desconto..:   ' get VM_PERDES pict mI62        valid VM_PERDES>=0.and.VM_PERDES<=100.and.(VM_DESCG:=VM_TOT*VM_PERDES/100)>=0 .and.fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{20,17}) when pb_msg('% para calculo de desconto Geral').and.VM_SERIE#'ADT'
				@18,01 say '(-) Descontos.:   ' get VM_DESCG  pict mI122       valid VM_DESCG>=0                                                             .and.fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{20,17}) when pb_msg('Valor do Desconto Geral').and.VM_SERIE#'ADT'
				@18,40 say '(-) Desc Itens:'+   transform(VM_DESCIT,masc(2))
				@19,01 say 'Vlr.NotaFiscal: '+  transform(VM_TOT-VM_DESCG,masc(2))
				@20,01 say '(-)Vlr Entrada:   ' get VM_VLRENT pict mI122       valid str(VM_VLRENT,15,2)<=str(VM_TOT,15,2) when fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{19,17}).and.pb_msg('Informe Valor Pago na Entrada').and.VM_SERIE#'ADT'
				@21,01 say 'OBS:'               get VM_OBS    pict mUUU+'S70'  valid fn_obs(@VM_OBS) when pb_msg('Informe Observacao para a Pedido F10-para buscar OBS')
				read
				set function 10 to
				if lastkey()#K_ESC
					VM_ENCFI:=min(VM_TOT-VM_TOTA,0) // se for negativo zerar
					if VM_PARCE>0
						//----------------------------------------------------------------------------> CHAMAR PARCELAMENTO
						VM_FAT:=fn_parc(VM_PARCE,(VM_TOT-VM_DESCG-VM_VLRENT),VM_ULTPD,PARAMETRO->PA_DATA)
						if (FLAG:=(len(VM_FAT)==VM_PARCE))
							for X:=1 to VM_PARCE
								TXTPARC+=dtoc(VM_FAT[X,2])				 // 01-09
								TXTPARC+=str( VM_FAT[X,3]*100,11)+'*'// 11-21+1
							next
						end
					end
				else
					FLAG  :=.F.
				end
			end
		else
			VM_RETORN:=Fechar_1(VM_TOT,'P',CLIENTE->CL_CODCL,CLIENTE->CL_RAZAO)
			VM_DESCG :=VM_RETORN[03]
			VM_PARCE :=VM_RETORN[04]	// Nr Parcelas
			VM_ENCFI :=VM_RETORN[06]	// Encargos
			VM_VLRENT:=VM_RETORN[07]
			VM_FAT   :=VM_RETORN[12]   // parcelamento
			VM_CARNE :=VM_RETORN[15]	// Imprimir Carne ?
			VM_OBS   :=VM_RETORN[16]   // Obs
			FLAG     :=.T.
		end		
	elseif PARAMETRO->PA_CFTIPOF==1 // tipo de fechamento de pedido = 1
		VM_RETORN:=Fechar_1(VM_TOT,'P',CLIENTE->CL_CODCL,CLIENTE->CL_RAZAO)
		VM_DESCG :=VM_RETORN[03]
		VM_PARCE :=VM_RETORN[04]	// Nr Parcelas
		VM_ENCFI :=VM_RETORN[06]	// Encargos
		VM_VLRENT:=VM_RETORN[07]
		VM_FAT   :=VM_RETORN[12]   // parcelamento
		VM_CARNE :=VM_RETORN[15]	// Imprimir Carne ?
		VM_OBS   :=VM_RETORN[16]   // Obs
		FLAG     :=.T.
	elseif PARAMETRO->PA_CFTIPOF==2 // COM CONDICAO DE PAGAMENTO
		VM_PERC  :=0.00
		while .T.
			VM_FLAG:=.T.
			pb_box(0,20,,,'W+/BG,R/W,,,W+/BG','Total da Venda-X')
			keyboard ''
			@13,22 say 'Total da Venda: '+  transform(VM_TOT, masc(02))
			@14,22 say 'Cond.Pagamento:'    get VM_CODCP pict mI3 valid fn_codcp(@VM_CODCP,@VM_TOT,@VM_VLRENT,@VM_PARCE,@VM_DIAS)
			read
			if lastkey()#K_ESC
				@15,22 say 'Enc.Financeiro: '+  transform(VM_TOT-VM_TOTA, masc(02))
				@16,22 say 'Total c/Acresc: '+  transform(VM_TOT,         masc(02))
				@17,60 say '%'                  get VM_PERC   pict mI62     valid VM_PERC>=0  when pb_msg('Informe Percentual de Desconto')
				@17,22 say '(-) Descontos.:   ' get VM_DESCG  pict masc(05) valid VM_DESCG>=0.AND.fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{19,38}) when ((VM_DESCG:=VM_TOT*VM_PERC/100)>=0).and.pb_msg('Informe Valor do Desconto')
				@18,22 say 'Sub-Total.....: ' + transform(VM_TOT-VM_DESCG,masc(2))
				@19,22 say 'Valor Entrada.:   ' get VM_VLRENT pict masc(05) valid str(VM_VLRENT,15,2)<=str(VM_TOT-VM_DESCG,15,2) when fn_imprv(transform(VM_TOT-VM_DESCG,masc(2)),{19,38})
				@20,22 say 'N.Parcelas....: '+  str(VM_PARCE,2)
				@21,01 say 'OBS:'               get VM_OBS    pict masc(1)+'S70' valid fn_obs(@VM_OBS) when pb_msg('Informe Observacao para a Pedido F10-para buscar OBS')
				read
				if lastkey()#K_ESC
					VM_FAT   :=fn_parc(VM_PARCE,;
										(VM_TOT-VM_DESCG-VM_VLRENT),;
										 VM_ULTPD,;
										 PARAMETRO->PA_DATA)
					FLAG     :=(len(VM_FAT)==VM_PARCE)
					VM_ENCFI :=max(VM_TOT-VM_TOTA,0)
				else
					if pb_sn('Deseja sair sem gravar ?')
						FLAG  :=.F.
					end
				end
			else
				FLAG  :=.F.
			end
		end
	end
	//------------------------------------------------------------> FINALIZANDO
	if FLAG
		salvabd(SALVA)
		select('PEDCAB')
		dbgobottom()
		dbskip()
		salvabd(RESTAURA)
		if pb_sn()
			pb_msg('Gravando Pedido...',NIL,.F.)
			FATPGRPE(pTipo,P2) //........................................Atualizar Pedidos
			if VM_PARCE>0
				for X:=1 to VM_PARCE
					TXTPARC+=dtoc(VM_FAT[X,2])				 // 01-09
					TXTPARC+=str( VM_FAT[X,3]*100,11)+'*'// 11-21+1
				next
				fn_grparc(VM_ULTPD,TXTPARC) //.........................<RE>Gravar Parcelamento
			end
			dbskip(0)
			//-------------------------------------------------------> 
			if pTipo=='Novo'
				OPC:=alert('Acao para este Pedido...',{'Terminar','Pedido','Nota Fiscal'},'W+/R')
				if OPC==2	// Imprimir Pedido.
					CFEP5104(.T.)
				elseif OPC==3
					CFEP5201('NF') // ir para impressão / geração da NF
					if VM_CARNE=='S'
						VM_DTEMI:=PEDCAB->PC_DTEMI
						Fn_ImpCarne(VM_CLI,VM_NOMNF,VM_FAT,VM_DTEMI)
					end
				end
			end
		end
	end
return FLAG
//------------------------------------EOF-----------------------------*