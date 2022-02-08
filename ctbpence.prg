*-----------------------------------------------------------------------------*
function CTBPENCE()		//	Encerramento ANUAL CONTABIL
*-----------------------------------------------------------------------------*
local VM_X,VM_SLD_IN,VM_P1
pb_lin4(_MSG_,ProcName())
tone(500,3)
if xxsenha(ProcName(),'Contabilidade-Encerramento Anual')
	if abre({'E->PARAMCTB',;
				'E->CTADET',;
				'E->RAZAO',;
				'R->DIARIO'}).and.;
		pb_sn('CONTABILIDADE;Deseja passar para pr¢ximo ANO '+pb_zer(PARAMCTB->PA_ANO+1,4)+' ?')
		pb_msg('Aguarde Encerramento...',1,.f.)
		VM_X:=ctod('01/01/'+pb_zer(PARAMCTB->PA_ANO,4))
		dbseek(dtos(VM_X),.T.)
		if year(DI_DATA)#PARAMCTB->PA_ANO
			select('PARAMCTB')
			replace 	PA_ANO 		with PA_ANO+1,;
						PA_NRLOTE 	with replicate('0',36)
			select("CTADET")
			DbGoTop()
			while !eof()
				VM_SLD_IN:=CD_SLD_IN
				for VM_X:=1 to 12
					VM_P1    :="CD_DEB_"+pb_zer(VM_X,2)
					VM_SLD_IN:=VM_SLD_IN-&VM_P1
					VM_P1    :="CD_CRE_"+pb_zer(VM_X,2)
					VM_SLD_IN:=VM_SLD_IN+&VM_P1
				next
				replace CD_SLD_IN with VM_SLD_IN
				for VM_X:=5 to 28
					replace &(fieldname(VM_X)) with 0
				next
				dbskip()
			end
			select('RAZAO')
			zap
		else
			alert('Exitem lancamentos a serem integrados;Nao Foi encerrado')
		end
	else
		pb_msg('Senha Incorreta.',1,.T.)
	end
end
dbcloseall()
return NIL
*------------------------------------[EOF]---------------------------------------*
