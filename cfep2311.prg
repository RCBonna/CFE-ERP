*-----------------------------------------------------------------------------*
function CFEP2311(VM_FL1,VM_FL2) // Dpls.a Pagar/Receber por BANCO				*
*						VM_FL1========RESUMO[.F.]												*
*						VM_FL1========GERAL[.T.]												*
*								VM_FL2==CLIENTES='CL'											*
*								VM_FL2==FORNECEDORES='FO'										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local CPO:={{'R->PARAMETRO','R->BANCO','R->CLIENTE','R->DPFOR'},;
			   {'R->PARAMETRO','R->BANCO','R->CLIENTE','R->DPCLI'}}

VM_REL='Duplicatas a '+if(VM_FL2='FO','Pagar','Receber')+' por Banco - '+if(VM_FL1,'GERAL','RESUMO')
pb_lin4(VM_REL,ProcName())

if !abre(if(VM_FL2='FO',CPO[1],CPO[2]))
	return NIL
end

select('BANCO')
dbgobottom();VM_FIM=BC_CODBC
DbGoTop();VM_INI=BC_CODBC
pb_box(19,27)
@20,28 say 'Banco Inicial..:' get VM_INI picture masc(11) valid fn_codigo(@VM_INI,{'BANCO',{||BANCO->(dbseek(str(VM_INI,2)))},,{2,1}})
@21,34 say 'Final....:'       get VM_FIM picture masc(11) valid fn_codigo(@VM_FIM,{'BANCO',{||BANCO->(dbseek(str(VM_FIM,2)))},,{2,1}}).and.VM_FIM>=VM_INI
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_PAG   := 0
	VM_LAR   := 132
	VM_TOT   := array(4,2)
	VM_TOTAL :=0.00
	if VM_FL2=='FO'
		pb_msg('Totalizando Fornecedores...')
		select('DPFOR')
		DbGoTop()
		dbeval({||VM_TOTAL+=DP_VLRDP-DP_VLRPG})
	else
		pb_msg('Totalizando Clientes...')
		select('DPCLI')
		DbGoTop()
		dbeval({||VM_TOTAL+=DR_VLRDP-DR_VLRPG})
	end
	dbsetorder(3)
	VM_CPO   :=if(VM_FL2='CL','CLIENTE','FORNEC')
	set relation to str(&(fieldname(8)),2) into BANCO,;
					 to str(&(fieldname(2)),5) into CLIENTE

	dbseek(str(VM_INI,2),.T.)	
	afill(VM_TOT[2],0)
	afill(VM_TOT[3],0)
	afill(VM_TOT[4],0)
	while !eof().and.&(fieldname(8))<=VM_FIM
		VM_CODBC := &(fieldname(8))
		VM_DESCR := BANCO->BC_DESCR
		VM_FL3   := .T.
		afill(VM_TOT[1],0)
		if !VM_FL1
			afill(VM_TOT[2],0)
		end
		while !eof().and.&(fieldname(8))==VM_CODBC
			VM_VLRDP:=&(fieldname(6))-&(fieldname(7))
			if VM_FL1 // resumo
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP231GA',VM_LAR)
				?  padr(if(VM_FL3,pb_zer(VM_CODBC,2)+'-'+VM_DESCR+space(3),''),34)
				?? transform(&(fieldname(1)),masc(16))+space(1)+pb_zer(&(fieldname(2)),5)+' - '
				salvabd()
				select CLIENTE
				?? left(&(fieldname(2)),30)
				salvabd(.F.)
				?? space(3)+dtoc(&(fieldname(3)))
				?? space(1)+dtoc(&(fieldname(4)))
				?? space(1)+transform(VM_VLRDP,masc(2))
				?? space(2)+str((pb_divzero(VM_VLRDP,VM_TOTAL)*100),7,3)
				VM_TOT[1,1]++
				VM_TOT[1,2]+=VM_VLRDP
				VM_FL3:=.F.
			else
				VM_TOT[if(&(fieldname(4))<PARAMETRO->PA_DATA,1,2),1]++
				VM_TOT[if(&(fieldname(4))<PARAMETRO->PA_DATA,1,2),2]+=VM_VLRDP
			end
			pb_brake()
		end
		if VM_FL1
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP231GA',VM_LAR)
			?
			?  space(49)+padr('TOTAL BANCO',51,'.')+':'+str(VM_TOT[1,1],6)
			?? space(1) +transform(VM_TOT[1,2],masc(2))
			?? space(2) +str((pb_divzero(VM_TOT[1,2],VM_TOTAL)*100),7,3)
			?
			VM_TOT[2,1]+=VM_TOT[1,1]
			VM_TOT[2,2]+=VM_TOT[1,2]
		else
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP231RA',VM_LAR)
			?  pb_zer(VM_CODBC,2)+' - '+VM_DESCR+ space(2)
			?? str(VM_TOT[1,1],4)+space(1)+transform(VM_TOT[1,2],masc(2))
			?? space(2)+str((pb_divzero(VM_TOT[1,2],VM_TOTAL)*100),7,3)+space(4)

			?? str(VM_TOT[2,1],4)+space(1)+transform(VM_TOT[2,2],masc(2))
			?? space(2)+str((pb_divzero(VM_TOT[2,2],VM_TOTAL)*100),7,3)+space(4)

			?? str(VM_TOT[1,1]+VM_TOT[2,1],4)+space(1)
			?? transform(VM_TOT[1,2]+VM_TOT[2,2],masc(2))
			?? space(2)+str((pb_divzero(VM_TOT[1,2]+VM_TOT[2,2],VM_TOTAL)*100),7,3)

			VM_TOT[3,1]+=VM_TOT[1,1]
			VM_TOT[3,2]+=VM_TOT[1,2]
			VM_TOT[4,1]+=VM_TOT[2,1]
			VM_TOT[4,2]+=VM_TOT[2,2]
		end
	end
	if VM_FL1
		?
		?  space(49)+padr('TOTAL GERAL',51,'.')+':'+str(VM_TOT[2,1],6)
		?? space(1) +transform(VM_TOT[2,2],masc(2))
		?? space(2) +str((pb_divzero(VM_TOT[2,2],VM_TOTAL)*100),7,3)
	else
		?
		?  space(5)+padr('TOTAL GERAL',29,'.')+':'+str(VM_TOT[3,1],6)
		?? space(1)+transform(VM_TOT[3,2],masc(2))
		?? space(2)+str((pb_divzero(VM_TOT[3,2],VM_TOTAL)*100),7,3)+space(4)

		?? str(VM_TOT[4,1],4)+space(1)+transform(VM_TOT[4,2],masc(2))
		?? space(2)+str((pb_divzero(VM_TOT[4,2],VM_TOTAL)*100),7,3)+space(4)

		?? str(VM_TOT[3,1]+VM_TOT[4,1],4)+space(1)
		?? transform(VM_TOT[3,2]+VM_TOT[4,2],masc(2))
		?? space(2)+str((pb_divzero(VM_TOT[3,2]+VM_TOT[4,2],VM_TOTAL)*100),7,3)
	end			
	?replicate('-',VM_LAR)
	?padr('Total Geral de Duplicatas',108,'.')+transform(VM_TOTAL,masc(2))
	eject
	pb_deslimp(C15CPP)
	set relation to
	DbGoTop()
end
dbcloseall()
return NIL

function CFEP231GA()
?  'Banco'+space(33)+'Dpl.'+space(3)
?? padr('Cliente/Fornecedor',42)+'Emissao'
?? space(6)+'Vcto.'
?? space(6)+'Vlr.em Aberto'
?? space(4)+'% G'
?replicate('-',VM_LAR)
return NIL

function CFEP231RA()
?  'Banco'+space(32)+'Duplicatas Vencidas'+space(6)+'%'+space(7)
?? 'Duplicatas a Vencer'+space(6)
?? '%'+space(7)
?? 'TOTAL BANCO'+space(14)+'%'
?replicate('-',VM_LAR)
return NIL

// end of file//