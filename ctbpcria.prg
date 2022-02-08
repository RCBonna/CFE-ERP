*---------------------------------------------------------------------------------------*
 static aVariav := {0,0,'',{}}
 //.................1.2..3, 4
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nY         => aVariav\[  2 \]
#xtranslate cArq       => aVariav\[  3 \]
#xtranslate aCampoX    => aVariav\[  4 \]

*#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function CTBPCRIA(P1)	//	Criacao dos arquivos Contabeis
*-----------------------------------------------------------------------------*
local aCampo
*---------------------------------------------------* Arquivos da contabilidade

if !abre({'R->PARAMCTB'})
	pb_fim('CFE')
end
VM_MASTAM:=len(strtran(trim(PA_MASCARA),'-',''))
VM_LENMAS:=len(trim(PA_MASCARA))
close

*----------------------------------------------------------------* CTAS TITULOS
cArq:='CTBACT'
if dbatual(cArq,;
				{{'CT_CONTA', 'C', VM_MASTAM,0},;	// 1-Cd Conta
				 {'CT_DESCR', 'C', 30,       0}},;	// 2-Descricao Conta
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*---------------------------------------------------------------* CTAS DETALHES
cArq:='CTBACD'

     aCampo:={}
aadd(aCampo,{'CD_CONTA',  'C', VM_MASTAM, 0})	// Cd Conta
aadd(aCampo,{'CD_CTA',    'N',         4, 0})	// Cd Conta REDUZIDA
aadd(aCampo,{'CD_DESCR',  'C',        30, 0})	// Descricao
aadd(aCampo,{'CD_SLD_IN', 'N',        15, 2})	// Saldo Inicial

nY:=5
for nX:=1 to 12

	aadd(aCampo,{'CD_DEB_'+pb_zer(nX,2),'N', 15, 2})
	aadd(aCampo,{'CD_CRE_'+pb_zer(nX,2),'N', 15, 2})
	
next
aadd(aCampo,{'CD_PGRAZ',  'N',  4,  0})	// Pagina do Razao

if dbatual(cArq,aCampo,RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------------------* Historico Padrao
cArq:='CTBAHP'
if dbatual(cArq,;
				{{'HP_HISTOR', 'N',  3,  0},;	// 1-Cd Classificacao
				 {'HP_DESCR',  'C', 60,  0}},;// 2-Descricao Historico
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*---------------------------------------------------------* Lancamentos Diarios
cArq:='CTBADI'
if dbatual(cArq,;
				{{'DI_DATA',  'D',   8,  0},;	// 1-Data
				 {'DI_CONTA' ,'N',   4,  0},;	// 2-Conta REDUZ    
				 {'DI_VALOR' ,'N',  15,  2},;	// 3-Valor do Lcto
				 {'DI_HISTOR','C',  60,  0},;	// 4-Historico
				 {'DI_DOCTO', 'C',  20,  0}},;// 5-Documento
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*------------------------------------------------------------------* CTRL Lotes
cArq:='CTBACL'
if dbatual(cArq,;
				{{'CL_NRLOTE', 'N',  8,  0},;	// 1-Nr Lote
				 {'CL_DATA',   'D',  8,  0},;	// 2-Data Lcto
				 {'CL_DIGIT',  'C', 10,  0},;	// 3-Digitador
				 {'CL_VLRLT',  'N', 15,  2},;	// 4-Vlr Total Lote
				 {'CL_DEBITO', 'N', 15,  2},;	// 5-Soma Debito
				 {'CL_CREDITO','N', 15,  2},;	// 6-Soma Credito
				 {'CL_FECHAD', 'L',  1,  0}},;// 7-Lote Fechado
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*-----------------------------------------------------------------------* Razao
cArq:='CTBARZ'
if dbatual(cArq,;
				{{'RZ_CONTA', 'C', VM_MASTAM,  0},;	// Conta contabil
				 {'RZ_DATA',  'D',			8,  0},;	// Data
				 {'RZ_NRLOTE','N',			8,  0},;	// Nr Lote
				 {'RZ_VALOR', 'N',		  15,  2},;	// Valor Lcto
				 {'RZ_HISTOR','C',		  60,  0},;	// Historico
				 {'RZ_DOCTO', 'C',		  20,  0}},;	// DOCUMENTO
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end

*-----------------------------------------------------------* Lancamento Direto
cArq:='CTBALD'
if dbatual(cArq,;
				{{'LD_GRUPO', 'C',  5,  0},;	// 1-Cd Grupo
				 {'LD_TIPO',  'C',  1,  0},;	// 2-Tipo=C/E
				 {'LD_CONTO', 'N',  4,  0},;	// 3-Conta Origem
				 {'LD_CONTD', 'N',  4,  0},;	// 4-Conta Destino
				 {'LD_HISTOO','C', 60,  0},;	// 5-Historico Origem
				 {'LD_HISTOD','C', 60,  0}},;	// 6-Historico Destino
				 RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
return NIL

*-----------------------------------------------------------------------------*
function CTBPINDI(P1)	//	Indices do Sistema											*
*-----------------------------------------------------------------------------*
cArq:='CTBACT'
if !file(cArq+OrdBagExt()).or.P1
//.............1...2...3..4...5...6....7
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CONTAS TITULO - Reg:'+str(LastRec(),7))
		pack
		Index on CT_CONTA        tag CONTA to (cARQ) eval {||ODOMETRO('CONTA')}
		Index on upper(CT_DESCR) tag ALFA  to (cARQ) eval {||ODOMETRO('ALFA')}
		close
	end
end

*---------------------------------------------------------------* CTAS DETALHES
cArq:='CTBACD'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CONTAS DETALHES - Reg:'+str(LastRec(),7))
		pack
		Index on str(CD_CTA,4)   tag CONTAR  to (cARQ) eval {||ODOMETRO('CONTAR')} 
		Index on CD_CONTA        tag CONTAN  to (cARQ) eval {||ODOMETRO('CONTAN')}
		Index on upper(CD_DESCR) tag ALFA    to (cARQ) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------------------* Historico Padrao
cArq:='CTBAHP'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. HIST. PADRAO - Reg:'+str(LastRec(),7))
		pack
		Index on str(HP_HISTOR,3) tag CODIGO  to (cARQ) eval {||ODOMETRO('CODIGO')} 
		Index on upper(HP_DESCR)  tag ALFA    to (cARQ) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------------------------* CTRL Lotes
cArq:='CTBACL'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. CONTROLE DE LOTES - Reg:'+str(LastRec(),7))
		pack
		Index on str(CL_NRLOTE,8) tag MESLOTE  to (cARQ) eval {||ODOMETRO('MESLOTE')}
		close
	end
end

*-----------------------------------------------------------------------* Razao
cArq:='CTBARZ'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. RAZAO - Reg:'+str(LastRec(),7))
		pack
		Index on RZ_CONTA+DtoS(RZ_DATA)+str(RZ_NRLOTE,8) tag CONTADT  to (cARQ) eval {||ODOMETRO('CONTA+DT')} every LastRec()/5
		Index on DtoS(RZ_DATA)+str(RZ_NRLOTE,8)+RZ_CONTA tag DTLOTE   to (cARQ) eval {||ODOMETRO('DT+LOTE')}  every LastRec()/5
		close
	end
end

*-----------------------------------------------------------------------* Razao
cArq:='CTBADI'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. DIARIO/INTEGRACAO - Reg:'+str(LastRec(),7))
		pack
		Index on dtos(DI_DATA)+str(RecNo(),7) tag DTCTA  to (cArq) eval {||ODOMETRO('DTCTA')} 
		close
	end
end

*-----------------------------------------------------------------------* lANCAMENTOS DIRETOS
cArq:='CTBALD'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. Lacamentos Diretos - Reg:'+str(LastRec(),7))
		pack
		Index on LD_GRUPO+str(LD_CONTO,4)+str(LD_CONTD,4) tag CODIGO to (cARQ) eval {||ODOMETRO('CODIGO')}
		Index on LD_GRUPO+str(LD_CONTD,4)+str(LD_CONTO,4) tag CODINV to (cARQ) eval {||ODOMETRO('CODINV')}
		Index on LD_GRUPO                                 tag GRUPOS to (cArq) eval {||ODOMETRO('GRUPOS')} UNIQUE
		close
	end
end
return NIL

*------------------------------------------------------------------------------------
function CRIA_PA_CTB()
*------------------------------------------------------------------------------------
cArq:='CTBAPA'
if dbatual(cArq,;
				{{'PA_NRDIAR', 'N',  4,  0},; // Numero do Diario
				 {'PA_PGDIAR', 'N',  4,  0},; // Ultima Folhas Impressa Diario
				 {'PA_LMDIAR', 'N',  4,  0},; // Limite Folhas Diario
				 {'PA_MASCARA','C', 20,  0},; // Mascara das Contas
				 {'PA_FECHAM', 'C', 12,  0},; // Fechamento de Mes (0 Nao / 1 Sim)
				 {'PA_NRLOTE', 'C', 48,  0},; // Numero seq do Lote
				 {'PA_ANO',    'N',  4,  0},;	// Ano
				 {'PA_MES',    'N',  2,  0},;	// Mes-Fechado
				 {'PA_SEQLOT', 'N',  6,  0}},;// Seq do Lote
				 RDDSETDEFAULT())
*-------------------------------999.999
	use (cArq) new EXCLUSIVE
	if lastrec()==0
		while .T.
			pb_box(21,00,23,79)
			@22,02 say 'Informe a mascara de edi‡„o para contabilidade :' get MASC_CTB pict '@K!' valid !empty(MASC_CTB).and.fn_masc(MASC_CTB)
			read
			if lastkey()==13
				exit
			end
		end
		dbappend(.T.)
		replace  PA_MASCARA with MASC_CTB,;
					PA_FECHAM  with replicate('0',24),;
					PA_NRLOTE  with replicate('0',48),;
					PA_PGDIAR  with 1,;
					PA_ANO     with year(Date())
		dbskip(0)
		dbcommit()
	end
	close
end
return NIL
//-----------------------------------------EOF----------------------------*
