*-----------------------------------------------------------------------------*
function CFEP44C0()	// Alterar Vlr Custo/Vlr Venda
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'R->PARAMETRO','R->CODTR','C->GRUPOS','C->MOVEST','C->PROD'})
	return NIL
end
select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

select('PROD')
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())

pb_dbedit1('CFEP44C','AlteraPesquiOrdem ')
VM_CAMPO:={'PR_CODGR','PR_CODPR','left(PR_DESCR,25)','left(PR_COMPL,20)','PR_VLCOM','PR_DTCOM','PR_VLVEN'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
							{masc(13),masc(21),masc(1),    masc(1),      masc(25),      masc(8),    masc(25)},;
							{'Grupo','C¢dig', 'Descri‡„o','Complemento','Valor Compra','Dt Compra','Vl Venda'})
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

function CFEP44C1() && Rotina de Inclus„o
while !eof().and.lastkey()#27
	if !reclock()
		loop
	end
	pb_box(14,20,,,,'Alterar VlrCompra')
	VM_DTCOM:=PR_DTCOM
	VM_VLCOM:=PR_VLCOM
	VM_VLVEN:=PR_VLVEN
	@15,22 say 'Grupo.......: '+transform(PR_CODGR,masc(13))
	@16,22 say 'C¢digo Prod.: '+str(PR_CODPR,L_P)
	@17,22 say 'Descri‡„o...: '+PR_DESCR
	@18,22 say 'Complemento.: '+PR_COMPL
	@19,22 say 'Data Compra.:' get VM_DTCOM picture masc(08)
	@20,22 say 'Vlr Compra..:' get VM_VLCOM picture masc(06) valid VM_VLCOM>=0.and.fn_vlven(@VM_VLVEN,(VM_VLCOM),PR_CODPR,0,0,0)
	@21,22 say 'Vlr Venda...:' get VM_VLVEN picture masc(06) valid VM_VLVEN>=0
	read
	if if(lastkey()#K_ESC,pb_sn(),.f.)
		replace  PR_DTCOM with VM_DTCOM,;
					PR_VLCOM with VM_VLCOM,;
					PR_VLVEN with VM_VLVEN
		dbrunlock()
		dbskip()
	end
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP44C2() // Rotina de Pesquisa
local VM_CHAVE1,VM_CHAVE2:={'Grupo','C¢digo','Descri‡„o'},;
		VM_CHAVE3:={masc(13),masc(21),'@K!S20'}
CFEP4205()
VM_CHAVE1:=if(indexord()=1,PR_CODGR,if(indexord()=2,PR_CODPR,PR_DESCR))
pb_box(20,28)
@21,30 say 'Pesquisar '+padr(VM_CHAVE2[indexord()],12,'.') get VM_CHAVE1 picture VM_CHAVE3[indexord()]
read
setcolor(VM_CORPAD)
dbseek(transform(VM_CHAVE1,VM_CHAVE3[indexord()]),.T.)
return NIL

*-----------------------------------------------------------------------------*
function CFEP44C3() // Rotina de Pesquisa
	CFEP4205() && Mudanca de Ordem
return NIL

