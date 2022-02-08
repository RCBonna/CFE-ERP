*-----------------------------------------------------------------------------*
function CFEP4370()	//	Produtos que atingiram estoque minimo						*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_REL:= 'Estoque Inferior ao Minimo',;
		VM_PAG:=0,VM_OPC

pb_lin4(VM_REL,ProcName())
if !abre({'R->PARAMETRO','R->PROD'})
	return NIL
end
dbsetorder(if(VM_OPC=1,2,3));DbGoTop()

VM_OPC:=alert('Selecione Ordem de Impress„o.',{'C¢digo','Alfabetica'})
if if(VM_OPC>0,pb_ligaimp(I15CPP),.F.)
	while !eof()
		VM_LAR:=132
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4370A',VM_LAR)
		if PR_ETMIN>0.and.PR_QTATU<PR_ETMIN
			?  padr(pb_zer(PR_CODPR,L_P)+chr(45)+PR_DESCR,49)+space(1)
			?? PR_UND+space(1)+PR_LOCAL+space(1)
			?? transform(PR_ETMIN,masc(6))
			?? transform(PR_QTATU,masc(6))
			?? transform(PR_VLATU,masc(2))
			?? space(2)+dtoc(PR_DTMOV)+space(2)+dtoc(PR_DTCOM)
			?? transform(PR_VLCOM,masc(2))
		end
		pb_brake()
	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP4370A()
?padr('Produto',50)+'Unid. Local'
??space(4)+'Et.Min. Qt.Atual Vl.Total-MEDIO'
??space(2)+'Ult.Mov.  Ult.Com.   Vlr.Ult.Compr'
?replicate('-',VM_LAR)
return NIL
