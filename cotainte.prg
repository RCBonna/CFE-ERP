*-----------------------------------------------------------------------------*
 function CotaInte(DATA,nLinha)	//	Integra Cota Parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local TIPO       :=0

if DATA==NIL
	alert('Chamada do programa incorreta;'+ProcName())
	return NIL
end
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTACTB',;
				'C->CLIENTE',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->BANCO',;
				'E->COTAPA',;
				'E->COTAMV',;
				'E->COTADV'})
	return .F.
end
pb_msg(ProcName()+'.Processando Integracao Cota Parte....')
COTAPA->(DbGoTop())
select COTADV
ORDEM DTMASS
dbseek(dtos(DATA[1]),.T.)
//------------------------------------------------------VALORES
while !eof().and.COTADV->DV_DTMOV<=DATA[2]
	if !COTADV->DV_FLCTB
		@nLinha,23 say 'Vlr.Cotas : '+dtos(COTADV->DV_DATA)
		//................................................................contabilizar
		CLIENTE->(dbseek(str(COTADV->DV_CODCL,5)))
		if COTADV->DV_TPMOV=='R' //.......................................recebimentos
			fn_atdiario(COTADV->DV_DTMOV,;
							COTAPA->PA_CTA01,;	// D=Subscricao
							DEB*Abs(COTADV->DV_SLDINI),;
							trim(COTAPA->PA_HIST1)+' de '+CLIENTE->CL_RAZAO,;
							'C P:'+dtos(COTADV->DV_DATA)+'-'+pb_zer(COTADV->DV_CODCL,5))
		
			fn_atdiario(COTADV->DV_DTMOV,;
							COTAPA->PA_CTA02,;	// C=Subscricao
							CRE*Abs(COTADV->DV_SLDINI),;
							trim(COTAPA->PA_HIST1)+' de '+CLIENTE->CL_RAZAO,;
							'C P:'+dtos(COTADV->DV_DATA)+'-'+pb_zer(COTADV->DV_CODCL,5))
		else //...........................................................Pagamento/Baixas
			fn_atdiario(COTADV->DV_DTMOV,;
							COTAPA->PA_CTA03,;	// D=Baixa
							DEB*Abs(COTADV->DV_SLDINI),;
							trim(COTAPA->PA_HIST1)+' de '+CLIENTE->CL_RAZAO,;
							'C P:'+dtos(COTADV->DV_DATA)+'-'+pb_zer(COTADV->DV_CODCL,5))
		
			fn_atdiario(COTADV->DV_DTMOV,;
							COTAPA->PA_CTA04,;	// C=Baixa
							CRE*Abs(COTADV->DV_SLDINI),;
							trim(COTAPA->PA_HIST2)+' de '+CLIENTE->CL_RAZAO,;
							'C P:'+dtos(COTADV->DV_DATA)+'-'+pb_zer(COTADV->DV_CODCL,5))
		end
		replace COTADV->DV_FLCTB with .T.
	end
	dbskip()
end
//....................................................CONTABILIZAR MOVIMENTACOES
select COTAMV
ORDEM DTASS
dbseek(dtos(DATA[1]),.T.)
while !eof().and.COTAMV->MV_DATA<=DATA[2]
	if !COTAMV->MV_FLCTB
		@21,23 say 'Mov.Cotas : '+dtos(COTAMV->MV_DATA)
		BANCO->(dbseek(str(COTAMV->MV_CODBC,2)))
		CLIENTE->(dbseek(str(COTAMV->MV_CODCL,5)))
		if COTAMV->MV_TPMOV=='R' //.........................VLR RECEBIDO
			fn_atdiario(COTAMV->MV_DATA,;
							BANCO->BC_CONTA,;	// D=Recebido no Banco
							DEB*COTAMV->MV_VALOR,;
							'Receb.de '+trim(CLIENTE->CL_RAZAO)+' ref Subscricao',;
							'C P:'+dtos(COTAMV->MV_DATA)+str(COTAMV->MV_CODCL,5))
			fn_atdiario(COTAMV->MV_DATA,;
							COTAPA->PA_CTA01,;	// C=Subscricao de debito anterior
							CRE*COTAMV->MV_VALOR,;
							'Receb.de '+trim(CLIENTE->CL_RAZAO)+' ref Subscricao',;
							'C P:'+dtos(COTAMV->MV_DATA)+str(COTAMV->MV_CODCL,5))
		else //.............................................................vlr pagos/baixas
			fn_atdiario(COTAMV->MV_DATA,;
							COTAPA->PA_CTA04,;	// D=Baixa de debito anterior
							DEB*COTAMV->MV_VALOR,;
							'Pago a '+trim(CLIENTE->CL_RAZAO)+' ref. Baixa',;
							'C P:'+dtos(COTAMV->MV_DATA)+str(COTAMV->MV_CODCL,5))
				fn_atdiario(COTAMV->MV_DATA,;
							BANCO->BC_CONTA,;	// C=Pagamento no Banco/Baixa
							CRE*COTAMV->MV_VALOR,;
							'Pago a '+trim(CLIENTE->CL_RAZAO)+' ref. Baixa',;
							'C P:'+dtos(COTAMV->MV_DATA)+str(COTAMV->MV_CODCL,5))
		end
		replace COTAMV->MV_FLCTB with .T.
	end
	dbskip()
end
dbcloseall()
return .T.
*------------------------------------[EOF]-------------------------------------*
