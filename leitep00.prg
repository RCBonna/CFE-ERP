//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.}
//....................1.2..3
//-----------------------------------------------------------------------------*
#xtranslate cArq			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate lCont			=> aVariav\[  3 \]

#include 'RCB.CH'
//-----------------------------------------------------------------------------*
  function LeiteP00()	//	Cadastro base Geral de Leite
//-----------------------------------------------------------------------------*
lCont:=.T.
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->LEIPARAM',;
				'C->PROD';
			})
	return NIL
end
private nX1
SELECT PROD
ORDEM CODIGO

SELECT LEIPARAM
for nX :=1 to fCount()
	nX1 :="VM"+substr(fieldname(nX),3)
	&nX1:=FieldGet(nX)
next
nX:=09
pb_box(nX++,0,,,,'LEITE-Parametros Gerais')
nX++
@nX++,01 say 'Codigo Leite............:' get VM_PROD		pict masc(21)	valid fn_codpr(@VM_PROD,77)
@nX  ,01 say 'Periodo Analise Leite...:' get VM_PERIODO pict mPER
@nX++,34 say '-'+VM_ERRANAL color 'GB+/G'
@nX++,01 say 'Diret.Export.Arq.Leite..:' get VM_DIREXPO pict mUUU 	valid IsDirectory(trim(VM_DIREXPO))
@nX++,01 say 'Diret.Import.Arq.Leite..:' get VM_DIRIMPO pict mUUU		valid IsDirectory(trim(VM_DIRIMPO))
@nX++,01 say 'Diret.Import.Arq.Laborat:' get VM_DIRIMPL pict mUUU		valid IsDirectory(trim(VM_DIRIMPL))
 nX++
@nX++,01 say 'Obs Laudo Leite:' 				get VM_MSGLEIT pict mXXX+'S60' ;
														when pb_msg('Observacao para extrato da Analise de Leite')
 nX++
//@nX++,01 say 'Vlr Leite Base...........:' get VM_VLBASE  pict mI85		valid VM_VLBASE  >=0 
//@nX++,01 say 'Vlr Leite-Adic.Fidelidade:' get VM_VLADFID pict mI85		valid VM_VLADFID >=0                 when	pb_msg('Vlr Adicional de Fidelidade (por tempo)')
//@nX++,01 say 'Vlr Leite-Adic.Mercado...:' get VM_VLADMER pict mI85		valid VM_VLADMER >=0                 when	pb_msg('Vlr Adicional de Mercado')
//@nX++,01 say 'Vlr Leite-Temperatura....:' get VM_VLTEMPE pict mI85		valid VM_VLTEMPE >=0                                               when           pb_msg('Vlr Adicional por Lt na Temperatura medida')
//@nX++,01 say 'Vlr Leite-Gordura........:' get VM_VLGORDU pict mI85		valid VM_VLGORDU >=0                                               when           pb_msg('Vlr Adicional por Kg Gordura')
//@nX++,01 say 'Vlr Leite-Adic.Volume....:' get VM_VLADVOL pict mI85		valid VM_VLADVOL >=0                                               when           pb_msg('Vlr Adicional por Volume Dia Entregue')
//@nX++,01 say 'Qtdade Max.Volume Lt Dia.:' get VM_QTMXADV pict mI5		valid VM_QTMXADV >=0                                               when           pb_msg('Limite Max Lt Adicional por Volume')

read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if RecCount()<1
		lCont:=AddRec()
	else
		lCont:=RecLock()
	end
	if lCont
		if LP_PERIODO#VM_PERIODO // Novo Período
			VM_ERRANAL:=''				// Erro no processo de Análise de Leite
		end
		for nX:=1 to fcount()
			nX1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &nX1
		next
		dbcommit()
	end
end
dbrunlock(recno())
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
	function Cria_LEITE(P1,P2) // Cria arquivos e Indices do Módulo Leite
