*----------------------------------------------------------------------------*
 static aVariav := {{ }, { }}
 //..................1....2
*-----------------------------------------------------------------------------*
#xtranslate VM_CPO	=> aVariav\[  1 \]

*-----------------------------------------------------------------------------*
function CFEPVEND(P1) // Listagem de Vendas												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','N','N','DTI','DTF','N','N'}
//        1   2   3    4     5    6   7

VM_REL:='Vendas do Periodo'

pb_lin4(VM_REL,ProcName())

if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->DPCLI',;
				'R->PEDDET',;
				'R->HISCLI'})
	return NIL
end

select('DPCLI');dbsetorder(5)	// Dpls Receber
select('PROD');dbsetorder(2)	// Cadastro de Produtos

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=PARAMETRO->PA_DATA
pb_box(15,20,,,,'Selecione')
@16,22 say 'Imprimir Vlr Entrada...:' get VM_CPO[6] pict masc(1)  valid VM_CPO[6]$'SN' when pb_msg('Deseja uma coluna com valor de Entrada pagos pelo Cliente')
@17,22 say 'Imprimir Vlr Parcelado.:' get VM_CPO[7] pict masc(1)  valid VM_CPO[7]$'SN' when pb_msg('Deseja uma coluna com valor Parcelado da NFs')
@18,22 say '[A]nalitico [S]intetico:' get VM_CPO[1] pict masc(1)  valid VM_CPO[1]$'AS' when pb_msg('Listagem Analita - com itens ou Sintetica - So as NFs')
@19,22 say 'Totalizar Data Emiss„o ?' get VM_CPO[2] pict masc(1)  valid VM_CPO[2]$'SN' when pb_msg('Fazer uma totalizacao por data de Emissao?')
@20,22 say 'Data Emissao Inicial...:' get VM_CPO[4] pict masc(7)								when pb_msg('')
@21,22 say 'Data Emissao Final.....:' get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_LAR:=132
	VM_PAG:=0
	VM_REL+= ' de '+dtoc(VM_CPO[4])+' ate '+dtoc(VM_CPO[5])
	select('PEDCAB')
	ordem DTENNF
	dbseek(dtos(VM_CPO[4]),.T.) // Data Inicial
	TOTALG:={0,0,0,0,0,0,0} // Total Geral
	while !eof().and.PC_DTEMI<=VM_CPO[5]
		CFEPVEND1(P1)
	end
	?replicate('-',VM_LAR)
	? space(25)+padr('TOTAL DO GERAL',41,'.')
	??space(01)+transform(TOTALG[1],mD82)	// TOTAL GERAL NF 
	??space(01)+transform(TOTALG[2],mD82)	// TOTAL DESCONTOS
	??space(01)+transform(TOTALG[3],mD82)	// TOTAL NF (LIQUIDO)
	if VM_CPO[6]=='S' // Imprimir Vlr Entradas
		??space(01)+transform(TOTALG[4],mD82)
	end
	if VM_CPO[7]=='S' // Imprimir Vlr Parcelado
		??space(01)+transform(TOTALG[5],mD82)
	end
	?
	if TOTALG[4]>0
	? space(39)+padr('VLR TOTAL ENTRADA'		,54,'.')+transform(TOTALG[4],mD82)
	end
	? space(39)+padr('VLR TOTAL NF A VISTA'	,54,'.')+transform(TOTALG[7],mD82)
	? space(39)+padr('VLR TOTAL NF A PRAZO'	,54,'.')+transform(TOTALG[6],mD82)
	? space(39)+padr('VLR TOTAL PARCELADO'		,54,'.')+transform(TOTALG[5],mD82)
	? replicate('-',VM_LAR)
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
static function CFEPVEND1(P1)
*----------------------------------------------------------------------------*
local VM_DTEMI	:=PC_DTEMI
local TOTALD	:={0,0,0,0,0}	// Total Dia
local TOTALN						// Total NF
VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,'CFEPVEND',VM_REL,VM_PAG,'CFEPVENDA',VM_LAR)
while !eof().and.PC_DTEMI==VM_DTEMI
	if PEDCAB->PC_FLAG.and.!PEDCAB->PC_FLCAN.and.!Dev_Saida(PEDCAB->PC_CODOP)
		VM_PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,'CFEPVEND',VM_REL,VM_PAG,'CFEPVENDA',VM_LAR)
		TOTALN   :={0,0,0,0,0}	// Totais da NF 
		TOTALN[1]:=PEDCAB->PC_TOTAL+PEDCAB->PC_DESC+PEDCAB->PC_DESCIT	// Total Produtos
		TOTALN[2]:=PEDCAB->PC_DESC+PEDCAB->PC_DESCIT	// Valor dos Descontos
		TOTALN[3]:=TOTALN[1]-TOTALN[2]	// Valor Total NF
		TOTALN[4]:=PEDCAB->PC_VLRENT		// Valor das Entradas
		if PEDCAB->PC_FATUR==0	// A Vista
			TOTALG[7]+=TOTALN[3] // Total NF a Vista
		else
			TOTALG[6]+=TOTALN[3] // Total NF a Prazo
		end
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		? space(01)+pb_zer(PC_NRNF,6)
		??space(01)+pb_zer(PC_CODCL,5)+'-'+left(CLIENTE->CL_RAZAO,38)
		??space(01)+transform(PC_DTEMI,masc(7))
		??space(01)+str(PC_FATUR,2)
		??space(01)+transform(TOTALN[1],mD82)
		??space(01)+transform(TOTALN[2],mD82)
		??space(01)+transform(TOTALN[3],mD82)
		if VM_CPO[6]=='S' // Imprimir Vlr Entradas
			if TOTALN[4]>0
			??space(01)+transform(TOTALN[4],mD82)
			else
			??space(13)
			end
		end
		if VM_CPO[7]=='S'.and.PEDCAB->PC_FATUR>0	// Imprimir Vlr Parcelado
			TOTALN[5]:=TOTALN[3]-TOTALN[4]			// Valor Parcelado
			??space(01)+transform(TOTALN[5],mD82)
		end
		if VM_CPO[1]=='A'
			VM_PEDID:=PC_PEDID
			VM_FATUR:=PC_FATUR // 0=Vista , 1,2,3...=Prazo
			select('PEDDET')
			dbseek(str(VM_PEDID,6),.T.)
			while !eof().and.VM_PEDID=PD_PEDID
				PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPVENDA',VM_LAR)
				? space(35)+pb_zer(PD_ORDEM,2)
				??space(01)+padl(pb_zer(PD_CODPR,L_P)+'-'+PROD->PR_DESCR,50)
				??space(01)+transform(PD_QTDE,masc(6))
				??space(01)+transform(PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI,masc(2))
				dbskip()
			end
			select('PEDCAB')
		end
		TOTALD[1]+=TOTALN[1]
		TOTALD[2]+=TOTALN[2]
		TOTALD[3]+=TOTALN[3]
		TOTALD[4]+=TOTALN[4]
		TOTALD[5]+=TOTALN[5]
	end
	pb_brake()
