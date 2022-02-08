*---------------------------------------------------------------------*
function IMPORT(P1)
*---------------------------------------------------------------------*
if !file(P1)
	@21,20 say 'Arquivo '+P1+' nao encontrado'
	quit
end
use (P1)
@21,20 say 'Importando dados p/ arquivo '+P1+' de TMP'
append from TMP. delimited
close
quit
return NIL
*----------------------------------------------EOF-----------------------*