//-----------------------------------------------------------------------------*
cArq:='LEIPARAM'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
					{{'LP_DIREXPO','C',  50, 0},;	// 1-Diretório de Exportação Dados Produtores Leite
					 {'LP_DIRIMPO','C',  50, 0},;	// 2-Diretório de Importação Dados Quant Leite
					 {'LP_DIRIMPL','C',  50, 0},;	// 3-Diretório de Importação Dados-Laboratório(LEITP00.PRG)
					 {'LP_MSGLEIT','C', 250, 0},;	// 4-Diretório de Importação Dados-Laboratório(LEITP00.PRG)
					 {'LP_PERIODO','C',   6, 0},;	// 5-Período de Análise de Leite
					 {'LP_ERRANAL','C',  60, 0},;	// 6-Erro na Análise de Leite-Período
					 {'LP_PROD',	'N', L_P, 0};	// 7-Codigo Produto Padrão Leite
					},;
					RDDSETDEFAULT())
	//-------------------------------------------sem indice
end

//----------------------------------ROTA----------------------------------------*
cArq:='LEIROTA'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'LR_CDROTA',  'N',  6, 0},;		// 1-Codigo Rota
				 {'LR_DESCR',   'C', 60, 0},;		// 2-Descrição Rota
				 {'LR_DTVALID', 'D',  8, 0};		// 3-Dt Validade Rota
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. LEITE-Rotas',NIL,.F.)
		pack
		Index on str(LR_CDROTA,6) tag CODIGO to (cArq) eval ODOMETRO()
		close
	end
end

//----------------------------------TRANSPORTADOR-------------------------------*
cArq:='LEITRANS'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'LT_CDROTA', 'N',  6, 0},;		// 1-Cod.Rota
				 {'LT_CDTRAN', 'N',  5, 0};		// 2-Cod.Transportador
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. LEITE-Transportadores',NIL,.F.)
		pack
		Index on str(LT_CDROTA,6)+str(LT_CDTRAN,5)	tag CODIGO to (cArq) eval ODOMETRO()
		Index on str(LT_CDTRAN,5) 							tag TRANSP to (cArq) eval ODOMETRO()
		close
	end
end
//----------------------------------VEICULOS-TRANSPORTADOR---------------------------*
cArq:='LEIVEIC'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'LV_CDTRAN',  'N',  5, 0},;		// 1-Cod.Transportador
				 {'LV_PLACA',   'C',  7, 0},;		// 2-Placa Veiculos do Transportador
				 {'LV_UFPLACA', 'C',  2, 0},;		// 2-UF=Placa Veiculos do Transportador
				 {'LV_VEITPV',  'C', 40, 0},;		// 3-Tipo Veiculo
				 {'LV_VEITPT',  'C', 20, 0},;		// 4-Tipo Tanque
				 {'LV_VEIANOV', 'N',  4, 0},;		// 5-Ano Veiculo
				 {'LV_VEICAPL', 'N',  6, 0},;		// 4-Capacidade Veículo em Litros
				 {'LV_VEINRT',  'N',  1, 0};		// 5-Numero de Tanques
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. LEITE-Veiculos x Transportadores',NIL,.F.)
		pack
		Index on str(LV_CDTRAN,5)+LV_PLACA 	tag CODIGO	to (cArq) eval ODOMETRO()
		Index on LV_PLACA 						tag PLACA	to (cArq) eval ODOMETRO()
		close
	end
end

//----------------------------------MENSAGENS-------------------------------------------*
cArq:='LEIMOTIV'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'LM_CDMOTIV',	'N',  4, 0},;		// 1-Cod.Motivo
				 {'LM_DESCR',		'C', 60, 0};		// 2-Descrição
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. LEITE-Motivos de Rejeicao',NIL,.F.)
		pack
		Index on str(LM_CDMOTIV,4) tag CODIGO 	to (cArq) eval ODOMETRO()
		Index on Upper(LM_DESCR) 	tag ALFA 	to (cArq) eval ODOMETRO()
		close
	end
end

