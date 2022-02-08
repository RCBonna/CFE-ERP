//-----------------------------------------------------------------------------*
  function CFEP4440()	//	Movimetacoes do estoque - IMPLANTACAO
//-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !xxsenha(ProcName(),'Estoque - Implantacao')
	dbcloseall()
	return NIL
end
setcolor(VM_CORPAD)

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
pb_dbedit1('CFEP444','ImplanEXCLUIEspeci')

select('PROD')
ORDEM CODIGO

select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

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

//-----------------------------------------------------------------------------*
  function CFEP4441() && Rotina de Inclus„o
//-----------------------------------------------------------------------------*
local GETLIST  := {}
alert('Estes lancamentos irao sobrepor o Estoque Atual')
while lastkey()#K_ESC
	dbunlockall()
	VM_CODPR := 0
	VM_DATA  := PARAMETRO->PA_DATA
	VM_DOCTO := 0
	VM_QTDE  := 0
	VM_VLVEN := 0
	VM_VLMED := 0
	VM_VLCOM := 0
	pb_box(14,25,,,,'Implantacao Estoque')
	@15,26 say 'C¢digo do Produto..:' get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,78).and.PROD->(reclock())
	@16,26 say 'Data...............:' get VM_DATA  picture masc(07) valid VM_DATA<=PARAMETRO->PA_DATA
	@17,26 say 'Documento..........:' get VM_DOCTO picture masc(09)
	@18,26 say 'Qtde.Atual.........:' get VM_QTDE  picture masc(05) valid VM_QTDE >=0
	@19,26 say 'Vlr.Unit rio.......:' get VM_VLCOM picture masc(25) valid VM_VLCOM>=0 when (VM_VLCOM:=PROD->PR_VLCOM)>=0.and.VM_QTDE>0
	@20,26 say 'Vlr.Estoque(TOTAL).:' get VM_VLMED picture masc(05) valid fn_vlven(@VM_VLVEN,(VM_VLMED/VM_QTDE),VM_CODPR,0,0,0) when (VM_VLMED:=VM_QTDE*VM_VLCOM)>=0.and.VM_QTDE>0
	@21,26 say 'Vlr Venda(Unitario):' get VM_VLVEN picture masc(05) valid VM_VLVEN>0
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		select('PROD')
		dbseek(str(VM_CODPR,L_P))
		if str(VM_QTDE,15,2)==str(0,15,2)
			VM_VLCOM:=0
			VM_VLMED:=0
		end
		replace 	PR_QTATU with VM_QTDE,;
					PR_VLATU with VM_VLMED,;
					PR_VLVEN with VM_VLVEN,;
					PR_DTMOV with VM_DATA,;
					PR_DTCOM with VM_DATA,;
					PR_VLCOM with VM_VLCOM
		select('MOVEST')
		GrMovEst({	VM_CODPR,;		//	1 Cod Produto
						VM_DATA,;		//	2 Data Movto
						VM_DOCTO,;		//	3 Nr Docto
						VM_QTDE,;		//	4 Qtde
						VM_VLMED,;		//	5 Vlr Medio
						PROD->PR_VLVEN*abs(VM_QTDE),;		//	6 Vlr Venda
						'I',;				//	7 Tipo Implantação
						PROD->PR_CTB,;	//	8 Tipo Produto
						'',;				// 9 Serie - despesas
						0,;				//10 Cod Fornec
						0,;				//11 D-Conta contábil Despesa
						0,;				//12 D-Conta contábil Icms
						0,;				//13 Vlr Icms
						.F.,;				//14 Contabilizado ?
						'N'})				//15 P=Producao  //  D=Despesas // N=Normal
	end
end
return NIL

//-----------------------------------------------------------------------------*
  function CFEP4442() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
if MOVEST->ME_TIPO=='I'
	if reclock().and.pb_sn('Exclui implanta‡„o :'+pb_zer(ME_CODPR,L_P)+'-'+trim(PROD->PR_DESCR)+'?')
		if PROD->(reclock())
			replace  PROD->PR_QTATU with 0,;
						PROD->PR_VLATU with 0
			dbdelete()
			dbskip()
			if eof()
				DbGoTop()
			end
			VM_MARKDEL:=.T.
		end
	end
else
	alert('So excluir movimentacao do tipo <I> implantacao')
end
dbUnLockAll()
return NIL

//-----------------------------------------------------------------------------*
  function CFEP4443() // Rotina de impressao das exclusoes de implantacao
//-----------------------------------------------------------------------------*
set relation to
select('MOVEST')
dbsetorder(1)
select('PROD')
dbsetorder(3)
REL:='Produtos NAO Implantados'
LAR:=80
PAG:=0
if pb_ligaimp(C15CPP)
	DbGoTop()
	while !eof()
		PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),REL,PAG,'CFEP4443C',LAR)
		FLAG:=.T.
		select('MOVEST')
		dbseek(str(PROD->PR_CODPR,L_P),.T.)
		while !eof().and.ME_CODPR==PROD->PR_CODPR
			if ME_TIPO=='I'
				FLAG:=.F.
			end
			dbskip()
		end
		select('PROD')
		if FLAG
			? pb_zer(PROD->PR_CODPR,L_P)+'-'
			??PROD->PR_DESCR
			??STR(PROD->PR_QTATU,9,2)
			??STR(PROD->PR_VLATU,12,2)
		end
		pb_brake()
	end
	?replicate('-',LAR)
	?time()
	pb_deslimp()
end
select('PROD')
ORDEM CODIGO
select('MOVEST')
ORDEM DTCOD
DbGoTop()
set relation to str(MOVEST->ME_CODPR,L_P) into PROD
DbGoTop()
return NIL

//-----------------------------------------------------------------------------*
  function CFEP4443C() // Rotina de impressao das exclusoes de implantacao
//-----------------------------------------------------------------------------*
?padr('Codigo',L_P+1)+padr('Descricao',41)+'Qtda Atual   Valor Atual'
?replicate('-',LAR)
return NIL
//----------------------------------EOF----------------------------------------*

