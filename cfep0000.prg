*-----------------------------------------------------------------------------*
 static aVariav := {0,''}
 //.................1
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate cArq       => aVariav\[  2 \]

#include 'RCB.CH'
*------------------------------------------------> Arquivos do DBF
 function ARQ(P1,P2)	//	Criacao dos arquivos
*------------------------------------------------* CADASTRO DE CLIENTES

cArq:='CFEACL'
if dbatual(cArq,;
				{{'CL_CODCL' , 'N',  5,  0},;	// 01-Codigo
				 {'CL_RAZAO' , 'C', 45,  0},;	// 02-Descri‡„o
				 {'CL_ENDER' , 'C', 45,  0},;	// 03-Endere‡o
				 {'CL_BAIRRO', 'C', 25,  0},;	// 04-Bairro
				 {'CL_CEP'   , 'C',  8,  0},;	// 05-CEP
				 {'CL_CIDAD' , 'C', 20,  0},;	// 06-Cidade
				 {'CL_UF'    , 'C',  2,  0},;	// 07-UF
				 {'CL_CGC'   , 'C', 14,  0},;	// 08-CNPJ / CPF
				 {'CL_INSCR' , 'C', 18,  0},;	// 09-Inscricao Estadual/CI
				 {'CL_DTNAS' , 'D',  8,  0},;	// 10-Data de Nascimento
				 {'CL_FONE'  , 'C', 30,  0},;	// 11-Fone
				 {'CL_FAX',    'C', 30,  0},; 	// 12-FAX
				 {'CL_DTVEN' , 'D',  8,  0},;	// 13-Dt.Ult.Venda
				 {'CL_OBS'   , 'C',180,  0},;	// 14-Observacao
				 {'CL_VENDED', 'N',  3,  0},;	// 15-Cod.Vendedor
				 {'CL_CCTB'  , 'N',  4,  0},;	// 16-Conta Contabil --> avaliar para excluir
				 {'CL_DTCAD' , 'D',  8,  0},;	// 17-Data do Cadastro
				 {'CL_ATIVID', 'N',  2,  0},;	// 18-Atividade=Tabela <associado/nao associado>
				 {'CL_REMUN',  'N',  3,  0},;	// 19-Remuneracao SM  
				 {'CL_FILIAC', 'C', 60,  0},;	// 20-Filiacao Pai X Mae
				 {'CL_LOCTRA', 'C', 65,  0},;	// 21-Local Trabalho
				 {'CL_CARGO',  'C', 15,  0},;	// 22-Cargo Trabalho
				 {'CL_DATAAD', 'D',  8,  0},;	// 23-Data Admissao 
				 {'CL_ESTCIV', 'C',  1,  0},;	// 24-Estado Civil (SCDV)
				 {'CL_CONJUG', 'C', 45,  0},;	// 25-Conjuge     
				 {'CL_DOCTOC', 'C', 12,  0},;	// 26-Documento  Conjuge
				 {'CL_LOCTRC', 'C', 65,  0},;	// 27-local Trab Conjuge
				 {'CL_DATAAC', 'D',  8,  0},;	// 28-Data Admis Conjuge
				 {'CL_DATANC', 'D',  8,  0},;	// 29-Data Nasc. Conjuge
				 {'CL_CARGOC', 'C', 15,  0},;	// 30-Cargo      Conjuge
				 {'CL_RENDAC', 'N',  3,  0},;	// 31-Renda      Conjuge SM
				 {'CL_FILICG', 'C', 60,  0},;	// 32-Filiacao   Conjuge
				 {'CL_REFER',  'C', 50,  0},;	// 33-Referencias
				 {'CL_BENS',   'C', 60,  0},;	// 34-Bens
				 {'CL_DTSPC',  'D',  8,  0},;	// 35-DATA REG NO SPC
				 {'CL_DTCSP',  'D',  8,  0},;	// 36-DATA ULTIMA CONS NO SPC
				 {'CL_LOCNAS', 'C', 20,  0},;	// 37-local Nascimento
				 {'CL_VLRSPC', 'N', 15,  2},;	// 38-Valor quando enviado ao spc
				 {'CL_LIMCRE', 'N', 15,  2},;	// 39-Limite de Crédito
				 {'CL_NRCART', 'N',  1,  0},;	// 40-Nr.Cartas
				 {'CL_TIPOFJ', 'C',  1,  0},;	// 41-Tipo Pessoa (Fisico/Juridico)
				 {'CL_DTBAIX', 'D',  8,  0},;	// 42-Data de Baixa do Cliente - Nào haverá mais movivmentação
				 {'CL_CODFOR', 'N',  5,  0},;	// 43-Nr Fornec................NUMERO ANTIGO
				 {'CL_DTUCOM', 'D',  8,  0},;	// 44-Dt Ultima Compra
				 {'CL_CONTAT', 'C', 30,  0},;	// 45-Contato
				 {'CL_MATRIZ', 'N',  5,  0},;	// 46 Cod/Fornecedor Matriz/Cobranca
				 {'CL_STATUS', 'C', 42,  0},;	// 47 1=Tem Resfriador < >=Normal <== Só Coolacer-Leite == Valores (Resfriador=6+Canalização=6+Qualidade=6+Bonificacao=6+Livre=6)
				 {'CL_LEITSQ', 'N',  6,  0},;	// 48 Rota/Sequencia para buscar Leite
				 {'CL_NFANTA', 'C', 40,  0},;	// 49 Nome Fantasia
				 {'CL_INSMUN', 'C', 14,  0},;	// 50 Inscricao Municipal
				 {'CL_CCTRA1', 'N',  4,  0},;	// 51 Conta contábil de transferencia de Saida(estoque-débito)
				 {'CL_TPEMPR', 'N',  1,  0},;	// 52 Tipo Empresa = 0-Normal 5=SuperSimples
				 {'CL_CDIBGE', 'N',  7,  0},;	// 53 Codigo Municipio IBGE.
				 {'CL_CDSUFRA','C',  9,  0},;	// 54 Codigo SUFRAMA.
				 {'CL_CDPAIS', 'N',  5,  0},;	// 55 Codigo País
				 {'CL_ENDNRO', 'C', 10,  0},;	// 56 Número Imóvel
				 {'CL_ENDCOMP','C', 20,  0},;	// 57 Complemento
				 {'CL_EMAIL',  'C', 30,  0},;	// 58 E-mail
				 {'CL_NFPR',   'C', 20,  0}},;	// 59 NR NF-Produtor Rural (Leite)
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

cArq:='CFEACLX'
if dbatual(cArq,;
				{{'CLX_CODCL' , 'N',  5,  0},;	// 01-*Codigo
				 {'CLX_DTALT' , 'D',  8,  0},;	// 02-*Data Alteracao
				 {'CLX_NROCPO', 'N',  2,  0},;	// 03-*Nro campo SPED-FISCAL
				 {'CLX_CONTANT','C', 50,  0},;	// 04-Conteúdo anterior
				 {'CLX_USUARIO','C', 30,  0}},;	// 05-Usuário alterou
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* DUPLICATAS A RECEBER
cArq:='CFEADR'
if dbatual(cArq,;
				{{'DR_DUPLI' ,'N',  9,  0},;	// 01-Duplicata
				 {'DR_CODCL' ,'N',  6,  0},;	// 02-Cod.Cliente
				 {'DR_DTEMI' ,'D',  8,  0},;	// 03-Dt.Emissao
				 {'DR_DTVEN' ,'D',  8,  0},;	// 04-Dt.Vencimento
				 {'DR_DTPGT' ,'D',  8,  0},;	// 05-Dt.Pagto.
				 {'DR_VLRDP' ,'N', 15,  2},;	// 06-Vlr.Duplicata
				 {'DR_VLRPG' ,'N', 15,  2},;	// 07-Vlr.Pago
				 {'DR_CODBC' ,'N',  2,  0},;	// 08-Cod.Banco
				 {'DR_MOEDA' ,'N',  1,  0},;	// 09-Moeda(0=CRZ,1=URV....
				 {'DR_NRNF'  ,'N',  9,  0},;	// 10 Numero da NF
				 {'DR_SERIE' ,'C',  3,  0},;	// 11 Serie da NF
				 {'DR_ALFA'  ,'C', 40,  0},;	// 12-Nome Cliente
				 {'DR_DTPROT','D',  8,  0},;	// 13-Data Protesto
				 {'DR_OFICIO','C', 30,  0},;	// 14-Ofico Protesto
				 {'DR_JUROSD','N',  6,  3},;	// 15-Juros Financiamento
				 {'DR_TIPODP','C',  1,  0},;	// 16-N->Normal P-PREVISAO X->PROTESTO
				 {'DR_NRBOL', 'N', 16,  0},;	// 17-Nr do Boleto
				 {'DR_DPDR',  'C',  1,  0},;	// 18-<P>agar  <R>eceber <<<<NAO USADO>>>>
				 {'DR_ATIVID','N',  2,  0}},;	// 19-Tipo Cliente (Associado/Não Associado)
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* DUPLICATAS PAGAR (FORNECEDOR)
cArq:='CFEADP'
if dbatual(cArq,;
				{{'DP_DUPLI', 'N',  9,  0},;	//  1-Duplicata
				 {'DP_CODFO' ,'N',  6,  0},;	//  2-Cod.Fornecedor
				 {'DP_DTEMI' ,'D',  8,  0},;	//  3-Dt.Emissao
				 {'DP_DTVEN' ,'D',  8,  0},;	//  4-Dt.Vencimento
				 {'DP_DTPGT' ,'D',  8,  0},;	//  5-Dt.Pagto
				 {'DP_VLRDP' ,'N', 15,  2},;	//  6-Vlr.Duplicata
				 {'DP_VLRPG' ,'N', 15,  2},;	//  7-Vlr.Pago
				 {'DP_CODBC' ,'N',  2,  0},;	//  8-Cod.Banco
				 {'DP_MOEDA' ,'N',  1,  0},;	//  9-MOEDA(0-CRZ,1=URV..)
				 {'DP_NRNF'  ,'N',  9,  0},;	// 10 Numero da NF
				 {'DP_SERIE' ,'C',  3,  0},;	// 11 Serie da NF
				 {'DP_ALFA'  ,'C', 40,  0},;	// 12-Parte do nome
				 {'DP_DTPROT','D',  8,  0},;	// 13-Data Protesto
				 {'DP_OFICIO','C', 30,  0},;	// 14-Ofico Protesto
				 {'DP_JUROSD','N',  6,  3},;	// 15-Juros ao Mes
				 {'DP_TIPODP','C',  1,  0},;	// 16-N->Normal P-PREVISAO X->PROTESTO
				 {'DP_NRBOL', 'C', 16,  0},;	// 17-Nr do Boleto
				 {'DP_DPDR',  'C',  1,  0},;	// 18-<P>agar  <R>eceber <<<<NAO USADO>>>>
				 {'DP_ATIVID','N',  2,  0}},;	// 19-Tipo Cliente (Associado/Não Associado)
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* CLIENTES/OBS->SPC
cArq:='CFEACO'
if dbatual(cArq,;
				{{'CO_CODCL' ,'N',  5,  0},;	// 01-Codigo
				 {'CO_SEQUE' ,'N',  2,  0},;	// 02-Sequencia
				 {'CO_OBS'   ,'C', 60,  0}},;	// 03-Obs
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* GRUPOS DO ESTOQUE
cArq:='CFEAGE'
if dbatual(cArq,;
				{{'GE_CODGR' ,'N',  6,  0},;	// 1-Codigo Grupo
				 {'GE_DESCR' ,'C', 30,  0},;  // 2-Descricao do Grupo
				 {'GE_PERVEN','N',  7,  2}},; // 3-Percentual Vendedor
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* PRODUTOS DO ESTOQUE---Ver CFEP4206()-----
cArq:='CFEAPR'
if dbatual(cArq,;
				{{'PR_CODGR' , 'N',  6,  0},;	//	01-Cod.Grupo
				 {'PR_CODPR' , 'N',L_P,  0},;	//	02-Cod.Produto
				 {'PR_DESCR' , 'C', 40,  0},;	//	03-Descricao
				 {'PR_COMPL' , 'C', 40,  0},;	//	04-Complemento descricao
				 {'PR_UND'   , 'C',  5,  0},;	//	05-Unidade
				 {'PR_LOCAL' , 'C',  6,  0},;	//	06-Local de Armazenagem
				 {'PR_ETMIN' , 'N', 10,  2},;	//	07-Estoque Minimo
				 {'PR_QTATU' , 'N', 12,  3},;	//	08-Qtde.Atual Estoque
				 {'PR_VLATU' , 'N', 15,  2},;	//	09-Vlr.Estoque (Total) Medio
				 {'PR_VLVEN' , 'N', 15,  3},;	//	10-Vlr.Venda   (Unitário)
				 {'PR_DTMOV' , 'D',  8,  0},;	//	11-Dt.Ultima Movim.
				 {'PR_DTCOM' , 'D',  8,  0},;	//	12-Dt.Ultima Compra
				 {'PR_VLCOM' , 'N', 15,  4},;	//	13-Vlr.Unitario Ult.Compra-CUSTO
				 {'PR_SLDQT' , 'N', 13,  3},;	//	14-Qtde.Inicial Periodo
				 {'PR_SLDVL' , 'N', 15,  2},;	//	15-Valor Inicial Periodo
				 {'PR_ABCVE' , 'C',  1,  0},;	//	16-Classificacao ABC - PCO VENDA
				 {'PR_ABCET' , 'C',  1,  0},;	//	17-Classificacao ABC - VLR.ESTOQUE
				 {'PR_CTB'   , 'N',  2,  0},;	//	18-Codigo TIPO PRODUTO
				 {'PR_RESER' , 'N', 12,  2},;	//	19-Qtdade reservada
				 {'PR_LUCRO' , 'N',  7,  2},;	//	20-% Lucro adicional do produto p/calculo entrada
				 {'PR_PRVEN' , 'N',  5,  2},;	//	21-% Comissao para o Vendedor deste produto
				 {'PR_PIPI'  , 'N',  5,  2},;	//	22-% IPI padrao na entrada
				 {'PR_CODTR' , 'C',  3,  0},;	//	23-Codigo Trib Padrao - SAIDAS
				 {'PR_CFTRIB', 'C',  2,  0},;	//	24-Cupom Fiscal -Aliquota - tabela
				 {'PR_PICMS' , 'N',  5,  2},;	//	25-% ICMS 
				 {'PR_PTRIB' , 'N',  6,  2},;	//	26-% TRIB DA BASE ICMS
				 {'PR_IMPET' , 'C',  1,  0},;	//	27-Impressao de Etiqueta
				 {'PR_CODNBM', 'C', 20,  0},;	//	28-Código NBM
				 {'PR_MODO'  , 'C',  1,  0},;	//	29-Modo <N>ormal <D>ebito Direto
				 {'PR_CTRL'  , 'C',  1,  0},;	//	30-Controla Qtd Estoque <S>Sim <N>Nao < >Nao
				 {'PR_PERVEN', 'N',  6,  2},;	//	31-% Acrescimo na venda por produto
				 {'PR_CODTRE', 'C',  3,  0},;	//	32-Codigo Trib Padrao - ENTRADAS
				 {'PR_CODOBS', 'C',  1,  0},;	//	33-Codigo Observacao Padrao Produto
				 {'PR_PISCOF', 'C',  1,  0},;	//	34-Recolhido Pis/Cofins (LISTAGENS) ?
				 {'PR_CODCOE', 'C',  3,  0},;	//	35-Codigo Tabela-Pis/Cofins(Entrada)
				 {'PR_CODCOS', 'C',  3,  0},;	// 36-Codigo Tabela-Pis/Cofins(Saida)
				 {'PR_ITEMTAB','C',  3,  0},;	// 37-Item x Tabela-Pis/Cofins(Saida) - 4.3.12...4.3.16
				 {'PR_CFISIPI','C', 10,  0},;	//	38-Classificacao fiscal - IPI
				 {'PR_PESOKG', 'N', 10,  2},;	//	39-Peso em KG
				 {'PR_CODNCM', 'C', 10,  0},;	//	40-NCM=Nomenclatura Comum do Mercosul
				 {'PR_CODGEN', 'C',  2,  0},;	//	41-Genero=Nomenclatura Comum do Mercosul + 00 para serviços
				 {'PR_CDSVC',  'N',  4,  0},;	//	42-Código do serviço conforme lista do Anexo I da Lei Complementar Federal nº 116/03.
				 {'PR_TIPI',   'N',  2,  0},;	//	43-TIPI
				 {'PR_UNDTRIB','C',  5,  0},;	//	44-Unidade Tributável
				 {'PR_ORIGEM', 'N',  1,  0},;	//	45-Origem Mercadoria 0-Nacional, 1-Estrang Importação direta 2-Estrang Importação mercado interno
				 {'PR_CLCONS', 'N',  4,  0},;	//	46-Energia-Classe Consumo   (REG=45 Campo=02 - PH)
				 {'PR_TPLIGA', 'N',  1,  0},;	//	47-Energia-Cod Tipo Ligação (REG=45 Campo=25 - PH)
				 {'PR_GRTENS', 'N',  2,  0},;	//	48-Energia-Grupo Tensão     (REG=45 Campo=26 - PH)
				 {'PR_TPASSI', 'N',  2,  0},;	//	49-Energia-Tipo Assinant    (REG=45 Campo=27 - PH)
				 {'PR_DTCAD',  'D',  8,  0}},;//	50-Data cadastro do item
					RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* % IMPOSTOS 
cArq:='CFEANCM'
if dbatual(cArq,;
				{{'NCM_CODNCM',	'C', 10,  0},;	// 01-Codigo-NCM=Nomenclatura Comum do Mercosul
				 {'NCM_EX',			'C',  1,  0},;	// 03-Exceção - NCM
				 {'NCM_TABELA',	'C',  1,  0},;	// 04-Tabela - 0=NCM - 1=SERV- 2=LC 116
				 {'NCM_DESCR',		'C', 60,  0},;	// 02-Descrição dos Produtos
				 {'NCM_PERC1',		'N',  6,  2},;	//	05-% Tribucação Nacional
				 {'NCM_PERC2',		'N',  6,  2}},;//	06-% Tribuação (Prod Importado)
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* PRODUTO A ALTERACACOES PARA SPED
cArq:='CFEAPRA'
if dbatual(cArq,;
				{{'PRA_CODPR','N',L_P,  0},;	// 1-Codigo  item
				 {'PRA_DESCR','C', 40,  0},;  // 2-Descricao item - ANTERIOR
				 {'PRA_DTINI','D',  8,  0},;	// 3-Data Inicio
				 {'PRA_DTFIM','D',  8,  0}},; // 4-Data Fim
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* PRODUTO IMPOSTOS
cArq:='CFEAPRI'
if dbatual(cArq,;
				{{'PRI_CFOP',		'N',  7,  0},;	// 01-Codigo  Natureza Operação
				 {'PRI_CODPR',		'N',L_P,  0},;	// 02-Codigo  Produto
				 {'PRI_CODCOE',	'C',  3,  0},;	//	35-Codigo Tabela-Pis(Entrada)
				 {'PRI_CODCOS',	'C',  3,  0}},;// 36-Codigo Tabela-Pis(Saida)
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* UNIDADES DO ESTOQUE
cArq:='CFEAUN'
if dbatual(cArq,;
				{{'UN_CODUN' ,'C',  5,  0},;	// 1-Codigo unidade item (INTERNA)
				 {'UN_DESCR' ,'C', 30,  0},;  // 2-Descricao unidade item
				 {'UN_PESOKG','N', 10,  4}},; // 3-Peso da embalagem -> para futuramente colocar em frete
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* PRODUTOS DO ESTOQUE-APLICA
cArq:='CFEAP1'
if dbatual(cArq,;
				{{'P1_CODPR' ,'N', L_P,  0},;	// 01-Cod.Produto
				 {'P1_APLICA','C',3150,  0},;	// 02-Descricao 70c X 45 Linhas
				 {'P1_CLTOX', 'N',   1,  0},;	// 03-Qtd Classe
				 {'P1_DOSAGE','N',   6,  2},;	// 04-Dosagem padrao
				 {'P1_UND',   'C',   3,  0},;	// 05-UNIDADE DO PRODUTO PARA REC
				 {'P1_PRINAT','C',  30,  0},;	// 05-Pricipio Ativo
				 {'P1_GRQUIM','C',  30,  0},;	// 06-Grupo Quimico
				 {'P1_DIAGN', 'C',  50,  0}},;// 07-Diagnostico
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* PRODUTOS DO ESTOQUE-APLICA
cArq:='CFEAP2'
if dbatual(cArq,;
				{{'P2_CODPR' ,'N', L_P,  0},;	// 01-Cod.Produto
				 {'P2_CULTUR','C',  20,  0},;	// 02-Aplicado a Cultura
				 {'P2_UTILIZ','C', 120,  0},;	// 03-4linhas x 30colunas    
				 {'P2_DOSAGE','C',  25,  0},;	// 04-Dosagem
				 {'P2_CARENC','C',  10,  0}},;// 05-Carencia
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* MOVIMENTACAO ESTOQUE
cArq:='CFEAME'
if dbatual(cArq,;
				{{'ME_CODPR' ,'N',L_P,  0},;	// 1-Cod.Produto
				 {'ME_DATA'  ,'D',  8,  0},;	// 2-Data
				 {'ME_DCTO'  ,'N', 11,  0},;	// 3-Documento
				 {'ME_QTD'   ,'N', 13,  3},;	// 4-Qtde.Movimentada
				 {'ME_VLEST' ,'N', 15,  2},;	// 5-Vlr.Movimentado (MEDIO-Total)
				 {'ME_VLVEN' ,'N', 15,  2},;	// 6-Vlr.Movimentado (VENDA-Total)
				 {'ME_TIPO'  ,'C',  1,  0},;	// 7-Tipo Movimento (E/S/I/A/T/F)
				 {'ME_CTB'   ,'N',  2,  0},;	// 8-Tipo Produto
				 {'ME_SERIE' ,'C',  3,  0},;	// 9-SERIE
				 {'ME_CODFO' ,'N', 10,  0},;	//10-Codigo Fornecedor
				 {'ME_DESDB' ,'N',  4,  0},;	//11-Cod Contabil Desp/Prod(DB)
				 {'ME_ICMDB' ,'N',  4,  0},;	//12-Cod Contabil Icms     (DB)
				 {'ME_VICMS' ,'N', 12,  2},;	//13-Valor Icms
				 {'ME_FLCTB' ,'L',  1,  0},;	//14-Flag Contabilizado
				 {'ME_FORMA' ,'C',  1,  0}},;	//15-<D> ou <P>roducao ou <L>eite ou <S>ilo OU <N>ormal
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

CFEP0001(P1,   P2)	// Continuacao (EC/ED/HC/HF)
CTBPCRIA(P1,   P2)	// Contas Contabeis
CXAPCRIA(P1,   P2)	// Arquivos do modulo de caixa
FATPCRIA(P1,   P2)	// Criacao de arquivos do Faturamento (PC/PD)
FATPLOTEX(P1,  P2)	// Controle de Lotes para Parceria
FISPCRIA(P1,   P2)	// Criacao de arquivos do FISCAL
CotaCria(P1,   P2)	// Criacao de arquivos do modulo Cota Parte
CRSENHA(P1,    P2)	// Criacao de Senhas
Cria_Serie(P1, P2)	// verifica e cria arquivos de s‚rie
Cria_Natop(P1, P2)	// verifica e cria arquivos de natureza operacao
Cria_CFIS (P1, P2)	// verifica e cria arquivos Modelos/Códigos Documentos Fiscais
Cria_CxaAux(P1,P2)	
Cria_DesTr(P1,P2)
Cria_CFRETE(P1,P2) // Cria tabelas de conhecimento de frete - FATPDCF.PRG
Cria_UNNFUNEST(P1,P2) // Unidade de nf x Unidade estoque - fator

CRIA_CTRASUIN(P1,P2)	// verifica e cria arquivo controle suino - CTRPSUIN.PRG
CXAPPREX(P1,   P2)	// Cheques pré = CXAPPRE.PRG
CXAPADTX(P1,   P2)   // Adiantamentos
//LivroX  (P1,   P2)	// Criar Arquivos Livros Fiscais = LIVRO0.PRG
ParaLinh(P1,   P2)	// Criar Arquivo de parametros linha
SagpUmix(P1,   P2)   // Arquivo de SAG-Umidade

Cria_LEITE(P1,  P2)	// Arquivos do Leite (NOVO) - LEITEP00.PRG

//LEIPARAMX(P1,P2)	// Arquivo base Parametros - LEITEP00.PRG
//LEICRIOSX(P1,P2)	// Arquivo base Crioscopia - LEITEP00.PRG
//LEIREDUTX(P1,P2)	// Arquivo base Redutase - LEITEP00.PRG
//LEITEMPX (P1,P2)	// Arquivo base de temperatura - LEITEP05
//LEICCSOMX(P1,P2)	// Arquivo base Cont.CelulasSomaticas - LEITEP03.PRG
//LEIBASEX (P1,P2)   // Arquivo base de Dados de Leite-Antigo - LEITEP10.PRG
//LEIADFILX(P1,P2)	// Arquivo Base Adicional Fidelidade - LEITEP07.PRG

LEIGORDX (P1,  P2)   // Arquivo Faixa Gordura								-LEITEP12.PRG
LEIPROTX (P1,  P2)   // Arquivo Faixa Proteina								-LEITEP13.PRG
LEIESDX  (P1,  P2)   // Arquivo Faixa ESD-Extrato Seco Desengordurado-LEITEP14.PRG
LEICCSX  (P1,  P2)   // Arquivo Faixa CCS-Contagens Celulas Somaticas-LEITEP15.PRG
LEICPPX  (P1,  P2)   // Arquivo Faixa CPP-Contagem Padrao Placas		-LEITEP16.PRG
LEILABORX(P1,  P2)   // Importação do Laboratório (Análise Leite) 	-LEITEP17.PRG
LEIVOLX			(P1,	P2)	// Tabela Valor Litro por Volume 					-LEITEP22.PRG
LEIBONX			(P1,	P2)	// Tabela Calculo Análise Leite	 					-LEITEP23.PRG (Cálculo)

LEIPRODDX		(P1,  P2)	// Arquivo base de Avaliação de Propriedade/Controle Sanitário-LEITEP04
LEIMUNAUX		(P1,	P2) 	// Verifica e cria Arquivos de Municipo da Aurora (codigos)
EXCESSAO_Cria	(P1,  P2) 	// Cria arquivo Excessao -> EXCESSAO.PRG
*-----------------------------------------------------------------------------*
return NIL
*------------------------------EOF--------------------------------------------*