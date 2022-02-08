*-----------------------------------------------------------------------------*
 function ORDP2200()	//	SAIDAS DE PRODUTOS..												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->PARAMETRO',;
				'C->GRUPOS',;
				'C->CLIOBS',;
				'C->CODTR',;
				'C->CLIENTE',;
				'R->MOVEST',;
				'C->ALIQUOTAS',;
				'R->PROD',;
				'C->FISACOF',;
				'C->PARAMORD',;
				'C->ORDEM',;
				'C->MECMAQ',;
				'C->ATIVIDAD',;
				'C->EQUIDES',;
				'C->MOVORDEM'})
	return NIL
end

PROD->(dbsetorder(2))
set relation to str(IT_CODPR,L_P) into PROD

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_CAMPO[4]='pb_zer(IT_CODPR,'+str(L_P,2)+')+chr(45)+left(PROD->PR_DESCR,20)'

VM_MARKDEL = .F.

pb_dbedit1('ORDP220','IncluiExclui')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2', {masc(19),masc(11),masc(7),  masc(01),masc(11),masc(06),   masc(02),  masc(2)},;
														{'Ordem',     'Tp','Dt Lcto','Produto','Ativid','Qtdade','Vlr Venda','Vlr US$'})
pb_compac(VM_MARKDEL)
dbskip(0)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function ORDP2201()	//	Rotina de Inclus„o
*-----------------------------------------------------------------------------*
local GETLIST:={}
local X
local X1
local LCONT:=.T.
for X:=1 to fcount()
	X1:='VM'+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next

while lastkey()#K_ESC
	VM_DTLCT:=PARAMETRO->PA_DATA
	VM_VLRME:=0
	pb_box(14,10,,,,'Lan‡amentos')
	@15,12 say padr('Nr Ordem',15,'.')       get VM_CODOR pict masc(19) valid if(empty(PARAMORD->PA_DESCR3),;
															fn_codigo(@VM_CODOR,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODOR,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}),;
															fn_ordem(@VM_CODOR,.T.))
	@16,12 say padr('Dt.Lancto',15,'.')			get VM_DTLCT	pict masc(7)
	@17,12 say padr('Atividade',15,'.')			get VM_CODAT	pict masc(01) valid fn_codigo(@VM_CODAT,{'ATIVIDAD',{||ATIVIDAD->(dbseek(str(VM_CODAT,2)))},{||ORDP1400T(.T.)},{2,1}})
	@18,12 say padr('C¢d.Produto',15,'.')     get VM_CODPR	pict masc(21) valid fn_codpr(@VM_CODPR).and.fn_rtunid(VM_CODPR).and.if(PROD->PR_VLVEN>0,.T.,alert('PRODUTO COM VALOR DE VENDA ZERADO')==-99).and.PROD->(RecLock())
	@19,12 say padr('Qtdade',15,'.')          get VM_QTD		pict masc(06) valid fn_sdest(-VM_QTD) // SAIDA
	@20,12 say padr('Vlr Medio Mvto',15,'.')  get VM_VLRME	pict masc(05) 									when (VM_VLRME:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*abs(VM_QTD))<0.and.pb_msg('Valor de Venda R$'+transform(PROD->PR_VLVEN,mD102))
	@21,12 say padr('Vlr Venda Total',15,'.') get VM_VLRRE	pict masc(05) valid VM_VLRRE>0 			when (VM_VLRRE:=PROD->PR_VLVEN*abs(VM_QTD))>=0.00
	read
//	VM_VLMOV:=pb_divzero(PROD->PR_VLATU,PROD->PR_QTATU)*abs(VM_QTD)
//	if round(PROD->PR_QTATU-VM_QTD,2)=0.00
//		VM_VLMOV:=PROD->PR_VLATU
//	end
	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
//		if PROD->PR_CTB#99.or.PROD->PR_CTB#97
//			PROD->PR_VLATU:=PROD->PR_VLATU-VM_VLMOV
//			PROD->PR_QTATU:=PROD->PR_QTATU-VM_QTD
//		end
//		PROD->PR_DTMOV:=VM_DTLCT
		if empty(PARAMORD->PA_DESCR3)
			select('ORDEM')
			if !dbseek(str(VM_CODOR,6))
				AddRec()
				ORDEM->OR_CODOR:=VM_CODOR
				ORDEM->OR_CODCL:=VM_CODOR
				ORDEM->OR_DTENT:=PARAMETRO->PA_DATA
				ORDEM->OR_CODED:=pb_zer(VM_CODOR,12)
			end
			if reclock()
				ORDEM->OR_FLAG :=.F.
			end
			select('EQUIDES')
			if !dbseek(pb_zer(VM_CODOR,12))
				AddRec()
				EQUIDES->ED_CODIG:=pb_zer(VM_CODOR,12)
				EQUIDES->ED_DESCR:=CLIENTE->CL_RAZAO
				EQUIDES->ED_DTULM:=PARAMETRO->PA_DATA
			end
		end
		select('MOVORDEM')
		if AddRec()
			MOVORDEM->IT_CODOR:=VM_CODOR
			MOVORDEM->IT_DTLCT:=VM_DTLCT
			MOVORDEM->IT_CODPR:=VM_CODPR
			MOVORDEM->IT_CODAT:=VM_CODAT
			MOVORDEM->IT_TIPO :=1	// TIPO 1=PRODUTOS
			MOVORDEM->IT_QTD  :=VM_QTD
			MOVORDEM->IT_VLRRE:=round(VM_VLRRE,2) // TOTAL
			MOVORDEM->IT_VLRUS:=round(pb_divzero(VM_VLRRE,PARAMETRO->PA_VALOR),2)
		end
		dbcommitall()
	end
	dbunlockall()
end
return NIL

*-----------------------------------------------------------------------------*
	function ORDP2202()	//	Rotina de Exlusao
*-----------------------------------------------------------------------------*
if ORDEM->(dbseek(str(MOVORDEM->IT_CODOR,6)))
	if ORDEM->OR_FLAG
		alert('Ordem ja Fechada')
		return NIL
	end
end
if pb_sn('Excluir Produto '+pb_zer(IT_CODPR)+chr(45)+PROD->PR_DESCR).and.RecLock()
//	if PROD->PR_CTB#99.or.PROD->PR_CTB#97
//		if PROD->(reclock())
//			PROD->PR_VLATU:=PROD->PR_VLATU+MOVORDEM->IT_VLRRE
//			PROD->PR_QTATU:=PROD->PR_QTATU+MOVORDEM->IT_QTD
//		end
//	end
//	GravMovEst({	MOVORDEM->IT_CODPR,;	//	1
//						date(),;					//	2
//						MOVORDEM->IT_CODOR,;	//	3
//						MOVORDEM->IT_QTD,;	//	4
//						MOVORDEM->IT_VLRRE,;	//	5
//						MOVORDEM->IT_VLRRE,;	// 6-VLR VENDA
//						'E',;						//	7-Entrada Estoque
//						'OS',;					//	8
//						0})						//	9-Fornecedor
	fn_elimi()
end
return NIL
*--------------------------------------------------EOF---------------------------*
