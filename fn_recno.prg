*-----------------------------------------------------------------------------*
* RECUPERA AS NOTAS DOS ALUNOS E RETORNA VETOR											*
*-----------------------------------------------------------------------------*
function FN_RECNOTAS(P1)	// P1=
local X,NOTAX:={}
for X=1 to len(P1)
	aadd(NOTAX,{P1[X,2],;//......................//01 NOME MATERIA
					substr(ALUNOS->CD_BIM1,X*5-4,3),;//02-nota            +1
					substr(ALUNOS->CD_BIM1,X*5-1,2),;//03-falta 1.BIM     +1
					substr(ALUNOS->CD_BIM2,X*5-4,3),;//04-nota            +2
					substr(ALUNOS->CD_BIM2,X*5-1,2),;//05-falta 2.BIM     +2
					substr(ALUNOS->CD_BIM3,X*5-4,3),;//06-nota     ->:07  +3
					substr(ALUNOS->CD_BIM3,X*5-1,2),;//07-falta 3.BIM:08  +3
					substr(ALUNOS->CD_BIM4,X*5-4,3),;//08-nota       :09  +4
					substr(ALUNOS->CD_BIM4,X*5-1,2),;//09-falta 4.BIM:10  +4
					substr(ALUNOS->CD_BIM5,X*6-5,3),;//10-Notas Media:12  +?
					substr(ALUNOS->CD_BIM5,X*6-2,3),;//11-Falta Total:13  +?
					substr(ALUNOS->CD_BIM6,X*3-2,3),;//12-Exames     :14  +5
					substr(ALUNOS->CD_BIM7,X*3-2,3),;//13-2.Epoca    :15  +5
					substr(ALUNOS->CD_BIM8,X*3-2,3),;//14-Media Final:16  +?
					'',''})
	if len(BIMESTRE)>6
		ains(NOTAX[X],06)
		NOTAX[X,06]:=substr(ALUNOS->CD_BIMS1,X*3-2,3)//06-notas recuperacao 1.
		ains(NOTAX[X],11)
		NOTAX[X,11]:=substr(ALUNOS->CD_BIMS2,X*3-2,3)//11-notas recuperacao 2.
	end
next
return(NOTAX)
