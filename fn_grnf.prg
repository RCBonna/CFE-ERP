*-----------------------------------------------------------------------------*
 static aVariav := {0}
 //.................1
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function FN_PSNF(pTipo,pDescr)	//	FUNCAO PESQUISA-NUMERO							*
*-----------------------------------------------------------------------------*
nX:=1
salvabd(SALVA)
select('CTRNF')
if dbseek(pTipo)
	nX:=NF_NUMER+1
	if reclock()
		replace NF_NUMER with nX
	end
else
	if AddRec()
		while !reclock();end
		replace  NF_TIPO  with pTipo,;
					NF_NUMER with nX
	end
end
dbrunlock(recno())
dbskip(0)
salvabd(RESTAURA)
return(nX)

*----------------------------------------------------------------------------------*Voltar
  function FN_BACKNF(P1,P2)	//	FUNCAO PESQUISA-NUMERO										*
*----------------------------------------------------------------------------------*Voltar
salvabd(SALVA)
select('CTRNF')
if dbseek(P1)
	if CTRNF->NF_NUMER==P2
		if reclock()
			replace CTRNF->NF_NUMER with P2-1
			dbskip(0)
			dbrunlock(recno())
		end
	end
end
salvabd(RESTAURA)
return NIL
*--------------------------------[EOF]-------------------------------------*
