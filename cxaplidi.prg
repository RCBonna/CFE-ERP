*-----------------------------------------------------------------------------*
function CXAPLIDI()	//	Lista Diario do Caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
if !abre({'C->CAIXAPA','C->CAIXASA','C->CAIXACG','C->CAIXAMC'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end
select CAIXAMC
VM_DATA  :={bom(date()),eom(date())}
VM_FECHAR:='N'
SALDO    :=0.00
VM_DIARIO:=0
VM_MARGEM:=CAIXAPA->PA_MARGEM

X:=MaxRow()-8
pb_box(X++,MaxCol()-30,MaxRow()-2,MaxCol(),,'Selecao')
@X++,MaxCol()-28 say 'Data Inicial.:' get VM_DATA[1] pict masc(07) valid VM_DATA[1]>CAIXAPA->PA_DTFECC.and.fn_versadt(VM_DATA[1],@SALDO,@VM_DIARIO)
@X++,MaxCol()-28 say 'Data Final...:' get VM_DATA[2] pict masc(07) valid VM_DATA[2]>=VM_DATA[1].and.left(dtos(VM_DATA[1]),6)==left(dtos(VM_DATA[2]),6) when (VM_DATA[2]:=eom(VM_DATA[1]))>CTOD('')
@X++,MaxCol()-28 say 'Diario.......:' get VM_DIARIO  pict masc(12)
@X++,MaxCol()-28 say 'Margem Impres:' get VM_MARGEM  pict masc(12)
@X++,MaxCol()-28 say 'Fechar Mes...:' get VM_FECHAR  pict masc(01) valid VM_FECHAR$'SN' when bom(VM_DATA[1])==VM_DATA[1].and.eom(VM_DATA[1])==VM_DATA[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	set margin to VM_MARGEM
	dbseek(dtos(bom(VM_DATA[1])),.T.)
	PAGINA :=1
	NRLANC :=40
	VM_LAR :=120
 	CONTA  :=0
	TOTMV  :={0,0}
	// somar saldo ate a data
	while !eof().and.MC_DATA<VM_DATA[1]
		CAIXACG->(dbseek(str(CAIXAMC->MC_CODCG,3)))
		if CAIXACG->CG_INFCX
			if MC_TIPO=='+'
				TOTMV[1]+=MC_VALOR
			elseif MC_TIPO=='-'
				TOTMV[2]+=MC_VALOR
			end
			CONTA++
			if CONTA>NRLANC
				PAGINA++
				CONTA:=0
			end
		end
		dbskip()
	end

	CONTA:=0
	SALDO:=SALDO+TOTMV[1]-TOTMV[2] // novo saldo para relatorio
	TOTMV:={0,0}
	fn_pagina()
	while !eof().and.MC_DATA<=VM_DATA[2]
		CAIXACG->(dbseek(str(CAIXAMC->MC_CODCG,3)))
		if CAIXACG->CG_INFCX
			CONTA++
			?	dtoc(MC_DATA)+space(03)
			??	padr(MC_HISTO,75)
			if MC_TIPO=='+'
				TOTMV[1]+=MC_VALOR
			elseif MC_TIPO=='-'
				??	space(17)
				TOTMV[2]+=MC_VALOR
			end
			??	transform(MC_VALOR,masc(02))
			if CONTA>NRLANC
				?
				?space(60)+'Continua...'
				fn_pagina()
			end
		end
		dbskip()
	end
	// TOTAL
	for X:=CONTA to NRLANC
		?
	next
	?	space(89)+replicate('-',14)+space(03)+replicate('-',14)
	?	space(60)+padr('Total Entradas/Saidas',28,'.')
	?? transform(TOTMV[1],masc(02))+space(02)
	??	transform(TOTMV[2],masc(02))
	?
	?	space(60)+padr('Saldo Anterior',28,'.')+transform(SALDO,masc(02))
	SALDON:=SALDO+TOTMV[1]-TOTMV[2] // novo saldo
	?	space(60)+padr('Saldo Atual',28,'.')+space(17)+transform(SALDON,masc(02))
	?	space(89)+replicate('-',14)+space(03)+replicate('-',14)
	?	space(60)+padr('Fechamento',28,'.')
	?? transform(SALDO+TOTMV[1],masc(02))+space(02)
	??	transform(SALDON+TOTMV[2],masc(02))
	for X:=1 to 5
		?
	next
	?	replicate('-',30)+space(25)+replicate('-',30)
	?	padr('Visto Caixa',30)+space(25)+padr('Visto Gerencia',30)
	eject
	set margin to
	pb_deslimp(C15CPP)
	if VM_FECHAR=='S'.and.pb_sn('Diario esta correto ? Fechar ?')
		select CAIXAPA
		while !recLock();end
		replace 	CAIXAPA->PA_DTFECC with VM_DATA[2],;
					CAIXAPA->PA_LIVRO  with VM_DIARIO,;
					CAIXAPA->PA_PAGINA with PAGINA
		select('CAIXASA')
		if found()
			while !recLock();end
			replace SA_FLAG with .T. // MES ANTERIOR FECHADO
		end
		if !dbseek(left(dtos(VM_DATA[2]),6))
			AddRec()
			replace SA_PERIOD with left(dtos(VM_DATA[2]),6)
		else
			while !recLock();end
		end
		replace 	SA_SALDO  with SALDON,;
					SA_DIARIO with VM_DIARIO,;
					SA_FLAG   with .F.
		pb_msg('Eliminando lancamentos anteriores...')
		select CAIXAMC
		DbGoTop()
		X:=0
		while !eof().and.CAIXAMC->MC_DATA < (VM_DATA[1]-100)
			if reclock()
				delete
				X++
				@24,60 say str(X,5)
			end
			dbrunlock()
			dbskip()
		end
	end
end
dbcloseall()
return NIL

function FN_PAGINA()
if CONTA>NRLANC
	eject
	PAGINA++
	CONTA:=0
end
?	padc(trim(VM_EMPR),VM_LAR)
?  padl('Diario..: '+pb_zer(VM_DIARIO,6),VM_LAR)
?	space(47)+'M O V I M E N T O  D O  C A I X A'+space(24)+'Folha...: '+pb_zer(PAGINA,6)
?
?	padc('REFERENTE PERIODO [ '+dtoc(VM_DATA[1])+' ate '+dtoc(VM_DATA[2])+']', VM_LAR)
?	space(96)+'Entrada'+space(12)+'Saida'
?	replicate('-',VM_LAR)
return NIL


function FN_VERSADT(P1,P2,P3)
salvabd(SALVA)
select('CAIXASA')
P1:=bom(P1)-1
if dbseek(left(dtos(P1),6))
	P2:=SA_SALDO
	P3:=SA_DIARIO
else
	alert("O periodo "+transform(dtos(P1),masc(30))+";NAO ESTA FECHADO")
	P2:=0
	P3:=0
end
salvabd(RESTAURA)
return .T.
