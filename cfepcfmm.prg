*-----------------------------------------------------------------------------*
function CFEPCFMM()	//	Cupom Fiscal - Mudanca de Moeda
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->PARAMETRO'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	if xxsenha(ProcName(),'Mudar Moeda-Impressora Fiscal')
		if pb_sn('Enviar comando para Impressora Fiscal;MUDANCA DE MOEDA=R$ ?')
			imprfisc("01| R|")
		end
	end
end
dbcloseall()
return NIL
