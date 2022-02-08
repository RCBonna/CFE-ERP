*-----------------------------------------------------------------------------*
function CFEP4321(VM_P1)	//	Lista Precos												*
*						VM_P1=1 -> ordem GRUPO+NUMERICA										*
*						VM_P1=2 -> ordem Produto												*
*						VM_P1=3 -> ordem ALFABETICA											*
*						VM_P1=4 -> ordem GRUPO+ALFABETICA									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())
if !abre({	'R->GRUPOS',;
				'R->PARAMETRO',;
				'R->PROD'})
	return NIL
end
dbsetorder(VM_P1) // ordem dos produtos

VM_CTB :=0
VM_TIPO:=restarray('ESTOQUE.ARR')
VM_FLAG:={'N','S','C','S','S','N','N'}
/*
-----------1
---------------2
-------------------3
-----------------------4
---------------------------5
-------------------------------6
-----------------------------------7 imprime pis/cofins no relatório?
*/
nX:=13
pb_box(nX++,18,,,,'Selecione')
if '//APLICACAO'$upper(getenv('CFE'))
	@nX++,20 say 'Impr Aplica‡„o....:' get VM_FLAG[6] pict masc(1) valid VM_FLAG[6]$'SN'
end
@nX++,20 say 'Tipo de Listagem.....:' get VM_FLAG[3] pict masc(01) valid VM_FLAG[3]$'CN'												when pb_msg("[C]ondensado/[N]ormal")
@nX++,20 say 'Tipo Estoque.........:' get VM_CTB     pict masc(11) valid if(VM_CTB>0,fn_codar(@VM_CTB,'ESTOQUE.ARR'),.T.)	when pb_msg("Qual Grupo de Estoque a Listar <0>=Todos")
@nX++,20 say 'Selecionar Grupo.....?' get VM_FLAG[5] pict masc(01) valid VM_FLAG[5]$'SN'												when pb_msg("Selecionar Grupo de Estoque?")
@nX++,20 say 'Com Produto Zerado...?' get VM_FLAG[1] pict masc(01) valid VM_FLAG[1]$'SN'												when pb_msg("Listar Produto com Saldo Zero?")
@nX++,20 say 'Imprime Tp Pis/Cofins?' get VM_FLAG[7] pict masc(01) valid VM_FLAG[7]$'SN'
read

if lastkey()#27
	if VM_CTB>0
		VM_TIPO:=VM_TIPO[ascan(VM_TIPO,{|DET|DET[1]==VM_CTB}),2]
	end
	select('GRUPOS')
	dbgobottom();	VM_GRFIN:=GE_CODGR
	DbGoTop();		VM_GRINI:=GE_CODGR
	@nX++,20 say padr('Grupo Inicial',20) get VM_GRINI picture mGRU valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},,{2,1}})                        when VM_FLAG[5]=='S'
	@nX++,26 say padr('Final',14)         get VM_GRFIN picture mGRU valid fn_codigo(@VM_GRFIN,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIN,6)))},,{2,1}}).and.VM_GRINI<=VM_GRFIN when VM_FLAG[5]=='S'
	read
end

