#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function FN_CLIOBS(P1,P2)
local X:=0,VM_TF:=savescreen(),LCONT
private VETOR:=array(30,2)
salvabd(SALVA)
select('CLIOBS')
dbseek(str(P1,5),.T.)
if !empty(P2)
	pb_msg('Verificando registros no SPC',nil,.F.)
	aeval(VETOR,{|DET|DET[1]:='#'+pb_zer(++X,2),DET[2]:=space(60)})
	while !eof().and.P1==CO_CODCL
		VETOR[CO_SEQUE,2]:=CO_OBS
		dbskip()
	end
	X:=1
	if SAEPEDARE({'Sq','Descri‡„o de Motivos (ate 30)'},{3,60},{masc(23),masc(23)},'Registro no SPC')
		for X:=1 to len(VETOR)
			LCONT:=.T.
			if !dbseek(str(P1,5)+str(X,2))
				LCONT:=.F.
				if !empty(VETOR[X,2])
					LCONT:=AddRec()
				end
			else// existe
				if empty(VETOR[X,2])
					LCONT:=.F.
					if reclock()
						fn_elimi()
					end
				end
			end
			if LCONT
				if reclock()
					replace  CO_CODCL with P1,;
								CO_SEQUE with X,;
								CO_OBS   with VETOR[X,2]
				end
			end
		next
	end
else
	while !eof().and.P1==CO_CODCL
		if reclock()
			fn_elimi()
		end
		dbskip()
	end
end
salvabd(RESTAURA)
restscreen(,,,,VM_TF)
return(.T.)
*-----------------------------------[EOF]----------------------------*
