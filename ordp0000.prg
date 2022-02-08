#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function INIT_ORD()	//	Verifica Arquivos de ordem de Servico/producao			*
*-----------------------------------------------------------------------------*
local VM_CAMPO
local ARQ
ARQ:='ORDAPA'
if dbatual(ARQ,;
					{{'PA_SEQ',    'N', 6, 0},; // nr seq para ordem
					 {'PA_ORCAM',  'N', 6, 0},; // numero sequencia orcamento
					 {'PA_TIPO',   'C', 1, 0},; // C-Comprov Carro //E-Eletrod //P-PRODUCAO
					 {'PA_DESCR1', 'C',15, 0},; // Mecanicos/Maquinas
					 {'PA_DESCR2', 'C',15, 0},; // Equipamento/Desenho
					 {'PA_DESCR3', 'C',15, 0},; // Odem de Servico/Producao
					 {'PA_INTFAT', 'L', 1, 0}},; // Integracao - Faturamento
					RDDSETDEFAULT()) 
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		if lastrec()=0
			dbappend(.T.)
			replace  PA_SEQ    with 1,;
						PA_ORCAM  with 0,;
						PA_TIPO   with 'E',;
						PA_DESCR1 with 'Mecanicos',;
						PA_DESCR2 with 'Equipamento',; // placa / equipamento / desenho
						PA_DESCR3 with 'Ordem Servico'
		elseif empty(PA_TIPO)
			replace PA_TIPO with 'E'
		end
		close
	else
		pb_fim('CFE')
	end
end

