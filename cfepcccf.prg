*-----------------------------------------------------------------------------*
function CFEPCCCF(P1,P2) // Dpls.a Pagar/Receber por BANCO							*
*						P1='CL'=CLIENTES	/	P1='FO'=FORNECEDORES							*
* 						P2='V'=VIDEO		/	P2='P'=PRINTER									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local PAG:=0
default P2 to 'V' // Video

private VM_TIPO:={},LAR:=115
aadd(VM_TIPO,if(P1='CL','CLIENTE','FORNEC'))
aadd(VM_TIPO,if(P1='CL','DPCLI'  ,'DPFOR'))
aadd(VM_TIPO,if(P1='CL','HISCLI' ,'HISFOR'))
aadd(VM_TIPO,'') // NOME
aadd(VM_TIPO,if(P1='CL',{	'R->PARAMETRO',;
									'R->MOEDA',;
									'R->CLIENTE',;
									'R->HISCLI',;
									'R->DPCLI'},;
								{	'R->PARAMETRO',;
									'R->MOEDA',;
									'R->CLIENTE',;
									'R->HISFOR',;
									'R->DPFOR'}))

VM_REL:='Duplicatas dos '+if(P1='CL','Clientes','Fornecedores')
pb_lin4(VM_REL,ProcName())
if !abre(VM_TIPO[5])
	return NIL
end
VM_FIM :=&(fieldname(2))
VM_COD :=0
VM_DATA:={boy(PARAMETRO->PA_DATA),eoy(PARAMETRO->PA_DATA)}
dbsetorder(5)
select CLIENTE
pb_box(18,26)
@19,28 say padr('Data Inicio',20,'.') get VM_DATA[1] picture masc(7)
@20,28 say padr('Data Fim',20,'.')    get VM_DATA[2] picture masc(7) valid VM_DATA[2]>=VM_DATA[1]
@21,55 say '[0 - para todos]'
@21,28 say padr(VM_TIPO[1],20,'.') get VM_FIM Picture masc(4) valid if(VM_FIM==0,P2=='P',fn_codigo(@VM_FIM,{'CLIENTE',{||dbseek(str(VM_FIM,5))},,{2,1}}))
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	if P2=='P'
		if !pb_ligaimp(I15CPP)
			dbcloseall()
			return NIL
		end
	end
	
	VM_FIMX:=max(VM_FIM,99999)

	dbseek(str(VM_FIM,5),.T.)
	pb_msg(,NIL,.F.)
	while !eof().and.if(VM_FIM==0,.T.,&(fieldname(1))==VM_FIM)
		VM_TIPO[4]:=&(fieldname(2))
		VALORES:=CFEPDUPP()
		if len(VALORES)>0
			VM_COD:=&(fieldname(1))
			//.......1........2..........3..........4...........5.........6.........7...........8...........9....
			CAB:={'Docto','Dt.Venct','Dt.Pgto','Vlr Dupl','Vlr Pgtos','Saldos','Dt.Emiss','Vlr Juros','Vlr Desc'}
			MAS:={   mDPL,       mDT,      mDT,      mUUU,       mUUU,   mI102,       mDT,       mD82,     mD82 }
