*-----------------------------------------------------------------------------*
function CFEPFAR3(P1) // Listagem de Vendas												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','N','A',,,0,0,0,0,3,2}
//        1   2   3  456 7 8 9 0,1


VM_REL='Vendas '

pb_lin4(VM_REL,ProcName())

if !abre({'R->PARAMETRO','C->CLIENTE','R->CLICONV','R->PEDCAB','R->PEDDET'})
	return NIL
end

select('PEDCAB');ordsetfocus('CLIDTE')	// Pedidos/Vendas cli+dtEmiss

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=PARAMETRO->PA_DATA

VM_CLI   :=0
pb_box(17,20,,,,'Sele‡Æo')
// @17,22 say '[A]nalitico [S]intetico:' get VM_CPO[1] pict masc(01) valid VM_CPO[1]$'AS'
@18,22 say 'Empresa Conveniada.....:' get VM_CLI    pict masc(04) valid fn_codigo(@VM_CLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CLI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}).and.CLIENTE->CL_ATIVID==99 when pb_msg('Infome C¢digo da Empresa Conveniada, Atividade=99')
@19,22 say '[A]lfab‚tica [N]um‚rica:' get VM_CPO[3] pict masc(01) valid VM_CPO[3]$'AN' when pb_msg('Funcionarios em ordem A=Alfabetica N=Numerica')
@20,22 say 'Data Emissao Inicial...:' get VM_CPO[4] pict masc(07)
@21,22 say 'Data Emissao Final.....:' get VM_CPO[5] pict masc(07) valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	select('CLICONV')
	set filter to FC_EMPRESA==VM_CLI
	dbsetorder(1)	// Numerica
	if VM_CPO[3]=='A'
		dbsetorder(2)	// Alfa
	end
	VM_LAR:=80
	VM_PAG:=0
	VM_REL+= ' de '+dtoc(VM_CPO[4])+' ate '+dtoc(VM_CPO[5])
	DbGoTop()
	TOTALG:={0,0} // 
	while !eof()
		VM_CODFC :=FC_CODIGO
		VM_CPO[2]:=.T.
		TOTALG[1]:=0
		select('PEDCAB')
		dbseek(str(VM_CLI,5)+dtos(VM_CPO[4]),.T.)
		while !eof().and.VM_CLI==PC_CODCL.and.PC_DTEMI<=VM_CPO[5]
			if PC_CODFC==VM_CODFC.and.!PC_FLCAN
				if VM_CPO[2]
					VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPFAR3C',VM_LAR)
					?VM_CODFC+' '+padr(CLICONV->FC_NOME,39)
					VM_CPO[2]:=.F.
				end
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPFAR3C',VM_LAR)
				TOTALG[1]+=PC_TOTAL-PC_DESC
				if pcol()<30
					??space(50)
				end
				?? pb_zer(PC_NRNF,6)+' '
				?? dtoc(PC_DTEMI)
				?? transform(PC_TOTAL-PC_DESC,masc(2))
				?
			end
			dbskip()
		end
		if TOTALG[1]>0
			??padr(space(11)+'Total do funcionario',65)
			??transform(TOTALG[1],masc(2))
			?
			TOTALG[2]+=TOTALG[1]
		end
		select('CLICONV')
		dbskip()
	end
	?replicate('-',VM_LAR)
	? padr('TOTAL DA EMPRESA',65,'.')
	??transform(TOTALG[2],masc(2))
	?replicate('-',VM_LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEPFAR3C()
?padc('Relatorio da Empresa '+trim(CLIENTE->CL_RAZAO),VM_LAR)
?
?'Codigo'+space(5)+'Nome Funcionario'
??space(23)+'Nr.NF. Dt Emiss    Valor da NF'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
