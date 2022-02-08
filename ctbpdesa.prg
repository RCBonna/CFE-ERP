*-----------------------------------------------------------------------------*
function CTBPDESA()	//	Voltar Lotes														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())
if !abre({	'C->PARAMCTB',;
				'C->CTADET',;
				'C->RAZAO',;
				'C->CTRLOTE'})
	return NIL
end
select('RAZAO')
dbsetorder(2)
select('CTADET')
dbsetorder(2)
VM_LOTE:=0
VM_DATA:=ctod('')
pb_box(19,40,,,,'Informe')
@20,42 say 'Data Movto.:' get VM_DATA pict mDT
@21,42 say 'Numero Lote:' get VM_LOTE pict mI8 valid fn_veriflt(VM_DATA,VM_LOTE)
read
if if(lastkey()#K_ESC,pb_sn('Recuperar LOTE :'+pb_zer(VM_LOTE,8)),.F.)
	VM_VLRLT:=0
	select('CTRLOTE')
	while !AddRec();end
	replace 	CL_NRLOTE with VM_LOTE,;
				CL_VLRLT  with 0,;
				CL_FECHAD with .F.,;
				CL_DIGIT  with 'Importacao',;
				CL_DATA   with VM_DATA

	pb_lin4("RETORNANDO lote "+pb_zer(VM_LOTE,8),ProcName())
	fn_alote(VM_LOTE,.T.) // Criar arquivo de lotes
	select('RAZAO')
	dbseek(dtos(VM_DATA)+str(VM_LOTE,8),.T.)
	pb_msg("Aguarde... VOLTANDO LOTE.",NIL,.F.)
	while !eof().and.dtos(RZ_DATA)+str(RZ_NRLOTE,8)==dtos(VM_DATA)+str(VM_LOTE,8)
		SALVABANCO
		while !reclock();end
		select('CTADET')
		if dbseek(RAZAO->RZ_CONTA)
			while !reclock();end
		end
		select('LOTE')
		while !AddRec();end
		replace  LO_CONTA  with RAZAO->RZ_CONTA,;
					LO_CTA    with CTADET->CD_CTA,;
					LO_VALOR  with RAZAO->RZ_VALOR,;
					LO_CONTRA with replicate(' ',len(LO_CONTRA)),;
					LO_CTRA   with 0,;
					LO_HISTOR with RAZAO->RZ_HISTOR,;
					LO_TPLCTO with "",;
					LO_DOCTO  with RAZAO->RZ_DOCTO
		
		if RAZAO->RZ_VALOR>0
			VM_DEB :="CTADET->CD_DEB_"+pb_zer(month(CTRLOTE->CL_DATA),2)
			&VM_DEB:=&VM_DEB-abs(RAZAO->RZ_VALOR)
		else
			VM_CRE :="CTADET->CD_CRE_"+pb_zer(month(CTRLOTE->CL_DATA),2)
			&VM_CRE:=&VM_CRE-abs(RAZAO->RZ_VALOR)
		end
	
		VM_VLRLT+=if(LO_VALOR>0,LO_VALOR,0)
		RESTAURABANCO
		dbdelete()
		dbunlockall()
		dbskip()
	end
	dbsetorder(1)
	select('CTRLOTE')
	while !reclock();end
	replace CL_VLRLT with VM_VLRLT
	// dbcommitall()
	select('LOTE')
	dbclosearea()
end
select('RAZAO')
dbsetorder(1)
dbcloseall()
return NIL

*-----------------------------------------------------------------------* 
static function FN_VERIFLT(P1,P2)
*-----------------------------------------------------------------------* 
local RT:=.T.
SALVABANCO
select('RAZAO')
dbseek(dtos(P1)+str(P2,8),.T.)
if !dtos(RZ_DATA)+str(RZ_NRLOTE,8)==dtos(P1)+str(P2,8)
	RT:=.F.
	alert('VERIFIQUE;Lote ou data nao constam nos lancamentos do Razao.')
end
RESTAURABANCO
return RT
*-----------------------------------------------------------------------* Fim
