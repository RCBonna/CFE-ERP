*-----------------------------------------------------------------------------*
function CFEP2322()	// Impressao Fluxo de Caixa Banco								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

ABRE('BC')
VM_CODBC = 0
pb_box(20,30)
@21,31 say "Banco..:" get VM_CODBC picture masc(11) valid fn_codigo(@VM_CODBC,{'BANCO',{||BANCO->(dbseek(str(VM_CODBC,2)))},{||CFEP1500T(.T.)},{2,1}})
read
if lastkey()#K_ESC
	VM_REL = "Fluxo de Caixa - "+trim(BANCO->BC_DESCR)
	ABRE('CL')
	ABRE('PA')
	ABRE('DP')
	
	VM_TOT = array(3,24)  // 1.TOT1 2.TOT2 3.DIAS 4.tot3
	aadd(VM_TOT,{0,0,0,0})

	afill(VM_TOT[1],0)
	afill(VM_TOT[2],0)
	afill(VM_TOT[3],0)

	for VM_X=1 to 24
		VM_TOT[3,VM_X]=val(substr(PARAMETRO->PA_PGT,VM_X*4-3,4))
	next
	
	VM_TOT[3,01]=-999
	VM_TOT[3,24]=9999

	pb_msg("Calculando Fluxo de Caixa ... AGUARDE !!",.1,.F.)
	select('DPFOR')
	dbsetorder(3)
	dbseek(str(VM_CODBC,2),.T.)
	while !eof().and.lastkey()#K_ESC .and. DP_CODBC == VM_CODBC
		VM_P1=DP_DTVEN-PARAMETRO->PA_DATA
		for VM_X=1 to 23
			if VM_P1>=VM_TOT[3,VM_X].and.VM_P1<VM_TOT[3,VM_X+1]
				VM_TOT[1,VM_X]=VM_TOT[1,VM_X]+(DP_VLRDP-DP_VLRPG)
				VM_TOT[2,VM_X]=VM_TOT[2,VM_X]+1
				if VM_P1<=0
					VM_TOT[4,1]=VM_TOT[4,1]+(DP_VLRDP-DP_VLRPG)
					VM_TOT[4,2]=VM_TOT[4,2]+1
				else
					VM_TOT[4,3]=VM_TOT[4,3]+(DP_VLRDP-DP_VLRPG)
					VM_TOT[4,4]=VM_TOT[4,4]+1
				end
			end
		next
		skip
	end
	if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
		VM_PAG = 0
		VM_LAR = 80
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CFEP2322A",VM_LAR)
		for VM_X=1 to 23
			?  space(5)+ str(VM_X,2)+space(3)+str(VM_TOT[3,VM_X],4)+"  -  "+str(VM_TOT[3,VM_X+1]-1,4)+space(3)
			?? pb_zer(VM_TOT[2,VM_X],4)+transform(VM_TOT[1,VM_X],masc(2))
		next
		? replicate("-",VM_LAR)
		? "TOTAL DUPLICATAS VENCIDAS..:  "+pb_zer(VM_TOT[4,2],4)+"  -  "+transform(VM_TOT[4,1],masc(2))
		? "TOTAL DUPLICATAS A VENCER..:  "+pb_zer(VM_TOT[4,4],4)+"  -  "+transform(VM_TOT[4,3],masc(2))
		?
		? "TOTAL GERAL DUPLICATAS.....:  "+pb_zer(VM_TOT[4,2]+VM_TOT[4,4],4)+"  -  "+transform(VM_TOT[4,1]+VM_TOT[4,3],masc(2))
		? replicate("-",VM_LAR)
		? "Impresso as "+time()
		eject
		pb_deslimp(C15CPP)
	end
end
dbcloseall()
return NIL

function CFEP2322A()  // Cabecalho
? "Periodo"+space(7)+"Intervalo   Dpls."+space(09)+"Valor"
? replicate("-",VM_LAR)
return NIL
