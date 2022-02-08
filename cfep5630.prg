*-----------------------------------------------------------------------------*
function CFEP5630(P1) // Listagem de Vendedores											*
*					   P1=1 % DEFINIDO PELOS PARAMETROS - % VENDEDOR E % PRODUTO	*
*						P1=2 % DEFINIDO POR TIPO DE VENDAS	(A vista/A prazo)			*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'A','NF','N','','',0,0,0,0,3,2}
//        1   2    3  4  5  6 7 8 9 0,1

VM_REL:='Comissoes das Vendas'

pb_lin4(VM_REL,ProcName())
if !abre({	'R->PROD',;
				'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->HISCLI',;
				'R->VENDEDOR',;
				'C->NATOP'})
	return NIL
end

select('PROD');dbsetorder(2)	// Cadastro de Produtos
select('VENDEDOR')
	dbgobottom();VM_FIM:=VE_CODIG
	DbGoTop();   VM_INI:=VE_CODIG
VM_CPO[10]:=VE_PERC
VM_CPO[11]:=VE_PERCV

VM_CPO[4]:=bom(PARAMETRO->PA_DATA)
VM_CPO[5]:=eom(PARAMETRO->PA_DATA)
pb_box(16-P1,20)
if P1==2 // 2§ MODO
	@15,22 say '% Comiss„o < A vista :     >   < A prazo :     >'
	@15,44 get VM_CPO[10] picture masc(14) valid VM_CPO[10]>=0
	@15,64 get VM_CPO[11] picture masc(14) valid VM_CPO[11]>=0
end
@16,22 say '[A]nalitico [S]intetico:' get VM_CPO[1] pict masc(1)  valid VM_CPO[1]$'AS'
@17,22 say 'Analitico [NF][PR].....:' get VM_CPO[2] pict masc(1)  valid VM_CPO[2]+'.'$'NF.PR.' when VM_CPO[1]='A'
@18,22 say 'Uma P gina por Vendedor:' get VM_CPO[3] pict masc(1)  valid VM_CPO[3]$'SN' when VM_CPO[1]='A'
@19,22 say 'Vendedor Inicial:'        get VM_INI    pict masc(12) valid fn_codigo(@VM_INI,{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_INI,3)))},{||CFEP5610T(.T.)},{2,1}})
@20,31 say 'Final..:'                 get VM_FIM    pict masc(12) valid VM_FIM>=VM_INI.and.fn_codigo(@VM_FIM,{'VENDEDOR',{||VENDEDOR->(dbseek(str(VM_FIM,3)))},{||CFEP5610T(.T.)},{2,1}})
@21,22 say 'Data Limite de..:'        get VM_CPO[4] pict masc(7)
@21,52 say 'ate'                      get VM_CPO[5] pict masc(7)  valid VM_CPO[5]>=VM_CPO[4]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_LAR:=132
	VM_PAG:=0
	VM_REL+=' REF:'+dtoc(VM_CPO[4])+' a '+dtoc(VM_CPO[5])
	select('PEDCAB')
	ordem VEDDTE
	dbseek(str(VM_INI,3),.T.) // vendedor inicial
	while !eof().and.PC_VEND<=VM_FIM
		CFEP5631(P1)
	end
	if VM_CPO[8]>0
		? replicate('-',VM_LAR)
		? 'Total'+replicate('.',39)+transform(VM_CPO[9],masc(2))
		??space(2)+transform(VM_CPO[8],masc(2))
	end
	?replicate('-',VM_LAR)
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
function CFEP5631(P1)
*----------------------------------------------------------------------------*
local VM_LIVEND:=''
local VM_LINF  :=''
local VM_LIDET :=''
local VM_LOGIMP:={.T.,.T.} // imprimir linha vendedor , linha nf ?
local VM_VLCDET:=0

VM_VEND:=PC_VEND // codigo vendedor
VENDEDOR->(dbseek(str(VM_VEND,3)))
VM_PRVEN:=VENDEDOR->VE_PERC
dbseek(str(VM_VEND,3)+dtos(VM_CPO[4]),.T.) // VENDEDOR e DATA INICIAL

VM_PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP5630A',VM_LAR)
VM_LIVEND:=pb_zer(VM_VEND,3)+chr(45)+VENDEDOR->VE_NOME
if P1==1
	VM_LIVEND+=space(1)+transform(VENDEDOR->VE_PERC,masc(20))+'%'+space(1)
