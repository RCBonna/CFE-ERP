*-----------------------------------------------------------------------------*
 static aVariav:= {''}
 //.................1
*-----------------------------------------------------------------------------*
#xtranslate cMsgSerie      => aVariav\[  1 \]

*-----------------------------------------------------------------------------*
function CFEP2312(VM_FL1,VM_FL2) // Dpls.a Pagar FORNECEDOR/CLIENTES				*
*						VM_FL1=...........F.=RESUMO											*
*						VM_FL1=...........T.=GERAL												*
*									VM_FL2=..'FO'=FORNEC											*
*									VM_FL2=..'CL'=CLIENTE										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local CPO:={{	'R->PARAMETRO',;
					'R->BANCO',;
					'R->CTRNF',;
					'R->CLIENTE',;
					'R->DPFOR'},;
			   {	'R->PARAMETRO',;
					'R->BANCO',;
					'R->CTRNF',;
					'R->CLIENTE',;
					'R->DPCLI'}}

VM_REL='Duplicatas a '+if(VM_FL2='FO','Pagar por Fornecedor ','Receber por Cliente ')+'-'+if(VM_FL1,'GERAL','RESUMO')

pb_lin4(VM_REL,ProcName())
if !abre(CPO[if(VM_FL2=='FO',1,2)])
	return NIL
end
if !VM_FL1
	alert('Relatorio modificado para colocar;acumulado ao lado da coluna final;para fazer compartivo com outro relatoro de saldos')
end
VM_CODFOS:= 0
VM_DATA  :=PARAMETRO->PA_DATA
VM_DTVCT :=PARAMETRO->PA_DATA
VM_CPO   :=if(VM_FL2='CL','CLIENTE','FORNEC')
VM_SERIE :='   '
VM_FLAG  :='T'
if VM_FL2=='CL'
	cMsgSerie:='Branco para Listar Todas - Serie INT-Integralizar - use XXX para excluir INT'
else
	cMsgSerie:='Branco para Listar Todas - Usar SOB/QUO - use XXX para excluir SOB/QUO'
end
pb_box(17,27,,,,'Selecione')
@18,28 say padr('Data p/Juros',12,'.') get VM_DATA   pict mDT
@19,28 say padr(VM_CPO,        12,'.') get VM_CODFOS pict mI5  valid if(VM_CODFOS==0,.T.,fn_codigo(@VM_CODFOS,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODFOS,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})) when pb_msg('Informe 0 para selecionar todos')
@20,28 say padr('Serie',       12,'.') get VM_SERIE  pict mUUU valid VM_SERIE$'   |XXX'.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}) when pb_msg(cMsgSerie)
@21,28 say padr('Listar Dlp',  12,'.') get VM_FLAG   pict mUUU valid VM_FLAG$'VTA' when  pb_msg('<V> So Vencidas   <T>Todas')
@21,48 say 'Data Limite:'              get VM_DTVCT  pict mDT  when VM_FLAG=='V'.and.pb_msg('Data limite para listar vencimentos')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_PAG  := 0
	VM_TOT  := array(4,3)
	VM_TOTAL:=0.00
	VM_LAR  := 132
	if VM_FLAG$'TA'
		VM_DTVCT:=VM_DATA
	end
	if VM_FL2=='CL'
		pb_msg('Totalizando Clientes...')
		select('DPCLI')
		DbGoTop()
		dbeval({||VM_TOTAL+=DPCLI->DR_VLRDP-DPCLI->DR_VLRPG})
		set relation to str(&(fieldname(8)),2) into BANCO,;
						 to str(&(fieldname(2)),5) into CLIENTE

		if !empty(VM_SERIE)
			if VM_SERIE=='XXX'
				set filter to .NOT.(DPCLI->DR_SERIE $'SOB.INT.QUO')
			else
				set filter to DPCLI->DR_SERIE == VM_SERIE
			end
			SET OPTIMIZE   	ON		// otimização de filtros (SET FILTER TO)
		end
	else
		pb_msg('Totalizando Fornecedores...')
		select('DPFOR')
		DbGoTop()
		dbeval({||VM_TOTAL+=DPFOR->DP_VLRDP-DPFOR->DP_VLRPG})
		set relation to str(&(fieldname(8)),2) into BANCO,;
						 to str(&(fieldname(2)),5) into CLIENTE
		if !empty(VM_SERIE)
			if VM_SERIE=='XXX'
				set filter to .NOT.(DPFOR->DP_SERIE $'SOB.INT.QUO')
			else
				set filter to DPFOR->DP_SERIE = VM_SERIE
			end
			SET OPTIMIZE   	ON		// otimização de filtros (SET FILTER TO)
		end
	end
	if VM_CODFOS#0 // listar todos os Fornecedores/Clientes
		dbsetorder(5)
		dbseek(str(VM_CODFOS,5),.T.)
	else
		dbsetorder(2)
		DbGoTop()
