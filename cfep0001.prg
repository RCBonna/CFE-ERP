*-----------------------------------------------------------------------------*
 static aVariav := {0,''}
 //.................1
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate cArq       => aVariav\[  2 \]

#include 'RCB.CH'

*------------------------------------------------> Arquivos do DBF
function CFEP0001(P1,P2)
*------------------------------------------------* Entradas/Cabecalho
cArq:='CFEAEC'
if dbatual(cArq,;
				{{'EC_DOCTO', 'N',  9,  0},;	// 01-Nr.Documento
				 {'EC_CODFO' ,'N',  6,  0},;	// 02-Cod.Fornecedor
				 {'EC_CODBC' ,'N',  2,  0},;	// 03-Cod.Banco
				 {'EC_DOCBC' ,'N',  9,  0},;	// 04-Documento Cxa/Bco
				 {'EC_DTEMI' ,'D',  8,  0},;	// 05-Dt.Emissao
				 {'EC_DTENT' ,'D',  8,  0},;	// 06-Dt.Entrada (Saida-Quando for NF Entrada)
				 {'EC_TOTAL', 'N', 15,  2},;	// 07-Total Nota
				 {'EC_DESC',  'N', 15,  2},;	// 08-Vlr Desconto
				 {'EC_FUNRU', 'N', 15,  2},;	// 09-Vlr Funrural
				 {'EC_ICMSP', 'N',  5,  2},;	// 10-% ICMS (serve para frete -Livro Fiscal)
				 {'EC_ICMSB', 'N', 15,  2},;	// 11-ICMS BASE (serve para frete -Livro Fiscal)
				 {'EC_ICMSV', 'N', 15,  2},;	// 12-ICMS VALOR (serve para frete -Livro Fiscal)
				 {'EC_IPI',   'N', 15,  2},;	// 13-IPI VALOR
				 {'EC_VLROBS','N', 15,  2},;	// 13-Valor Observação 
				 {'EC_CODOP', 'N',  7,  0},;	// 14-COD OPERACAO/Natureza
				 {'EC_TPDOC', 'C',  3,  0},;	// 15-Tipo Docto (TP_DOCTO.ARR)
				 {'EC_SERIE', 'C',  3,  0},;	// 16-Serie NF//
				 {'EC_FATUR', 'N',  2,  0},;	// 17-Faturamento 0=vista/1,2,3..parc
				 {'EC_CODTR', 'C',  3,  0},;	// 18-Class Fiscal (00,01,02,,,)
				 {'EC_GERAC', 'C',  1,  0},;	// 19-G-GERADO A-ALTERADO M-MANUAL
				 {'EC_PARCE', 'C',280,  0},;	// 20-Vencimentos
				 {'EC_ACESS', 'N', 15,  2},;	// 21-Despesas Acessorias (soma == manter histórico)
				 {'EC_ACFRET','N', 15,  2},;	// 22-Despesas Acessorias-Frete
				 {'EC_ACSEGU','N', 15,  2},;	// 23-Despesas Acessorias-Seguro
				 {'EC_ACOUTR','N', 15,  2},;	// 24-Despesas Acessorias-Outras
				 {'EC_ICMSTB','N', 15,  2},;	// 25-ICMS ST Base
				 {'EC_ICMSTV','N', 15,  2},;	// 26-ICMS ST Valor
				 {'EC_FRDOC', 'N',  8,  0},;	// 22-Numero do Documento de Frete
				 {'EC_FRSER', 'C',  3,  0},;	// 23-Serie NF de Frete
				 {'EC_FRFOR', 'N',  5,  0},;	// 24-Fornecedor de Frete
				 {'EC_NFCAN', 'L',  1,  0},;	// 25-NF Cancelada? (Sim/Não)
				 {'EC_FLCTB', 'L',  1,  0},;	// 26-Flag Contabilizado
				 {'EC_FLADTO','L',  1,  0},;	// 27-Flag Adiantamento
				 {'EC_NSU',   'N', 10,  0},;  // 28-Numero Sequencial Unico
				 {'EC_NFEKEY','C', 44,  0},;  // 29-Chave NFE
				 {'EC_NFEDEV','C', 44,  0},;  // 29-Chave NFE-Devolução
				 {'EC_OBSLIV','C', 25,  0},;  // 30-Observação para Livros Fiscais
				 {'EC_OBSNFE','C', 75,  0},;  // 31-Observação para NFe
				 {'TR_CODTRA','N',  6,  0},;  // 32-Frete-Codigo Fornecedor (só apartir de mai/2011)
				 {'TR_NOME',  'C', 40,  0},;  // 32-Frete-Nome
				 {'TR_ENDE',  'C', 40,  0},;  // 33-Frete-Endereco
				 {'TR_MUNI',  'C', 20,  0},;  // 34-Frete-Nome Municipio
				 {'TR_UFT',   'C',  2,  0},;  // 35-Frete-UF Transportador
				 {'TR_TIPO',  'N',  1,  0},;  // 36-Frete-Tipo de Frete (0= 1=)
				 {'TR_PLACA', 'C',  7,  0},;  // 37-Frete-Placa
				 {'TR_UFV',   'C',  2,  0},;  // 38-Frete-UF-Veiculo
				 {'TR_CGC',   'C', 18,  0},;  // 39-Frete-CGC Transportador 
				 {'TR_INCR',  'C', 18,  0},;  // 40-Frete-Inscr.Estadual
				 {'TR_QTDEM', 'N',  9,  2},;  // 41-Frete-Quantidade Embalagem
				 {'TR_ESPE',  'C', 20,  0},;  // 42-Frete-Especie de Embalagem
				 {'TR_MARC',  'C', 20,  0},;  // 43-Frete-Marca da Embalagem
				 {'TR_PBRU',  'N',  9,  2},;  // 44-Frete-Peso Bruto
				 {'TR_PLIQ',  'N',  9,  2}},; // 45-Frete-Peso Liquido
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
// Indice em ==> CFEPIND1.PRG

*------------------------------------------------* Entradas/Detalhe
cArq:='CFEAED'
if dbatual(cArq,;
				{{'ED_DOCTO',  'N', 10,  0},;	// 01-Nr.documento
				 {'ED_SERIE' , 'C',  3,  0},;	// 02-Serie da NF
				 {'ED_CODFO' , 'N',  6,  0},;	// 03-Cod.Fornecedor
				 {'ED_ORDEM' , 'N',  3,  0},;	// 04-Nr de Ordem
				 {'ED_CODPR' , 'N',L_P,  0},;	// 05-Cod.Produto
				 {'ED_QTDE'  , 'N', 13,  3},;	// 06-Qtde.Movimentada
				 {'ED_VALOR' , 'N', 15,  2},;	// 07-Vlr Aquisicao Item -> Total
				 {'ED_PCICM',  'N',  5,  2},;	// 08-% ICMS
				 {'ED_VLICM',  'N', 15,  2},;	// 09-Valor do ICMS
				 {'ED_PIPI',   'N',  5,  2},;	// 10-% IPI
				 {'ED_IPI' ,   'N', 15,  2},;	// 11-Valor do IPI
				 {'ED_VENDA',  'N', 15,  2},;	// 12-Valor de Venda
				 {'ED_BICMS',  'N', 15,  2},;	// 13-Base ICMS
				 {'ED_ISENT',  'N', 15,  2},;	// 14-Valor Isentas
				 {'ED_OUTRA',  'N', 15,  2},;	// 15-Valor Outras
				 {'ED_CODOP',  'N',  7,  0},;	// 16-Cod Operacao
				 {'ED_CODTR',  'C',  3,  0},;	// 17-Cod Situação Tributaria
				 {'ED_CTACTB', 'N',  4,  0},;	// 18-Cod Conta Contabil Debito Direto
				 {'ED_CODCOF', 'C',  3,  0},;	// 19-Tabela Pis+Cofins
				 {'ED_VLPIS',  'N', 10,  2},;	// 20-Valor Pis - NF
				 {'ED_VLCOFI', 'N', 10,  2},;	// 21-Valor Cofins - NF
				 {'ED_FVLPIS', 'N', 10,  2},;	// 20-Valor Pis - FRETE
				 {'ED_FVLCOFI','N', 10,  2},;	// 21-Valor Cofins - FRETE
				 {'ED_NROADT', 'N',  5,  0},;	// 22-Numero Adiantamento
				 {'ED_CFISIPI','C', 10,  0},;	// 23-Classif Fiscal - IPI
				 {'ED_DESTRAN','N',  4,  0},;	// 24-Conta Contábil-Destino-Tranferencia-DEBITO
				 {'ED_DESTRAC','N',  4,  0},;	// 25-Conta Contábil-Destino-Tranferencia-CREDITO
				 {'ED_QTDENTR','N', 13,  3},;	// 26-Quantidade Original Entrada
				 {'ED_UNIENTR','C',  5,  0},;	// 27-Unidade Original de Entrada
				 {'ED_FATENTR','N', 15,  6}},;// 28-Fator de conversao usado na entrada para inventário
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* HISTORICO CLIENTE
cArq:='CFEAHC'
if dbatual(cArq,;
				{{'HC_CODCL' ,'N',  6,  0},;	//  1 Cod.Cliente
				 {'HC_DUPLI' ,'N', 11,  0},;	//  2 Duplicata
				 {'HC_DTEMI' ,'D',  8,  0},;	//  3 Dt.Emissao
				 {'HC_DTVEN' ,'D',  8,  0},;	//  4 Dt.Vencimento
				 {'HC_DTPGT' ,'D',  8,  0},;	//  5 Dt.Pagamento
				 {'HC_VLRDP' ,'N', 15,  2},;	//  6 Vlr.Duplicata
				 {'HC_VLRPG' ,'N', 15,  2},;	//  7 Vlr.Pago
				 {'HC_VLRJU' ,'N', 15,  2},;	//  8 Vlr.JUROS
				 {'HC_VLRDE' ,'N', 15,  2},;	//  9 Vlr.DESCONTOS
				 {'HC_VLRMO' ,'N', 15,  2},;	// 10 Vlr.Pago em (MOEDA)
				 {'HC_NRNF'  ,'N',  9,  0},;	// 11 Numero da NF
				 {'HC_SERIE' ,'C',  3,  0},;	// 12 Serie da NF
				 {'HC_CXACG', 'N',  3,  0},;	// 13 Codigo Caixa
				 {'HC_FLCXA' ,'L',  1,  0},;	// 14 Caixa Integrado ?
				 {'HC_FLBCO' ,'L',  1,  0},;	// 15 Bancos Integrado ?
				 {'HC_VLRET' ,'N', 15,  2},;	// 16 Vlr Retido
				 {'HC_VLBON' ,'N', 15,  2},;	// 17 Vlr Bonificado
				 {'HC_CDCXA' ,'N',  2,  0}},;	// 18 Codigo do Caixa
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* HISTORICO FORNENCEDOR
cArq:='CFEAHF'
if dbatual(cArq,;
				{{'HF_CODFO', 'N',  6,  0},;	//  1-Cod.Fornecedor
				 {'HF_DUPLI' ,'N', 11,  0},;	//  2-Duplicata (9999999-99)
				 {'HF_DTEMI' ,'D',  8,  0},;	//  3-Dt.Emissao
				 {'HF_DTVEN' ,'D',  8,  0},;	//  4-Dt.Vencimento
				 {'HF_DTPGT' ,'D',  8,  0},;	//  5-Dt.Pagamento
				 {'HF_VLRDP' ,'N', 15,  2},;	//  6-Vlr.Duplicata
				 {'HF_VLRPG' ,'N', 15,  2},;	//  7-Vlr.Pago
				 {'HF_VLRJU' ,'N', 15,  2},;	//  8-Vlr. JUROS
				 {'HF_VLRDE' ,'N', 15,  2},;	//  9-Vlr. DESCONTOS
				 {'HF_VLRMO' ,'N', 15,  2},;	// 10-Vlr.Pago em (MOEDA)
				 {'HF_NRNF'  ,'N',  9,  0},;	// 11 Numero da NF
				 {'HF_SERIE' ,'C',  3,  0},;	// 12 Serie da NF
				 {'HF_CXACG', 'N',  3,  0},;	// 13 Caixa Contas e Grupos
				 {'HF_FLCXA' ,'L',  1,  0},;	// 14 Caixa Integrado ?
				 {'HF_FLBCO' ,'L',  1,  0},;	// 15 Bancos Integrado ?
				 {'HF_VLRET' ,'N', 15,  2},;	// 16 Vlr Retido
				 {'HF_VLBON' ,'N', 15,  2},;	// 17 Vlr Bonificado
				 {'HF_CDCXA' ,'N',  2,  0}},;	// 18 Codigo do Caixa
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*-----------------------------------------------* PROD & FORN / FORN & PROD
cArq:='CFEAPF'
if dbatual(cArq,;
				{{'PF_CODPR', 'N', L_P,  0},;	// 1-Cod.Produto
				 {'PF_CODFO', 'N',   6,  0},;	// 2-Cod.Fornecedor
				 {'PF_DATA',  'D',   8,  0},;	// 3-data Ultima Compra
				 {'PF_PRECO', 'N',  12,  2},; // 4-Vlr unit ultima compra
				 {'PF_OBS',   'C',  15,  0}},;// 5-Observaçao sobre compra
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* DADOS CHEQUES
cArq:='CFEADA'
if dbatual(cArq,;
				{{'DA_PORTA' ,'C', 40,  0},;	// 1-Portador
				 {'DA_VALOR' ,'N', 15,  2},;	// 2-Valor
				 {'DA_DATA'  ,'D',  8,  0},;	// 3-Data
				 {'DA_NRCHE' ,'N',  6,  0}},;	// 4-Nr.Cheque
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Tabela ICMS
cArq:='CFEATI'
if dbatual(cArq,;
				{{'TI_UF'  ,'C',  2,  0},;	// 1-UF
				 {'TI_ENTR','N',  6,  2},;	// 2-% ICMS entrada
				 {'TI_SAID','N',  6,  2}},;// 3-% ICMS saida
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Tabela de moedas
cArq:='CFEAMO'
if dbatual(cArq,;
				{{'MO_DATA',   'D',  8,  0},;	// 1-DATA
				 {'MO_VLMOED1','N', 15,  2},;	// 2-% VALOR MOEDA 1 parametro US$
				 {'MO_VLMOED2','N', 15,  2}},;// 3-% VALOR MOEDA 2 urv
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Tabela Estoque - sped fiscal
cArq:='CFEAEST'
if dbatual(cArq,;
				{{'ES_CODES',  'N',  2,  0},;	// 1-Codigo Interno
				 {'ES_DESCR',  'C', 25,  0},;	// 2-Descricao
				 {'ES_TSPED',  'N',  2,  0}},;// 3-Codigo Sped
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end


*------------------------------------------------* Vendedores
cArq:='CFEAVE'
if dbatual(cArq,;
				{{'VE_CODIG', 'N',  3,  0},;	// 1
				 {'VE_NOME',  'C', 30,  0},;	// 2
				 {'VE_ENDER', 'C', 45,  0},;	// 3
				 {'VE_CEP',   'N',  8,  0},;	// 4
				 {'VE_CIDAD', 'C', 25,  0},;	// 5
				 {'VE_UF',    'C',  2,  0},;	// 6
				 {'VE_CPF',   'C', 11,  0},;	// 7
				 {'VE_RG',    'C', 16,  0},;	// 8
				 {'VE_DTNAS', 'C', 12,  0},;	// 9
				 {'VE_FONE',  'C', 15,  0},;	//10
				 {'VE_PERC',  'N',  5,  2},;	//11 % COMISSAO PRAZO
				 {'VE_PERCV', 'N',  5,  2}},;	//11 % COMISSAO VISTA
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Tabela de OBS
cArq:='CFEAOB'
if dbatual(cArq,{{'OB_DESCR','C',300, 0}},;	// OBSERVACOES
						RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* TABELA ESTOQUE X CTB
cArq:='CFEACC'
if dbatual(cArq,;
				{{'CC_TPMOV', 'C',   1,  0},;	// E=entrada// S=Saida
				 {'CC_TPCFO' ,'N',   2,  0},;	// FORNECEDOR // CLIENTE
				 {'CC_TPEST', 'N',   2,  0},;	// TIPO ESTOQUE
				 {'CC_SEQUE' ,'N',   2,  0},;	// 
				 {'CC_CONTA' ,'N',   4,  0}},;
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* CARTAS A CLIENTES
cArq:='CFEACA'
if dbatual(cArq,;
				{{'CA_CODIG', 'C', 25, 0},;
				 {'CA_NRCAR', 'N',  1, 0},;
				 {'CA_DESCR', 'M', 10, 0}},;
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Parcelamento Pedido
cArq:='CFEAPP'
if dbatual(cArq,;
				{{'PP_PEDID', 'N',  6, 0},;
				 {'PP_PARCE', 'C',500, 0}},; // PARCELAMENTO DT+VLR(20)*PARC
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
	close
end

*------------------------------------------------* FARMACIA CLIENTES
cArq:='CFEAFC'
if dbatual(cArq,;
				{{'FC_EMPRESA','N',  5, 0},;
				 {'FC_CODIGO', 'C', 10, 0},;
				 {'FC_NOME',   'C', 40, 0},;
				 {'FC_ATIVO',  'L',  1, 0},;
				 {'FC_DATAD',  'D',  8, 0}},;
				 RDDSETDEFAULT()) // 
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* SALDOS ESTOQUE
cArq:='CFEASA'
if dbatual(cArq,;
				{{'SA_EMPRESA','N',   2, 0},;
				 {'SA_PERIOD', 'C',   6, 0},;
				 {'SA_CODPR',  'N', L_P, 0},;
				 {'SA_QTD',    'N',  13, 3},;	// qtde em estoque no fim mes
				 {'SA_VLR',    'N',  15, 2}},;
				 RDDSETDEFAULT()) // 
	ferase(cArq+OrdBagExt())
	close
end
return NIL
*--------------------------------------EOF------------------------------------*