//----------------------------------COMPLEMENTO DADOS DO CLIENTE----------------------*
cArq:='LEICPROD'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'LC_CDFILI',		'N',  2, 0},;	// 1-*Codigo Filiada/Filial
				 {'LC_CDCLI',		'N',  5, 0},;	// 2-*Codigo Cliente
				 {'LC_CDPROP',		'N',  2, 0},;	// 3-*Codigo Propriedade
				 {'LC_CDROTA',		'N',  6, 0},;	// 4-*Codigo Rota
				 {'LC_ESTABUL',	'N',  2, 0},;	// 5-*Nr.Estabulo
				 {'LC_TARRO',		'N',  6, 0},;	// 6-*Nr.Tarro
				 {'LC_SEQUENC',	'N',  3, 0},;	// 7-*Nr.Sequencia
				 {'LC_ANA_CCS',	'N',  6, 2},;	// 8-Análise-CCS
				 {'LC_ANA_CBT',	'N',  6, 2},;	// 9-Análise-CBT
				 {'LC_SIGSIF',		'N',  9, 0},;	//10-Nr.SIF (SIG)
				 {'LC_NIRF',		'N',  8, 0},;	//11-Nr.NIRF
				 {'LC_CAPRESF',	'N',  8, 0},;	//12-Capacidade de Resfriamento
				 {'LC_DTIENTR',	'D',  8, 0};	//13-Data Inicio Entrega Leite
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. LEITE-Complemento Dados Cliente',NIL,.F.)
		pack
		Index on str(LC_CDROTA,6)+str(LC_TARRO,6);
					tag OROTA			to (cArq) eval ODOMETRO()	// Única - Rota + Tarro
		Index on str(LC_CDCLI,5);
					tag CODCLI			to (cArq) eval ODOMETRO()
		Index on str(LC_CDFILI,2)+str(LC_CDCLI,5)+str(LC_CDPROP,2)+str(LC_CDROTA,6)+str(LC_ESTABUL,2)+str(LC_TARRO,6)+str(LC_SEQUENC,3);
					tag FILIPROD	to (cArq) eval ODOMETRO()	// Única, inclui afiliada
		close
	end
end

//----------------------------------IMPORTAÇÃO DADOS DE ENTREGA DE LEITE----------------*
cArq:='LEIDADOS'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'LD_CDFILI',		'N',  2, 0},;	// 1-*Codigo Filiada/Filial
				 {'LD_CDCLI',		'N',  5, 0},;	// 2-*Codigo Cliente
				 {'LD_CDPROP',		'N',  2, 0},;	// 3-*Codigo Propriedade
				 {'LD_CDROTA',		'N',  6, 0},;	// 4-*Codigo Rota
				 {'LD_ESTABUL',	'N',  2, 0},;	// 5-*Nr.Estabulo
				 {'LD_TARRO',		'N',  6, 0},;	// 6-*Nr.Tarro
				 {'LD_SEQUENC',	'N',  4, 0},;	// 7-Nr.Sequencia de Coleta
				 {'LD_ALIZAR', 	'C', 20, 0},;	// 8-Alizarol
				 {'LD_ALTERAD',	'C',  1, 0},;	// 9-Alterada (Reg. Alterado apos coletado)
				 {'LD_CDMOTIV',	'N',  4, 0},;	//10-Motivo Rejeição
				 {'LD_CPFCPPJ',	'C', 18, 0},;	//11-CPF/CNPJ
				 {'LD_DTCOLET',	'D',  8, 0},;	//12-Data da Coleta
				 {'LD_DTEMISS',	'D',  8, 0},;	//13-Data de Emissão (PDA)
				 {'LD_HREMISS',	'C',  8, 0},;	//14-Hora de Emissão (PDA)
				 {'LD_NOMEPRO',	'C', 60, 0},;	//15-Nome Produtor
				 {'LD_NRVIAG',	   'N',  4, 0},;	//16-Nr da Viagem
				 {'LD_PLACA',	   'C',  7, 0},;	//17-Placa Veiculo
				 {'LD_REENVIA',	'C',  1, 0},;	//18-Renviado
				 {'LD_REJEITA',	'C',  1, 0},;	//19-Rejeitado
				 {'LD_TEMPER',	   'N',  5, 2},;	//17-Temperatura
				 {'LD_VOLTAN1',	'N',  9, 2},;	//18-Volume-Tanque 1
				 {'LD_VOLTAN2',	'N',  9, 2},;	//19-Volume-Tanque 2
				 {'LD_VOLTAN3',	'N',  9, 2},;	//20-Volume-Tanque 3
				 {'LD_VOLTAN4',	'N',  9, 2},;	//21-Volume-Tanque 4
				 {'LD_VOLTAN5',	'N',  9, 2},;	//22-Volume-Tanque 5
				 {'LD_VOLTANT',	'N',  9, 2},;	//23-Volume-Total
				 {'LD_DTIMPOR',	'D',  8, 0};	//24-Data Importacao
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. LEITE-Importacao dos dados de coleta',NIL,.F.)
		pack
		Index on DtoS(LD_DTCOLET)+str(LD_NRVIAG,4)+str(LD_CDROTA,6)+str(LD_TARRO,6)+str(LD_SEQUENC,4);
					tag DTCOLETA		to (cArq) eval ODOMETRO()	// Única - Data+Viagem+Rota+Tarro+Sequencia
		Index on DtoS(LD_DTCOLET)+str(LD_CDCLI,5);
					tag DTCLI			to (cArq) eval ODOMETRO()	// Data+Cliente
		Index on str(LD_CDCLI,5)+DtoS(LD_DTCOLET);
					tag CLIDT			to (cArq) eval ODOMETRO()	// Cliente+Data
		close
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LEIGORDX(P1,P2) // Tabela de Gordura LEITEP12.PRG
//-----------------------------------------------------------------------------*
ARQ:='LEIGORD'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'LG_GORDL1','N',  6, 2},;	// 1-% Gordura Limite 1
				 {'LG_GORDL2','N',  6, 2},;	// 2-% Gordura Limite 2
				 {'LG_VLRPLT','N',  8, 4};		// 3-Acrescenta/Diminui ao Vlr Litro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Tabela Gordura',NIL,.F.)
		Index on str(LG_GORDL1,6,2) tag CODIGO to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LEIPROTX(P1,P2) // Tabela de Proteina LEITEP13.PRG
