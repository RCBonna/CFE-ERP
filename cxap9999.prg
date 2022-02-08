*-----------------------------------------------------------------------------*
function CXAP9999() // Fechamento de caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

private NroCxa

pb_lin4(_MSG_,ProcName())
NroCxa:=FN_SelCxa('Fechamento')
if NroCxa==0
	Return Nil
end
pb_msg('Fechamento...')
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
if LogStat=="FECHADO"
	alert('Caixa Numero : '+pb_zer(NroCxa,2)+';Ja esta FECHADO em: '+dtoc(CAIXA01->AX_DATA))
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

if !xxsenha(ProcName(),_MSG_+'/'+pb_zer(NroCxa,2))
	dbcloseall()
	return NIL
end

AtualPgto(VM_DTCXA)
//==============================================================================================
select CAIXAMC
ORDEM CODCXA
Dbseek(str(NroCxa,2)+dtos(VM_DTCXA),.T.)
while !eof().and.str(NroCxa,2)+dtos(VM_DTCXA)==str(MC_CODCXA,2)+dtos(MC_DATA)
	if MC_TIPO=='+'
		VM_RECDIA+=MC_VALOR
	elseif MC_TIPO=='-'
		if MC_CODCG==1
			VM_REMDIN+=MC_VALOR // SOMAR VALORES DE REMESSA PARA MATRIZ = DINH OU CHEQUES
		elseif MC_CODCG==2
			VM_REMBAN+=MC_VALOR // SOMAR VALORES DE REMESSA PARA MATRIZ = DEPOSITO EM CONTA
		else
			VM_PAGDIA+=MC_VALOR
		end
	end
	pb_brake()
end

//==============================================================================================
select CAIXA02
ORDEM CXADATA
Dbseek(str(NroCxa,2)+dtos(VM_DTCXA),.T.)
SEQ   :=AX_SEQ
SeqUlt:=0
SeqCon:=0
Faltam:=""
while !eof().and.str(NroCxa,2)+dtos(VM_DTCXA)==str(AX_CAIXA,2)+dtos(AX_DATA)
	SeqUlt:=max(SeqUlt,AX_SEQ)
	if AX_SEQ>SEQ
	  	for SEQX:=SEQ to AX_SEQ-1
			FALTAM+=str(SEQX,6)
			SeqCon++
		end
   	SEQ:=AX_SEQ
	end
	SEQ++
	VM_VLRDOC+=AX_VALOR
	pb_brake()
end

//==============================================================================================
select PEDCAB
ORDEM DTENNF
Dbseek(dtos(VM_DTCXA),.T.)
while !eof().and.PC_DTEMI==VM_DTCXA
	if PC_NRCXA == NroCxa
		if PC_FLAG
			if !PC_FLCAN
				if PC_FATUR==0
					VM_VLRVIS+=(PC_TOTAL-PC_DESC)
				else
					VM_VLRPRA+=(PC_TOTAL-PC_DESC)
				end
			end
		end
	end
	pb_brake()
end
InFecha:= ' '
     X:=12
pb_box(X++,20,,,,'Fechamento do Caixa - confirme !')
for SEQX:=1 TO 8
  	scroll(13,70,21,78,-1)
	@13,70 say subst(FALTAM,SEQX*6-5,6)
end
 X++
@X++,22 say 'Caixa..................: '+pb_zer(NroCxa,2)
@X++,22 say 'Data Fechamento........: '+transform(VM_DTCXA,mDT)
 X++
//@X++,22 say '(+)Saldo Inicial.......: '+transform(VM_SLDINI,mD112)
//@X++,22 say '(+)Recebimentos do Dia.: '+transform(VM_RECDIA,mD112)
//@X++,22 say '(+)Vendas do Dia...(V).: '+transform(VM_VLRVIS,mD112)
//@X++,22 say '( )Vendas do Dia...(P).: '+transform(VM_VLRPRA,mD112)
//@X++,22 say '(+)Soma Documentos.....: '+transform(VM_VLRDOC,mD112)
//@X++,22 say '(-)Pagamentos do Dia...: '+transform(VM_PAGDIA,mD112)
//@X++,22 say '(-)Remessa Matriz..RMD.: '+transform(VM_REMDIN,mD112)
//@X++,22 say '(-)Remessa Matriz..RMB.: '+transform(VM_REMBAN,mD112)

