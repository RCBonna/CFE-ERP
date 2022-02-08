#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function CFEPIND1(P1,P2)	//	Indices do Sistema													*
*-----------------------------------------------------------------------------*
local ARQ
//------------------------------------------------* Pedido/Cabecalho
ARQ:='CFEAPC'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Cabecalho de Pedidos - '+Str(Lastrec(),7))
		go top
		DbEval({||DbDelete()},			{||Empty(PC_PEDID)})
		go top
		DbEval({||PC_DTSAI:=PC_DTEMI},{||Empty(PC_DTSAI)})
		Pack
		Index on  str(PC_PEDID,6)                tag GPEDIDO to (Arq) eval {||ODOMETRO('GPEDIDO')}	// 1
		Index on  str(PC_PEDID,6)                tag FPEDIDO to (Arq) eval {||ODOMETRO('FPEDIDO')} for !PC_FLAG	// 2
		Index on  str(PC_VEND,3)+dtos(PC_DTEMI)  tag VEDDTE  to (Arq) eval {||ODOMETRO('VEDDTE')}		// 3
		Index on dtos(PC_DTEMI)+str(PC_PEDID,6)  tag DTEPED  to (Arq) eval {||ODOMETRO('DTEPED')}		// 4
		Index on  str(PC_NRNF,6)+PC_SERIE        tag NNFSER  to (Arq) eval {||ODOMETRO('NNFSER')}		// 5
		Index on dtos(PC_DTEMI)+str(PC_NRNF,6)   tag DTENNF  to (Arq) eval {||ODOMETRO('DTENNF')}		// 6
		Index on  str(PC_CODCL,5)+dtos(PC_DTEMI) tag CLIDTE  to (Arq) eval {||ODOMETRO('CLIDTE')}		// 7
		close
	end
end

ARQ:='CFEAPD'
//------------------------------------------------* Pedido/Detalhe
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reord. Detalhes de Pedidos - '+Str(Lastrec(),7))
		DbGoTop()
		DbEval({||DbDelete()},{||Empty(PD_PEDID).or.Empty(PD_ORDEM)})
		pack
		Index on str(PD_PEDID,6)+str(PD_ORDEM,2) tag PEDSEQ to (Arq) eval {||ODOMETRO('PEDSEQ')}
		close
	end
end

//------------------------------------------------* Entradas/Cabecalho
ARQ:='CFEAEC'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reord. Cabecalho de Entradas - '+Str(LastRec(),7))
//		DbEval({||DbDelete()},{||Empty(EC_DOCTO).or.Empty(EC_CODFO)}) // Eliminar registros com erro
		pack
		Index on  str(EC_DOCTO,8)+EC_SERIE+str(EC_CODFO,5)	tag DOCSER to (Arq) eval ODOMETRO('DOCSER')
		Index on dtos(EC_DTENT)+str(EC_DOCTO,8)				tag DTEDOC to (Arq) eval ODOMETRO('DTEDOC')
		Index on  str(EC_CODFO,5)+dtos(EC_DTENT)			tag FORDTE to (Arq) eval ODOMETRO('FORDTE')
//		alert(ARQ+	';1='+OrdName(1)+'='+IndexKey(1)+;
//						';2='+OrdName(2)+'='+IndexKey(2)+;
//						';3='+OrdName(3)+'='+IndexKey(3))
		close
	end
end

//------------------------------------------------* Entradas/Detalhe
ARQ:='CFEAED'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reord. Detalhes de Entrada - '+Str(Lastrec(),7))
		DbEval({||DbDelete()},{||Empty(ED_DOCTO).or.Empty(ED_CODFO)})  // Eliminar Registros com erro
		pack
		Index on str(ED_DOCTO,8)+ED_SERIE+str(ED_CODFO,5)+str(ED_ORDEM,3);
					tag DOCSER to (Arq) eval {||ODOMETRO('DOCSER')}
		close
	end
end

