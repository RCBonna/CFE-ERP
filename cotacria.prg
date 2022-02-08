*-----------------------------------------------------------------------------*
function CotaCria(P1,P2)	//	Criacao dos arquivos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local ARQ

*------------------------------------------------* PARAMETROS
ARQ:='COTAPA'
if dbatual(ARQ,;
				{{'PA_CTA01',  'N',  4, 0},;  //D-SUBSCRICAO
				 {'PA_CTA02',  'N',  4, 0},;	//C-SUBSCRICAO
				 {'PA_HIST1',  'C', 40, 0},;
				 {'PA_CTA03',  'N',  4, 0},;	//D-BAIXA
				 {'PA_CTA04',  'N',  4, 0},;	//C-BAIXA
				 {'PA_HIST2',  'C', 40, 0},;
				 {'PA_CTA05',  'N',  4, 0},;	//D-SOBRA-DISTRIBUIR-AGO
				 {'PA_CTA06',  'N',  4, 0},;	//C-SOBRA-DISTRIBUIR-
				 {'PA_HIST3',  'C', 40, 0}},;
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* COTA PARTE COOPERATIVA-EXTRATO
ARQ:='CFEACP'
if dbatual(ARQ,;
				{{'CP_CODCL',  'N',  5, 0},;
				 {'CP_DATAE',  'D',  8, 0},;
				 {'CP_VALOR',  'N', 15, 2},;
				 {'CP_HISTOR', 'C', 60, 0}},;
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* COTA PARTE DUPLICATA
ARQ:='COTADV'
if dbatual(ARQ,;
				{{'DV_CODCL',  'N',  5, 0},;	//1-Associado
				 {'DV_DATA',   'D',  8, 0},;	//2-Data Vencimento
				 {'DV_SLDINI', 'N', 15, 2},;	//3-Saldo Inicial
				 {'DV_VLRPG',  'N', 15, 2},;	//4-Valor Pago/Recebido
				 {'DV_TPMOV',  'C',  1, 0},;	//5-TIPO MOVIMENTO(P/R)
				 {'DV_FLCTB',  'L',  1, 0},;	//6-Flag - Contabilizado ?
				 {'DV_DTMOV',  'D',  8, 0}},;	//7-DATA Movimento
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* COTA PARTE DUPLICATA/MOVIMENTO
ARQ:='COTAMV'
if dbatual(ARQ,;
				{{'MV_CODCL',  'N',  5, 0},;	// 1-Associado
				 {'MV_DATA',   'D',  8, 0},;	// 2-DATA MOVIMENTO
				 {'MV_VALOR',  'N', 15, 2},;	// 3-VALOR MOVIMENTADO
				 {'MV_TPMOV',  'C',  1, 0},;	// 4-TIPO DE MOVIMENTO(P/R)
				 {'MV_CODBC',  'N',  2, 0},;	// 5-CODIGO PARA BANCO
				 {'MV_CODCX',  'N',  2, 0},;	// 6-CODIGO PARA CAIXA
				 {'MV_NRDOC',  'N',  6, 0},;	// 7-CODIGO PARA CAIXA
				 {'MV_FLCTB',  'L',  1, 0},;	// 8-Flag - Contabilizado ?
				 {'MV_FLCXA',  'L',  1, 0}},;	// 9-Flag - Lcto no Caixa ?
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
end

*---------------------------------------------* COTA PARTE COOPERATIVA-SOBRAS
ARQ:='CFEACPS'
if dbatual(ARQ,;
				{{'CP_ANO',		'N',  4, 0},;	// ano da distribuicao
				 {'CP_VALORE', 'N', 15, 2},;	// valor das compras
				 {'CP_VALORS', 'N', 15, 2},;	// valor das vendas
				 {'CP_VALORD', 'N', 15, 2},;	// valor da DISTRIB Sobra-Extrato
				 {'CP_VALORP', 'N', 15, 2},;	// valor da DISTRIB Sobra-Distribuicao-Pagamento
				 {'CP_DISTRI', 'L',  1, 0},;	// distribuido nao pode mexer
				 {'CP_HISTOR', 'C', 60, 0},;	// historico padrao-Capitalizacao
				 {'CP_HISTDS', 'C', 60, 0}},;	// historico padrao-Distribuiccao
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
end

*---------------------------------------------* COTA PARTE COOPERATIVA-CALCULO
ARQ:='CFEACPV'
if dbatual(ARQ,;
				{{'CP_CODCL',	'N',  5, 0},;	// 1-Codigo associado
				 {'CP_ANO',		'N',  4, 0},;	// 2-Ano de Processo
				 {'CP_VALORE', 'N', 15, 2},;	// 3-valor das nossas compras
				 {'CP_VALORS', 'N', 15, 2},;	// 4-valor das nossas vendas
				 {'CP_PERCENT','N', 10, 6},;	// 5-% de particip
				 {'CP_VLRSOBR','N', 15, 2},;	// 6-valor apropriado-Extrato
				 {'CP_VLRDIST','N', 15, 2},;	// 6-valor apropriado-Distribuicao
				 {'CP_VLRENBA','N', 15, 2},;	// 7-valor Entrada/Baixa
				 {'CP_DTENBA', 'D',  8, 0},;	// 8-Data Entrada/Baixa
				 {'CP_TIPOMV', 'C',  1, 0},;	// 9-S=Sobra B=Baixa E=Entrada
				 {'CP_HISTOR', 'C', 60, 0}},;	//10-Historico
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
	close
end

return NIL

*-------------------------------------------------------------------------------------------
function CotaCriaIndice(P1,P2)
*------------------------------------------------* COTA PARTE *-----------------------------
local ARQ:='CFEACP'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. COTAS PARTE - Reg:'+str(LastRec(),7))
		pack
		Index on str(CP_CODCL,5)+dtos(CP_DATAE) tag CODCLI to (Arq) eval {||ODOMETRO('CLIENTE+DATA')}
		close
	end
end

*------------------------------------------------* COTA PARTE -SOBRAS
ARQ:='CFEACPS'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. COTAS PARTE-SOBRAS - Reg:'+str(LastRec(),7))
		pack
		Index on str(CP_ANO,4) tag ANO to (Arq) eval {||ODOMETRO('ANO')}
		close
	end
end

*------------------------------------------------* COTA PARTE -SOBRAS
ARQ:='CFEACPV'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. COTAS PARTE-CALCULOS - Reg:'+str(LastRec(),7))
		pack
		Index on str(CP_CODCL,5)+str(CP_ANO,4) tag CODCLI to (Arq) eval {||ODOMETRO('ASSOC+ANO')}
		close
	end
end

*------------------------------------------------* COTA PARTE - PAGARxRECEBER
ARQ:='COTADV'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. COTA PARTE (VLR DEVIDOS/RECEBIDOS) - Reg:'+str(LastRec(),7))
		pack
		Index on str(DV_CODCL,5)+ dtos(DV_DATA)   tag ASSDT  to (Arq) eval {||ODOMETRO('ASSOC+DATA')}
		Index on str(DV_CODCL,5)+ dtos(DV_DATA)   tag ARECE  to (Arq) eval {||ODOMETRO('ASSOC+DATA SLD>0')} for DV_SLDINI>0
		Index on str(DV_CODCL,5)+ dtos(DV_DATA)   tag APAGA  to (Arq) eval {||ODOMETRO('ASSOC+DATA SLD<0')} for DV_SLDINI<0
		Index on dtos(DV_DATA)  + str(DV_CODCL,5) tag DTASS  to (Arq) eval {||ODOMETRO('DT+ASSOC')}
		Index on dtos(DV_DTMOV) + str(DV_CODCL,5) tag DTMASS to (Arq) eval {||ODOMETRO('DTMV ASSOC')}
		close
	end
end
*------------------------------------------------* COTA PARTE -SOBRAS
ARQ:='COTAMV'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. COTAS PARTE-VLR MOVIMENTOS - Reg:'+str(LastRec(),7))
		pack
		Index on str(MV_CODCL,5)+ dtos(MV_DATA)   tag ASSDT  to (Arq) eval {||ODOMETRO('ASSOC+DTMV')}
		Index on dtos(MV_DATA)  + str(MV_CODCL,5) tag DTASS  to (Arq) eval {||ODOMETRO('DTMV ASSOC')}
		close
	end
end
*-----------------------------------------------------------------------------*
return NIL
