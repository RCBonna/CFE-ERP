*-----------------------------------------------------------------------------*
function CXAP0003() // Fechamento de caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

private NroCxa

pb_lin4(_MSG_,ProcName())
NroCxa:=FN_SelCxa('Fechamento')
if NroCxa==0
	Return Nil
end

setcolor(VM_CORPAD)
if !abre({	'R->PROD',		'R->CLIENTE',	'R->PEDCAB',	'C->CAIXAMC',;
				'C->CAIXASA',	'E->CAIXAPA',	'C->HISFOR',	'C->HISCLI',	'R->CAIXA02',;
				'R->DPCLI',		'R->PEDDET',	'R->PARAMETRO','R->CAIXACG',	'C->CAIXA01'})
	return NIL
end
if empty(PARAMETRO->PA_INSCR).or.val(trim(PARAMETRO->PA_INSCR))>999
	alert('C¢digo da empresa nao configurado.;Altere parametro INSCR.EST')
	dbcloseall()
	return NIL
end
LogStat:=fn_StatCxa(NroCxa)
if LogStat=="ERRO-1"
	Alert('Erro na Abertura do Caixa='+LogStat)
	dbcloseall()
	return NIL
end
if LogStat=="ABERTO"
	alert('Caixa Numero : '+pb_zer(NroCxa,2)+';Esta ABERTO em: '+dtoc(CAIXA01->AX_DATA))
	dbcloseall()
	return NIL
end

VM_DTCXA := CAIXA01->AX_DATA
NroLimit :={CAIXA01->AX_SEQ_I,CAIXA01->AX_SEQ_F}
VM_SLDINI:= CAIXA01->AX_VLRINI
VM_SLDATU:=0
VM_REMDIN:=0
VM_REMBAN:=0
VM_VLRDOC:=0
VM_VLRVIS:=0
VM_VLRPRA:=0
VM_RECDIA:=0
VM_PAGDIA:=0

//==============================================================================================
if pb_ligaimp()
	? 'Empresa.................: '+VM_EMPR
	? 'Caixa Numero............: '+str(NroCxa,2)
	?
	? 'Data Fechamento.........: '+transform(VM_DTCXA,mDT)
	?
	?
   select CAIXA02
   ORDEM CXADATA
   Dbseek(str(NroCxa,2)+dtos(VM_DTCXA),.T.)
	SEQ:=AX_SEQ
   while !eof().and.str(NroCxa,2)+dtos(VM_DTCXA)==str(AX_CAIXA,2)+dtos(AX_DATA)
   	if AX_SEQ>SEQ
	   	for SEQX:=SEQ to AX_SEQ-1
		   	??str(SEQX,6)+" :......."+space(5)
	   		if pcol()>70
   				?
   			end
   		end
   		SEQ:=AX_SEQ
   	end
   	??str(AX_SEQ,6)+" :"+transform(AX_VALOR,mD42)+space(5)
   	if pcol()>70
   		?
   	end
		SEQ++
   	pb_brake()
   end
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

