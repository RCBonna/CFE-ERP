
*-----------------------------------------------------------------------------*
function CFEPFAR4() // Listagem de Vendas/Aliqutas
*-----------------------------------------------------------------------------*

#include 'RCB.CH'

VM_CPO:={'S','N','N',,,0,0,0,0,3,2}
//        1   2   3  456 7 8 9 0,1


VM_REL='Resumo Aliquotas'

pb_lin4(VM_REL,ProcName())

if !abre({'R->PARAMETRO','C->CLIENTE','R->CLICONV','R->PEDCAB','R->PEDDET'})
	return NIL
end

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=PARAMETRO->PA_DATA
VM_SERIE :=space(3)
pb_box(18,20,,,,'Sele‡Æo')
@19,22 say 'Informe Serie..........:' get VM_SERIE  pict masc(01) when pb_msg('Branco para todas as series')
@20,22 say 'Data Emissao Inicial...:' get VM_CPO[4] pict masc(07)
@21,22 say 'Data Emissao Final.....:' get VM_CPO[5] pict masc(07) valid VM_CPO[5]>=VM_CPO[4]

read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	select('PEDCAB')
	ordem DTENNF	// DATA + NF
	if !empty(VM_SERIE)
		set filter to PEDCAB->PC_SERIE==VM_SERIE.and.filpedcab()
	end
	dbseek(dtos(VM_CPO[4]),.T.)
	VM_REL+= ' de '+dtoc(VM_CPO[4])+' a '+dtoc(VM_CPO[5])
	VM_PAG:=0
	VM_LAR:=80
	TOTALG:={}
	TOTVL:=0
	TOTNR:=0
	while !eof().and.PC_DTEMI<=VM_CPO[5]
		VM_CPO[2]:=PC_DTEMI
		while !eof().and.PC_DTEMI==VM_CPO[2]
			if PC_FLAG.and.!PC_FLCAN
				TOTNR++
				VM_PEDID  :=PC_PEDID
				VM_PERDES :=0.00
				if PC_DESC>0
					VM_PERDES :=pb_divzero(PC_DESC,PC_TOTAL)
				end
				TOTNF     :=PC_TOTAL-PC_DESC
				VM_VLRDEST:=0.00
				VM_VLRDESP:=0.00
				TOTDT     :=0.00
				salvabd(SALVA)
				select('PEDDET')
				dbseek(str(VM_PEDID,6),.T.)
				while !eof().and.VM_PEDID==PD_PEDID
					VM_CPO[1]:=ascan(TOTALG,{|DET|DET[1]==PD_ICMSP})
					if VM_CPO[1]=0
						aadd(TOTALG,{PD_ICMSP,0,0,0,0,0,0})
						VM_CPO[1]:=len(TOTALG)
					end
					VM_VLRVEND:=trunca((PD_VALOR*PD_QTDE)-PD_DESCV+PD_ENCFI,2)
					TOTDT     +=VM_VLRVEND
					if PEDCAB->PC_DESC>0
						VM_VLRDESP:=trunca(VM_VLRVEND*VM_PERDES,2)
						VM_VLRDEST+=VM_VLRDESP
						TOTDT     -=VM_VLRDESP
					end
					TOTALG[VM_CPO[1],2]+=(VM_VLRVEND-VM_VLRDESP)
					TOTALG[VM_CPO[1],3]+=trunca((VM_VLRVEND-VM_VLRDESP)*PD_PTRIB/100,2)
					TOTALG[VM_CPO[1],4]+=PD_VLICM
					dbskip()
				end
				salvabd(RESTAURA)
				if str(VM_VLRDEST,15,2)#str(PEDCAB->PC_DESC,15,2)
					VM_VLRDESP:=PEDCAB->PC_DESC - VM_VLRDEST
					TOTALG[VM_CPO[1],2]-=VM_VLRDESP
					TOTALG[VM_CPO[1],3]-=VM_VLRDESP
					TOTDT-=VM_VLRDESP
				end
				if str(TOTNF,15,2)#str(TOTDT,15,2)
					VM_VLRDESP:=TOTNF - TOTDT
					TOTALG[VM_CPO[1],2]+=VM_VLRDESP
					TOTALG[VM_CPO[1],3]+=VM_VLRDESP
//					alert('NF '+str(PEDCAB->PC_NRNF,6)+"  Ped: "+str(PC_PEDID,6)+";"+;
//							'Cabec:'+str(TOTNF,15,2)+";"+;
//							'S.Det:'+str(TOTDT,15,2))
				end
			end
			dbskip()
		end
		// termino do dia
		TOTALG:=asort(TOTALG,,,{|DET,DET1|DET[1]<DET1[1]})
		TOTALD:={0,0,0}
		for X:=1 to len(TOTALG)	
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPFAR4C',VM_LAR)
			if X==1
				? space(3)+dtoc(VM_CPO[2])+space(5)
			else
				? space(18)
			end
			??transform(TOTALG[X,1],masc(20))
			??transform(TOTALG[X,2],masc(02))
			??transform(TOTALG[X,3],masc(02))
			??transform(TOTALG[X,4],masc(02))
			TOTALG[X,5]+=TOTALG[X,2]
			TOTALG[X,6]+=TOTALG[X,3]
			TOTALG[X,7]+=TOTALG[X,4]
			TOTALD[  1]+=TOTALG[X,2]
			TOTALD[  2]+=TOTALG[X,3]
			TOTALD[  3]+=TOTALG[X,4]
			TOTALG[X,2]:=0
			TOTALG[X,3]:=0
			TOTALG[X,4]:=0
		next
		?padc('Total Dia',24)
		??transform(TOTALD[1],masc(02))
		??transform(TOTALD[2],masc(02))
		??transform(TOTALD[3],masc(02))
		?
	end
	// termino do arquivo
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPFAR4C',VM_LAR)
	?replicate('-',VM_LAR)
	?padc('TOTAL GERAL',VM_LAR,'.')
	TOTALD:={0,0,0}
	for X:=1 to len(TOTALG)
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPFAR4C',VM_LAR)
		? space(18)
		??transform(TOTALG[X,1],masc(20))
		??transform(TOTALG[X,5],masc(02))
		??transform(TOTALG[X,6],masc(02))
		??transform(TOTALG[X,7],masc(02))
		TOTALD[  1]+=TOTALG[X,5]
		TOTALD[  2]+=TOTALG[X,6]
		TOTALD[  3]+=TOTALG[X,7]
	next
	?padc('Total',24)
	??transform(TOTALD[1],masc(02))
	??transform(TOTALD[2],masc(02))
	??transform(TOTALD[3],masc(02))
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEPFAR4C()
?space(7)+'Data     Aliquota     Valor Total     Valor Base     Valor ICMS'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
