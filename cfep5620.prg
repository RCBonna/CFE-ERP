*-----------------------------------------------------------------------------*
function CFEP5620()	// Cadastro de Itens % Comissao por Produto					*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'C->GRUPOS',;
				'C->PROD'})
	return NIL
end
ORDEM CODIGO

pb_tela()
pb_lin4('Atualiza‡„o do % do vendedor',ProcName())

pb_dbedit1('CFEP562','AlteraOrdem Lista Zerar ')
VM_CAMPO:=array(4)
afields(VM_CAMPO)
VM_CAMPO[4]=fieldname(21)

VM_MARKDEL = .F.
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
							{masc(13),masc(21),masc(1),masc(6)},;
							{'Grupo','C¢dig','Descri‡„o','% Vended'})
// dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP5621() && Rotina de Inclus„o
while lastkey()#27
	CFEP5620T()
end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
function CFEP5622() && Rotina de Inclus„o
CFEP4203()
return NIL

*-----------------------------------------------------------------------------*
function CFEP5620T(VM_FL)
local GETLIST  := {}
VM_CODPR = PR_CODPR
VM_PRVEN = PR_PRVEN
pb_box(18,21,,,,'% Comiss„o')
@19,22 say 'Produto.....:' get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,78).and.reclock()
@21,22 say '% Comiss„o..:' get VM_PRVEN picture masc(06) valid VM_PRVEN>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	replace PR_PRVEN with VM_PRVEN
	// dbcommit()
	dbrunlock()
	dbskip()
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP5623() && Rotina de Impressao
*-----------------------------------------------------------------------------*
local VM_CPO:=indexord()
dbsetorder(4)
dbgobottom();VM_GRFIN=PR_CODGR
DbGoTop();   VM_GRINI=PR_CODGR
pb_box(19,30)
@20,32 say 'Grupo Inicial.' get VM_GRINI pict masc(13) valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},{||CFEP4100T(.T.)},{2,1}})
@21,38 say       'Fim.....' get VM_GRFIN pict masc(13) valid fn_codigo(@VM_GRFIN,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIN,6)))},{||CFEP4100T(.T.)},{2,1}})
read
if if(lastkey()#K_ESC,pb_ligaimp(),.F.)
	dbseek(str(VM_GRINI,6),.T.)
	VM_REL  :='Produtos por Grupo e %Vendedor'
	VM_LAR  :=80
	VM_PAG  :=0
	VM_GRINI:=space(6)
	dbeval({||CFEP56231()},,{||!eof().and.pb_brake(.T.).and.PR_CODGR<=VM_GRFIN})
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*---------------------------------------------------------------------------------*
function CFEP56231() // Rotina de Impressao
if !empty(PR_PRVEN)
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP5623A',VM_LAR)
	if VM_GRINI#str(PR_CODGR,6)
		if left(VM_GRINI,2)#left(str(PR_CODGR,6),2)
			?INEGR+fn_impgrp(left(str(PR_CODGR,6),2))+CNEGR
		end
		if left(VM_GRINI,4)#left(str(PR_CODGR,6),4)
			?INEGR+fn_impgrp(left(str(PR_CODGR,6),4))+CNEGR
			?
		end
		if left(VM_GRINI,4)#left(str(PR_CODGR,6),4).and.right(str(PR_CODGR,6),2)#'00'
			?INEGR+fn_impgrp(str(PR_CODGR,6))+CNEGR
			?
		end
		VM_GRINI=str(PR_CODGR,6)
	end
	? space(3)+pb_zer(PR_CODPR,L_P)
	??chr(45)+PR_DESCR
	??I15CPP+chr(32)+PR_COMPL+C15CPP
	??transform(PR_PRVEN,'@E 9999.99')
end
return NIL

function CFEP5623A() && Rotina de Impressao
? space(3)+padr('Codigo',L_P+2)
??padr('Descricao',41)
??I15CPP+padr('Complemento',41)+C15CPP
??'% Vended'
?replicate('-',VM_LAR)

//---------------------------------------------------------------
function CFEP5624() && Rotina de Inclusao
if pb_sn("Eliminar Comissao de todos Produtos")
	DbGoTop()
	while !eof()
		pb_msg('Processando..'+str(PR_CODPR,L_P))
		if reclock()
			replace PR_PRVEN with 0 // % venda comissao
		end
		dbrunlock()
		skip
	end
end
DbGoTop()
return NIL

*------------------------------------------------------EOF