//		dbsetorder(5) // teste
	//	DbGoTop() // teste
	end

	afill(VM_TOT[2],0)
	afill(VM_TOT[3],0)
	afill(VM_TOT[4],0)
	while !eof().and.if(VM_CODFOS==0,.T.,&(fieldname(2))==VM_CODFOS)
		VM_CODFO:=&(fieldname(2))
		salvabd()
		select CLIENTE
		VM_DESCR := left(&(fieldname(2)),26)
		salvabd(.F.)
		VM_FL3   := .T.
		afill(VM_TOT[1],0)
		if !VM_FL1
			afill(VM_TOT[2],0)
		end
		VM_SUBTOT:={0,0}
		while !eof().and.&(fieldname(2))==VM_CODFO
			VM_VLRDP:=&(fieldname(6))-&(fieldname(7))
			VM_JUROS:=CalcJur(VM_VLRDP,&(fieldname(4)),&(fieldname(15)),VM_DATA,VM_FL2=='CL')
			if VM_FL1
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP232GA',VM_LAR)
				if VM_SUBTOT[1]>0.and.&(fieldname(4))>VM_DTVCT
					?  space(53)+padr('Sub-Total Vencidas',37,'.')
					?? transform(VM_SUBTOT[1],masc(2))
					VM_SUBTOT[1]:=0
				end
				if VM_FLAG=='T'.or.;
					VM_FLAG=='A'.or.;
					(VM_FLAG=='V'.and.fieldget(4)<=VM_DTVCT)
					?  if(VM_FL3,pb_zer(VM_CODFO,5)+'-'+VM_DESCR+space(1),space(33))
					?? transform(&(fieldname(1)),masc(16))+'/'+&(fieldname(11))
					?? space(1)+pb_zer(&(fieldname(8)),2)+'-'+left(BANCO->BC_DESCR,12)
					?? space(1)+dtoc(&(fieldname(3)))
					?? space(1)+dtoc(&(fieldname(4)))
					?? str(max(VM_DATA-&(fieldname(4)),0),5)
					?? transform(VM_VLRDP,masc(2))
					?? transform(VM_JUROS,masc(25))
					?? transform(VM_VLRDP+VM_JUROS,masc(2))
					VM_TOT[1,1]++
					VM_TOT[1,2]+=VM_VLRDP
					VM_TOT[1,3]+=VM_JUROS
					VM_FL3=.F.
					VM_SUBTOT[1]+=if(&(fieldname(4))< VM_DTVCT,VM_VLRDP,0)
					VM_SUBTOT[2]+=if(&(fieldname(4))>=VM_DTVCT,VM_VLRDP,0)
				end
			else
				VM_TOT[if(&(fieldname(4))<VM_DATA,1,2),1]++
				VM_TOT[if(&(fieldname(4))<VM_DATA,1,2),2]+=VM_VLRDP
			end
			pb_brake()
		end
		if VM_FL1
			if VM_TOT[1,2]>0
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP232GA',VM_LAR)
				if VM_SUBTOT[2]>0
					?  space(52)+padr('Sub-Total a Vencer',38,'.')
					?? transform(VM_SUBTOT[2],masc(2))
				end
				?
				?  space(53)+padr('TOTAL '+VM_CPO,29,'.')+':  '+str(VM_TOT[1,1],4)
				?? space(1) +transform(VM_TOT[1,2],masc(2))
				??           transform(VM_TOT[1,3],masc(25))
				??           transform(VM_TOT[1,2]+VM_TOT[1,3],masc(2))
			end
			?
			VM_TOT[2,1]+=VM_TOT[1,1]
			VM_TOT[2,2]+=VM_TOT[1,2]
			VM_TOT[2,3]+=VM_TOT[1,3]
		else
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP232RA',VM_LAR)
			?  pb_zer(VM_CODFO,5)+'-'+VM_DESCR+ space(1)
			?? str(VM_TOT[1,1],4)+space(1)+transform(VM_TOT[1,2],masc(2))
			?? space(2)+str((pb_divzero(VM_TOT[1,2],VM_TOTAL)*100),7,3)+space(4)

			?? str(VM_TOT[2,1],4)+space(1)+transform(VM_TOT[2,2],masc(2))
			?? space(2)+str((pb_divzero(VM_TOT[2,2],VM_TOTAL)*100),7,3)+space(4)

