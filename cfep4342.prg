*-----------------------------------------------------------------------------*
function CFEP4342(VM_P1)	//	Comparativo Precos com qtdade							*
*						VM_P1=1 -> ordem GRUPO+NUMERICA										*
*						VM_P1=4 -> ordem GRUPO+ALFABETICA									*
*						VM_P1=3 -> ordem ALFABETICA											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())
if !abre({'R->GRUPOS','R->PARAMETRO','R->PROD'})
	return NIL
end
dbsetorder(VM_P1) // ordem dos produtos

VM_CTB :=0
VM_TIPO:=restarray('ESTOQUE.ARR')
VM_FLAG:={'N','S','C','S',.T.,'N'}
pb_box(16,18,,,,'Sele‡Æo de Relatorio')
@17,45 say '[C]ondensado/[N]ormal'
@17,20 say 'Tipo de Listagem..:' get VM_FLAG[3] pict masc(1) valid VM_FLAG[3]$'CN'
@18,45 say '<0> para todos'
@18,20 say 'Tipo Estoque......:' get VM_CTB     pict masc(11) valid if(VM_CTB>0,fn_codar(@VM_CTB,'ESTOQUE.ARR'),.T.)
@19,20 say 'Com Prod.Zerado ?.:' get VM_FLAG[1] pict masc(1)  valid VM_FLAG[1]$'SN'
read

if lastkey()#27
	if VM_CTB>0
		VM_TIPO:=VM_TIPO[ascan(VM_TIPO,{|DET|DET[1]==VM_CTB}),2]
	end
	select('GRUPOS')
	dbgobottom();	VM_GRFIN=GE_CODGR
	DbGoTop();		VM_GRINI=GE_CODGR
	@20,20 say padr('Grupo Inicial',20) get VM_GRINI picture masc(13) valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},,{2,1}}) when if(VM_P1==3,eval({||VM_FLAG[5]:=pb_sn('Selecionar Grupos de Estoque')}),.T.)
	@21,26 say padr('Final',14)         get VM_GRFIN picture masc(13) valid fn_codigo(@VM_GRFIN,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIN,6)))},,{2,1}}).and.VM_GRINI<=VM_GRFIN when VM_FLAG[5]
	read
end

if if(lastkey()#27,pb_ligaimp(),.F.)
	if VM_FLAG[3]=='C'
		??I15CPP
	else
		??C15CPP
	end
	select('PROD')
	VM_FLAG[4]:=VM_FLAG[4]='S'
	VM_FLAG[3]:=VM_FLAG[3]='N' // Normal=.T.       // Condensado=.F.
	VM_FLAG[1]:=VM_FLAG[1]='S'
	VM_LAR    :=if(VM_FLAG[3],80,132)
	VM_TOTAL  :={0,0}
	VM_PAG    :=0
	VM_REL    :='Lista de Preco '+if(VM_P1==1,'por Grupo (CODIGO)',if(VM_P1==4,'por Grupo (ALFA)','Alfabetica'))
	VM_REL+= space(2)+if(VM_CTB>0,'So '+trim(VM_TIPO),'Todos os Produtos')
	if VM_CTB>0.and.VM_FLAG[5] // selecionar produtos
		dbsetfilter({||PROD->PR_CTB==VM_CTB.and.;
							PROD->PR_CODGR>=VM_GRINI.and.;
							PROD->PR_CODGR<=VM_GRFIN.and.;
							if(VM_FLAG[1],.T.,PROD->PR_QTATU#0).and.;
							filprod()})
	elseif VM_CTB>0 // selecionar produtos
		dbsetfilter({||PROD->PR_CTB==VM_CTB.and.;
							if(VM_FLAG[1],.T.,PROD->PR_QTATU#0).and.;
							filprod()})
	elseif VM_FLAG[5] // selecionar produtos
		dbsetfilter({||PROD->PR_CODGR>=VM_GRINI.and.;
							PROD->PR_CODGR<=VM_GRFIN.and.;
							if(VM_FLAG[1],.T.,PROD->PR_QTATU#0).and.;
							filprod()})
	elseif !VM_FLAG[1]
		dbsetfilter({||PROD->PR_QTATU#0.and.filprod()})
	else
		dbsetfilter({||filprod()})
	end
	DbGoTop()
	if VM_P1#3
		select('PROD')
		set relation to str(PR_CODGR,6) into GRUPOS
		dbseek(str(VM_GRINI,6),.T.)
		while !eof().and.PR_CODGR<=VM_GRFIN
			CFEP43421() // por grupo
		end
	else
		while !eof()
			CFEP4342I() // alfabetica
		end
	end
	?replicate('-',VM_LAR)
	? padr('Total dos valores a preco de custo',90)
	??transform(VM_TOTAL[2],masc(2))
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP43421() // por grupo
VM_GRUPO=left(str(PR_CODGR,6),2)
VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4342A',VM_LAR)
? INEGR+fn_impgrp(VM_GRUPO)+CNEGR
while !eof().and.PR_CODGR<=VM_GRFIN.and.left(str(PR_CODGR,6),2)==VM_GRUPO
	VM_SUBGR=left(str(PR_CODGR,6),4)
	VM_PAG = pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(),VM_REL,VM_PAG,'CFEP4342A',VM_LAR)
	? INEGR+fn_impgrp(VM_SUBGR)+CNEGR
	while !eof().and.PR_CODGR<=VM_GRFIN.and.left(str(PR_CODGR,6),4)==VM_SUBGR
		VM_SUBSB = str(PR_CODGR,6)
		if right(VM_SUBSB,2) # '00'
			? INEGR+fn_impgrp(VM_SUBSB)+CNEGR
		end
		?
		while !eof().and.PR_CODGR<=VM_GRFIN.and.str(PR_CODGR,6)==VM_SUBSB
			CFEP4342I() // IMPRESSAO LINHA
		end
		?
	end
end			
return NIL

*-----------------------------------------------------------------------------*
function CFEP4342A()
? padr('Produto',49)
if VM_FLAG[3]
	?space(8)
end
??if(VM_FLAG[3],I15CPP,'')+padr('Complemento',23)
??if(VM_FLAG[3],C15CPP,'')
??'Qtdade '
??'Valor Custo    '
??'Total Custo '
??'Valor Venda'+space(3)+'% Aumento'
? replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function CFEP4342I() // impressao linha
VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4342A',VM_LAR)
if VM_FLAG[1].or.PR_QTATU>0
	? padr(pb_zer(PR_CODPR,L_P)+'-'+PR_DESCR,48)+space(1)
	if VM_FLAG[3]
		?space(8)
	end
	??if(VM_FLAG[3],I15CPP,'')+left(PR_COMPL,20)+if(VM_FLAG[3],space(5)+C15CPP,'')
	??transform(PR_QTATU,masc(06))
	??transform(PR_VLCOM,masc(25))
	??transform(PR_VLCOM*PR_QTATU,masc(2))
	??transform(PR_VLVEN,masc(25))
	if PR_VLCOM>PR_VLVEN
		??transform(-(pb_divzero(PR_VLCOM,PR_VLVEN)*100-100),masc(25))
	else
		??transform(pb_divzero(PR_VLVEN,PR_VLCOM)*100-100,masc(25))
	end
	VM_TOTAL[2]+=PR_VLCOM*PR_QTATU
end
pb_brake()
return NIL
