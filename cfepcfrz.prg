*-----------------------------------------------------------------------------*
function CFEPCFRZ()	//	Cupom Fiscal - Reducao Z
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->CAIXA01','C->PARAMETRO'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	SALVABANCO
	select CAIXA01
	if NUM_CXA == 1
		ORDEM CXA01
	elseif NUM_CXA == 2
		ORDEM CXA02
	end
	if dbseek(str(NUM_CXA,2)+dtos(PARAMETRO->PA_DATA))
		if !AX_FECHAD
			alert("Caixa "+str(NUM_CXA,2)+" ainda aberto;Use rotina de fechamento")
			dbcloseall()
			return NIL
		end
	end
	RESTAURABANCO
	if pb_sn('Caixa='+pb_zer(NUM_CXA,2)+';Enviar comando para Impressora Fiscal;REDUCAO Z ?')
		if pb_sn('A Impressora Fiscal so voltara a imprimir no pb_brake() Dia;CONTINUAR ?')
			ImprFisc("05|")
		end
	end
end
dbcloseall()
return NIL
