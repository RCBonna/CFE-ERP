*--------------------------------------------------------------------------*


*--------------------------------------------------------------------------*
#include 'RCB.CH'

function FN_CONSPAR()
local RT:=savescreen()
local VALOR:=0
local FLAG:=.F.
if select('PARAMETRO')>0
else
	if !abre({'R->PARAMETRO'})
		return NIL
	end
	FLAG:=.T.
end
while .T.
	pb_box(9,,,,'W+/R','Consulta valores de parcelamento')
	@10,02 say 'Valor:' get VALOR pict mI92 valid VALOR>=0 when pb_msg('Informe o valor')
	read
	if lastkey()#K_ESC
		Fechar_1(VALOR,'C')
	else
		exit
	end
end
restscreen(,,,,RT)
if FLAG
	close
end
return NIL