end
VM_TOTAL:={0,0,0,0,0} // 
while !eof().and.VM_VEND==PC_VEND.and.PC_DTEMI<=VM_CPO[5]
	if PC_FLAG.and.!PC_FLCAN.and.!Dev_Saida(PEDCAB->PC_CODOP).and.!Nat_Transf(PEDCAB->PC_CODOP)	// Verificar se NF é devoluçao (Não processar) e pedidos não confirmados e NF transferencias
		VM_TOTAL[1]:=PC_TOTAL									// Liquido da NF
		VM_TOTAL[2]+=VM_TOTAL[1]								// Soma de valores totais
		if P1==2 // % vista e a prazo
			VM_TOTAL[3]:=VM_TOTAL[1]							// VLR DA DPL
		else
			VM_TOTAL[3]:=fn_dplpg(PC_CODCL,PC_NRDPL)		// VLR DAS DPL JA PAGAS
		end
		VM_TOTAL[4]+=VM_TOTAL[3]								// Somatorio de Dpl Pagas
		VM_TOTAL[5]:=1-pb_divzero(PC_DESC,(PC_TOTAL+PC_DESC))		// % DESCONTO
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		VM_LOGIMP[2]:=.T.
		VM_LINF:=space(11)+;
	  				pb_zer(PC_PEDID,6)          +space(01)+;
					pb_zer(PC_NRNF,6)           +space(01)+;
					transform(PC_NRDPL,masc(16))+space(01)+;
					pb_zer(PC_CODCL,5)+'-'+left(CLIENTE->CL_RAZAO,35)+space(01)+;
					transform(PC_DTEMI,masc(7))+space(01)+;
					transform(VM_TOTAL[1],masc(2))+space(01)+;
					str(PC_FATUR,1)+space(01)+;
					transform(VM_TOTAL[3],masc(2))+space(01)+;
					transform(pb_divzero(VM_TOTAL[3],VM_TOTAL[1])*100,masc(20))+;
					if(PC_FLAG,'','<PED>')
		VM_PEDID:=PC_PEDID
		VM_FATUR:=PC_FATUR // 0=Vista , 1,2,3...=Prazo
		select('PEDDET')
		dbseek(str(VM_PEDID,6),.T.)
		while !eof().and.VM_PEDID=PD_PEDID
			PROD->(dbseek(str(PEDDET->PD_CODPR,L_P)))
			VM_CPO[6]+=round((PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)*VM_TOTAL[5]*pb_divzero(VM_TOTAL[3],VM_TOTAL[1]),2)
			if P1==1
				VM_VLCDET:=round((PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)*VM_TOTAL[5]*((PROD->PR_PRVEN+VM_PRVEN)/100)*pb_divzero(VM_TOTAL[3],VM_TOTAL[1]),2) // Cal Comissao
			else
				VM_VLCDET:=round((PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI)*VM_TOTAL[5]*if(VM_FATUR=0,VM_CPO[10],VM_CPO[11])/100,2) // Calc Comissao
			end
			VM_CPO[7]+=VM_VLCDET
			
			VM_LIDET:=space(22)+;
						 pb_zer(PD_ORDEM,2)+space(01)+;
						 padl(pb_zer(PD_CODPR,L_P)+'-'+PROD->PR_DESCR,48)+space(02)+;
						 transform(PD_QTDE,masc(6))+space(01)+;
						 transform(PD_QTDE*PD_VALOR-PD_DESCV+PD_ENCFI,masc(2))
			if P1==1 // modo normal
				VM_LIDET+=space(01)+transform(PROD->PR_PRVEN,masc(14))
			end
			
			if VM_CPO[1]='A'.and.str(VM_VLCDET,15,2)>str(0,15,2) // Tem comissao
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP5630A',VM_LAR)
				if VM_LOGIMP[1]
					?VM_LIVEND
					VM_LOGIMP[1]:=.F.
				end
	
				if VM_LOGIMP[2]
					?VM_LINF
					VM_LOGIMP[2]:=.F.
				end
	
				if VM_CPO[2]=='PR'
					?VM_LIDET
				end
			end
			dbskip()
		end
	end
	select('PEDCAB')
	pb_brake()
end

if VM_LOGIMP[1]
else
	if VM_CPO[1]=='A'
		?
		?space(1)+padr('Totais do Vendedor',25,'.')
		??'Comissao:'+transform(VM_CPO[7],masc(2))
		??'  Vendas:'+transform(VM_CPO[6],masc(2))
	else
		??'Comis:'+transform(VM_CPO[7],masc(2))
		??space(1)+transform(VM_CPO[6],masc(2))
	end
	?
	VM_CPO[8]+=VM_CPO[6]
	VM_CPO[9]+=VM_CPO[7]
	VM_CPO[6] =0
	VM_CPO[7] =0
end

if !eof() 
	dbseek(str(VM_VEND,3)+'9',.T.) // VENDEDOR INICIAL
end
return NIL

*-----------------------------------------------------------------------------*
	function CFEP5630A()
*-----------------------------------------------------------------------------*
? I15CPP
if VM_CPO[1]='A'
	??padr('Vendedor',10)
	??'Pedido N.Fisc  Duplicata '+padr('Cliente',42)
	??'Data Emiss'    +space(6)
	??'Vlr Compra Fat'+space(4)
	??'Valor Pago  %Pago OBS'
else
	??'Vendedor'+space(59)+'Valor Vendido'
end
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
	function FN_DPLPG(P1,P2)
*-----------------------------------------------------------------------------*
local VM_TOTAL:=PC_TOTAL-PC_DESC
if PC_FATUR>0
//	P2=left(str(P2,9),8)
	VM_TOTAL:=0
	salvabd(SALVA)
	select('HISCLI')
	dbseek(str(P1,5),.T.)
	while !eof().and.P1==HC_CODCL
		for X=1 to PEDCAB->PC_FATUR
			if P2+1==HC_DUPLI
				VM_TOTAL+=HC_VLRPG
			end
		end
		dbskip()
	end
	salvabd(RESTAURA)
	//	dbeval({||VM_TOTAL+=HC_VLRPG},{||P2==left(str(HC_DUPLI,9),8)},{||P1==HC_CODCL})
end
return(VM_TOTAL)
//----------------------------------------------------------------EOF--------------