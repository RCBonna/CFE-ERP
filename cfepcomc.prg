*-----------------------------------------------------------------------------*
function CFEPCOMC() // Listagem de Comissa dos Vendedores							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_REL:='Comissoes dos Vendedores-C'
pb_lin4(VM_REL,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->VENDEDOR'})
	return NIL
end
private VM_CPO:={'A','S','S','N','','',0,0,0, 3,4}
			//        1   2  3   4   5  6 7 8 9 0,1

select('VENDEDOR')
dbgobottom();VM_FIM=VE_CODIG
DbGoTop();   VM_INI=VE_CODIG
VM_CPO[05]:=bom(PARAMETRO->PA_DATA)
VM_CPO[06]:=eom(PARAMETRO->PA_DATA)
pb_box(14,20,,,,'Selecione')
@15,22 say '[A]nalitico [S]intetico...:' get VM_CPO[01] pict masc(01) valid VM_CPO[1]$'AS'
@16,22 say 'Total das Vendas p/Data ?  ' get VM_CPO[02] pict masc(01) valid VM_CPO[2]$'SN'
@17,22 say 'Total das Comissoes p/Data?' get VM_CPO[03] pict masc(01) valid VM_CPO[3]$'SN'
@18,22 say 'Uma P gina por Vendedor...:' get VM_CPO[04] pict masc(01) valid VM_CPO[4]$'SN' when VM_CPO[1]='A'
@19,22 say 'Vendedor Inicial:'           get VM_INI     pict masc(12) valid fn_codigo(@VM_INI,{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_INI,3)))},{||CFEP5610T(.T.)},{2,1}})
@20,31 say 'Final..:'                    get VM_FIM     pict masc(12) valid VM_FIM>=VM_INI.and.fn_codigo(@VM_FIM,{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_FIM,3)))},{||CFEP5610T(.T.)},{2,1}})
@21,22 say 'Data Limite de............:' get VM_CPO[05] pict masc(07)
@21,60 say 'ate'                         get VM_CPO[06] pict masc(07) valid VM_CPO[6]>=VM_CPO[5]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_LAR:=132
	VM_PAG:=0
	select('PEDCAB')
	dbsetorder(3)
	dbseek(str(VM_INI,3),.T.) // Vendedor inicial
	while !eof().and.PC_VEND<=VM_FIM
		COMC1()
	end
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
static function COMC1()
*----------------------------------------------------------------------------*
local VM_TOTAL:={0,0,0,0,0,0}
local VM_COMIS:={0,0,0,0,0,0}
local VM_VEND:=PC_VEND
local VM_DATA
dbseek(str(VM_VEND,3)+dtos(VM_CPO[5]),.T.) // VENDEDOR INICIAL
VENDEDOR->(dbseek(str(VM_VEND,3)))
VM_CPO[10]:=VENDEDOR->VE_PERCV	// Comissao a Vista
VM_CPO[11]:=VENDEDOR->VE_PERC		// Comissao a Prazo
VM_PAG    :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPCOMCA',VM_LAR)
?pb_zer(VM_VEND,3)+chr(45)+VENDEDOR->VE_NOME
while !eof().and.VM_VEND==PC_VEND.and.PC_DTEMI<=VM_CPO[6]
	VM_DATA:=PC_DTEMI
	while !eof().and.VM_VEND==PC_VEND.and.PC_DTEMI<=VM_CPO[6].and.VM_DATA==PC_DTEMI
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPCOMCA',VM_LAR)
		VM_TOTAL[1] =PC_VLRENT								// VLR Vista NF
		VM_TOTAL[2] =PC_TOTAL-PC_DESC-PC_VLRENT		// VLR Prazo NF
		VM_TOTAL[3]+=VM_TOTAL[1]							// Soma DIA VISTA
		VM_TOTAL[4]+=VM_TOTAL[2]							// Soma DIA PRAZO
		VM_COMIS[1] =round(VM_TOTAL[1]*VM_CPO[10]/100,2) // Comis Vista
		VM_COMIS[2] =round(VM_TOTAL[2]*VM_CPO[11]/100,2) // Comis Prazo
		VM_COMIS[3]+=VM_COMIS[1]	// DIA VISTA
		VM_COMIS[4]+=VM_COMIS[2]	// DIA PRAZO
		if VM_CPO[1]=='A' // Analitico
			CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
			? space(02)+pb_zer(PC_PEDID,6)
			??space(01)+pb_zer(PC_NRNF,6)
			??space(01)+transform(PC_NRDPL,masc(16))
			??space(01)+pb_zer(PC_CODCL,5)+'-'+left(CLIENTE->CL_RAZAO,20)
			??space(01)+transform(PC_DTEMI,masc(7))
			??space(02)+str(PC_FATUR,1)
			??transform(VM_TOTAL[1],masc(2))
			??transform(VM_TOTAL[2],masc(2))
			??transform(VM_TOTAL[1]+VM_TOTAL[2],masc(2))
			??transform(VM_COMIS[1]+VM_COMIS[2],masc(25))
			??space(01)+if(PC_FLAG,'','<<PEDIDO>>')
		end
		pb_brake()
	end
	? 'Vendas do dia  '+dtoc(VM_DATA)
	if VM_CPO[2]=='S'
		??' A Vista' 
		??transform(VM_TOTAL[3],masc(2))
		??' A Prazo'
		??transform(VM_TOTAL[4],masc(2))
		??' = '
		??transform(VM_TOTAL[3]+VM_TOTAL[4],masc(2))
	end
	if VM_CPO[3]=='S'
		??' Comissao'
		??transform(VM_COMIS[3]+VM_COMIS[4],masc(25))
	end
	VM_TOTAL[5]+=VM_TOTAL[3]	// Soma FINAL Vista
	VM_TOTAL[6]+=VM_TOTAL[4]	// Soma FINAL Prazo
	VM_COMIS[5]+=VM_COMIS[3]	// TOT VISTA
	VM_COMIS[6]+=VM_COMIS[4]	// TOT PRAZO
	VM_TOTAL[3]:=0
	VM_TOTAL[4]:=0
	VM_COMIS[3]:=0
	VM_COMIS[4]:=0
end

	? 'Total do Vendedor........'
	if VM_CPO[2]=='S'
		??' A Vista' 
		??transform(VM_TOTAL[5],masc(2))
		??' A Prazo'
		??transform(VM_TOTAL[6],masc(2))
		??' = '
		??transform(VM_TOTAL[5]+VM_TOTAL[6],masc(2))
	end
	if VM_CPO[3]=='S'
		??' Comissao'
		??transform(VM_COMIS[5]+VM_COMIS[6],masc(2))
	end

if VM_CPO[04]=='S'
	setprc(64,1)
end
dbseek(str(VM_VEND,3)+'9',.T.) // PROX VENDEDOR
return NIL

*-----------------------------------------------------------------------------*
function CFEPCOMCA()
if VM_CPO[1]=='A'
	? I15CPP
	??space(02)
	??'Pedido N.Fisc  Duplicata '+padr('Cliente',27)
	??'Data Emiss PC'  +space(6)
	??'Vlr Vista'    +space(6)
	??'Vlr Prazo  Vlr Nota Fisc  Vlr Comiss OBS'
	??C15CPP
else
	?'Vendedor'+space(59)+'Valor Vendido'
end
?replicate('-',VM_LAR)
return NIL
