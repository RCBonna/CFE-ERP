*-----------------------------------------------------------------------------*
function CXAPTRAC()	// Transferencia entre bancos
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local VM_CTA1
local VM_CTA2
local VM_DES1
local VM_DES2
local DOCTO  :=0
local lCtrl  :=.T.

if !abre({	'C->PARAMETRO',;
				'C->CTACTB',;
				'C->BANCO',;
				'C->CAIXACG',;
				'C->DIARIO',;
				'C->CTADET',;
				'C->CTRNF',;
				'C->CAIXAMB'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end
while lastkey()#K_ESC
	private VM_DATA :=date()
	private VM_BANC1:=0
	private VM_BANC2:=0
	private VALOR   :=0.00
	private Flag    :='S'
	DOCTO   :=fn_psnf('FIN','Financeiro')
	X       :=15
	VM_CTA1 :=0
	VM_CTA2 :=0
	pb_box(X++,12,,,,'Transferencia Bancaria')
	@X++,14 say 'Data.........:' get VM_DATA  pict mDT                      when pb_msg('Data Movimento')
	@X++,14 say 'Banco Origem.:' get VM_BANC1 pict masc(11) valid fn_codigo(@VM_BANC1,{'BANCO',{||BANCO->(dbseek(str(VM_BANC1,2)))},{||CFEP1500T(.T.)},{2,1}}) when pb_msg('')
	@X++,14 say 'Vlr Tranferec:' get VALOR    pict masc(05) valid VALOR>0   when pb_msg('')
	@X++,14 say 'Nr Documento.:' get DOCTO    pict mI6      valid DOCTO>=0  when pb_msg('')
	@X++,14 say 'Banco Destino:' get VM_BANC2 pict masc(11) valid fn_codigo(@VM_BANC2,{'BANCO',{||BANCO->(dbseek(str(VM_BANC2,2)))},{||CFEP1500T(.T.)},{2,1}}).and.VM_BANC1#VM_BANC2 when pb_msg('')
	@X  ,14 say 'Contabilizar.:' get FLAG     pict mUUU     valid Flag$'SN' when pb_msg('Contabilizar Movimento de Transferencia ?   <S>im     <N>ao')
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		BANCO->(dbseek(str(VM_BANC1,2)))
		VM_CTA1:=BANCO->BC_CONTA
		VM_DES1:=trim(BANCO->BC_DESCR)

		BANCO->(dbseek(str(VM_BANC2,2)))
		VM_CTA2:=BANCO->BC_CONTA
		VM_DES2:=trim(BANCO->BC_DESCR)

		grav_bco(VM_BANC1,VM_DATA,DOCTO,'Transf.p/ '+VM_DES2,-VALOR,'IN')
		grav_bco(VM_BANC2,VM_DATA,DOCTO,'Transf.de '+VM_DES1,+VALOR,'IN')
		if Flag == 'S'
			fn_atdiario(VM_DATA,;
							VM_CTA2,;//-------------------------------------------------CAIXA/BCO
							DEB*VALOR,;
							'Docto.'+ltrim(str(DOCTO))+' Transf.de '+VM_DES1,;
							'FIN:'+pb_zer(DOCTO,6)+'/TRANSF')
			fn_atdiario(VM_DATA,;
							VM_CTA1,;//-------------------------------------------------CAIXA/BCO
							CRE*VALOR,;
							'Docto.'+ltrim(str(DOCTO))+' Transf.p/ '+VM_DES2,;
							'FIN:'+pb_zer(DOCTO,6)+'/TRANSF')
		end
		lCtrl:=.F.
	end
	if lCtrl
		fn_backnf('FIN',DOCTO)
	end
end
dbcloseall()
return NIL
*-------------------------------------[EOF]------------------------------*
