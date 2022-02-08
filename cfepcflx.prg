*-----------------------------------------------------------------------------*
function CFEPCFLX()	//	Cupom Fiscal - Leitura X
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->PARAMETRO'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	if pb_sn('Enviar comando para Impressora Fiscal;LEITURA X ?')
		imprfisc("06|")
	end
end
dbcloseall()
return NIL
