*--------------------------------------------------------------------------*
 function CFEP4390() // Produtos Nao Movimentados desde DD/MM/AA				*
*--------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_REL:= 'Produtos nao Movimentados ate '
local VM_PAG:=0
private VM_LAR
pb_lin4(VM_REL,ProcName())

if !abre({	'R->PARAMETRO',;
				'R->PROD'})
	return NIL
end
dbsetorder(2)
DbGoTop()
VM_DATA := date()-180
VM_ITZER:='T'
pb_box(19,26)
@20,28 say 'Listar Itens Zerados ?' get VM_ITZER pict mUUU    valid VM_ITZER$'SNT'   when pb_msg('<S>So Itens Zerados    <N>So Itens Nao Zerados   <T> Todos Itens')
@21,28 say 'Listar '+VM_REL+'.:'    get VM_DATA  pict masc(7) valid VM_DATA<=date()
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_REL+=dtoc(VM_DATA)
	VM_LAR:=132
	while !eof()
		if PR_DTMOV<=VM_DATA
			if VM_ITZER=='T'.or.;
				(if(VM_ITZER=='S',str(PR_QTATU,15,3)==str(0,15,3),if(VM_ITZER=='N',str(PR_QTATU,15,3)#str(0,15,3),.T.)))
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4390A',VM_LAR)
				?  padr(pb_zer(PR_CODPR,L_P)+'-'+PR_DESCR,49)+space(1)
				?? PR_UND+space(2)+PR_LOCAL+space(2)
				?? transform(PR_ETMIN,masc(6))+space(1)
				?? transform(PR_QTATU,masc(6))+space(1)
				?? transform(PR_VLVEN,masc(2))+space(2)
				?? transform(PR_VLATU,masc(2))+space(2)
				?? dtoc(PR_DTMOV)+space(1)
				?? str(PARAMETRO->PA_DATA-PR_DTMOV,4)
			end
		end
		pb_brake()
	end									
	?replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

//----------------------------------------------------------------------
 function CFEP4390A()
//----------------------------------------------------------------------

?padr('Produto',50)+'Unidad Local'
??space(4)+'Est.Min.   Qt.Atu.  Vlr.Unt.-VENDA  Vlr.Total-MEDIO  Ult.Mov  Dias'
?replicate('-',VM_LAR)
return NIL
