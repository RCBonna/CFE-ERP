*-----------------------------------------------------------------------------*
 function CFEP4460()	//	Movimetacoes do estoque - SAIDA CONSUMO
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'R->CODTR',;
				'R->ALIQUOTAS',;
				'C->XOBS',;
				'C->GRUPOS',;
				'C->MOVEST',;
				'C->FISACOF',;
				'C->SALDOS',;
				'C->UNIDADE',;
				'C->PROD'})
	return NIL
end
pb_dbedit1('CFEP446','Saida Lista ')

select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

select('PROD')
ORDEM CODIGO

select('MOVEST')
ORDEM DTCOD
DbGoTop()
set relation to str(ME_CODPR,L_P) into PROD

VM_CAMPO:={ fieldname(07),;	// Tipo
				fieldname(02),;	// Data
				'str(MOVEST->ME_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,22)',;
				fieldname(03),;	// Docto
				fieldname(04),;	// Qtde
				fieldname(05),;	// Vlr Mov Médio
				FieldName(15);		// Forma
				}
VM_CABE    :={'T','Dt Movto','Produto','Dcto','Qtde.','Vlr.Est.','F'}
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
set relation to
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4461()
*-----------------------------------------------------------------------------*
local GETLIST  := {}
VM_DATA = PARAMETRO->PA_DATA
while lastkey()#K_ESC
	DbUnLockAll()
	VM_CODPR := 0
	VM_DOCTO := 0
	VM_QTDE  := 0
	pb_box(16,20,,,,'Saida Consumo')
	@17,22 say 'C¢d.Produto.....:' get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,77).and.fn_rtunid(VM_CODPR)
	@18,22 say 'Data............:' get VM_DATA  picture masc(7) valid VM_DATA<=PARAMETRO->PA_DATA
	@19,22 say 'Documento.......:' get VM_DOCTO picture masc(8)
	@20,22 say 'Qtde.Movimento..:' get VM_QTDE  picture masc(6) valid VM_QTDE>0.and.fn_sdest(-VM_QTDE)
	@21,22 say 'Vlr.Un.Movimento:'
	read
	VM_VLMOV:=round(pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*VM_QTDE,2)
	if str(round(PROD->PR_QTATU-VM_QTDE,2),15,3)==str(0,15,3)
		VM_VLMOV:=PROD->PR_VLATU
	end
	@21,41 say transform(VM_VLMOV,masc(2))
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn().and.PROD->(reclock()),.F.)
		select('PROD')
		if PR_CTB#99.or.PR_CTB#97
			replace 	PR_VLATU with PR_VLATU-VM_VLMOV,;
						PR_QTATU with PR_QTATU-VM_QTDE
		end
		replace PR_DTMOV with VM_DATA
		select('MOVEST')
		GrMovEst({	VM_CODPR,;		//	1 Cod Produto
						VM_DATA,;		//	2 Data Movto
						VM_DOCTO,;		//	3 Nr Docto
						VM_QTDE,;		//	4 Qtde
						VM_VLMOV,;		//	5 Vlr Medio
						PROD->PR_VLVEN*VM_QTDE,;		//	6 Vlr Venda
						'S',;				//	7 Tipo Transferencia
						PROD->PR_CTB,;	//	8 Tipo Produto
						'',;				// 9 Serie - despesas
						0,;				//10 Cod Fornec
						0,;				//11 D-Conta contábil Despesa
						0,;				//12 D-Conta contábil Icms
						0,;				//13 Vlr Icms
						.F.,;				//14 Contabilizado ?
						'N'})				//15 P=Producao  //  D=Despesas // N=Normal
	end
	dbskip(0)
	dbcommitall()
end
return NIL

*-----------------------------------------------------------------------------------
  function CFEP4462(VM_REL,TipoMov) //.... Lista
*-----------------------------------------------------------------------------------
local Saldos:=array(2,3)
local X
local PercImcs
local LinhProd
local Pag  :=0
local LinhaObs:={space(130),space(130),space(130)}
local TipoMov1:=TipoMov
local VM_DATA :={bom(PARAMETRO->PA_DATA),PARAMETRO->PA_DATA}
local Flag_Imp:=.T.
local OrdAnt  :=IndexOrd()

if VM_REL==Nil
	VM_REL :=padr('Estoque - Saida Consumo - Ref: ',30)
end

if TipoMov==Nil
	TipoMov:='S' 
else
	TipoMov:=left(TipoMov,1)
end

select('PROD')
dbgobottom()
private VM_PRFIM:=PR_CODPR
DbGoTop()
private VM_PRINI:=PR_CODPR
private VM_LAR  :=132

	select('MOVEST')
	ORDEM TPCOD