if if(lastkey()#27,pb_ligaimp(),.F.)
	if VM_FLAG[3]=='C'
		??I15CPP
	else
		??C15CPP
	end
	select('PROD')
	VM_FLAG[1]=VM_FLAG[1]='S'
	VM_FLAG[3]=VM_FLAG[3]='N' // Normal=.T.       // Condensado=.F.
	VM_FLAG[4]=VM_FLAG[4]='S'
	VM_FLAG[5]=VM_FLAG[5]='S'
	VM_LAR = if(VM_FLAG[3],80,133)
	VM_PAG = 0
	VM_REL = 'Lista de Preco '+if(VM_P1==1,'por Grupo (CODIGO)',if(VM_P1==4,'por Grupo (ALFA)','Alfabetica'))
	VM_REL+= space(2)+if(VM_CTB>0,'So '+trim(VM_TIPO),'Todos os Produtos')
	if VM_CTB>0.and.VM_FLAG[5] // selecionar produtos
		dbsetfilter({||PROD->PR_CTB==VM_CTB.and.;
							PROD->PR_CODGR>=VM_GRINI.and.;
							PROD->PR_CODGR<=VM_GRFIN.and.;
							filprod()})
	elseif VM_CTB>0 // selecionar produtos
		dbsetfilter({||PROD->PR_CTB==VM_CTB.and.;
							PROD->PR_CODGR>=VM_GRINI.and.;
							PROD->PR_CODGR<=VM_GRFIN.and.;
							filprod()})
	elseif VM_FLAG[5] // selecionar produtos
		dbsetfilter({||PROD->PR_CODGR>=VM_GRINI.and.;
							PROD->PR_CODGR<=VM_GRFIN.and.;
							filprod()})
	end
	DbGoTop()
	if VM_P1==1.or.VM_P1==4
		set relation to str(PR_CODGR,6) into GRUPOS
		dbseek(str(VM_GRINI,6),.T.)
		while !eof().and.PR_CODGR<=VM_GRFIN
			CFEP43211() // por grupo
		end
	else
		while !eof()
			CFEP4321I() // alfabetica/NUMERICA
		end
	end
	?replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP43211() // por grupo
*-----------------------------------------------------------------------------*
VM_GRUPO=left(str(PR_CODGR,6),2)
VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4321A',VM_LAR)
? INEGR+fn_impgrp(VM_GRUPO)+CNEGR
while !eof().and.PR_CODGR<=VM_GRFIN.and.left(str(PR_CODGR,6),2)==VM_GRUPO
	VM_SUBGR=left(str(PR_CODGR,6),4)
	VM_PAG = pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(),VM_REL,VM_PAG,'CFEP4321A',VM_LAR)
	? INEGR+fn_impgrp(VM_SUBGR)+CNEGR
	while !eof().and.PR_CODGR<=VM_GRFIN.and.left(str(PR_CODGR,6),4)==VM_SUBGR
		VM_SUBSB = str(PR_CODGR,6)
		if right(VM_SUBSB,2) # '00'
			? INEGR+fn_impgrp(VM_SUBSB)+CNEGR
		end
		?
		while !eof().and.PR_CODGR<=VM_GRFIN.and.str(PR_CODGR,6)==VM_SUBSB
			CFEP4321I() // IMPRESSAO LINHA
		end
		?
	end
end			
return NIL

*-----------------------------------------------------------------------------*
function CFEP4321A()
*-----------------------------------------------------------------------------*
? padr('Produto',49)
if VM_FLAG[3]
	?space(8)
end
??if(VM_FLAG[3],I15CPP,'')+'Complemento'+space(30)
??if(VM_FLAG[3],C15CPP+space(4),'')
??'Grupo Unid'+space(6)
if VM_FLAG[7]=='S' // Imprime Pis/Cofins Entrada e Saida
	??'Pis/Cofins [E]/[S]'
else
	??'Qtdade'+space(1)+'Vlr Vista'+space(1)+'Vlr Prazo Pis/Cof'
	? replicate('-',VM_LAR)
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP4321I() // impressao linha
*-----------------------------------------------------------------------------*
VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4321A',VM_LAR)
if VM_FLAG[1].or.PR_QTATU>0
	? padr(pb_zer(PR_CODPR,L_P)+'-'+PR_DESCR,48)+space(1)
	if VM_FLAG[3]
		?space(8)
	end
	??if(VM_FLAG[3],I15CPP,'')+PR_COMPL+if(VM_FLAG[3],space(5)+C15CPP,'')
	??transform(PR_CODGR,masc(13))+' '+PR_UND
	if VM_FLAG[7]=='S' // Imprime Pis/Cofins Entrada e Saida
		??space(13)
		??" "+PR_CODCOE
		??"/"+PR_CODCOS
	else	
		??transform(PR_QTATU,masc(6))
		??transform(PR_VLVEN,masc(32))
		??transform(PR_VLVEN+PR_VLVEN*(PARAMETRO->PA_DESCV+PR_PERVEN)/100,masc(32))
	end
	if VM_FLAG[6]=='S'
		for X:=1 to 10
			if !empty(substr(PR_APLIC,X*40-39,40))
				?space(L_P+1)+substr(PR_APLIC,X*40-39,40)
			end
		next
	end
end
pb_brake()
return NIL
*-----------------------------------------------------EOF---------------------*