//-----------------------------------------------------------------------------*
ARQ:='LEIPROT'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'PT_PROTE1','N',  6, 2},;	// 1-% Proteina Limite 1
				 {'PT_PROTE2','N',  6, 2},;	// 2-% Proteina Limite 2
				 {'PT_VLRPLT','N',  8, 4};		// 3-Acrescenta/Diminui ao Vlr Litro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Tabela Gordura',NIL,.F.)
		Index on str(PT_PROTE1,6,2) tag CODIGO to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//----------------------------------------------------------------------------------*
	function LEIESDX(P1,P2) // Tabela de ESD-Extrato Seco Desengordurado-LEITEP14.PRG
//----------------------------------------------------------------------------------*
ARQ:='LEIESD'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'ES_PRESD1','N',  6, 2},;	// 1-% Proteina Limite 1
				 {'ES_PRESD2','N',  6, 2},;	// 2-% Proteina Limite 2
				 {'ES_VLRPLT','N',  8, 4};		// 3-Acrescenta/Diminui ao Vlr Litro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Tabela ESD-Extrado Seco DesenGordurado',NIL,.F.)
		Index on str(ES_PRESD1,6,2) tag CODIGO to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LEICCSX(P1,P2) // Tabela de CCS - LEITEP15.PRG
//-----------------------------------------------------------------------------*
ARQ:='LEICCS'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'CC_NRCSS1','N',  5, 0},;	// 1-% Proteina Limite 1
				 {'CC_NRCSS2','N',  5, 0},;	// 2-% Proteina Limite 2
				 {'CC_VLRPLT','N',  8, 4};		// 3-Acrescenta/Diminui ao Vlr Litro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Tabela CCS-Contagem de Celulas Somaticas',NIL,.F.)
		Index on str(CC_NRCSS1,5) tag CODIGO to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LEICPPX(P1,P2) // Tabela CPP-Contagem Padrao Placas - LEITEP16.PRG
//-----------------------------------------------------------------------------*
ARQ:='LEICPP'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'CP_NRCPP1','N',  5, 0},;	// 1-Limite Inicial - CPP
				 {'CP_NRCPP2','N',  5, 0},;	// 2-Limite Final - CPP
				 {'CP_VLRPLT','N',  8, 4};		// 3-Acrescenta/Diminui ao Vlr Litro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Tabela CPP-Contagem Padrao Placas',NIL,.F.)
		Index on str(CP_NRCPP1,5) tag CODIGO to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LEIVOLX(P1,P2) // Tabela Valor Litro por Volume - LEITEP22.PRG
