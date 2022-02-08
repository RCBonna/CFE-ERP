*-----------------------------------------------------------------------------*
function CFEP2313(VM_FL1,VM_FL2) // Dpls.a Pagar/Receber DT.Venc					*
*						VM_FL1=.F.=............RESUMO											*
*						VM_FL1=.T.=............GERAL											*
*									VM_FL2='FO'=..FORNEC											*
*									VM_FL2='CL'=CLIENTE											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local CPO:={{	'R->PARAMETRO',;//.......[1]
					'R->BANCO',;
					'R->CLIENTE',;
					'R->DPFOR'},;
				{	'R->PARAMETRO',;//...... [2]
					'R->BANCO',;
					'R->CLIENTE',;
					'R->DPCLI'}}

VM_REL:='Duplicatas a '+if(VM_FL2='FO','Pagar','Receber')+' por Vencimento - '+if(VM_FL1,'GERAL','RESUMO')
pb_lin4(VM_REL,ProcName())
if !abre(if(VM_FL2='FO',CPO[1],CPO[2]))
	return NIL
end
dbsetorder(4)
VM_DTINI := ctod('01/01/'+str(year(PARAMETRO->PA_DATA),4))
VM_DTFIM := ctod('31/12/'+str(year(PARAMETRO->PA_DATA),4))
pb_box(18,27,,,,'Selecione Datas das Duplicatas')
@20,28 say 'Data Inicial..:' get VM_DTINI picture masc(7)
@21,33 say 'Final....:'      get VM_DTFIM picture masc(7) valid VM_DTFIM>=VM_DTINI
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_PAG  := 0
	VM_LAR  := 132
	VM_TOT  := array(4,2)
	VM_TOTAL:=0.00
	if VM_FL2=='CL'
		pb_msg('Totalizando Clientes...')
		select('DPCLI')
		DbGoTop()
		dbeval({||VM_TOTAL+=DR_VLRDP-DR_VLRPG})
	else
		pb_msg('Totalizando Fornecedores...')
		select('DPFOR')
		DbGoTop()
		dbeval({||VM_TOTAL+=DP_VLRDP-DP_VLRPG})
	end

	VM_CPO  :=if(VM_FL2='CL','CLIENTE','FORNEC')

	set relation to str(&(fieldname(8)),2) into BANCO,;
					 to str(&(fieldname(2)),5) into CLIENTE

	dbseek(dtos(VM_DTINI),.T.)
	afill(VM_TOT[2],0)
	afill(VM_TOT[3],0)
	afill(VM_TOT[4],0)
	while !eof().and.&(fieldname(4))<=VM_DTFIM
		VM_DTVEN := &(fieldname(4))
		VM_FL3   := .T.
		afill(VM_TOT[1],0)
		if !VM_FL1
			afill(VM_TOT[2],0)
		end
		while !eof().and.&(fieldname(4))==VM_DTVEN
			VM_VLRDP:=&(fieldname(6))-&(fieldname(7))
			if VM_FL1
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP233GA',VM_LAR)
				?  if(VM_FL3,dtoc(VM_DTVEN)+space(1),space(11))
				?? pb_zer(&(fieldname(2)),5)+'-'
				salvabd(SALVA)
				select CLIENTE
				?? left(&(fieldname(2)),30)
				salvabd(RESTAURA)
				?? '-'+transform(&(fieldname(1)),masc(16))
				?? space(1)+pb_zer(&(fieldname(8)),2)+' - '+BANCO->BC_DESCR
				?? space(1)+transform(&(fieldname(3)),mDT)
				?? space(3)+transform(VM_VLRDP,masc(2))+space(2)
				?? str((pb_divzero(VM_VLRDP,VM_TOTAL)*100),7,3)
				VM_TOT[1,1]++
				VM_TOT[1,2]+=VM_VLRDP
				VM_FL3=.F.
			else
				VM_TOT[if(&(fieldname(4))<PARAMETRO->PA_DATA,1,2),1]++
				VM_TOT[if(&(fieldname(4))<PARAMETRO->PA_DATA,1,2),2]+=VM_VLRDP
			end
			pb_brake()
		end
		if VM_FL1
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP233GA',VM_LAR)
			?
			?  space(64)+'TOTAL DATA'+replicate('.',26)+':  '+str(VM_TOT[1,1],4)
			?? space(1) +transform(VM_TOT[1,2],masc(2))
			?? space(2) +str((pb_divzero(VM_TOT[1,2],VM_TOTAL)*100),7,3)
			?
			VM_TOT[2,1]+=VM_TOT[1,1]
			VM_TOT[2,2]+=VM_TOT[1,2]
		else
			VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP233RA',VM_LAR)
			?  dtoc(VM_DTVEN)+ space(29)
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
		?  space(64)+padr('TOTAL SELECAO',36,'.')+':'+str(VM_TOT[2,1],6)
		?? space(1) +transform(VM_TOT[2,2],masc(2))
		?? space(2) +str((pb_divzero(VM_TOT[2,2],VM_TOTAL)*100),7,3)
	else
		?
		?  space(5)+'TOTAL GERAL'+replicate('.',18)+':  '+str(VM_TOT[3,1],4)
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
end
dbcloseall()
return NIL

function CFEP233GA()
?  'Dt.Venc'+space(4)+padr(VM_CPO,41)+'Dpl.'
?? space(03)+'Banco'
?? space(34)+'Emissao'
?? space(05)+'Vlr.em Aberto'+space(4)+'%G'
?replicate('-',VM_LAR)
return NIL

function CFEP233RA()
?  'Data'+space(33)+'Duplicatas Vencidas'+space(6)+'%'+space(7)
?? 'Duplicatas a Vencer'+space(6)+'%'+space(7)
?? 'TOTAL DATA'+space(15)+'%'
?replicate('-',VM_LAR)
return NIL