@X++,22 say 'Ultimo Cupom...........: '+transform(SeqUlt,mI6) color 'R+/G'
@X++,22 say 'Faltam.................: '+transform(SeqCon,mI6)

@X++,22 say '(=)Saldo em Caixa......:' get VM_SLDATU pict mD112 valid VM_SLDATU>=0
 X++
@X++,22 say 'Executar Fechamento....:' get InFecha pict mUUU  valid InFecha$'SN'
read

if if(lastkey()#K_ESC,pb_ligaimp(),.F.)
	select CAIXA01
	NroLimit[2]:=SeqUlt
	if reclock()
		replace AX_FECHAD with .T. // FECHAR
		replace AX_VLRINI with VM_SLDATU // Gravar saldo Final
		replace AX_SEQ_I  with NroLimit[1]
		replace AX_SEQ_F  with NroLimit[2]
	end
	REL:=_MSG_+'/'+transform(VM_DTCXA,mDT)
	LAR:=78
	PAG:=0
	PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,NIL,LAR)
	VM_SALDCAL:=(VM_SLDINI+VM_VLRVIS+VM_VLRDOC+VM_RECDIA)-(VM_REMDIN+VM_REMBAN+VM_PAGDIA)
	? 'Empresa.................: '+VM_EMPR
	? 'Caixa Numero............: '+str(NroCxa,2)
	?
	? 'Data Fechamento.........: '+transform(VM_DTCXA,mDT)
	?
	? '(+)Saldo Incial (DIA)...: '+transform(VM_SLDINI,mD112)
	? '(+)Vendas do Dia...(V)..: '+transform(VM_VLRVIS,mD112)
	? '( )Vendas do Dia...(P)..: '+transform(VM_VLRPRA,mD112)
	? '(+)Recebimentos do Dia..: '+transform(VM_RECDIA,mD112)
	? '(+)Documentos...........: '+transform(VM_VLRDOC,mD112)
	? '( )Sub-Total............: '+transform(VM_SLDINI+VM_VLRVIS+VM_VLRDOC+VM_RECDIA,mD112)
	?
	? '(-)Remessa Matriz Dinh..: '+transform(VM_REMDIN,mD112)
	? '(-)Remessa Matriz Banco.: '+transform(VM_REMBAN,mD112)
	? '(-)Pagamentos do Dia....: '+transform(VM_PAGDIA,mD112)
	? '( )Sub-Total............: '+transform(VM_REMDIN+VM_REMBAN+VM_PAGDIA,mD112)
	?
	? 'Saldo em Caixa Calculado: '+transform(VM_SALDCAL,mD112)
	? 'Saldo de Fechamento.....: '+transform(VM_SLDATU, mD112)
	?
	? '------>Diferenca--------> '+transform(VM_SLDATU-VM_SALDCAL, mD112)
	?
	? 'Sequencias Usadas.......: '+str(NroLimit[1],6)+' ate '+str(NroLimit[2],6)
	? 'Faltam..................: '+transform(SeqCon,mI6)+' Documentos'
	? replicate('-',LAR)
	? "Valores"
   select CAIXAMC
   ORDEM CODCXA
   Dbseek(str(NroCxa,2)+dtos(VM_DTCXA),.T.)
   while !eof().and.str(NroCxa,2)+dtos(VM_DTCXA)==str(MC_CODCXA,2)+dtos(MC_DATA)
		CAIXACG->(dbseek(str(CAIXAMC->MC_CODCG,3)))
 		? str(MC_CODCG,3)+'-'+CAIXACG->CG_DESCR
 		? "---->"
 		??MC_HISTO
 		??transform(MC_VALOR, mD112)+MC_TIPO
   	pb_brake()
   end
	eject
	pb_deslimp()
	ARQUIVO:=dtos(VM_DTCXA)+'.'+left(PARAMETRO->PA_INSCR,3)
	GerarArq(ARQUIVO,'FCAIXA',val(left(PARAMETRO->PA_INSCR,3)))
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
static function GerarArq(P1,Extensao,VM_CODEMP)
local Buffer
	if !file(P1)
		Canal:=fcreate(P1)
	else
		Canal:=fopen(P1)
	end
	Buffer:='Inicio Arquivo |'+dtos(date())+CRLF
	fwrite(Canal,Buffer)
	Buffer:=Extensao+'|'
	Buffer+=pb_zer(VM_CODEMP,3)   +'|'
	Buffer+='RCD:'+pb_zer(VM_RECDIA*100,15)+'|'
	Buffer+='VDO:'+pb_zer(VM_VLRDOC*100,15)+'|'
	Buffer+='RMD:'+pb_zer(VM_REMDIN*100,15)+'|'
	Buffer+='RMB:'+pb_zer(VM_REMBAN*100,15)+'|'
	Buffer+='PGD:'+pb_zer(VM_PAGDIA*100,15)+'|'
	Buffer+='SLD:'+pb_zer(VM_SLDATU*100,15)+'|'
	Buffer+='SLI:'+pb_zer(VM_SLDATU*100,15)+'|'
	Buffer+='SLF:'+pb_zer(VM_SLDATU*100,15)+'|'
	Buffer+=CRLF
	fwrite(Canal,Buffer)
	select CAIXA02
	ORDEM CXADATA
	Dbseek(str(NroCxa,2)+dtos(VM_DTCXA),.T.)
	SEQ   :=AX_SEQ
	SeqUlt:=0
	SeqCon:=0
	Faltam:=""
	while !eof().and.str(NroCxa,2)+dtos(VM_DTCXA)==str(AX_CAIXA,2)+dtos(AX_DATA)
		Buffer:='DOCUMENTOS|'
		Buffer+=pb_zer(VM_CODEMP,3)   +'|'
		Buffer+=pb_zer(AX_SEQ,6)+'|'
		Buffer+=pb_zer(AX_VALOR*100,15)+'|'
		Buffer+=CRLF
		fwrite(Canal,Buffer)
		pb_brake()
	end
	Buffer:='Fim Arquivo'+CRLF
	fclose(Canal)
