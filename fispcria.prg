*-----------------------------------------------------------------------------*
 static aVariav := {''}
 //.................1.
*-----------------------------------------------------------------------------*
#xtranslate ARQ   => aVariav\[  1 \]
*-----------------------------------------------------------------------------*
function FISPCRIA(P1,P2)
#include 'RCB.CH' 
*------------------------------------------------* PARAMETRO DE CAIXAS
ARQ:='FISAPA'
if dbatual(ARQ,;
				{{'PA_PERINT','C', 6, 0},;	// 1-Periodo Integrado aaaa/mm
				 {'PA_SLDANT','N',15, 2},;	// 2-Ultima data fechada - CAIXA
				 {'PA_NRLIVR','N', 3, 0},; // 3-Nro Livro
				 {'PA_NRPAG', 'N', 3, 0},; // 3-Nro Pagina
				 {'PA_MARGEM','N', 3, 0}},;// 3-Margem
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* REGISTRO DE APURACAO
ARQ:='FISARA'
if dbatual(ARQ,;
				{{'RA_PERIOD','C', 6, 0},;	// 1-Periodo Integrado aaaa/mm
				 {'RA_CODOPE','C', 5, 0},;	// 2-Nat Operacao Normal
				 {'RA_VLRCTB','N',15, 2},;	// 3-Vlr Contabil
				 {'RA_VLRBAS','N',15, 2},;	// 4-Vlr Base ICMS
				 {'RA_VLRIMP','N',15, 2},;	// 5-Vlr Imposto
				 {'RA_VLRISE','N',15, 2},;	// 6-Vlr Isentos
				 {'RA_VLROUT','N',15, 2}},;// 7-Vlr Outros
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* % DE CUPONS FISCAIS
ARQ:='CFEAAF'
if dbatual(ARQ,;
				{{'AF_CODIGO', 'C',  2, 0},;
				 {'AF_DESCR',  'C', 15, 0},;
				 {'AF_ALIQUO', 'N',  5, 2}},;
				 RDDSETDEFAULT()) //
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* OBS PARA NOTAS FISCAIS
ARQ:='FISAOBS'
if dbatual(ARQ,;
				{{'OB_CODOBS', 'C',  1, 0},;
				 {'OB_DESCR',  'C', 80, 0}},;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* CODIGO TRIBUTARIO
ARQ:='CFEACT'
if dbatual(ARQ,;
				{{'CT_CODTR', 'C',  3, 0},;
				 {'CT_DESCR', 'C', 60, 0},;
				 {'CT_PERC',  'N',  6, 2}},;
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* PIS+COFINS
ARQ:='FISACOF'
if dbatual(ARQ,;
				{{'CO_CODCOF','C',  3, 0},;	//01
				 {'CO_DESCR', 'C', 40, 0},;	//02
				 {'CO_TIPOFJ','C',  1, 0},;	//03 Pessoa    <F>isico  .... <J>uridico
				 {'CO_TIPOIN','C',  2, 0},;	//04 Tipo Incidencia <I>sento <T>ributado <S>ubstituicao <N>ao Tributado
				 {'CO_PERC1', 'N',  6, 2},;	//05 %PIS
				 {'CO_PERC2', 'N',  6, 2},;	//06 %COFINS
				 {'CO_CCTB1', 'N',  4, 0},;	//07 Conta Contábil PIS
				 {'CO_CCTB2', 'N',  4, 0},;	//08 Conta Contábil COFINS
				 {'CO_HISPHP','C',  4, 0},;	//09 Histórico do PIS (para integração com EFPH)
				 {'CO_HISPHC','C',  4, 0}},;	//10 Histórico do COFINS (para integração com EFPH)
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

LIVROX(P1,P2) // Cria + Valida Arquivos de Livros Fiscais --> livro0.PRG

return NIL

*-----------------------------------------------------------------------------*
function FISPINDI(P1,P2)	//	Indices do Modulo de fiscal
*-----------------------------------------------------------------------------*
ARQ:='FISARA'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. REG APURACAO - Reg:'+str(LastRec(),7))
		pack
		Index on RA_PERIOD+RA_CODOPE  tag PERIODO  to (Arq) eval {||ODOMETRO('PERIODO')}
		close
	end
end

*------------------------------------------------* Aliquotas Imp Fiscal
ARQ:='CFEAAF'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Aliquotas/CF - Reg:'+str(LastRec(),7))
		pack
		Index on AF_CODIGO        tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(AF_DESCR)  tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* TAB OBSERVACAO
ARQ:='FISAOBS'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Tabela de observacao - Reg:'+str(LastRec(),7))
		pack
		Index on OB_CODOBS       tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(OB_DESCR) tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* CODIGO TRIBUTARIO
ARQ:='CFEACT'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		if RecCount()==0
			DbAppend()
			replace	CT_CODTR with "000",;
						CT_DESCR with "Nac-Trib Integralmente",;
						CT_PERC	with 100
		end
		pb_msg(ARQ+' Reorg. CODIGO TRIBUTARIO - Reg:'+str(LastRec(),7))
		pack
		Index on CT_CODTR tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on CT_DESCR tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* PIS+COFINS
ARQ:='FISACOF'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Tabela PIS+COFINS - Reg:'+str(LastRec(),7))
		pack
		Index on CO_CODCOF+CO_TIPOFJ        tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(CO_DESCR)            tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		Index on CO_CODCOF                  tag CODUNI to (Arq) eval {||ODOMETRO('COD.UNICO')} UNIQUE
		close
	end
end
return NIL
*----------------------------------------------------EOF------------------------------------------
