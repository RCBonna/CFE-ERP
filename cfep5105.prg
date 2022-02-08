*-----------------------------------------------------------------------------*
 function CFEP5105() // rotina tmp
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
salvabd(SALVA)
select('PEDCAB')
pb_msg('Processando. Aguarde...',NIL,.F.)
if fillock()
	if eof().or.bof()
		select('PROD')
		if fillock()
			dbeval({||PROD->PR_RESER:=0})
		end
		dbunlock()
		select('PEDCAB')
	else
		pb_msg('Existem Pedidos Pendentes press <ENTER>.',0,.T.)
	end
end
dbunlock()
salvabd(RESTAURA)
return NIL
//----------------------------eof--------------------------
