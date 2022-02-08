#include 'RCB.CH'
*-----------------------------------------------------------------------------*
* Calcula o valor de venda																		*
* P1=Retorna o valor do preco de venda														*
* P2=Valor medio de entrada																	*
* P3=Codigo do produto																			*
* P4=Proporcional Frete																			*
* P5=%ICMS																							*
* P6=VLR IPI																						*
*-----------------------------------------------------------------------------*
 function FN_VLVEN(P1,P2,P3,P4,P5,P6)  // Calcula Vlr.Venda
*-----------------------------------------------------------------------------*
local RT:=.F.
local VM_PCUST
local VM_RECLI:=0
if pb_ifcod2(str(P3,L_P),'PROD',.T.,2)
	VM_PCUST:=P2+P4+P6
	VM_RECLI:=VM_PCUST+VM_PCUST*PARAMETRO->PA_ENCAR/100+;
							VM_PCUST*PARAMETRO->PA_SALAR/100+;
							VM_PCUST*PARAMETRO->PA_DESPE/100+;
							VM_PCUST*PARAMETRO->PA_LUCRO/100-;
							VM_PCUST*PARAMETRO->PA_ICMSS/100-;
							VM_PCUST*PARAMETRO->PA_IMPOU/100+;
							VM_PCUST*PROD->PR_LUCRO/100
	P1:=round(VM_RECLI+0.001,PARAMETRO->PA_NRDECVE)
	RT:=.T.
	pb_msg('Valor atual do produto R$ '+alltrim(transform(PROD->PR_VLVEN,masc(05)))+'.',NIL,.F.)
end
return(RT)
*------------------------------------------EOF-----------------------------------------------------