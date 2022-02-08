#include 'RCB.CH' 

*-----------------------------------------------------------------------------*
function CXAPCRIA(P1)
*------------------------------------------------* PARAMETRO DE CAIXAS
local cArq:='CXAAPA'
if dbatual(cArq,;
				{{'PA_MODCX' ,'L',  1, 0},;	// 1-Modulo Caixa ?
				 {'PA_DTFECC','D',  8, 0},;	// 2-Ultima data fechada - CAIXA
				 {'PA_DTFECB','D',  8, 0},;	// 2-Ultima data fechada - BANCOS
				 {'PA_DTINTC','D',  8, 0},;	// 3-Data Ultima Integracao-CAIXA
				 {'PA_DTINTB','D',  8, 0},;	// 3-Data Ultima Integracao-BANCOS
				 {'PA_LIVRO' ,'N',  4, 0},;	// 4-Numero do Livro-Inicial
				 {'PA_PAGINA','N',  4, 0},;	// 5-Numero da Pagina-Inicial
				 {'PA_MARGEM','N',  3, 0}},;	// 6-Margem
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* CADASTRO DE BANCOS
cArq:='CFEABC'
if dbatual(cArq,;
				{{'BC_CODBC' ,'N',  2,  0},;	//  1-Cod.Banco
				 {'BC_DESCR' ,'C', 30,  0},;	//  2-Descricao
				 {'BC_AGENC' ,'C', 10,  0},;	//  3-BBB/NNNN-5 Banco(3)/Agencia(4)/D
				 {'BC_ENDER' ,'C', 45,  0},;	//  4-Endereco
				 {'BC_CEP'   ,'C',  8,  0},;	//  5-CEP
				 {'BC_CIDAD' ,'C', 20,  0},;	//  6-Cidade
				 {'BC_UF'    ,'C',  2,  0},;	//  7-UF
				 {'BC_CONTA', 'N',  4,  0},;	//  8-Codigo conta contabil - reduz
				 {'BC_SLDINI','N', 15,  2},;	//  9-Saldo Inicial Banco
				 {'BC_CAIXA', 'L',  1,  0},;	// 11-E' conta Caixa ?
				 {'BC_IMPCHE','L',  1,  0},;	// 12-IMPRIMIR CHEQUE
				 {'BC_ULTCHE','N',  6,  0},;	// 13-NUM ULT CH IMPRESSO
				 {'BC_PORCHE','N',  1,  0},;	// 14-Porta de impressao cheque
				 {'BC_NRLIN' ,'N',  2,  0},;	// 15-Nr.Linhas
				 {'BC_LPP' ,  'N',  1,  0},;	// 16-Linha p/polegada
				 {'BC_NRBOL', 'N', 16,  0},;	// 17-N£mero –ltimo Boleto Impresso+Digit
				 {'BC_USER',  'C',150,  0}},;	// 18-Seguran‡a
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* LAYOUT CHEQUES
cArq:='CFEALY'
if dbatual(cArq,;
				{{'LY_CODBC', 'N',  2,  0},;	// 1-Banco
				 {'LY_SEQ' ,  'N',  2,  0},;	// 4-Dado
				 {'LY_DADO' , 'C', 10,  0},;	// 4-Dado
				 {'LY_LINHA' ,'N',  2,  0},;	// 5-Posicao Linha
				 {'LY_COLUNA','N',  2,  0}},;	// 6-Posicao Coluna
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------* CAIXACG-Contas de Grupo
cArq:='CXAACG'
if dbatual(cArq,;
				{{'CG_CODCG',  'N',  3, 0},;
				 {'CG_DESCR',  'C', 30, 0},; 	// CONTA CONTABIL
				 {'CG_INFCX',  'L',  1, 0},; 	// Inclui no Caixa ?
				 {'CG_TIPOM',  'C',  1, 0}},; // Tipo de Movimentação (R-Receitas // D-Despesas  // N-Nula)
				 RDDSETDEFAULT()) //
	ferase(cArq+OrdBagExt())
	close
end

*------------------------------------------------* CAIXASA-SALDOS
cArq:='CXAASA'
if dbatual(cArq,;
				{{'SA_PERIOD', 'C',  6, 0},;	// AAAA/MM -> AAMMDD
				 {'SA_SALDO',  'N', 15, 2},;	//2
				 {'SA_DIARIO', 'N',  3, 0},;	//3
				 {'SA_FLAG',   'L',  1, 0},;	//4-FECHADO ?
				 {'SA_CODCXA', 'N',  2, 0}},;	//7-
				 RDDSETDEFAULT()) //
	ferase(cArq+OrdBagExt())
	close
end

*------------------------------------------------* CAIXA-MOVIMENTACAO
cArq:='CXAAMC'
if dbatual(cArq,;
				{{'MC_DATA',   'D',  8, 0},;
				 {'MC_CODCG',  'N',  3, 0},; // CONTAS DE GRUPO
				 {'MC_VALOR',  'N', 15, 2},;
				 {'MC_TIPO',   'C',  1, 0},;	// + Entrada - Saida
				 {'MC_HISTO',  'C', 60, 0},;
				 {'MC_CODCC',  'N',  4, 0},;	// CONTA CONTABIL
				 {'MC_ORIG',   'C',  2, 0},;	// Infor Bancos Fat Clientes/fornec
				 {'MC_CODCXA', 'N',  2, 0},;	// Numero do Caixa
				 {'MC_NRODOC', 'N',  9, 0}},;	// Numero do Documento
				 RDDSETDEFAULT()) //
	ferase(cArq+OrdBagExt())
	close
end

*------------------------------------------------* MOVIMENTO BANCOS
cArq:='CXAAMB'
if dbatual(cArq,;
				{{'MB_CODBC',  'N', 2, 0},;	// 1-Cod.Banco
				 {'MB_DATA',   'D', 8, 0},;	// 2-Data Movto
				 {'MB_DOCTO',  'N', 9, 0},;	// 3-Nr Documento
				 {'MB_HISTO',  'C',60, 0},;	// 4-Historico
				 {'MB_VALOR',  'N',15, 2},;	// 5-Valor
				 {'MB_TIPO',   'C', 1, 0},;	// 6-Tipo (+/-)
				 {'MB_SALDO',  'N',15, 2},;	// 7-Saldo para cada Lcto
				 {'MB_ORIG',   'C', 1, 0},;	// 8-Informado,Faturamento,Clientes,fOrnecedores
				 {'MB_FLCXA',  'L', 1, 0},;	// 9-Integrado no Caixa ?
				 {'MB_FLCTB',  'L', 1, 0},;	//10-Integrado Contabil ?
				 {'MB_EXTRA',  'L', 1, 0},;	//11-Ja conferido com extrato
				 {'MB_FECHADO','L', 1, 0}},;	//12-Ja fechado // 
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

return NIL

*-----------------------------------------------------------------------------*
function CXAPINDI(P1)	//	Indices do Modulo de Caixa
*-----------------------------------------------------------------------------*
local cArq:='CXAACG'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CAIXA-GRUPOS - Reg:'+str(LastRec(),7))
		pack
		Index on str(CG_CODCG,3)  tag CODIGO to (cArq) eval {||ODOMETRO('CODIGO')}
		Index on upper(CG_DESCR)  tag ALFA   to (cArq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* CADASTRO DE BANCOS
cArq:='CFEABC'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CADASTRO DE BANCOS - Reg:'+str(LastRec(),7))
		pack
		Index on str(BC_CODBC,2) tag CODIGO to (cArq) eval {||ODOMETRO('CODIGO')}
		Index on upper(BC_DESCR) tag ALFA   to (cArq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* LAYOUT DE CHEQUE
cArq:='CFEALY'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. LayOut Cheques - Reg:'+str(LastRec(),7))
		pack
		Index on str(LY_CODBC,2)+str(LY_SEQ,2) tag CODIGO to (cArq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* Saldos do caixa
cArq:='CXAASA'
if !file(cArq+OrdBagExt()).or.P1
//.............1...2...3..4...5...6....7
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CAIXA-SALDOS - Reg:'+str(LastRec(),7))
		pack
		Index on SA_PERIOD                   tag PERIOD to (cArq) eval {||ODOMETRO('PERIODO')}
		Index on str(SA_CODCXA,2)+SA_PERIOD  tag CODCXA to (cArq) eval {||ODOMETRO('COD.CXA')}
		close
	end
end

cArq:='CXAAMC'
if !file(cArq+OrdBagExt()).or.P1
//.............1...2...3..4...5...6....7
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CAIXA-MOVIMENTOS - Reg:'+str(LastRec(),7))
		pack
		Index on dtos(MC_DATA)                                   tag DATA   to (cArq) eval {||ODOMETRO('DATA')}
		Index on str(MC_CODCG,3)+dtos(MC_DATA)                   tag CODCG  to (cArq) eval {||ODOMETRO('COD+DT')}
		Index on str(MC_CODCXA,2)+dtos(MC_DATA)+str(MC_NRODOC,6) tag CODCXA to (cArq) eval {||ODOMETRO('COD+DT+NRO')}
		close
	end
end

cArq:='CXAAMB'
if !file(cArq+OrdBagExt()).or.P1
	//.............1...2...3..4...5...6....7
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. BANCO-MOVIMENTOS - Reg:'+str(LastRec(),7))
		pack
		Index on str(MB_CODBC,2)+dtos(MB_DATA)+str(MB_DOCTO,9)  tag DATA   to (cArq) eval {||ODOMETRO('BCO+DATA')}      for !MB_FECHADO
		Index on str(MB_CODBC,2)+str(MB_DOCTO,9)                tag DOCTO  to (cArq) eval {||ODOMETRO('BCO+DOC-FECH')}  for !MB_FECHADO
		Index on str(MB_CODBC,2)+dtos(MB_DATA)+str(MB_DOCTO,9)  tag GDATA  to (cArq) eval {||ODOMETRO('BCO+DATA+DOC')}
		Index on str(MB_CODBC,2)+str(MB_DOCTO,9)                tag GDOCTO to (cArq) eval {||ODOMETRO('BCO+DOC-TODOS')}
		close
	end
end

return NIL
