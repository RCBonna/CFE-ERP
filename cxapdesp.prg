*-----------------------------------------------------------------------------*
	function CXAPDESP()	// Lancamentos de Despesas										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local cTpLcto:='P'
local nDocto :=0
local nValor :=0.00
local X
local VM_CTA1
local dDataM 
local cHistorico
private nBanco  :=10
private nConta  :=0

if !abre({	'C->PARAMETRO',;
				'C->BANCO',;
				'C->CAIXACG',;
				'C->CAIXAMB',;
				'C->CAIXAMC',;
				'C->CAIXAPA',;
				'C->DIARIO',;
				'C->CTRNF',;
				'C->CTADET',;
				'C->CTACTB'})

	return NIL
end

pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end
dDataM    :=PARAMETRO->PA_DATA
while lastkey()#K_ESC
	nDocto    :=fn_psnf('FIN','Financeiro')
	lCtrl     :=.T.
	nValor    :=0.00
	cHistorico:=Space(60)
	nX        :=11
	pb_box(nX++,12,,,,'Pagamento/Recebimentos Diversos')
	 nX++
	@nX++,14 say 'Tipo Lancamento:' get cTpLcto    pict mUUU valid cTpLcto$'PR' when pb_msg('Tipo de Lancamento :     <P>agamentos       <R>ecebimentos')
	@nX++,14 say 'Data Movimento.:' get dDataM     pict mDT                     when pb_msg('Data Movimento')
	 nX++
	@nX++,14 say 'Codigo Banco...:' get nBanco     pict mI2  valid fn_codigo(@nBanco,{'BANCO',{||BANCO->(dbseek(str(nBanco,2)))},{||CFEP1500T(.T.)},{2,1}}) when pb_msg('Informe Codigo Banco')
	@nX++,14 say 'Conta Contabil.:' get nConta     pict mI4  valid fn_ifconta(,@nConta)
	@nX++,14 say 'Nr Documento...:' get nDocto     pict mI6  valid nDocto>=0            when pb_msg('Numero do Documento')
	@nX++,14 say 'Valor Movimento:' get nValor     pict mUUU valid nValor>=0            when pb_msg('')
	 nX++
	@nX++,14 say 'Historico......:' get cHistorico pict mUUU+'S45' valid !empty(cHistorico)   when pb_msg('Informe o Historico').and.(cHistorico:=padr(if(cTpLcto=='P','Pago','Recebido'),60))>=''
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		BANCO->(dbseek(str(nBanco,2)))
		VM_CTA1:=BANCO->BC_CONTA
		nCodLct:=BuscTipoCx(cTpLcto)
		if cTpLcto=='P' //
			Grav_Bco(nBanco,;
						dDataM,;
						nDocto,;
						cHistorico,;
						-nValor,;
						'OU')
			GravMvCxa(nCodLct,;
						dDataM,;
						-nValor,;
						cHistorico,;
						nDocto,;
						'CP')
			fn_atdiario(dDataM,;
							VM_CTA1,;//-------------------------------------------------CAIXA/BCO
							CRE*nValor,;
							cHistorico,;
							'FIN:'+pb_zer(nDocto,6)+'/DVS-'+cTpLcto)
			fn_atdiario(dDataM,;
							nConta,;//-------------------------------------------------Contra Partida
							DEB*nValor,;
							cHistorico,;
							'FIN:'+pb_zer(nDocto,6)+'/DVS-'+cTpLcto)

		elseif cTpLcto=='R' // Recebimentos
			Grav_Bco(nBanco,;
						dDataM,;
						nDocto,;
						cHistorico,;
						nValor,;
						'OU')
			GravMvCxa(nCodLct,;
						dDataM,;
						nValor,;
						cHistorico,;
						nDocto,;
						'CR')
			fn_atdiario(dDataM,;
							VM_CTA1,;//-------------------------------------------------CAIXA/BCO
							DEB*nValor,;
							cHistorico,;
							'FIN:'+str(nDocto,6)+'/DVS-'+cTpLcto)

			fn_atdiario(dDataM,;
							nConta,;//-------------------------------------------------Contra Partida
							CRE*nValor,;
							cHistorico,;
							'FIN:'+str(nDocto,6)+'/DVS-'+cTpLcto)
		end
		lCtrl     :=.F.
	end
	if lCtrl
		fn_backnf('FIN',nDocto)
	end
end
dbcloseall()
return NIL
*--------------------------------------[EOF]-------------------------------*