X:=13
pb_box(X++,1,,,,'Selecione')
@X++,02 say 'Relatorio........:' get VM_REL      pict mXXX+'S55'
X++
@X,  02 say 'Produto Inicial..:' get VM_PRINI    pict masc(21)
@X++,55 say         'Final....:' get VM_PRFIM    pict masc(21) valid VM_PRFIM>=VM_PRINI
@X  ,02 say 'Data Inicial.....:' get VM_DATA[1]  pict mDT
@X++,55 say      'Final.......:' get VM_DATA[2]  pict mDT valid VM_DATA[2]>=VM_DATA[1]
@X++,02 say 'Linha Observ:1...:' get LinhaObs[1] pict mUUU+'S55'
@X++,02 say 'Linha Observ:2...:' get LinhaObs[2] pict mUUU+'S55'
@X++,02 say 'Linha Observ:3...:' get LinhaObs[3] pict mUUU+'S55'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_REL     :=trim(VM_REL)+' '+dtoc(VM_DATA[1])+' a '+dtoc(VM_DATA[2])
	SALDOS[1,1]:=0
	SALDOS[1,2]:=0
	SALDOS[1,3]:=0
	dbseek(TipoMov+str(VM_PRINI,L_P),.T.)
	while !eof().and.ME_TIPO==TipoMov.and.ME_CODPR<=VM_PRFIM
		VM_CODPR:=ME_CODPR
		dbseek(TipoMov+str(VM_CODPR,L_P)+dtos(VM_DATA[1]),.T.)
		PercIcms:=PROD->PR_PICMS*(PROD->PR_PTRIB/100)
		LinhProd:=padr(pb_zer(VM_CODPR,L_P)+' - '+PROD->PR_DESCR,51)+space(1)+PROD->PR_UND
		SALDOS[2,1]:=0
		SALDOS[2,2]:=0
		SALDOS[2,3]:=0
		while !eof().and.ME_TIPO==TipoMov.and.MOVEST->ME_CODPR==VM_CODPR.and.MOVEST->ME_DATA<=VM_DATA[2]
			Flag_Imp:=.T.
			if TipoMov1=='T1'
				Flag_Imp:=(ME_FORMA=='D')
			end
			if TipoMov1=='T2'
				Flag_Imp:=(ME_FORMA=='P')
			end
			if Flag_Imp
				SALDOS[2,1]+=MOVEST->ME_QTD
				SALDOS[2,2]+=abs(MOVEST->ME_VLEST)
				SALDOS[2,3]+=abs(MOVEST->ME_VICMS)
			end
			pb_brake()
		end
		
		// MUDEI DE PRODUTO OU PASSOU DA DATA FINAL

		if SALDOS[2,1]+SALDOS[2,2]+SALDOS[2,3]#0
			Pag  := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,Pag,'CFEP4462A',VM_LAR)
			?LinhProd
			?? transform(SALDOS[2,1],mD112)+space(3)
			?? transform(SALDOS[2,2]*if(SALDOS[2,1]<0,-1,+1),mD112)+space(4)
			?? transform(SALDOS[2,3],mD112)+space(4)
			?? transform(PercIcms,mI62)
			SALDOS[1,1]+=SALDOS[2,1]
			SALDOS[1,2]+=SALDOS[2,2]*if(SALDOS[2,1]<0,-1,+1)
			SALDOS[1,3]+=SALDOS[2,3]
		end
		if !eof()
			dbseek(TipoMov+str(VM_CODPR,L_P)+'99999999',.T.)
			if ME_TIPO#TipoMov
				dbgobottom()
				skip
			end
		end
	end
	if str(SALDOS[1,1]+SALDOS[1,2]+SALDOS[1,3],15,2)#str(0,15,2)
		? replicate('-',VM_LAR)
		?padc('Total Geral',72,'.')
		?? transform(SALDOS[1,2],mD112)+space(4)
		?? transform(SALDOS[1,3],mD112)+space(4)
	end
	?
	if !empty(LinhaObs[1])
		? LinhaObs[1]
	end
	if !empty(LinhaObs[2])
		? LinhaObs[2]
	end
	if !empty(LinhaObs[3])
		? LinhaObs[3]
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbSetOrder(OrdAnt)
DbGoTop()
return NIL


//-----------------------------------------------------------------------------
   function CFEP4462A() //
//-----------------------------------------------------------------------------
?  padr('Produto',59)+'Quantidade    Valor Medio      Valor Icms     %Icms'
?  replicate('-',VM_LAR)
return NIL
//-----------------------------------------------------------------------------
