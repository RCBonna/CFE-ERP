*-----------------------------------------------------------------------------*
 function CFEP4430()	//	Movimetacoes do estoque - TRANSFERENCIAS					*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'R->CODTR',;
				'R->ALIQUOTAS',;
				'C->CTADET',;
				'C->CTACTB',;
				'C->XOBS',;
				'C->GRUPOS',;
				'C->MOVEST',;
				'C->FISACOF',;
				'C->SALDOS',;
				'C->UNIDADE',;
				'C->PROD'})
	return NIL
end
if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
	pb_dbedit1('CFEP443','Transf')
else
	pb_dbedit1('CFEP443','TransfDespesProducLista Ajuste')
end

select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

select('PROD')
ORDEM CODIGO

select('MOVEST')
ORDEM DTCOD
DbGoTop()
set relation to str(ME_CODPR,L_P) into PROD

VM_CAMPO:={ Fieldname(07),;	// Tipo
				Fieldname(02),;	// Data
				'str(MOVEST->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,22)',;
				Fieldname(03),;	// Docto
				Fieldname(04),;	// Qtde
				Fieldname(05),;	// Vlr Mov Médio
				FieldName(15);		// Forma
				}
VM_CABE    :={'T','Dt Movto','Produto','Dcto','Qtde.','Vlr.Est.','F'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
set relation to
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4431() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
local GETLIST  := {}
while lastkey()#K_ESC
	VM_CODPR = 0
	VM_DATA  = PARAMETRO->PA_DATA
	VM_DOCTO = 0
	VM_QTDE  = 0
	pb_box(15,20,,,,'Transferecia Normal')
	@16,22 say 'C¢d.Produto....:' get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,77).and.fn_rtunid(VM_CODPR)
	@17,22 say 'Data...........:' get VM_DATA  picture mDT      valid VM_DATA<=PARAMETRO->PA_DATA
	@18,22 say 'Documento......:' get VM_DOCTO picture masc(8)
	@19,22 say 'Qtde.Moviment..:' get VM_QTDE  picture masc(6) valid fn_sdest(-VM_QTDE) when pb_msg('Use quantidade negativa para diminuir o estoque')
	@20,22 say 'Valor Movimento:'
	@21,22 say 'Valor Venda....:'
	read
	VM_VLMOV:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*abs(VM_QTDE)
	if str(round(PROD->PR_QTATU+VM_QTDE,2),15,2)==str(0,15,2)
		VM_VLMOV:=PROD->PR_VLATU
	end
	@20,40 get VM_VLMOV pict mI92 valid VM_VLMOV>0
	@21,40 say transform((PROD->PR_VLVEN*abs(VM_QTDE)),masc(2))
	if lastkey()#K_ESC
		read
	end
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		select('PROD')
		while !RecLock();end
		replace 	PR_VLATU with PR_VLATU+(VM_VLMOV*if(VM_QTDE<0,-1,1)),;
					PR_QTATU with PR_QTATU+VM_QTDE,;
					PR_DTMOV with VM_DATA

		select('MOVEST')
		GrMovEst({	VM_CODPR,;		//	1 Cod Produto
						VM_DATA,;		//	2 Data Movto
						VM_DOCTO,;		//	3 Nr Docto
						VM_QTDE,;		//	4 Qtde
						VM_VLMOV,;		//	5 Vlr Medio
						PROD->PR_VLVEN*abs(VM_QTDE),;		//	6 Vlr Venda
						'T',;				//	7 Tipo Transferencia
						PROD->PR_CTB,;	//	8 Tipo Produto
						'',;				// 9 Serie - despesas
						0,;				//10 Cod Fornec
						0,;				//11 D-Conta contábil Despesa
						0,;				//12 D-Conta contábil Icms
						0,;				//13 Vlr Icms
						.F.,;				//14 Contabilizado ?
						'N'})				//15 P=Producao  //  D=Despesas // N=Normal

	end
	dbrunlock()
	dbcommitall()
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4432() // Saida por Despesas
*-----------------------------------------------------------------------------*
local GETLIST  := {}
while lastkey()#K_ESC
	VM_CODPR := 0
	VM_DATA  := PARAMETRO->PA_DATA
	VM_DOCTO := 0
	VM_QTDE  := 0
	VM_VICMS := 0
	VM_VLMOV := 0

	VM_CTA1  := 0	// Conta despesa
	VM_CTA2  :=41	// Conta Icms
	VM_CTAX  := space(20)

	pb_box(14,20,,,,'Saida por Despesas')
	@15,22 say 'C¢d.Produto....:' get VM_CODPR pict masc(21) valid fn_codpr(@VM_CODPR,77).and.fn_rtunid(VM_CODPR)
	@16,22 say 'Data...........:' get VM_DATA  pict mDT      valid VM_DATA<=PARAMETRO->PA_DATA
	@17,22 say 'Documento......:' get VM_DOCTO pict masc(8)
	@18,22 say 'Qtde.Moviment..:' get VM_QTDE  pict masc(6) valid VM_QTDE>0.and.fn_sdest(-VM_QTDE)
	@19,22 say '(D)Cta Despesa.:' get VM_CTA1  pict mI4     valid fn_ifconta(@VM_CTAX,@VM_CTA1) when pb_msg('Debito-Conta Contabil de Despesa')
	@20,22 say '(C)Cta Icms....:' get VM_CTA2  pict mI4     valid fn_ifconta(@VM_CTAX,@VM_CTA2) when pb_msg('Credito-Conta Contabil estorno ICMS')
	@21,22 say 'Valor Movimento:'
	read
	VM_VLMOV:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*VM_QTDE
	if str(round(PROD->PR_QTATU-VM_QTDE,2),15,2)==str(0,15,2)
		VM_VLMOV:=PROD->PR_VLATU
	end
	VM_VICMS:=VM_VLMOV*PROD->PR_PICMS*(PROD->PR_PTRIB/100)/100
	@21,40                 get VM_VLMOV pict mI92 valid VM_VLMOV >= 0.and.(VM_VICMS:=VM_VLMOV*PROD->PR_PICMS*(PROD->PR_PTRIB/100)/100)>=0
	@21,55 say 'Vlr Icms:' get VM_VICMS pict mI92
	if lastkey()#K_ESC
		read
	end
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		select('PROD')
		while !RecLock();end
		replace 	PR_VLATU with PR_VLATU-VM_VLMOV,;
					PR_QTATU with PR_QTATU-VM_QTDE,;
					PR_DTMOV with VM_DATA

		select('MOVEST')
		GrMovEst({	VM_CODPR,;		//	1 Cod Produto
						VM_DATA,;		//	2 Data Movto
						VM_DOCTO,;		//	3 Nr Docto
						-VM_QTDE,;		//	4 Qtde
						VM_VLMOV,;		//	5 Vlr Medio
						PROD->PR_VLVEN*abs(VM_QTDE),;		//	6 Vlr Venda
						'T',;				//	7 Tipo Transferencia
						PROD->PR_CTB,;	//	8 Tipo Produto
						'DES',;			// 9 Serie - despesas
						0,;				//10 Cod Fornec
						VM_CTA1,;		//11 D-Conta contábil Despesa
						VM_CTA2,;		//12 D-Conta contábil Icms
						VM_VICMS,;		//13 Vlr Icms
						.F.,;				//14 Contabilizado ?
						'D'})				//15 P=Producao  //  D=Despesas
	end
	dbcommitall()