//------------------------------------------------* HISTORICO CLIENTE
ARQ:='CFEAHC'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Historico dos Clientes - '+Str(Lastrec(),7))
		pack
		Index on str(HC_CODCL,5)+dtos(HC_DTPGT) tag CLIDTP to (Arq) eval {||ODOMETRO('CLIDTP')} every LastRec()/5
		Index on str(HC_NRNF,9)+HC_SERIE        tag NNFSER to (Arq) eval {||ODOMETRO('NNFSER')} every LastRec()/5
		Index on dtos(HC_DTPGT)+str(HC_CODCL,5) tag DTPGTO to (Arq) eval {||ODOMETRO('DTPGTO')} every LastRec()/5
		close
	end
end

*------------------------------------------------* HISTORICO FORNENCEDOR
ARQ:='CFEAHF'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Historico de Fornecedores - '+Str(Lastrec(),7))
		pack
		Index on str(HF_CODFO,5)+dtos(HF_DTPGT) tag FORDTP to (Arq) eval {||ODOMETRO('FORDTP')} every LastRec()/5
		Index on dtos(HF_DTPGT)+str(HF_CODFO,5) tag DTPGTO to (Arq) eval {||ODOMETRO('DTPGTO')} every LastRec()/5
		close
	end
end

*-----------------------------------------------* PROD & FORN / FORN & PROD
ARQ:='CFEAPF'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. PRODUTOS x FORNECEDORES - '+Str(Lastrec(),7))
		pack
		Index on str(PF_CODPR,L_P)+str(PF_CODFO,5)+descend(dtos(PF_DATA)) tag PROFOR to (Arq) eval {||ODOMETRO('PRD+FOR')}	// PRODUTO
		Index on str(PF_CODFO,5)+str(PF_CODPR,L_P)+descend(dtos(PF_DATA)) tag FORPRO to (Arq) eval {||ODOMETRO('FOR+PRd')}	// FORNECEDOR
		close
	end
end

*------------------------------------------------* Tabela ICMS
ARQ:='CFEATI'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Tabela de ICMS - '+Str(Lastrec(),7))
		pack
		Index on TI_UF tag UF to (Arq) eval {||ODOMETRO('UF')}
		close
	end
end

*------------------------------------------------* Vendedor
ARQ:='CFEAVE'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Vendedores - '+Str(Lastrec(),7))
		pack
		Index on str(VE_CODIG,3) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(VE_NOME)  tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* Moeda
ARQ:='CFEAMO'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Moedas - '+Str(Lastrec(),7))
		pack
		Index on dtos(MO_DATA) tag DATAMV to (Arq) eval {||ODOMETRO('DATA')}
		close
	end
end

*------------------------------------------------* Observacao
ARQ:='CFEAOB'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Observa‡”es - '+Str(Lastrec(),7))
		pack
		Index on upper(Left(OB_DESCR,60)) tag ALFA to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end

*------------------------------------------------* Ligacoes Contabeis
ARQ:='CFEACC'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Lig.Contabeis - '+Str(Lastrec(),7))
		pack
		Index on CC_TPMOV+str(CC_TPCFO,2)+str(CC_TPEST,2)+str(CC_SEQUE,2) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* Cartas a Clientes
ARQ:='CFEACA'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. CARTAS A CLIENTES - '+Str(Lastrec(),7))
		pack
		Index on CA_CODIG tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* Parcelamento Pedido
ARQ:='CFEAPP'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. Parcelamento Pedido - '+Str(Lastrec(),7))
		pack
		Index on str(PP_PEDID,6) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end

*------------------------------------------------* Parcelamento Pedido
ARQ:='CFEAFC'
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' Reorg. CLIENTES/CONVENIO - '+Str(Lastrec(),7))
		pack
		Index on str(FC_EMPRESA,5)+FC_CODIGO      tag CODIGO to (Arq) eval {||ODOMETRO('EMPR+CODIGO')}
		Index on str(FC_EMPRESA,5)+UPPER(FC_NOME) tag NOME   to (Arq) eval {||ODOMETRO('EMPR+NOME')}
		Index on UPPER(FC_NOME)                   tag SONOME to (Arq) eval {||ODOMETRO('SO NOME')}
		close
	end
end
return NIL
*---------------------------EOF---------------------------------------------------------------------------
