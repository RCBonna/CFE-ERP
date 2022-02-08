*-----------------------------------------------------------------------------*
function CFEP6500() // Listagem de NF Saida												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','','','',0,0,0,0}
//        1  2  3  4  5 6 7 8

VM_REL='Notas Fiscais-Saida'
pb_lin4(padc(VM_REL,36),ProcName())
if !abre({'R->PARAMETRO','R->CLIENTE','R->PROD','R->PEDCAB','R->PEDDET'})
	return NIL
end
select('PROD');dbsetorder(2)
select('CLIENTE');dbsetorder(1)
select('PEDCAB');dbsetorder(4)
set relation to str(PC_CODCL,5) into CLIENTE

VM_CPO[2]=ctod('01/'+pb_zer(month(PARAMETRO->PA_DATA),2)+'/'+pb_zer(year(PARAMETRO->PA_DATA)-1900,2))
VM_CPO[3]=PARAMETRO->PA_DATA
pb_box(17,35)
@18,37 say '[A]nalitico [S]intetico:'  get VM_CPO[1] pict masc(1) valid VM_CPO[1]$'AS'
@20,37 say padr('Data Inicial',23)+':' get VM_CPO[2] pict masc(7)
@21,56 say 'ate.:'                     get VM_CPO[3] pict masc(7) valid VM_CPO[3]>=VM_CPO[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(RST),.F.)
	VM_LAR=80
	VM_PAG=0
	VM_REL+='('+dtoc(VM_CPO[2])+'-'+dtoc(VM_CPO[3])+')'
	select('PEDCAB')
	dbseek(dtos(VM_CPO[2]),.T.)
	while !eof().and.PC_DTEMI<=VM_CPO[3]
		CFEP6501()
	end
	if VM_CPO[5]+VM_CPO[6]+VM_CPO[7]>0
		? replicate('-',VM_LAR)
		? 'Total'+replicate('.',23)
		??transform(VM_CPO[5],masc(2))
		??transform(VM_CPO[6],masc(2))
		??transform(VM_CPO[7],masc(2))
		? replicate('-',VM_LAR)
	end
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

//-------------------------------------------------------------------------------------------
function CFEP6501()
//-------------------------------------------------------------------------------------------
VM_CPO[4]=PC_DTEMI
VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6500A',VM_LAR)
?
?INEGR+dtoc(VM_CPO[4])+CNEGR
while !eof().and.VM_CPO[4]==PC_DTEMI
	VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6500A',VM_LAR)
	? pb_zer(PC_NRNF,6)+space(01)
	??I15CPP+pb_zer(PC_CODCL,5)+'-'+left(CLIENTE->CL_RAZAO,30)+C15CPP
	??transform(PC_TOTAL-PC_DESC,masc(2))
	??transform(PC_DESC,masc(2))
	VM_CPO[5]+=PC_TOTAL-PC_DESC
	VM_CPO[6]+=PC_DESC
	VM_PEDID=PC_PEDID
	select('PEDDET')
	dbseek(str(VM_PEDID,6),.T.)
	ORD:={}
	VM_CPO[8]=0
	while !eof().and.VM_PEDID=PD_PEDID
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6500A',VM_LAR)
		PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
		aadd(ORD,I15CPP+space(55)+pb_zer(PD_ORDEM,2)+space(01)+pb_zer(PD_CODPR,L_P)+'-'+PROD->PR_DESCR+space(01)+transform(PD_QTDE,masc(6))+space(01)+transform(PD_VALOR*PD_QTDE-PD_DESCV,masc(2))+C15CPP)
		VM_CPO[8]+=PD_VLICM
		dbskip()
	end
	select('PEDCAB')
	VM_CPO[7]+=VM_CPO[8]
	??transform(VM_CPO[8],masc(2))
	??str(PC_FATUR,3)
	if VM_CPO[1]='A'
		for VM_X=1 to len(ORD)
			VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6500A',VM_LAR)
			?ORD[VM_X]
		next
		?
	end
	pb_brake()
end
return NIL

//-------------------------------------------------------------------------------------------
function CFEP6500A()
//-------------------------------------------------------------------------------------------
?'NtFisc Cliente'+space(21)+'Total NF'+space(2)+'Total Descont'+space(5)+'Total ICMS'+space(1)+'Fat'
?replicate('-',VM_LAR)
return NIL
//-----------------------------------------------------------------------------------------------------EOF-----------------------------------------------------