end
if VM_CPO[2]=='S'
	? space(25)+padr('Total do Dia',52,'.')
	??space(01)+transform(TOTALD[1],				mD82)
	??space(01)+transform(TOTALD[2],				mD82)
	??space(01)+transform(TOTALD[3],				mD82)
	if VM_CPO[6]=='S' //..............................Imprimir Vlr Entradas
		??space(01)+transform(TOTALD[4],			mD82)
	end
	if VM_CPO[7]=='S' //..............................Imprimir Vlr Parcelado
		??space(01)+transform(TOTALD[5],			mD82)
	end
	??space(01)+transform(pb_divzero(TOTALD[2],TOTALD[1])*100,masc(20))
	?
end
TOTALG[1]+=TOTALD[1]	// Vlr Total Produtos
TOTALG[2]+=TOTALD[2]	// Vlr Desconto
TOTALG[3]+=TOTALD[3]	// Vlr Nota
TOTALG[4]+=TOTALD[4]	// Entradas
TOTALG[5]+=TOTALD[5] // parcelado
return NIL

*-----------------------------------------------------------------------------*
 function CFEPVENDA()
*-----------------------------------------------------------------------------*
?' N.Fisc '+ padr('Cliente',45)+'Dt Emiss Parc  VTot Produt  Vlr Descont Vlr Total NF'
if VM_CPO[6]=='S' // Imprimir Vlr Entradas
	??'  VlrEntradas '
end
if VM_CPO[7]=='S' // Imprimir Vlr Parcelado
	??' VlrParcelado'
end
if VM_CPO[1]='A'
	? space(35)+'Item '+padr('Produtos',52)
	??'Qtdade        Vlr Item'
end
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
