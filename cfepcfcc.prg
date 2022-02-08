*-----------------------------------------------------------------------------*
function CFEPCFCC()	//	Cupom Fiscal - Cancelamento de Cupom
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->PARAMETRO'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	if xxsenha(ProcName(),'Cancelamento de Cupom-Impressora Fiscal')
		if pb_sn('Enviar comando para Impressora Fiscal;CANCELAMENTO DE CUPOM FISCAL ?')
			imprfisc("10|0000|"+;
					pb_zer(1000*100,14)+"|d|"+;
					pb_zer(0,14)+"|"+;
					'ERRO DE FECHAMENTO'+;
					"|"+CHR(13)) // fechamento cupom
			imprfisc("14|")
		end
	end
end
dbcloseall()
return NIL
