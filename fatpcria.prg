*-----------------------------------------------------------------------------*
 function FATPCRIA(P1)	//	Criacao dos cArquivos do faturamento
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_CAMPO
local VM_X
local VM_C
local cArq
*------------------------------------------------> Condicoes de Pagamento
*------------------------------------------------* Pedido/Cabecalho
cArq:='CFEAPC'
if dbatual(cArq,;
				{{'PC_PEDID' ,'N',  6,  0},;	// 01-Nr.PEDIDO
				 {'PC_CODCL' ,'N',  5,  0},;	// 02-Cod.Cliente
				 {'PC_CODBC' ,'N',  2,  0},;	// 03-Cod.Banco
				 {'PC_DTEMI' ,'D',  8,  0},;	// 04-Dt.Emissao
				 {'PC_DTSAI' ,'D',  8,  0},;	// 05-Dt.Saida (18/04/2012)
				 {'PC_DTCAN' ,'D',  8,  0},;	// 06-Dt.Cancelamento (18/04/2012)
				 {'PC_DESC'  ,'N', 15,  2},;	// 07-Vlr.Desconto Geral
				 {'PC_DESCIT','N', 15,  2},;	// 08-Soma Vlr.Desconto por Itens
				 {'PC_TOTAL', 'N', 15,  2},;  // 09-Vlr Total Nota - Descontos
				 {'PC_VLRENT','N', 15,  2},;  // 10-Valor da Entrada (pagamento)
				 {'PC_ENCFI', 'N', 15,  2},;  // 11-Encargo Financeiros
				 {'PC_VLROBS','N', 15,  2},;  // 12-Valor Obs para Livro de Saida
				 {'PC_CODCG', 'N',  3,  0},;  // ---Cod Grupo Caixa
				 {'PC_CODOP', 'N',  7,  0},;  // 13-COD OPERACAO/Natureza Operacao
				 {'PC_FATUR', 'N',  2,  0},;  // 14-Faturamento 0=vista/1,2,3..parc
				 {'PC_NRDPL', 'N',  9,  0},;  // 15-Nr Duplicata (BASICO)+00
				 {'PC_NRNF',  'N',  9,  0},;  // 16-Nr Nota Fiscal
				 {'PC_VEND',  'N',  3,  0},;  // 17-Codigo do Vendedor
				 {'PC_FLAG',  'L',  1,  0},;  // 18-NF IMPRESSA ?
				 {'PC_SERIE', 'C',  3,  0},;  // 19-SERIE DA NF
				 {'PC_OBSER', 'C',300,  0},;  // 20-Observacoes
				 {'PC_DESVC', 'C', 80,  0},;  // 21-Descricao dos Servicos
				 {'PC_FLDUP', 'L',  1,  0},;  // 22-DPLS IMPRESSA ?
				 {'PC_TPDOC', 'C',  3,  0},;  // 23-Tipo de Documento
				 {'PC_CODFC', 'C', 10,  0},;  // 24-Cod funcionario(Convenio)
				 {'PC_FLCAN', 'L',  1,  0},;  // 25-FLAG NF Cancelada ?
				 {'PC_FLCTB', 'L',  1,  0},;  // 26-FLAG Contabilizada ?
				 {'PC_FLOFI', 'L',  1,  0},;  // 27-FLAG NF Inte Obrig Fiscal
				 {'PC_FLCXA', 'L',  1,  0},;  // 28-FALG de Caixa integrado 
				 {'PC_FLSVC', 'L',  1,  0},;  // 29-FALG de Nota Tipo Servico 
				 {'PC_FLADTO','L',  1,  0},;	// 30-Flag Adiantamento
				 {'PC_NRCXA', 'N',  2,  0},;  // 31-Numero do Caixa de venda
				 {'PC_LOTE',  'N',  4,  0},;  // 32-Lote parceria - alojamento
				 {'PC_TPTRAN','N',  1,  0},;  // 33-Tipo de Transferencia(1=Custo/2=Margem)
				 {'PC_NSU',   'N', 10,  0},;  // 34-Numero Sequencial Unico
				 {'PC_CFRETE','C', 30,  0},;  // 35-MODELO=08...CLIENTE(5)+NF(6)+SERIE(3)+VALOR*100(14)
				 {'PC_NFEKEY','C', 44,  0},;  // 36-CHAVE NFE
				 {'PC_NFEDEV','C', 44,  0},;  // 36-CHAVE NFE-Devolução
				 {'PC_OBSLIV','C', 24,  0},;  // 37-Observação para Livros Fiscais
				 {'PC_GERAC', 'C',  1,  0},;	// 38-G-GERADO A-ALTERADO M-MANUAL (Inlcusao)
				 {'TR_CODTRA','N',  6,  0},;  // 01-Transportador - Codigo
				 {'TR_NOME',  'C', 40,  0},;  // 02-Transportador - Nome
				 {'TR_ENDE',  'C', 40,  0},;  // 03-Transportador - Endereco
				 {'TR_MUNI',  'C', 20,  0},;  // 04-Transportador - Municipio
				 {'TR_UFT',   'C',  2,  0},;  // 05-Transportador - UF
				 {'TR_TIPO',  'N',  1,  0},;  // 06-Transportador - Tipo Frete (1=Emitente 2=Destinatário)
				 {'TR_PLACA', 'C',  7,  0},;  // 07-Transportador - Placa
				 {'TR_UFV',   'C',  2,  0},;  // 08-Transportador - UF-Veiculo
				 {'TR_CGC',   'C', 18,  0},;  // 09-Transportador - CGC/CFG
				 {'TR_INCR',  'C', 18,  0},;  // 10-Transportador - Inscricao
				 {'TR_QTDEM', 'N',  9,  2},;  // 11-Transportador - Qtde Embalag
				 {'TR_ESPE',  'C', 20,  0},;  // 12-Transportador - Especie Embalag
				 {'TR_MARC',  'C', 20,  0},;  // 13-Transportador - Marca
				 {'TR_PBRU',  'N',  9,  2},;  // 14-Transportador - Peso Bruto
				 {'TR_PLIQ',  'N',  9,  2},;	// 15-Transportador - Peso Liquido
				 {'TR_PICMS', 'N',  5,  2},;	// 16-%     Icms Frete 
				 {'TR_BICMS', 'N', 15,  2},;	// 17-Base  Icms Frete
				 {'TR_VICMS', 'N', 15,  2}},; // 18-Valor Icms Frete
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
// Indice em ==> CFEPIND1.PRG

*------------------------------------------------* Pedido/Detalhe
cArq:='CFEAPD'
if dbatual(cArq,;
				{{'PD_PEDID',  'N',  6, 0},;	// 01-Nr.PEDIDO
				 {'PD_ORDEM' , 'N',  2, 0},;	// 02-Nr de Ordem
				 {'PD_CODPR' , 'N',L_P, 0},;	// 03-Cod.Produto
				 {'PD_QTDE'  , 'N', 13, 3},;	// 04-Qtde.Movimentada
				 {'PD_VALOR' , 'N', 15, 4},;	// 05-Vlr Item Venda (UNITARIO)
				 {'PD_VLRMD' , 'N', 15, 4},;	// 06-Vlr Item Medio (TOTAL)
				 {'PD_DESCV' , 'N', 12, 2},;	// 07-Desconto Valor Item
				 {'PD_DESCG' , 'N', 12, 2},;	// 08-Desconto Proporc/Geral
				 {'PD_ENCFI' , 'N', 12, 2},;	// 09-Encargo Financeior
				 {'PD_CODTR' , 'C',  3, 0},;	// 10-Codigo Tributario
				 {'PD_ICMSP' , 'N',  5, 2},;	// 11-% ICMS
				 {'PD_VLICM' , 'N', 12, 2},;	// 12-Valor do ICMS
				 {'PD_BAICM' , 'N', 12, 2},;	// 13-ICMS-Base
				 {'PD_VLIRR' , 'N', 12, 2},;	// 14-Valor do IRRF
				 {'PD_VLISS' , 'N', 12, 2},;	// 15-Valor do ISS
				 {'PD_CODOP',  'N',  7, 0},;	// 16-Nat Operação
				 {'PD_PTRIB' , 'N',  6, 2},;	// 17-% Tributacao (sobre imposto)
				 {'PD_VLROU' , 'N', 12, 2},;	// 18-ICMS-Vlr Outros = Livro Fiscal
				 {'PD_VLRIS' , 'N', 12, 2},;	// 19-ICMS-Vlr Isentos = Livro Fiscal
				 {'PD_CODCOF', 'C',  3, 0},;	// 20-Codigo Tabela Interna Pis+Cofins
				 {'PD_VLPIS',  'N', 10, 2},;	// 21-Valor Pis
				 {'PD_VLCOFI', 'N', 10, 2},;	// 22-Valor Cofins
				 {'PD_VLITEM', 'N', 12, 2},;	// 23-Valor Tot Liquido do item (-desconto)
				 {'PD_NROADT', 'N',  5, 0},;	// 24-Numero Adiantamento
				 {'PD_CFISIPI','C', 10, 0},;	// 25-CodFiscal-IPI
				 {'PD_DESTRAN','N',  4, 0},;	// 26-Conta Contábil-Destino-Tranferencia-Debito
				 {'PD_DESTRAC','N',  4, 0},;	// 27-Conta Contábil-Destino-Tranferencia-Credito
				 {'PD_VLCOMIS','N', 12, 2},;	// 28-Valor da Comisao
				 {'PD_UNIDEST','C',  5, 0},;	// 29-Unidade de Estoque
				 {'PD_UNIDVEN','C',  5, 0}},;	// 30-Unidade de Venda
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Pedido/Detalhe servico
cArq:='CFEAPS'
if dbatual(cArq,;
				{{'PS_PEDID', 'N',  6,  0},;	// 01-Nr.PEDIDO
				 {'PS_ORDEM' ,'N',  2,  0},;	// 02-Nr de Ordem
				 {'PS_CODSVC','N',  3,  0},;	// 03-Cod.Servico
				 {'PS_QTDE'  ,'N', 13,  3},;	// 04-Qtde.Movimentada
				 {'PS_VALOR' ,'N', 15,  3},;	// 05-Vlr unitario Item Venda
				 {'PS_DESCV' ,'N', 12,  2},;	// 07-Desconto Valor
				 {'PS_DESCG' ,'N', 12,  2},;	// 08-Desconto Proporc/Geral
				 {'PS_ENCFI' ,'N', 12,  2},;	// 09-Encargo Financeior
				 {'PS_CODTR' ,'C',  3,  0},;	// 10-Codigo Tributario
				 {'PS_ICMSP' ,'N',  5,  2},;	// 11-% ICMS
				 {'PS_VLICM' ,'N', 12,  2},;	// 12-Valor do ICMS
				 {'PS_BAICM' ,'N', 12,  2},;	// 13-Base do ICMS
				 {'PS_VLIRR' ,'N', 12,  2},;	// 14-Valor do IRRF
				 {'PS_VLISS' ,'N', 12,  2},;	// 15-Valor do ISS
				 {'PS_CODOP', 'N',  7,  0},;  // 16-COD OPERACAO
				 {'PS_PTRIB' ,'N',  6,  2},;	// 17-% Tributacao
				 {'PS_VLROU' ,'N', 12,  2},;	// 18-Vlr Outros = Livro Fiscal
				 {'PS_VLRIS' ,'N', 12,  2},;	// 19-Vlr Isento = Livro Fiscal
				 {'PS_CODCOF','C',  3,  0},;	// 20-Tabela Pis+Cofins
				 {'PS_VLPIS', 'N', 10,  2},;	// 21-Valor Pis
				 {'PS_VLCOFI','N', 10,  2},;	// 22-Valor Cofins
				 {'PS_VLITEM','N', 12,  2}},;	// 23-Valor tot liquido do item (-desconto)
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* Condicoes de pagamento
cArq:='FATACP'
if dbatual(cArq,;
				{{'CP_CODCP',  'N',  3, 0},; 	// Codigo Condicoes de Pagamento
				 {'CP_DESCR',  'C', 30, 0},; 	// Descricao
				 {'CP_PARC',   'N',  3, 0},; 	// Nr Parcela
				 {'CP_AUMENT', 'N',  8, 3},; 	// Acrescimo no vlr Vista
				 {'CP_PERENT', 'N',  3, 0},; 	// Percentual Entrada
				 {'CP_DIAEPA', 'N',  2, 0}},; // Dias Entre Parcelas
				 RDDSETDEFAULT())
end

*------------------------------------------------* Dig Inventario
cArq:='INVADA'
if dbatual(cArq,;
				{{'IN_CODIN', 'N',  4, 0},; 	// 1-Numero do Inventario
				 {'IN_SEQ',   'N',  2, 0},; 	// 2-Seq.
				 {'IN_CODPR', 'N',L_P, 0},; 	// 3-Codigo do Produto
				 {'IN_QTDE',  'N', 11, 3},; 	// 4-Quantidade
				 {'IN_DATA',  'D',  8, 0},;	// 5-Data Entrada
				 {'IN_TIPOM', 'C',  1, 0}},;	// 6-Tipo Movimento
				 RDDSETDEFAULT())
end

return NIL

function FATPINDI(P1)	//	Criacao dos cArquivos do faturamento
*-------------------------------------------------------------------------*
local cArq:='FATACP'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CONDICOES DE PAGAMENTO - Reg:'+str(LastRec(),7))
		pack
		Index on str(CP_CODCP,3) tag CODIGO to (cArq) eval {||ODOMETRO('CODIGO')}
		Index on upper(CP_DESCR) tag ALFA   to (cArq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* Dig Inventario
cArq:='INVADA'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. DADOS DE INVENTARIOS - Reg:'+str(LastRec(),7))
		pack
		Index on str(IN_CODIN,4)+str(IN_SEQ,2)+str(IN_CODPR,L_P) tag CODIGO  to (cArq) eval {||ODOMETRO('CODIGOI')} for IN_TIPOM=='I'
		Index on str(IN_CODIN,4)+str(IN_SEQ,2)+str(IN_CODPR,L_P) tag CODIGOP to (cArq) eval {||ODOMETRO('CODIGOP')} for IN_TIPOM=='P'
		close
	end
end

cArq:='CFEAPS'
*------------------------------------------------* Pedido/Detalhe SERVICOS
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. Pedidos/DET/SVC - Reg:'+str(LastRec(),7))
		pack
		Index on str(PS_PEDID,6)+str(PS_ORDEM,2) tag SVCSEQ to (cArq) eval {||ODOMETRO()}
		close
	end
end
return NIL
*-------------------------------------------------EOF-------------------------------------------*
