#include 'RCB.CH'

*-------------------------------------------------------------------------------
function CFEPIND2(P1)
*------------------------------------------------* CADASTRO DE CLIENTES
local ARQ:='CFEACL'

if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. CAD. CLIENTES - '+Str(Lastrec(),7))
		pack
		Index on str(CL_CODCL,5)						tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(CL_RAZAO)						tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		Index on CL_CGC									tag CGC    to (Arq) eval {||ODOMETRO('CGC')}
		Index on str(CL_VENDED,3)+CL_RAZAO			tag VENDED to (Arq) eval {||ODOMETRO('VENDED')}
		Index on upper(CL_UF+CL_CIDAD+CL_BAIRRO)	tag UFCIDA to (Arq) eval {||ODOMETRO('UF+CIDADE')}
		Index on CL_RAZAO									tag BAIXAS to (Arq) eval {||ODOMETRO('BAIXAS')} for !empty(CL_DTBAIX)
		Index on str(CL_CODFOR,5)						tag ANTIGO to (Arq) eval {||ODOMETRO('COD ANTIGO')}
		Index on str(CL_LEITSQ,6)						tag LEITE  to (Arq) eval {||ODOMETRO('SEQ.LEITE')} for CL_LEITSQ > 0
		Index on DtoS(CL_DTNAS)							tag DTNASC to (Arq) eval {||ODOMETRO('DT NASCIMENTO')}
		close
	end
end

*-----------------------------------------------------* CLIENTES - ALTERACOES
ARQ:='CFEACLX'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. CAD. CLIENTES-Movimentos - '+Str(Lastrec(),7))
		pack
		Index on str(CLX_CODCL,5)+dtos(CLX_DTALT)+str(CLX_NROCPO,2) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* CLIENTES//OBS//SPC
ARQ:='CFEACO'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. OBS CLIENTES - '+Str(Lastrec(),7))
		pack
		Index on str(CO_CODCL,5)+str(CO_SEQUE,2) tag CODIGO to (Arq) eval {||ODOMETRO('')}
		close
	end
end

*------------------------------------------------* DUPLICATAS A RECEBER
ARQ:='CFEADR'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. DUPLICATAS A RECEBER - '+Str(Lastrec(),7))
		pack
		Index on str  (DR_DUPLI,8)+dtos(DR_DTVEN)                 tag DPLDTV  to (Arq) eval {||ODOMETRO('DR/DPL+DTVENC')}
		Index on upper(DR_ALFA)+dtos(DR_DTVEN)  		          tag ALFADTV to (Arq) eval {||ODOMETRO('DR/ALFA+DTVENC')}
		Index on str  (DR_CODBC,2)+dtos(DR_DTVEN)+str(DR_CODCL,5) tag BCODTV  to (Arq) eval {||ODOMETRO('DR/BCO+DTVENC')}
		Index on dtos (DR_DTVEN)+str(DR_DUPLI,8)                  tag DTVDPL  to (Arq) eval {||ODOMETRO('DR/DTVENC+DPL')}
		Index on str  (DR_CODCL,5)+dtos(DR_DTVEN)                 tag CLIDTV  to (Arq) eval {||ODOMETRO('DR/DTVENC')}
		Index on str  (DR_NRNF,9)+DR_SERIE                        tag NNFSER  to (Arq) eval {||ODOMETRO('DR/NRNF+SERIE')}
	end
	close
end

*------------------------------------------------* GRUPOS DO ESTOQUE
ARQ:='CFEAGE'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. GRUPOS DO ESTOQUE - '+Str(Lastrec(),7))
		pack
		Index on str(GE_CODGR,6) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')} 
		Index on GE_DESCR        tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* PRODUTOS DO ESTOQUE
ARQ:='CFEAPR'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. PRODUTOS DO ESTOQUE - '+Str(Lastrec(),7))
		pack
		Index on str(PR_CODGR,6)+str(PR_CODPR,L_P) tag GRUPRO to (Arq) eval {||ODOMETRO('GRUPO+PROD')}
		Index on str(PR_CODPR,L_P)                 tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(PR_DESCR)                   tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		Index on str(PR_CODGR,6)+upper(PR_DESCR)   tag GRUALF to (Arq) eval {||ODOMETRO('GRUPO+ALFA')}
		Index on str(PR_CTB,2)+upper(PR_DESCR)     tag TIPO   to (Arq) eval {||ODOMETRO('TIPO+ALFA')}
		close
	end
end

