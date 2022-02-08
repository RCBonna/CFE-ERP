*-----------------------------------------------------------------------------*
function CFEPCFHV()	//	Cupom Fiscal - Entra no Horario de Verao
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->PARAMETRO'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	if pb_sn('Enviar comando para Impressora Fiscal;HORARIO DE VERAO ?')
		imprfisc("18|")
	end
end
dbcloseall()
return NIL
