#include "RCB.CH"

*-----------------------------------------------------------------------------*
	function ArqI(P1,P2)	//	Indices do Sistema											*
*-----------------------------------------------------------------------------*
*------------------------------------------------* CADASTRO DE FORNECEDORES
local cArq:='CFEAFO'
if file(cArq+'.DBF')
	if !file(cArq+OrdBagExt()).or.P1
		if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
			pb_msg(cArq+' Reorg. CAD.FORNECEDORES - Reg:'+str(LastRec(),7))
			pack
			Index on str(FO_CODFO,5)  tag CODIGO to (cArq) eval {||ODOMETRO('CODIGO')}
			Index on FO_RAZAO         tag ALFA   to (cArq) eval {||ODOMETRO('ALFA')}
			Index on FO_CGC           tag CGC    to (cArq) eval {||ODOMETRO('CGC')}
			Index on str(FO_LEITSQ,6) tag LEITE  to (cArq) eval {||ODOMETRO('LEITE')} for FO_LEITSQ > 0
			close
		end
	end
end
*------------------------------------------------* DUPLICATAS A PAGAR
cArq:='CFEADP'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. DUPLICATAS A PAGAR - Reg:'+str(LastRec(),7))
		pack
		Index on str  (DP_DUPLI,8)+dtos(DP_DTVEN)                 tag DLPDTV   to (cArq) eval {||ODOMETRO('DP+DLP+DTV')}
		Index on upper(DP_ALFA)+dtos(DP_DTVEN)                    tag ALFADTV  to (cArq) eval {||ODOMETRO('DP+ALFA+DTV')}
		Index on str  (DP_CODBC,2)+dtos(DP_DTVEN)+str(DP_DUPLI,8) tag BCODTV   to (cArq) eval {||ODOMETRO('DP+BCO+DTV')}
		Index on dtos (DP_DTVEN)+str(DP_DUPLI,8)                  tag DTVDPL   to (cArq) eval {||ODOMETRO('DP+DTV+DPL')}
		Index on str  (DP_CODFO,5)+dtos(DP_DTVEN)                 tag FORDTV   to (cArq) eval {||ODOMETRO('DP+FOR+DTV')}
		close
	end
end

*------------------------------------------------* TIPO ESTOQUE - SPED
cArq:='CFEAEST'
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cArq+' Reorg. SPED-TIPO ESTOQUE - Reg:'+str(LastRec(),7))
		pack
		Index on str  (ES_CODES,2) tag CODIGO to (cArq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

CFEPIND1(P1,P2)		// Indice CFE/1 (PC+PD+EC+ED+HC+HF+PF)
CFEPIND2(P1,P2)		// Indice CFE/2 (CL+CLX+CO+DR+GE+PR+PRA+PRI+CNM+UN+P1P2+ME+SA
CTBPINDI(P1,P2)		// Indice CTB/1
CXAPINDI(P1,P2)		// Indice dos cArquivos do caixa
FATPINDI(P1,P2)		// Indice para o faturamento
FISPINDI(P1,P2)		// Indice para o fiscal
ParaLinhX(P1,P2)		// Indice ParaLinha
CotaCriaIndice(P1,P2)// Indice para cota parte
Cria_Serie(P1,P2) 	// verifica e cria Arquivos de s‚rie
Cria_NatOp(P1,P2) 	// verifica e cria Arquivos de natureza operacao
return NIL
*-------------------------------------------------------------EOF---------------------------------