return NIL


//---------------------------------------------------------------------------pagamentos
static function AtualPgto(P1)
SALVABANCO
	select('HISFOR')
	ordem DTPGTO
	dbseek(dtos(P1),.T.)
	while !eof().and.HF_DTPGT==P1
		if !HF_FLCXA
			if reclock()
				CLIENTE->(dbseek(str(HISFOR->HF_CODFO,5)))
				grav_cxa(HF_CXACG,;
							HF_DTPGT,;
							HF_VLRPG+HF_VLRJU-HF_VLRDE-HF_VLRET+HF_VLBON,;
							CLIENTE->CL_RAZAO,;
							HF_DUPLI,;
							'CP',;
							HF_CDCXA)
				replace HF_FLCXA with .T.
				dbrunlock(recno())
			end
		end
		dbskip()
	end

//--------------------------------------------------------------------------recebimentos
	select('HISCLI')
	ordem DTPGTO
	dbseek(dtos(P1),.T.)
	while !eof().and.HC_DTPGT==P1
		if !HC_FLCXA
			if reclock()
				CLIENTE->(dbseek(str(HISCLI->HC_CODCL,5)))
				grav_cxa(HC_CXACG,;
							HC_DTPGT,;
							HC_VLRPG+HC_VLRJU-HC_VLRDE-HC_VLRET+HC_VLBON,;
							CLIENTE->CL_RAZAO,;
							HC_DUPLI,;
							'CR',;
							HC_CDCXA)
				replace HC_FLCXA with .T.
				dbrunlock(recno())
			end
		end
		dbskip()
	end
RESTAURABANCO
return NIL
