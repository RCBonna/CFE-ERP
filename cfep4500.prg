*-----------------------------------------------------------------------------*
function CFEP4500()	//	Correcao de Precos												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({'R->PARAMETRO','E->GRUPOS','E->PROD'})
	return NIL
end

if VM_OPX1=1  // Correcao GERAL
	VM_PERCE:= 0
	pb_box(18,25)
	@19,26 say "Percentual..:" get VM_PERCE picture masc(6)
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		dbsetorder(2)
		DbGoTop()
		pb_msg("AGUARDE ... Atualizando Vlr.Venda",1,.F.)
		while !eof()
			@21,26 say str(PR_CODPR,5)+" - "+PR_DESCR
			replace PR_VLVEN with round(PR_VLVEN+(PR_VLVEN*(VM_PERCE/100)),2)
			dbskip()
		end
	end
elseif VM_OPX1=2
	dbsetorder(1)
	DbGoTop()
	VM_PERCE=0
	VM_GRINI=0
	VM_GRFIN=0
	pb_box(17,25)
	@18,26 say "Percentual.:" get VM_PERCE picture masc(6)
	@20,26 say "Grp INICIAL:" get VM_GRINI picture masc(3) valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},{||CFEP4100T(.T.)},{2,1}})
	@21,26 say "Grp FINAL..:" get VM_GRFIN picture masc(3) valid fn_codigo(@VM_GRFIN,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIN,6)))},{||CFEP4100T(.T.)},{2,1}})
	read
	setcolor (VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		dbseek(str(VM_GRINI,4),.T.)
		pb_msg("AGUARDE ... Atualizando Vlr.Venda",1,.F.)
		while !eof()
			@21,26 say str(PR_CODPR,5)+" - "+PR_DESCR
			replace PR_VLVEN with round(PR_VLVEN+(PR_VLVEN*(VM_PERCE/100)),2)
			dbskip()
		end
	end
else
	VM_CODPR=0
	VM_VLVEN=0
	pb_box(19,25)
	@20,26 say "Produto....:" get VM_CODPR picture masc(4) valid fn_codpr(@VM_CODPR,77)
	@21,26 say "Vlr.Venda..:" get VM_VLVEN picture masc(5) valid VM_VLVEN>0 when eval({||VM_VLVEN:=PR_VLVEN})>=0
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		dbsetorder(2);DbGoTop()
		dbseek(str(VM_CODPR,5))
		pb_msg("AGUARDE ... Atualizando Vlr.Venda",1,.F.)
		@21,26 say str(PR_CODPR,5)+" - "+PR_DESCR
		replace PR_VLVEN with VM_VLVEN
		dbskip()
	end
end
setcolor(VM_CORPAD)
dbcloseall()
return NIL
