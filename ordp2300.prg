*-----------------------------------------------------------------------------*
function ORDP2300()	//	Digita Horas														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->PARAMETRO',;
				'C->CLIENTE',;
				'C->MOVEST',;
				'C->PARAMORD',;
				'C->EQUIDES',;
				'C->MECMAQ',;
				'C->ORDEM',;
				'C->CLIPRECO',;
				'C->ATIVIDAD',;
				'C->MOVORDEM'})
	return NIL
end
dbsetorder(2)
set relation to str(IT_CODPR,2) into MECMAQ
DbGoTop()
VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_CAMPO[4]:='pb_zer(IT_CODPR,2)+chr(45)+left(MECMAQ->MM_NOME,15)'

VM_MARKDEL := .F.

pb_dbedit1('ORDP230','IncluiAlteraExclui')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2', {masc(19),masc(11),  masc(7),                    masc(1), masc(11),  masc(6),    masc(25),masc(25)},;
														{'Ordem',     'Tp',  'Dt Lcto',trim(PARAMORD->PA_DESCR1),   'Ativ', 'Qtdade','Vlr Movto','Vlr US$'})
pb_compac(VM_MARKDEL)
dbcloseall()
return NIL

function ORDP2301(FL)	//	Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	ORDP230T(.T.)
end
return NIL

function ORDP2302()	//	Rotina de Alteracao
if reclock()
	ORDP230T(.F.)
end
return NIL

function ORDP230T(FL)	//	Rotina de digitacao
local GETLIST:={},X,X1
for X :=1 to fcount()
	X1 :='VM'+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next

	VM_VLRUN:=0
	if FL
		VM_DTLCT:=PARAMETRO->PA_DATA
	else
		VM_VLRUN:=round(pb_divzero(VM_VLRRE,VM_QTD),2)
	end
	pb_box(13,10,,,,'Lancamentos de Horas')
	@14,12 say padr('Nr Ordem',15,'.')                 get VM_CODOR pict masc(19) valid fn_ordem(@VM_CODOR,.T.)
	@15,12 say padr('Dt.Lancto',15,'.')                get VM_DTLCT pict masc(07)
	@16,12 say padr('C¢d.'+trim(PARAMORD->PA_DESCR1),15,'.') get VM_CODPR pict masc(11) valid fn_codigo(@VM_CODPR,{'MECMAQ',{||MECMAQ->(dbseek(str(VM_CODPR,2)))},{||ORDP1200T(.T.)},{2,1}})
	@17,12 say padr('Atividade',15,'.')                get VM_CODAT pict masc(01) valid fn_codigo(@VM_CODAT,{'ATIVIDAD',{||ATIVIDAD->(dbseek(str(VM_CODAT,2)))},{||ORDP1400T(.T.)},{2,1}})
	@18,12 say padr('Qtdade',15,'.')                   get VM_QTD   pict masc(06) valid VM_QTD>0
	@19,12 say padr('Vlr Unitario',15,'.')             get VM_VLRUN pict masc(06) valid VM_VLRUN>=0 when FL.and.(VM_VLRUN:=fn_vhora(ORDEM->OR_CODCL,VM_CODAT))>=0
	@20,12 say padr('Vlr Mvto',15,'.')
//	@21,12 say padr('Vlr US$',15,'.')
	read

	VM_VLRRE:=round(VM_VLRUN*VM_QTD,2)
	@20,33 say transform(VM_VLRRE,masc(25))
//	@21,33 say transform(round(pb_divzero(VM_VLRRE,PARAMETRO->PA_VALOR),2),masc(25))

	setcolor(VM_CORPAD)
	if if(lastkey()#K_ESC,pb_sn(),.F.)
		select('MOVORDEM')
		if FL
			AddRec()
		end
		MOVORDEM->IT_CODOR:=VM_CODOR
		MOVORDEM->IT_DTLCT:=VM_DTLCT
		MOVORDEM->IT_CODPR:=VM_CODPR
		MOVORDEM->IT_CODAT:=VM_CODAT
		MOVORDEM->IT_TIPO :=2		// TIPO HORAS
		MOVORDEM->IT_QTD  :=VM_QTD
		MOVORDEM->IT_VLRRE:=VM_VLRRE
		MOVORDEM->IT_VLRUS:=round(pb_divzero(VM_VLRRE,PARAMETRO->PA_VALOR),2)
	end
return NIL

*----------------------------------------------------------------------------*
 static function FN_VHORA(P1,P2)
*----------------------------------------------------------------------------*
local RT:=ATIVIDAD->AT_VLRHR
salvabd(SALVA)
select('CLIPRECO')
if dbseek(str(P1,5)+str(P2,2))
	RT:=PR_VLRHR
end
salvabd(RESTAURA)
return RT

*-----------------------------------------------------------------------------*
function ORDP2303()	//	Rotina de Pesquisa
if ORDEM->(dbseek(str(MOVORDEM->IT_CODOR,6)))
	if ORDEM->OR_FLAG
		alert('Ordem ja Fechada')
		return NIL
	end
end
if pb_sn('Excluir Lcto Hr :'+&(VM_CAMPO[4])+transform(IT_QTD,masc(6))+' ?').and.reclock()
	fn_elimi()
end
return NIL
*--------------------------------------------EOF--------------------------------*