//-----------------------------------------------------------------------------*
ARQ:='LEIVOL'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'VL_QTLIT1','N',  5, 0},;	// 1-Quantidade Litros Inicial
				 {'VL_QTLIT2','N',  5, 0},;	// 2-Quantidade Litros Final
				 {'VL_VLRPLT','N',  8, 4};		// 3-Vlr por Litro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Volume x Valor',NIL,.F.)
		Index on str(VL_QTLIT1,5) tag CODIGO to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//-----------------------------------------------------------------------------*
	function LEILABORX(P1,P2) // Importação dados LABORATORIO - LEITEP17.PRG
//-----------------------------------------------------------------------------*
ARQ:='LEILABOR'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'LA_NRREQU','N',  5, 0},;	// 01-Nr Requisição Laboratório
				 {'LA_ANOREQ','N',  4, 0},;	// 02-Ano Requisição Laboratório
				 {'LA_DTCOLE','D',  8, 0},;	// 03-DATA_COLETA
				 {'LA_TARRO', 'N',  6, 0},;	// 04-Nr Tarro = IDENT_AMOSTRA
				 {'LA_GORDUR','N',  6, 2},;	// 05-PERC_GORDURA
				 {'LA_PROTEI','N',  6, 2},;	// 06-PROTEINA
				 {'LA_LACTOS','N',  6, 2},;	// 07-PERC_LACTOSE
				 {'LA_ESD'	 ,'N',  6, 2},;	// 08-EDS-Extrato Seco Desengurdurado
				 {'LA_PERSOL','N',  6, 2},;	// 09-PERC_SOLIDOSTOTAL
				 {'LA_NRCCS', 'N',  5, 0},;	// 10-CCS_1000
				 {'LA_NRCBT', 'N',  5, 0},;	// 11-CBT/CPP
				 {'LA_DTANA', 'D',  8, 0},;	// 12-DATA_ANALISE
				 {'LA_CDROTA','N',  6, 0},;	// 13-ROTA_LINHA
				 {'LA_CDPROP','N',  2, 0},;	// 14-UNIDADE_CLIENTE
				 {'LA_CDCLI', 'N',  5, 0},;	// 15-Codigo Cliente (Colocado na Importação)
				 {'LA_DTIMP', 'D',  8, 0},;	// 16-Dt Importação
				 {'LA_USUAR', 'C', 20, 0};		// 17-Usuário
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Importacao Dados Laboratorio',NIL,.F.)
		Index on DtoS(LA_DTCOLE)+str(LA_TARRO,6) tag DTROT to (Arq) eval ODOMETRO()
		Index on DtoS(LA_DTCOLE)+str(LA_CDCLI,5) tag DTCLI to (Arq) eval ODOMETRO()
		Index on str(LA_TARRO,6)+DtoS(LA_DTCOLE) tag ROTDT to (Arq) eval ODOMETRO()
		Index on str(LA_CDCLI,5)+DtoS(LA_DTCOLE) tag CLIDT to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//------------------------------------------------------------------------------------*
	function LEIBONX(P1,P2) // Calculo dos Valores da Qualidade do Leite - LEITEP22.PRG