//			?? str(VM_TOT[1,1]+VM_TOT[2,1],4)+space(1)
			?? transform(VM_TOT[1,2]+VM_TOT[2,2],masc(2))
//			?? space(2)+str((pb_divzero(VM_TOT[1,2]+VM_TOT[2,2],VM_TOTAL)*100),7,3)
			
			VM_TOT[3,1]+=VM_TOT[1,1]
			VM_TOT[3,2]+=VM_TOT[1,2] //
			VM_TOT[4,1]+=VM_TOT[2,1]
			VM_TOT[4,2]+=VM_TOT[2,2] //
			
			?? transform(VM_TOT[3,2]+VM_TOT[4,2],masc(2)) // IMPRIMIR ACUMULADO TEMPORARIAMENTE
			
		end
	end
	if VM_FL1
		if VM_CODFOS=0
			?
			?  space(44)+'TOTAL GERAL'+replicate('.',27)+':  '+str(VM_TOT[2,1],4)
			?? space(1) +transform(VM_TOT[2,2],masc(2))
			??           transform(VM_TOT[2,3],masc(25))
			??           transform(VM_TOT[2,2]+VM_TOT[2,3],masc(2))
		end
	else
		if VM_CODFOS=0
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
	end			
	?replicate('-',VM_LAR)
	if VM_CODFOS=0
		? space(26)+padr('Total Geral de Duplicatas',91,'.')
		??transform(VM_TOTAL,masc(2))
	end
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL
*----------------------------------------------------------------------------------------*
function CFEP232GA()
*----------------------------------------------------------------------------------------*
if VM_FLAG=='V'
	?'Somente Duplicatas vencidas ate : ' + transform(VM_DTVCT,mDT)
end
?  padr(VM_CPO,40,'.')+'Dpl/Ser Banco'+space(12)+'Dt Emiss     '
?? 'Dt Vcto Dias  Vlr.em Aberto   Vlr Juros    Valor Total'
?replicate('-',VM_LAR)
return NIL

*----------------------------------------------------------------------------------------*
function CFEP232RA()
*----------------------------------------------------------------------------------------*
?  padr(VM_CPO,34,'.')+'Duplicatas Vencidas'+space(6)+'%'+space(7)
?? 'Duplicatas a Vencer'+space(6)+'%'+space(7)
?? padL('TOTAL '+VM_CPO,19)+space(6)+'%'
?replicate('-',VM_LAR)
return NIL
*----------------------------------[EOF]---------------------------------------------------*