*------------------------------------------------* Alteração dos produtos para SPED
ARQ:='CFEAPRA'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Alteracoes na descricao do produto-SPED - '+Str(Lastrec(),7))
		pack
		Index on str(PRA_CODPR,L_P)+dtos(PRA_DTFIM) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* Produtos - Impostos especificos
ARQ:='CFEAPRI'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Produtos - Impostos especificos - '+Str(Lastrec(),7))
		pack
		Index on str(PRI_CFOP,7)+str(PRI_CODPR,L_P) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* Produtos - Impostos especificos
ARQ:='CFEANCM'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Produtos - Tabela NCM (% Impostos) - '+Str(Lastrec(),7))
		if LastRec()<=0
			ArqX:="C:\TEMP\IBPTAX.CSV"
			if File(ArqX)
				imp_csv(ArqX)
			else
//				Alert("A t e n c a o;O Arquivo IBPTAX.CSV deve ser colocado em C:\TEMP;Para atualizar a tabela de Impostos para esta versao.")
			end
		end
		pack
		Index on NCM_CODNCM tag CODNCM	to (Arq) eval {||ODOMETRO('CODNCM')}		for NCM_TABELA=='0'
		Index on NCM_CODNCM tag CODSERV	to (Arq) eval {||ODOMETRO('CODSERV')}		for NCM_TABELA=='1'
		Index on NCM_CODNCM tag CODCL116	to (Arq) eval {||ODOMETRO('CODSLC116')}	for NCM_TABELA=='2'
		close
	end
end

*------------------------------------------------* UNIDADE PRODUTOS DO ESTOQUE
ARQ:='CFEAUN'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. UNIDADE PRODUTOS DO ESTOQUE - '+Str(Lastrec(),7))
		pack
		Index on UN_CODUN 			tag CODIGO 	to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(UN_DESCR) 	tag ALFA 	to (Arq) eval {||ODOMETRO('ALFABETICO')}
		close
	end
end

*------------------------------------------------* PRODUTOS/APLICACAO
ARQ:='CFEAP1'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. PRODUTOS/APLICACAO=1 - '+Str(Lastrec(),7))
		pack
		Index on str(P1_CODPR,L_P)                 tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* PRODUTOS/APLICACAO
ARQ:='CFEAP2'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. PRODUTOS/APLICACAO=2 - '+Str(Lastrec(),7))
		pack
		Index on str(P2_CODPR,L_P)+upper(P2_CULTUR) tag CODIGO  to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(P2_CULTUR)                   tag CULTURA to (Arq) eval {||ODOMETRO('CULTURA')}
		close
	end
end

*------------------------------------------------* MOVIMENTACAO ESTOQUE
ARQ:='CFEAME'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. MOVIMENTA€ŽO DO ESTOQUE - '+Str(Lastrec(),7))
		DbGoTop()
		dbeval({||if(empty(ME_DATA).or.empty(ME_CODPR),DbDelete(),NIL)})
		pack
		Index on str(ME_CODPR,L_P)+dtos(ME_DATA)          tag CODDT  to (Arq) eval {||ODOMETRO('CODDT')} every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTCOD  to (Arq) eval {||ODOMETRO('DTCOD')} every LastRec()/5
		Index on ME_TIPO+str(ME_CODPR,L_P)+dtos(ME_DATA)  tag TPCOD  to (Arq) eval {||ODOMETRO('TPCOD')} every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTPROA to (Arq) eval {||ODOMETRO('DTPROA')} for ME_TIPO=='A' every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTPROE to (Arq) eval {||ODOMETRO('DTPROE')} for ME_TIPO=='E' every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTPROF to (Arq) eval {||ODOMETRO('DTPROF')} for ME_TIPO=='F' every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTPROI to (Arq) eval {||ODOMETRO('DTPROI')} for ME_TIPO=='I' every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTPROS to (Arq) eval {||ODOMETRO('DTPROS')} for ME_TIPO=='S' every LastRec()/5
		Index on dtos(ME_DATA)+str(ME_CODPR,L_P)          tag DTPROT to (Arq) eval {||ODOMETRO('DTPROT')} for ME_TIPO=='T' every LastRec()/5
		close
	end
end

*------------------------------------------------* SALDO ESTOQUE
ARQ:='CFEASA'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Saldos do Estoque - '+Str(LastRec(),7))
		pack
		Index on str(SA_EMPRESA,2)+SA_PERIOD+str(SA_CODPR,L_P) tag CODIGO to (Arq) eval {||ODOMETRO('PERIODO')}
		close
	end
end
return NIL
*------------------------------------------------------------------------EOF----------------------------
