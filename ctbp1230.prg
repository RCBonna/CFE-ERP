*-----------------------------------------------------------------------------*
function CTBP1230()	//	Integracao de Lotes												*
*								Roberto Carlos Bonanomi - Jun/93								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_OK,VM_ARQ
if !abre({	'R->PARAMCTB',;
				'C->CTADET',;
				'C->RAZAO',;
				'C->CTRLOTE'})
	return NIL
end
select('CTADET');dbsetorder(2)
select('CTRLOTE')
if lastrec()==0
	beeperro()
	pb_msg('Nenhum Lote Criado. Use op‡„o 1.',1)
else
	select('CTRLOTE')
	set filter to CL_FECHAD
	DbGoTop()
	VM_CAMPO:=array(fcount())
	afields(VM_CAMPO)
	VM_MUSC:={mI8,"@D","@!",masc(02),masc(02),masc(02),"Y"}
	VM_CABE:={"Nr.Lote","Data","Digitador","Vlr Tot Lote","Lcto Debito","Lcto Credito","F"}
	dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,,VM_MUSC,VM_CABE)
	pb_lin4("INTEGRACAO lote "+str(CL_NRLOTE,8)+" de "+dtoc(CL_DATA),ProcName())
	if if(lastkey()#K_ESC,pb_sn('Confirme Integra‡„o lote '+pb_zer(CL_NRLOTE,8)+' ? '),.F.)
		if CL_FECHAD
			VM_ARQ:=str(CL_NRLOTE,8)+'.DBF'
			if reclock().and.!fn_alote(CL_NRLOTE,.F.) // Abre/criar arq lotes
				dbcloseall()
				return NIL
			end
			DbGoTop()
			while !eof()
				pb_msg('Aguarde. Processando registro '+str(recno(),4)+'/'+str(lastrec(),4)+'.')
				fn_atcta(LO_CONTA, +LO_VALOR,CTRLOTE->CL_DATA) //Atual Ctas
				fn_atcta(LO_CONTRA,-LO_VALOR,CTRLOTE->CL_DATA) //Atual Ctas Contrap

				fn_atraz(LO_CONTA, +LO_VALOR,CTRLOTE->CL_DATA,CTRLOTE->CL_NRLOTE,LO_HISTOR,LO_DOCTO) //Atual Razao
				fn_atraz(LO_CONTRA,-LO_VALOR,CTRLOTE->CL_DATA,CTRLOTE->CL_NRLOTE,LO_HISTOR,LO_DOCTO) //Atual Razao Contrap
				// dbcommitall()
				dbskip()
			end
			select('CTRLOTE')
			fn_elimi()
			pb_msg('Feito Com Sucesso. Pressione <ENTER> para continuar.',0,.T.)
			dbcloseall()
			ferase(VM_ARQ)
		else
			pb_msg('Este lote NAO esta FECHADO. Favor Critica-lo/Corrigi-lo.',3)
		end
	end
end
dbcloseall()
return NIL
*-----------------------------------------------------------------------* Fim
