*-----------------------------------------------------------------------------*
static CodLib:="R.A.001"
static PWord :=CHR(250)+chr(250)
*-----------------------------------------------------------------------------*
 function CFEPRA01()	// Cadastro de Itens - Receituario Agronomico
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X
local SENHA:=''
local CodX :=trunca(TimeToSec(Time()),0)
if !abre({	'R->PARAMETRO',;
				'C->PARALINH',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->CODTR',;
				'C->PRODAPL'})
	return NIL
end

	select('PROD')
	ordem CODIGO
	select('PRODAPL')
	set relation to str(P1_CODPR,L_P) into PROD
	DbGoTop()
	pb_tela()
	pb_lin4(_MSG_,ProcName())
	pb_dbedit1('CFEPRA01','IncluiAlteraPesquiExclui')
	VM_CAMPO:={'str(P1_CODPR,L_P)+chr(45)+PROD->PR_DESCR','P1_CLTOX','P1_DOSAGE'}
	VM_MASC :={                                   masc(1),  masc(28),masc(20)}
	VM_CABE :={                                 'Produto', 'Cl.Tox','Dosagem' }
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2', VM_MASC,VM_CABE)

dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEPRA011() // Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	CFEPRA01T(.T.)
	dbrunlock()
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA012() // Rotina de Alteracao
if reclock()
	CFEPRA01T(.F.)
	dbrunlock(recno())
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA01T(VM_FL)
local GETLIST := {},LCONT:=.T.,VM_X,ORDANT:=indexord()
for VM_X=1 to fcount()
	VM_Y :='VM'+substr(fieldname(VM_X),3)
	&VM_Y:=&(fieldname(VM_X))
next
if VM_FL
	VM_CLTOX :=1
	VM_APLICA:= 'PRINCIPIO ATIVO....: '+chr(13)+chr(10)+;
					'CONCENTRACAO.......: '+chr(13)+chr(10)+;
					'FORMULACAO.........: '+chr(13)+chr(10)+;
					'GRUPO QUIMICO......: '+chr(13)+chr(10)+;
					'DIAGNOSTICO........: '+chr(13)+chr(10)+;
					'DOSAGEM............: '+chr(13)+chr(10)+;
					'APLICACAO..........: '+chr(13)+chr(10)+;
					'CARENCIA...........: '+chr(13)+chr(10)+;
					'PRECAUCOES E PRIMEIROS SOCORROS'+chr(13)+chr(10)+;
					'RECOMENDACOES PARA USO E MANEJO DE EQUIPAMENTOS'
end

pb_box(,,,,,'Produtos Agronomicos')
keyboard chr(K_CTRL_END)
@8,5 say padc('RECOMENDACOES',71) color 'R/W'
memoedit(VM_APLICA,9,5,21,75,.f.)
@06,02 say 'C¢digo Produto.....:' get VM_CODPR picture masc(21) valid pb_ifcod2(str(VM_CODPR,L_P),NIL,.F.).and.fn_codpr(@VM_CODPR,77).and.PROD->(reclock()) when VM_FL
if !VM_FL
	@06,36 say PROD->PR_DESCR
end
@07,02 say 'Classe Toxicologica:' get VM_CLTOX pict masc(28) valid VM_CLTOX>0.and.VM_CLTOX<5
@07,60 say 'Dosagem:' get VM_DOSAGE            pict masc(20) valid VM_DOSAGE>0.00
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	set cursor ON
	set function 10 to chr(K_CTRL_END)
	pb_msg('Pressione F10 para gravar')
	VM_APLICA:=memoedit(VM_APLICA,9,5,21,75)
	set function 10 to 
	set cursor OFF
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		if VM_FL
			LCONT:=AddRec()
		end
		if LCONT
			for VM_X=1 to fcount()
				VM_Y:="VM"+substr(fieldname(VM_X),3)
				replace &(fieldname(VM_X)) with &VM_Y
			next
			// dbcommit()
			dbskip(0)
			if VM_FL
				DbGoTop()
			end
		end
	end
end
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA013() // Rotina de Pesquisa
local VM_CODPR:=P1_CODPR
@21,30 say 'Pesquisar ' get VM_CODPR pict masc(21)
read
setcolor(VM_CORPAD)
dbseek(str(VM_CODPR,L_P),.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEPRA014() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir PRODUTO..:'+pb_zer(P1_CODPR,L_P)+chr(45)+trim(PROD->PR_DESCR))
	fn_elimi()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*