*----------------------------------------------------------* Mecanicos/Maquinas
ARQ:='ORDAMM'
if dbatual(ARQ,;
					{{'MM_CODIG', 'N', 2,  0},;	// 1-codigo
					 {'MM_NOME',  'C',30,  0},;	//	2-nome
					 {'MM_FUNC',  'C',20,  0},;	// 3-funcao
					 {'MM_VLRHR', 'N',10,  2},;	// 4-valor hora custo
					 {'MM_HRMES', 'N', 3,  0},;	// 5-nr horas no mes
					 {'MM_PPROD', 'N', 2,  0},;	// 6-% produtividade
					 {'MM_PASSID','N', 2,  0},;	// 7-% assiduidade
					 {'MM_PRESP', 'N', 2,  0},;	// 8-% responsabilidade
					 {'MM_CODPR', 'N',20,  0}},;	// 9-Numero produto Estoque
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando BASE HORAS',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(MM_CODIG,2) tag CODIGO to (Arq) eval ODOMETRO()
		Index on upper(MM_NOME)  tag ALFA   to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end	

*----------------------------------------------------------* Atividades Desenv
ARQ:='ORDAAT'
if dbatual(ARQ,;
					{{'AT_CODIG', 'N', 2,  0},;
					 {'AT_DESCR', 'C',40,  0},;
					 {'AT_VLRHR', 'N',10,  2},;
					 {'AT_CODCOS','C', 3,  0},; // CODIGO TABELE DE PIS/COFINS
					 {'AT_CTAC',  'N', 4,  0}},;
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando CAD.ATIVIDADES',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(AT_CODIG,2) tag CODIGO to (Arq) eval ODOMETRO()
		Index on upper(AT_DESCR) tag ALFA   to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end	

*----------------------------------------------------------* Precos/Clientes
ARQ:='ORDAPR'
if dbatual(ARQ,;
					{{'PR_CODCL', 'N', 5,  0},;
					 {'PR_CODAT', 'N', 2,  0},;
					 {'PR_VLRHR', 'N',10,  2}},;
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando Preco de Atividade X Cliente',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(PR_CODCL,5)+str(PR_CODAT,2) tag CODIGO to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end	

*----------------------------------------------------------*Equipamento/Desenho
ARQ:='ORDAED'
if dbatual(ARQ,;
					{{'ED_CODIG', 'C',12, 0},;
					 {'ED_DESCR', 'C',50, 0},;
					 {'ED_OBS',   'C',78, 0},;
					 {'ED_DTULM', 'D', 8, 0}},RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando EQUIPAMENTO/DESENHO',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on ED_CODIG        tag CODIGO to (Arq) eval ODOMETRO()
		Index on upper(ED_DESCR) tag ALFA   to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end	

*----------------------------------------------------------* Odem Serv/Producao
ARQ:='ORDAOR'
if dbatual(ARQ,;
					{{'OR_CODOR','N',  6, 0},;//	 1 CODIGO ORDEM SVC-PROD
					 {'OR_CODCL','N',  5, 0},;//	 2 CODIGO CLIENTE
					 {'OR_CODED','C', 12, 0},;//	 3 PARAM_3=DESENHO/EQUIPAMENTO
					 {'OR_NRCLI','C', 12, 0},;//	 4 Numero Solic do Cliente
					 {'OR_DTENT','D',  8, 0},;//	 5 data de Entrada 
					 {'OR_DTSAI','D',  8, 0},;//	 6 data de Saida
					 {'OR_FLAG', 'L',  1, 0},;//	 7 .T.Fechada/.F.NAO Fechada
					 {'OR_QUANT','N',  6, 1},;//	 8 Quantidade -> Producao
					 {'OR_PARC', 'N',  2, 0},;//	 9 Parcelamento
					 {'OR_VPROD','N', 12, 2},;//	10 Valor Produtos/Pecas
					 {'OR_VMDO', 'N', 12, 2},;//	11 Valor Mao de Obra
					 {'OR_VDESC','N', 10, 2},;//	12 Valor Desconto
					 {'OR_VACRE','N', 10, 2},;//	13 Valor Acrecimo
					 {'OR_VIPI', 'N', 10, 2},;//	14 Valor Acrecimo
					 {'OR_VICMS','N', 10, 2},;//	15 Valor Acrecimo
					 {'OR_SERIE','C',  3, 0},;//	16 Serie
					 {'OR_DPL',  'N',  6, 0},;//	17 Nr basico Duplicata
					 {'OR_OBS',  'C',300, 0}},;//	18 OBSERVACAO
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando ORDENS',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(OR_CODOR,6)                 tag CODIGO to (Arq) eval ODOMETRO()
		Index on str(OR_CODCL,5)+str(OR_CODOR,6) tag CLIENT to (Arq) eval ODOMETRO()
		Index on OR_CODED+dtos(OR_DTENT)         tag EQUIPA to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end

*----------------------------------------------------* Itens Odem Serv/Producao
ARQ:='ORDAIT'
if dbatual(ARQ,;
					{{'IT_CODOR','N',  6, 0},;//	1 CODIGO ORDEM SVC-PROD
					 {'IT_TIPO', 'N',  1, 0},;//	2 TIPO=1=PRODUTO /2=HORA
					 {'IT_DTLCT','D',  8, 0},;//	3 DATA LANCAMENTO
					 {'IT_CODPR','N',L_P, 0},;//	4 CODIGO PRODUTO/SERVICO
					 {'IT_CODAT','N',  2, 0},;//	5 TIPO=1=PRODUTO /2=HORA
					 {'IT_QTD',  'N',  9, 2},;//	6 QTDADE PROD/HORAS
					 {'IT_VLRRE','N', 14, 2},;//	7 VLR EM REAL VENDA
					 {'IT_VLRUS','N', 14, 2}},;//	8 VLR EM US$
					 RDDSETDEFAULT())//
	ferase(ARQ+OrdBagExt())
end

if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando ORDEM/ITENS',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(IT_CODOR,6)+str(IT_CODPR,L_P)+dtos(IT_DTLCT)                tag ORDEM1 to (ARQ) for IT_TIPO==1 eval ODOMETRO()
		Index on str(IT_CODOR,6)+str(IT_CODPR,2)+dtos(IT_DTLCT)                  tag ORDEM2 to (ARQ) for IT_TIPO==2 eval ODOMETRO()
		Index on str(IT_CODOR,6)+str(IT_TIPO,1)+str(IT_CODPR,L_P)+dtos(IT_DTLCT) tag ORDEMG to (ARQ)                eval ODOMETRO()
		Index on str(IT_CODPR,2)+str(IT_CODAT,2)+dtos(IT_DTLCT)                  tag HORAS  to (ARQ) for IT_TIPO==2 eval ODOMETRO()
		Index on str(IT_CODAT,2)+str(IT_CODPR,2)+dtos(IT_DTLCT)                  tag HRATIV to (ARQ) for IT_TIPO==2 eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end

*----------------------------------------------------* Produtos PAI
ARQ:='ORDAENGP'
if dbatual(ARQ,;
					{{'ITP_CODPRP','N',L_P,0},;// 1-Item
					 {'ITP_VERSAO','N',  3,0},;//	2 VERSAO
					 {'ITP_DTVALI','D',  8,0},;//	3 DATA INICIO VALIDADE
					 {'ITP_VLIMIT','N',  8,0},;//	4 LIMITE
					 {'ITP_OBS'   ,'C', 20,0}},;//5 Observacao
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando ITENS/FORMULAS-Pai',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(ITP_CODPRP,L_P)+str (ITP_VERSAO,3)       tag PRDVER to (Arq) eval ODOMETRO()
		Index on str(ITP_CODPRP,L_P)+dtos(ITP_DTVALI)         tag PRDVAL to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end

*----------------------------------------------------* Formulas Estrutura
ARQ:='ORDAENGF'
if dbatual(ARQ,;
					{{'ITF_CODPRP','N',L_P,0},;//	1-Item produto Pai
					 {'ITF_VERSAO','N',  3,0},;//	2 VERSAO
					 {'ITF_CODPR', 'N',L_P,0},;//	3 Item produto FILHO
					 {'ITF_QTDADE','N',  8,3}},;//4 Quantidade
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando ITENS/FORMULAS-Filho',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(ITF_CODPRP,L_P)+str(ITF_VERSAO,3)+str(ITF_CODPR,L_P) tag PRDVERFIL to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end

*----------------------------------------------------------* Orcamento CAB
ARQ:='ORDAOC'
if dbatual(ARQ,;
					{{'OC_CODOC', 'N',   6, 0},;//	 1 CODIGO ORCAMENTO
					 {'OC_SEQ',   'N',   2, 0},;//	 2 SEQUENCIA
					 {'OC_CODCL' ,'N',   5, 0},;//	 3 CODIGO CLIENTE
					 {'OC_CODED' ,'C',  12, 0},;//	 4 PARAM_3=DESENHO/EQUIPAMENTO
					 {'OC_DTPRO' ,'D',   8, 0},;//	 5 data proposta
					 {'OC_DTVAL' ,'D',   8, 0},;//	 6 data de validade proposta
					 {'OC_TIPO'  ,'C',   1, 0},;//	 7 Tipo Orcamento u=unitario t=total
					 {'OC_QUANT' ,'N',   9, 2},;//	 8 Quantidade -> Producao
					 {'OC_SITUA' ,'C',   1, 0},;//	 9 A-aprovado C-Cancelada A-Aprova
					 {'OC_DTAPR' ,'D',   8, 0},;//	10 Data aprovacao
					 {'OC_CODOR' ,'N',   6, 0},;//	11 Numero Ord Prod<-Aprovado
					 {'OC_VPROD' ,'N',  12, 2},;//	12 Valor Tot Produtos/Pecas
					 {'OC_VMDO' , 'N',  12, 2},;//	13 Valor Tot Mao de Obra
					 {'OC_VICMS', 'N',  12, 2},;//	14 Valor ICMS
					 {'OC_VIPI' , 'N',  12, 2},;//	15 Valor IPI
					 {'OC_VFRET', 'N',  12, 2},;//	16 Valor FRETE
					 {'OC_ORDCOM','C',  10, 0},;//	17 Nr Ordem Compra Cliente
					 {'OC_OBS'   ,'C', 120, 0}},;//	18 Observacao
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando ORCAM/CABEC',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(OC_CODOC,6)+str(OC_SEQ,2)		tag CODORCT  to (Arq) eval ODOMETRO(Arq)
		Index on str(OC_CODOC,6)+str(OC_SEQ,2)		tag CODORCA  to (ARQ) eval ODOMETRO(Arq) for OC_SITUA=='E' // Esperando
		Index on str(OC_CODCL,5)+str(OC_CODOC,6)+str(OC_SEQ,2);
																tag CLIORC   to (Arq) eval ODOMETRO(Arq)
		Index on OC_CODED+dtos(OC_DTPRO)				tag EQUIDT   to (Arq) eval ODOMETRO(Arq)
		Index on str(OC_CODOR,6)						tag ORDPRO   to (Arq) eval ODOMETRO(Arq) // CODIGO DE PRODUCAO
		close
	else
		pb_fim('CFE')
	end
end

*----------------------------------------------------* Orcamento Detalhe
ARQ:='ORDAOD'
if dbatual('ORDAOD',;
					{{'OD_CODOC','N',  6, 0},;//	1 CODIGO ORCAMENTO
					 {'OD_SEQ',  'N',  2, 0},;//	2 SEQUENCIA DE OCAMENTO
					 {'OD_CODPR','N',L_P, 0},;//	3 CODIGO PRODUTO/MECMAQ-ATIVIDADE
					 {'OD_TIPO', 'N',  1, 0},;//	4 TIPO=1=PRODUTO /2=HORAS
					 {'OD_QTD',  'N',  9, 2},;//	5 QTDADE PROD/HORAS
					 {'OD_VLRRE','N', 14, 2},;//	6 VLR EM REAL VENDA TOTAL
					 {'OD_VLRUS','N', 14, 2}},;//	7 VLR EM US$ TOTAL
					 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

if !file(ARQ+OrdBagExt())
	pb_msg('Reordenando ORCAM/DETALHE',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		Index on str(OD_CODOC,6)+str(OD_SEQ,2)+str(OD_TIPO,1)+str(OD_CODPR,L_P) tag CODIGO to (Arq) eval ODOMETRO()
		close
	else
		pb_fim('CFE')
	end
end
return NIL

*-----------------------------------------------------------------------------*