end
DbUnLockAll()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4433() // Saida para Produção
*-----------------------------------------------------------------------------*
local GETLIST  := {}
if PARAMETRO->PA_CONTAB#chr(255)+chr(25)
	alert(';Modulo Contabil nao disponivel;')
	return NIL
end
while lastkey()#K_ESC
	VM_CODPR := 0
	VM_DATA  := PARAMETRO->PA_DATA
	VM_DOCTO := 0
	VM_QTDE  := 0
	VM_VICMS := 0
	VM_VLMOV := 0
	VM_CTA1  := 0	// Conta despesa
	VM_CTA2  := 0	// Conta Icms
	VM_CTAX  := space(20)
	pb_box(14,20,,,,'Transferencia para Producao')
	@15,22 say 'C¢d.Produto....:' get VM_CODPR pict masc(21) valid fn_codpr(@VM_CODPR,77).and.fn_rtunid(VM_CODPR)
	@16,22 say 'Data...........:' get VM_DATA  pict mDT      valid VM_DATA<=PARAMETRO->PA_DATA
	@17,22 say 'Documento......:' get VM_DOCTO pict masc(8)
	@18,22 say 'Qtde.Moviment..:' get VM_QTDE  pict masc(6) valid VM_QTDE>0.and.fn_sdest(-VM_QTDE)
	@19,22 say '(D)Cta Despesa.:' get VM_CTA1  pict mI4     valid fn_ifconta(@VM_CTAX,@VM_CTA1) when pb_msg('Debito-Conta Contabil de Despesa')
	@21,22 say 'Valor Movimento:'
	read
	VM_VLMOV:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*VM_QTDE
	if str(round(PROD->PR_QTATU-VM_QTDE,2),15,2)==str(0,15,2)
		VM_VLMOV:=PROD->PR_VLATU
	end
	@21,40 get VM_VLMOV pict mI92 valid VM_VLMOV >= 0
	@21,55 say 'Vlr Icms:'+transform(VM_VICMS,mD82)
	if lastkey()#K_ESC
		read
	end
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		select('PROD')
		while !RecLock();end
		replace 	PR_VLATU with PR_VLATU-VM_VLMOV,;
					PR_QTATU with PR_QTATU-VM_QTDE,;
					PR_DTMOV with VM_DATA

		select('MOVEST')
		GrMovEst({	VM_CODPR,;		//	1 Cod Produto
						VM_DATA,;		//	2 Data Movto
						VM_DOCTO,;		//	3 Nr Docto
						-VM_QTDE,;		//	4 Qtde
						VM_VLMOV,;		//	5 Vlr Medio
						PROD->PR_VLVEN*abs(VM_QTDE),;		//	6 Vlr Venda
						'T',;				//	7 Tipo Transferencia
						PROD->PR_CTB,;	//	8 Tipo Produto
						'PRD',;			// 9 Serie
						0,;				//10 Cod Fornec
						VM_CTA1,;		//11 D-Conta contábil Despesa
						VM_CTA2,;		//12 D-Conta contábil Icms
						VM_VICMS,;		//13 Vlr Icms
						.F.,;				//14 Contabilizado ?
						'P'})				//15 P=Producao  //  D=Despesas
	end
	dbcommitall()
end
DbUnLockAll()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4434() // Rotina de Impressao
*-----------------------------------------------------------------------------*
local OPC:=alert('Informe Tipo de Listagem ',{'Consumo','Producao'})
if OPC==1 
	CFEP4462('Lista de Itens Consumidos - Ref: ','T1')
elseif OPC==2
	CFEP4462('Lista de Itens Enviados a Producao - Ref: ','T2')
end
return NIL

*-----------------------------------------------------------------------------*
	function CFEP4435() // Ajuste
*-----------------------------------------------------------------------------*
ORDEM DTPROT // só transferencias
DbGoTop()
while !eof()
	if MOVEST->ME_VLEST<0.and.reclock()
		replace MOVEST->ME_VLEST with abs(MOVEST->ME_VLEST)
		dbrunlock()
	end
	skip
end
Alert('Processado')
ORDEM DTCOD
DbGoTop()
Return NIL
