*-----------------------------------------------------------------------------*
function CXAPLIGR() //  despesas por grupo
*-----------------------------------------------------------------------------*
local X
#include 'RCB.CH'
if !abre({'C->CAIXAPA','C->CAIXASA','C->CAIXACG','C->CAIXAMC'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end
select('CAIXAMC')
ORDEM CODCG
VM_DATA  :={bom(date()),eom(date())}
VM_CONTA :=0
VM_TIPOL :='R'

X:=MaxRow()-7
pb_box(X++,MaxCol()-55,MaxRow()-2,MaxCol(),,'Selecao')
@X++,MaxCol()-54 say 'Data Inicial.:' get VM_DATA[1] pict masc(07)
@X++,MaxCol()-54 say 'Data Final...:' get VM_DATA[2] pict masc(07) valid VM_DATA[2]>=VM_DATA[1] when (VM_DATA[2]:=eom(VM_DATA[1]))>CTOD('')
@X  ,MaxCol()-30 say '<R> Resumida <D> Detalhada'
@X++,MaxCol()-54 say 'Tipo Listagem:' get VM_TIPOL   pict masc(01) valid VM_TIPOL$'RD'
@X  ,MaxCol()-30 say '<0> para todas'
@X++,MaxCol()-54 say 'Cod Conta....:' get VM_CONTA   pict masc(03) valid VM_CONTA==0.or.fn_codigo(@VM_CONTA,{'CAIXACG',{||CAIXACG->(dbseek(str(VM_CONTA,3)))},{||CXAPCDGRT(.T.)},{2,1}}) when VM_TIPOL=='D'
read
if if(lastkey()#27,pb_ligaimp(C15CPP),.F.)
	VM_LAR:=80
	VM_PAG:=0
	VM_REL:='Resumo por Grupo de Despesas'
	set filter to MC_DATA>=VM_DATA[1].and.MC_DATA<=VM_DATA[2]
	DbGoTop()
	dbseek(str(VM_CONTA,3),.T.)
	TOTAL:={0,0,0,0}
	while !eof().and.if(VM_CONTA>0,VM_CONTA==MC_CODCG,.T.)
		VM_PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CXAPLIGRC',VM_LAR)
		VM_CODCG:=MC_CODCG
		CAIXACG->(dbseek(str(VM_CODCG,3)))
		?  padr(pb_zer(VM_CODCG,3)+' - '+CAIXACG->CG_DESCR,50)
		while !eof().and.VM_CODCG==MC_CODCG
			if VM_TIPOL=='D'
				VM_PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CXAPLIGRC',VM_LAR)
				? space(04)+dtoc(MC_DATA)
				??space(01)+I15CPP+MC_HISTO+C15CPP
				??space(if(MC_TIPO=='+',0,17))
				??transform(MC_VALOR,masc(02))
			end
			TOTAL[if(MC_TIPO=='+',1,2)]+=MC_VALOR
			dbskip()
		end
		if VM_TIPOL=='D'
			?space(10)+padr('Total do Grupo de Conta',40,'.')
		end
		??	transform(TOTAL[1],masc(02))
		??	transform(TOTAL[2],masc(02))
		if VM_TIPOL=='D'
			?
		end
		TOTAL[3]+=TOTAL[1]
		TOTAL[4]+=TOTAL[2]
		TOTAL[1]:=0
		TOTAL[2]:=0
	end
	? replicate('-',VM_LAR)
	?space(10)+padr('TOTAL DO GERAL',40,'.')
	??	transform(TOTAL[3],masc(02))
	??	transform(TOTAL[4],masc(02))
	? replicate('-',VM_LAR)
	? 'impresso as '+time()
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CXAPLIGRC()
? padc('Periodo : '+dtoc(VM_DATA[1])+' a '+dtoc(VM_DATA[2]),VM_LAR)
?
?	padr('Despesas',51)+'Total Entradas   Total Saidas'
if VM_TIPOL=='D'
	?space(4)+'Data   Historico'
end
?	replicate('-',VM_LAR)
return NIL
