*-----------------------------------------------------------------------------*
  function CFEP7500() // Reorganizar Base de Dados
*-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({'E->PARAMETRO'})
	return NIL
end
if pb_sn("R E O R D E N A R;TODOS OS USUARIOS ESTAO FORA ????;Voce deseja reorganizar a sua base dados ?")
	dbcloseall()
	if !abre({'E->PARAMETRO'})
		return NIL
	end
	DelIndic()
	ARQI(.T.,'VER INDICES') // recriar arquivos indices
	dbcommitall()
end
dbcloseall()
return NIL
// EOF //
