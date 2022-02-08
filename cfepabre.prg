*------------- ALIAS       NOME FISICO TEM.INDICE---------------------------------*

static ARQ:={{'PARAMETRO',	'CFEAPA',		.F. },;	//001-PARAMETROS GERAIS
				 {'ALIQUOTAS',	'CFEAAF',		.T. },;	//002-CADASTRO ALIQUOTAS FISCAIS*
				 {'BANCO',		'CFEABC',		.T. },;	//003-CADASTRO DE BANCOS*
				 {'CARTAS',		'CFEACA',		.T. },;	//004-CARTAS A CLIENTES*
				 {'COTAS',		'CFEACP',		.T. },;	//006-COTAS - EXTRATOS
				 {'COTAPA',		'COTAPA',		.F. },;	//005-COTAS - PARAMETROS*
				 {'COTASA',		'COTASA',		.F. },;	//006-COTAS - SALDO*
				 {'COTASSO',	'CFEACPS',		.T. },;	//007-COTAS - VLR SOBRAS ANUAIS
				 {'COTASCV',	'CFEACPV',		.T. },;	//008-COTAS - VLR ASSOCIADOS
				 {'COTADV',		'COTADV',		.T. },;	//009-COTAS - VALORES DEVIDOS/RECEB
				 {'COTAMV',		'COTAMV',		.T. },;	//010-COTAS - MOVIMENTO PAGAMENTOS/RECEBIMENTOS
				 {'CTACTB',		'CFEACC',		.T. },;	//011-CTAS CONTABEIS->LIGA CLI/FOR
				 {'CTADET',		'CTBACD',		.T. },;	//012-CTAS DETALHES
				 {'CLIENTE',	'CFEACL',		.T. },;	//013-CAD CLIENTE
				 {'CLICONV',	'CFEAFC',		.T. },;	//014-CLIENTE/CONVENIO
				 {'CLIOBS',		'CFEACO',		.T. },;	//015-CLIENTE->OBS//SPC
				 {'PARAMCTB',	'CTBAPA',		.F. },;	//016-PARAMETROS CTB
				 {'CTATIT',		'CTBACT',		.T. },;	//017-CONTAS TITULOS
				 {'CHEQUES',	'CFEADA',		.F. },;	//018-DADOS DOS CHEQUES
				 {'DIARIO',		'CTBADI',		.T. },;	//019-DIARIO DA CTB
				 {'DPFOR',		'CFEADP',		.T. },;	//020-DUPLICATAS FORNECEDOR/PAGAR
				 {'DPCLI',		'CFEADR',		.T. },;	//021-DUPLICATAS CLIENTES/RECEBER
				 {'ENTCAB',		'CFEAEC',		.T. },;	//022-ENTRADA-CABECALHO
				 {'ENTDET',		'CFEAED',		.T. },;	//023-ENTRADA-DETALHE
				 {'GRUPOS',		'CFEAGE',		.T. },;	//025-GRUPOS DO ESTOQUE
				 {'HISCLI',		'CFEAHC',		.T. },;	//026-HISTORICO CLIENTES
				 {'HISFOR',		'CFEAHF',		.T. },;	//027-HISTORICO FORNECEDOR
				 {'HISPAD',		'CTBAHP',		.T. },;	//028-HISTORICO PADRAO
				 {'CTRLOTE',	'CTBACL',		.T. },;	//029-CONTROLE LOTE
				 {'LCTODIR',	'CTBALD',		.T. },;	//030-LANCAMENTOS DIRETOS
				 {'LAYOUT',		'CFEALY',		.T. },;	//031-LAYOUT CHEQUES
				 {'MOVEST',		'CFEAME',		.T. },;	//032-MOVIMENTO DO ESTOQUE
				 {'MOEDA',		'CFEAMO',		.T. },;	//033-CADASTRO MOEDAS
				 {'CTRNF',		'CFEANF',		.T. },;	//034-CTRL DE NOTA FISCAL/PEDIDO
				 {'NATOP',		'CFEANO',		.T. },;	//035-NATUREZA DE OPERACAO
				 {'CODTR',		'CFEACT',		.T. },;	//036-Codigo Tributario
				 {'OBS',			'CFEAOB',		.T. },;	//037-OBS
				 {'XOBS',		'FISAOBS',		.T. },;	//038-OBS Curtas
				 {'PEDCAB',		'CFEAPC',		.T. },;	//039-PEDIDOS-CABECALHO
				 {'PEDSVC',		'CFEAPS',		.T. },;	//040-PEDIDOS-DET-SVC
				 {'PROFOR',		'CFEAPF',		.T. },;	//041-PRODUTO x FORNECEDOR
				 {'PEDDET',		'CFEAPD',		.T. },;	//042-PEDIDOS-DETALHE
				 {'PEDPARC',	'CFEAPP',		.T. },;	//043-PARCELAMENTO
				 {'PROD',		'CFEAPR',		.T. },;	//044-PRODUTOS NO ESTOQUE
				 {'CFEAPRI',	'CFEAPRI',		.T. },;	//044-PRODUTOS - IMPOSTOS
				 {'PRODAPL',	'CFEAP1',		.T. },;	//045-PRODUTOS - APLICACAO
				 {'PRODAPL2',	'CFEAP2',		.T. },;	//046-PRODUTOS - APLICACAO - 2
				 {'NCM',			'CFEANCM',		.T. },;	//047-PRODUTOS - APLICACAO - 2
				 {'FISACOF',	'FISACOF',		.T. },;	//047-Cod / Tabela PIS/COFINS
				 {'FISAMOD',	'FISAMOD',		.T. },;	//047-Cod Documentos Fiscal - Medelo Fiscal
				 {'RAZAO',		'CTBARZ',		.T. },;	//048-RAZAO CTB
				 {'SALDOS',		'CFEASA',		.T. },;	//049-HISTORICO PRODUTOS NO ESTOQUE
				 {'TABICMS',	'CFEATI',		.T. },;	//050-TABELA ICMS
				 {'VENDEDOR',	'CFEAVE',		.T. },;	//051-VENDEDORES
				 {'SENHAS',		'SENHAINT',		.F. },;	//052-SENHAS
				 {'PARAMORD',	'ORDAPA',		.F. },;	//053-PARAMETRO DE ORDEM SERV/PRODUCAO
				 {'MECMAQ',		'ORDAMM',		.T. },;	//054-HORAS DE MECANICOS OU MAQUINAS
				 {'EQUIDES',	'ORDAED',		.T. },;	//055-Cadastro de Equipamentos/Desenho
				 {'ORDEM',		'ORDAOR',		.T. },;	//056-Ordem de Producao/Servico
				 {'MOVORDEM',	'ORDAIT',		.T. },;	//057-Ordem de Producao/Servico
				 {'ORCACAB',	'ORDAOC',		.T. },;	//058-Orcamento Cabe‡alho
				 {'ORCADET',	'ORDAOD',		.T. },;	//059-Orcamento Detalhe
				 {'ATIVIDAD',	'ORDAAT',		.T. },;	//060-Atividades de producao
				 {'CLIPRECO',	'ORDAPR',		.T. },;	//061-Preco por Cliente
				 {'CONDPGTO',	'FATACP',		.T. },;	//062-Faturamento-Condicoes de Pgto
				 {'DESTRANSF',	'FATADT',		.T. },;	//063-Destino de Transferencias
				 {'CAIXAPA',	'CXAAPA',		.F. },;	//064-Caixa Saldos mensais
				 {'CAIXASA',	'CXAASA',		.T. },;	//065-Caixa Saldos mensais
				 {'CAIXACG',	'CXAACG',		.T. },;	//066-Caixa Contas de Grupo
				 {'CAIXAMC',	'CXAAMC',		.T. },;	//067-Caixa Lctos diarios
				 {'CAIXAMB',	'CXAAMB',		.T. },;	//068-Caixa Lctos diarios
				 {'CHPRE',		'CXAAPRE',		.T. },;	//069-Cheque pré-datado
				 {'ADTOSD',		'CXAAADD',		.T. },;	//070-Adiantamentos Detalhes
				 {'ADTOSC',		'CXAAADT',		.T. },;	//071-Adiantamentos Cabecalho/Totalizador
				 {'LOTEPAR',	'LOTEPAR',		.T. },;	//072-Parcelamento + Lotes
				 {'INVENT',		'INVADA',		.T. },;	//073-Dados de Inventario
				 {'FISPARA',	'FISAPA',		.F. },;	//074-Fiscal-Parametros
				 {'FISRAPU',	'FISARA',		.T. },;	//075-Fiscal-Reg Apuracao
				 {'CAIXA01',	'CAIXA01',		.T. },;	//079-Caixa auxilar - numero de documentos*
				 {'CAIXA02',	'CAIXA02',		.T. },;	//081-Caixa auxilar - numero de documentos*
				 {'GDFBASE',	'GDFBAS',		.T. },;	//082-Base de dados GDF
				 {'LIVROPA',	'LIVROPA',		.F. },;	//083-Parametros Livro Fiscais
				 {'LIVRO',		'LIVRO',			.T. },;	//084-Dados Livros Fiscais
				 {'PARALINH',	'PARALINH',		.T. },;	//085-Parametros Individuais
				 {'GDFBASE',	'GDFBAS',		.T. },;	//086-Base de dados GDF
				 {'GDF60S',		'GDF60S',		.T. },;	//087-Base de dados GDF
				 {'ENGPAI',		'ORDAENGP',		.T. },;	//098-engenharia de produtos-Pai
				 {'ENGFIL',		'ORDAENGF',		.T. },;	//089-engenharia de produtos-Filho
				 {'UMIDADE',	'SAGAUM',		.T. },;	//090-SAG-engenharia de produtos-Filho
				 {'LEIPARAM',	'LEIPARAM',		.F. },;	//091-LEITE-Parametros Gerais	=OK
				 {'LEIROTA',	'LEIROTA',		.T. },;	//092-LEITE-Codigo Rota			=OK
				 {'LEITRANS',	'LEITRANS',		.T. },;	//093-LEITE-Rota X Transp		=OK
				 {'LEIVEIC',	'LEIVEIC',		.T. },;	//094-LEITE-Transp X Veiculo	=OK
				 {'LEIMOTIV',	'LEIMOTIV',		.T. },;	//095-LEITE-Motivo				=OK (LEITEP00.PRG)
				 {'LEICPROD',	'LEICPROD',		.T. },;	//096-LEITE-COMPL PRODUTOR    =OK
				 {'LEIDADOS',	'LEIDADOS',		.T. },;	//097-LEITE-DADOS IMPORTADOS  =OK //093-Arquivo (LEICCSOM) LEITE-CONTAGEM CELULAS SOMATICAS=NOK
				 {'LEIPRODD',	'LEIPRODD',		.T. },;	//094-LEITE-PRODUTOR - DADOS =TEMPORÁRIO
				 {'LEITEMP',	'LEITEMP',		.T. },;	//095-LEITE-PRODUTOR - DADOS =NOK
				 {'LEIGORD',	'LEIGORD',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEIPROT',	'LEIPROT',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEIESD',		'LEIESD',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEICCS',		'LEICCS',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEICPP',		'LEICPP',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEILABOR',	'LEILABOR',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEIBON',		'LEIBON',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEIVOL',		'LEIVOL',		.T. },;	//096-LEITE-PRODUTOR - DADOS =OK
				 {'LEIMUNAU',	'LEIMUNAU',		.T. },;	//100-LEITE-COD MUNICIPIOS AURORA
				 {'CTRASUIN',	'CTRASUIN',		.T. },;	//100-Controle Suino
				 {'NFC',			'..\SAG\SAGANFC',	.T. },;	//101-Nota Fiscal-cabec
				 {'NFD',			'..\SAG\SAGANFD',	.T. },;	//102-Nota Fiscal-detalhe
				 {'BOL',			'..\SAG\BOLENTR',	.T. },;	//103-Boletins
				 {'MOVCLIX',	'CFEACLX',		.T. },;		//104-NOVIMENTO CAD CLIENTE - SPED
				 {'UNIDADE',	'CFEAUN',		.T. },;		//105-UNIDADE - SPED
				 {'UNIDFAT',	'CFEAUNF',		.T. },;		//106-FATOR X UNIDADES
				 {'SPEDBAS',	'SPEDBAS',		.T. },;		//107-Arquivo Base SpedFiscal
				 {'SPEDAICM',	'SPEDAICM',		.T. },;		//108-Arquivo Base SpedFiscal-Apuraçao
				 {'CFEACFC',	'CFEACFC',		.T. },;		//109-Conhecimento de Frete-Cabec
				 {'CFEACFD',	'CFEACFD',		.T. },;		//110-Conhecimento de Frete-Detalhe
				 {'EXCESSAO',	'EXCESSAO',		.T. };		//111-Excessao
					}
*-----------------------------------------------------------------------------*
*																										*
function ABRE(P1)  // Abre Arquivos	P1[AR_M],,,,										*
*														M=R,E,C										*
*-----------------------------------------------------------------------------*

local VM_RT:=.T.
local CMODO
local P2
local X
local Y
local TF:=savescreen(maxrow(),0,maxrow(),maxcol())

for X:=1 to len(P1)
	pb_msg('Abrindo Arquivos, Aguarde...'+P1[X],nil,.F.)
	CMODO:=upper(left(P1[X],1))
	if (P2:=ascan(ARQ,{|DET|DET[1]==substr(P1[X],4)}))>0
		//..............1........2.........3...4.......5....6.........7
		if !net_use(ARQ[P2,2],CMODO=='E', ,ARQ[P2,1], ,CMODO=='R',RDDSETDEFAULT())
			pb_msg('Arquivo '+ARQ[P2,2]+' n„o pode ser aberto.',3,.t.)
			VM_RT:=.F.
			exit
		end
		if file(ARQ[P2,2]+OrdBagExt())
			OrdListAdd(ARQ[P2,2])
			SET OPTIMIZE ON
		elseif ARQ[P2,3] // Tem que Existir Arquivo de Indice? ... Não foi achado.
			Alert(ProcName()+'.Arquivo de Indice necessario ('+ARQ[P2,2]+OrdBagExt()+') nao encontrado.;Reportar')
			VM_RT:=.F.
		end
		if ARQ[P2,1]=='PARAMCTB' // Parametros Gerais Contábeis
			MASC_CTB:='@R '+trim(PARAMCTB->PA_MASCARA)
			VM_MASTAM  :=len(strtran(trim(PA_MASCARA),'-',''))
			VM_LENMAS  :=len(trim(PA_MASCARA))
		end
	else
		alert('Arquivo '+P1[X]+' Erro interno.'+ProcName())
	end
next
if !VM_RT
	dbcloseall()	// nao pode abrir todos os arquivos (fechar)
else
	if select('PARAMETRO')>0.and.;
		PARAMETRO->PA_SERFF1 .and.;
		RT_NIVEL()==2 // senha normal
		AbreX() // Abre Arquivos dependentes
	end
end
RestScreen(maxrow(),0,maxrow(),maxcol(),TF)
return (VM_RT)
*-----------------------------------------eof--------------------------------------------------