//			MAS:={      1,         2,        3,         4,          5,       6,         7,          8,        9 }
			if P2=='P'
				REL  :='Extrato de '+VM_TIPO[1]+' Referente '+str(year(PARAMETRO->PA_DATA),4)
				PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPCCCFC',LAR)
				SALDO:={0,0,0,0}
				for X:=1 to len(VALORES)
					PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEPCCCFC',LAR)
					MOEDA->(dbseek(dtos(VALORES[X,7]),.T.))
					SALDO[1]:=val(charonly('0123456789',VALORES[X,4]))/100
					SALDO[2]+=SALDO[1]
					SALDO[3]+=val(charonly('0123456789',VALORES[X,5]))/100
					? transform(VALORES[X,7],MAS[7])+space(1) //..1-DT Emit
					??transform(VALORES[X,1],MAS[1])+space(1) //..2-Nr Docto
					??transform(VALORES[X,2],MAS[2])+space(1) //..3-DT Venc
					??transform(VALORES[X,3],MAS[3])+space(7) //..4-DT Pgto
					??transform(VALORES[X,4],MAS[4])+space(6) //..5-Vlr Dup
					??transform(VALORES[X,5],MAS[5]) //...........6-Vlr Juros
					??transform(VALORES[X,8],MAS[8]) //...........7
					??transform(VALORES[X,9],MAS[8]) //...........8
					??transform(SALDO[1]/max(MOEDA->MO_VLMOED1,1),MAS[9]) //..9
				next
				MOEDA->(dbseek(dtos(PARAMETRO->PA_DATA),.T.))
				? replicate('-',LAR)
				? padr('Total da Movimentacao',44,'.')+transform(SALDO[2],masc(2))+transform(SALDO[3],masc(2))
				? padr('Saldo Devedor',        44,'.')+transform(VALORES[X-1,6],masc(2))
				??space(26)+'em '+PARAMETRO->PA_MOEDA+transform(VALORES[X-1,6]/max(MOEDA->MO_VLMOED1,1),MAS[9])
				?replicate('-',LAR)
				setprc(65,1)
			else
				pb_msg('Use as setas, PgUP,PgDown.',NIL,.F.)
				@06,01 say padr(VM_TIPO[1],20,'.')+' '+pb_zer(VM_FIM,5)+'-'+VM_TIPO[4]+space(3)
				setcolor('GR+/B')
				X:=abrowse(7,0,22,79,;
							VALORES,CAB,;
							{10,10,10,11,11,11,10,11,11},;
							MAS)
			end
		end
		pb_brake()
	end
	if P2=='P'
		eject
		pb_deslimp(C15CPP)
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------
function CFEPCCCFC() // Cabecalho
*-----------------------------------------------------------------------
?'Codigo '+VM_TIPO[1]+'...:'+pb_zer(VM_COD,5)+'-'+VM_TIPO[4]
?
?replicate('-',LAR)
? padc(CAB[7],10)
??padc(CAB[1],14)
??padc(CAB[2], 9)
??padc(CAB[3],11)
??padl(CAB[4],15)
??padl(CAB[5],15)
??padl(CAB[8],12)
??padl(CAB[9],12)
??padl('Valor US$',12)
?replicate('-',LAR)
return NIL

*-----------------------------------------------------------------------------*
function CFEPDUPP() // duplicatas a pagar
local P1:=&(fieldname(1)),P2:={},SALDO:=0
salvabd(SALVA)
*------------------------------------------------------------->Dpl Pendentes
select(VM_TIPO[2])
dbseek(str(P1,5),.T.)
dbeval({||aadd(P2,{fieldget(1)							,;	// 1 Documento
						 fieldget(4)							,;	// 2 Data Venc
						 ctod('')								,;	// 3 Data Pgto
						 fieldget(6)							,;	// 4 Valor Dpl
						 0.00										,;	// 5 Valor Pago
						 0.00										,;	// 6 Saldo Devedor
						 fieldget(3)							,;	// 7 Data Emissao
						 0.00										,;	// 8 Juros
						 0.00})}									,;	// 9 Descontos
						 {||fieldget(3)>=VM_DATA[1].and.fieldget(3)<=VM_DATA[2]},;
						 {||P1==fieldget(2)})

*----------------------------------------------------------------> HISTORICO
select(VM_TIPO[3]) // LER HISTÓRICO
dbseek(str(P1,5),.T.)
dbeval({||aadd(P2,{fieldget(2),;	// 1 Documento
						 fieldget(4),;		// 2 Dt Vencto
						 fieldget(5),;		// 3 Dt Pgto
						 fieldget(6),;		// 4 Valor Dpl
						 fieldget(7),;		// 5 Valor Pago
						 0.00       ,;		// 6 Saldo Devedor
						 fieldget(3),;		// 7 Dt Emissao
						 fieldget(8),;		// 8 Juros
						 fieldget(9)})},;	// 9 Descontos
						 {||fieldget(3)>=VM_DATA[1].and.fieldget(3)<=VM_DATA[2]},;
						{||P1=fieldget(1)})

salvabd(RESTAURA)

	P2:=asort(P2,,,{|X,Y|dtos(X[7])+str(X[1],9)+dtos(X[3])+descend(str(X[4],12))<dtos(Y[7])+str(Y[1],9)+dtos(Y[3])+descend(str(Y[4],12))})
	for X:=1 to len(P2)
		if X>1.and.P2[X,1]==P2[X-1,1]
			P2[X,4]=0
		end
		SALDO+=P2[X,4]-P2[X,5]
		P2[X,6]:=SALDO
		P2[X,4]:=transform(if(P2[X,4]>0,P2[X,4],0),mI92)
		P2[X,5]:=transform(if(P2[X,5]>0,P2[X,5],0),mI92)
	next

return(P2)

*---------------------------------------------EOF--------------------------------*