//------------------------------------------------------------------------------------*
ARQ:='LEIBON'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'CB_CDCLI', 'N',  5, 0},;	// 01-Codigo Cliente
				 {'CB_PERIOD','C',  6, 0},;	// 02-Período (AAAAMM)
				 {'CB_GORDUR','N',  6, 2},;	// 03-PERC_GORDURA
				 {'CB_PROTEI','N',  6, 2},;	// 04-PERC_PROTEINA
				 {'CB_LACTOS','N',  6, 2},;	// 05-PERC_LACTOSE
				 {'CB_ESD'	 ,'N',  6, 2},;	// 06-PERC EDS-Extrato Seco Desengurdurado
				 {'CB_PERSOL','N',  6, 2},;	// 07-PERC_SOLIDOSTOTAL
				 {'CB_NRCCS', 'N',  5, 0},;	// 08-CCS_1000
				 {'CB_NRCPP', 'N',  5, 0},;	// 09-CCP=CBT
				 {'CB_VLGORD','N',  8, 4},;	// 10-VLR_GORDURA
				 {'CB_VLPROT','N',  8, 4},;	// 11-VLR PROTEINA
				 {'CB_VLESD' ,'N',  8, 4},;	// 12-VLR EDS-Extrato Seco Desengurdurado
				 {'CB_VLCCS', 'N',  8, 4},;	// 13-VLR CCS_1000
				 {'CB_VLCPP', 'N',  8, 4},;	// 14-VLR CPP=CBT
				 {'CB_NRNFPR','N',  6, 0},;	// 15-Nr Nota Fiscal Produtor
				 {'CB_ERFXCL','C',  7, 0},;	// 16-Existe Erro de Faixa no Registro|Rota
				 {'CB_CDROTA','N',  6, 0},;	// 17-Rota
				 {'CB_TARRO', 'N',  6, 0};		// 18-Nr Tarro
				 },;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-Volume x Valor',NIL,.F.)
		Index on str(CB_CDCLI,5)+CB_PERIOD 							tag CLIPER	to (Arq) eval ODOMETRO()
		Index on CB_PERIOD+str(CB_CDCLI,5) 							tag PERCLI	to (Arq) eval ODOMETRO()
		Index on str(CB_CDROTA,6)+str(CB_TARRO,6)+CB_PERIOD 	tag ROTDT	to (Arq) eval ODOMETRO()
		close
	end
end
return NIL

//---------------------------------------------------------------------------------------*
//---------------------------------------------------------------------------------------*
//---------------------------------------------------------------------------------------*
//---------------------------------------------------------------------------------------*
// ELIMINAR - ELIMINAR - ELIMINAR - ELIMINAR - ELIMINAR - ELIMINAR - ELIMINAR - ELIMINAR *
//---------------------------------------------------------------------------------------*
//---------------------------------------------------------------------------------------*
//---------------------------------------------------------------------------------------*
//---------------------------------------------------------------------------------------*
/*
*------------------------------------------------* Numero de documentos-leiteP03.PRG
	function LEICCSOMX(P1,P2)
*------------------------------------------------* Numero de documentos
ARQ:='LEICCSOM'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'LS_LIMITE1', 'N',  7, 0},;		// 1-Vlr Limite Celulas
				 {'LS_LIMITE2', 'N',  7, 0},;		// 2-Vlr Limite Celulas
				 {'LS_PERCENT', 'N',  6, 2}},;	// 3-% do valor base
				  RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-CONTAGEM CEL.SOMATICAS',NIL,.F.)
		Index on str(LS_LIMITE1,7) tag CODIGO to (ARQ) eval ODOMETRO()
		close
	end
end
return NIL

//-------------------------------------------------------Numero de documentos-leiteP05.PRG
	function LEITEMPX(P1,P2)
//-----------------------------------------------------------------------------*
ARQ:='LEITEMP'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'LT_GRAU',   'N',  2, 0},;	// 1-Vlr Limite Crioscopia
				 {'LT_PERCENT','N',  6, 2}},;	// 2-% do valor base
				  RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-CRIOSCOPIA',NIL,.F.)
		Index on str(LT_GRAU,2) tag CODIGO to (ARQ) eval ODOMETRO()
		close
	end
end
return NIL
*/

//------------------------------------------------------------------------------
	function LEIPRODDX(P1,P2)
//------------------------------------------------------------------------------
ARQ:='LEIPRODD'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'CL_CODCL',   'N',  5, 0},;	// 1-Codigo Cliente
				 {'CL_ROTA',    'N',  6, 0},;	// 2-Rota de Busca de Leite
				 {'CL_PORDENH', 'N',  6, 2},;	// 3-Propriedade-Tipo Ordenha
				 {'CL_PRESFRI', 'N',  6, 2},;	// 4-Propriedade-Resfriador
				 {'CL_PVACINA', 'N',  6, 2},;	// 5-Propriedade-Vacinação
				 {'CL_DTIENTR', 'D',  8, 0}},;// 6-Data inicio entrega leite
				  RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pack
		pb_msg('Reorg. LEITE-REDUTASE',NIL,.F.)
		Index on str(CL_CODCL,5) tag CODIGO to (ARQ) eval ODOMETRO()
		Index on str(CL_ROTA,6)  tag ROTA   to (ARQ) eval ODOMETRO()
		close
	end
end
return NIL

//----------------------------------------------------------EOF----------------
