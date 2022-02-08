*-----------------------------------------------------------------------------*
 function ORDP2100()	//	Abre/Altera OS/OP..												*
*-----------------------------------------------------------------------------*

#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'C->CLIENTE',;
				'C->PARALINH',;
				'C->CLIOBS',;
				'C->PARAMORD',;
				'C->MOVORDEM',;
				'C->MECMAQ',;
				'C->EQUIDES',;
				'C->ORDEM'})
	return NIL
end

pb_tela()
pb_lin4(PARAMORD->PA_DESCR3,ProcName())

if empty(PARAMORD->PA_DESCR1)
	alert('M¢dulo n„o implantando corretamente, consulte pessoal de Suporte.')
	pb_dbedit1('ORDP210','')
else
	pb_dbedit1('ORDP210')
end

if pb_sn('Deseja ver somente '+PARAMORD->PA_DESCR3+' Abertas ?;Nao = Todas')
	set filter to !OR_FLAG
	DbGoTop()
end

set relation   to str(OR_CODCL,5) into CLIENTE,;
					to OR_CODED into EQUIDES

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_CAMPO[1]='pb_zer(OR_CODOR,6)+chr(45)+if(OR_FLAG,"F","A")'
VM_CAMPO[2]='pb_zer(OR_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)'
VM_CAMPO[3]='OR_CODED+chr(45)+left(EQUIDES->ED_DESCR,25)'
VM_CAMPO[7]='if(OR_FLAG,"Fechada","Aberta ")'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
					{mI6    ,  mXXX   ,                 mXXX   ,      mUUU,     mDT,     mDT,      mXXX,     mI61,   mI2,      mI122,    mI122,    mI122,      mI122,  mUUU,       mI6, mXXX},;
					{'Ordem','Cliente',trim(PARAMORD->PA_DESCR2),'NrSolCli','DtEntr','DtSaid','Situa‡„o','Qtdade','Parc','Vlr Pecas','Vlr MDO','Vlr Desc','Vlr Acres','Ser','Nr Duplic','OBS'})
set filter to
// dbcommitall()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function ORDP2101()	//	Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	ORDP2100T( .T.)
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2102()	//	Rotina de Alteracao
if reclock()
	ORDP2100T(.F.)
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2100T( VM_FL )
local GETLIST:={},X,X1,OBS:=array(5),LCONT:=.T.
if !VM_FL.and.OR_FLAG
	beeperro()
	pb_msg('Ordem Servi‡o/Produ‡„o fechada.',15,.T.)
	return NIL
end

for  X:=1 to fcount()
	 X1:='V'+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
if VM_FL
	V_CODOR:=PARAMORD->PA_SEQ+1
	V_DTENT:=date()
	V_DTSAI:=date()+7
end
for X=1 to 5
	OBS[X]=substr(V_OBS,X*60-59,60)
end
pb_box(07,10,,,,trim(PARAMORD->PA_DESCR3))
@08,12 say padr('Nr Ordem',15,'.')      get V_CODOR pict masc(19) valid V_CODOR>0.and.pb_ifcod2(str(V_CODOR,6),NIL,.F.,1) when VM_FL
@09,12 say padr('C¢d.Cliente',15,'.')   get V_CODCL pict masc(04) valid fn_codigo(@V_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(V_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@10,12 say padr(trim(PARAMORD->PA_DESCR2),15,'.');
													 get V_CODED pict    mUUU valid fn_codigo(@V_CODED,{'EQUIDES',{||EQUIDES->(dbseek(V_CODED))},{||ORDP1300T(.T.)},{2,1}}) when !empty(PARAMORD->PA_DESCR2)
@11,12 say padr('Nr.Solic.Cliente',15,'.') get V_NRCLI pict mUUU
if PARAMORD->PA_TIPO=='P'
	@12,12 say padr('Quantidade',15,'.') get V_QUANT pict mI61 valid V_QUANT > 0
end
@13,12 say padr('O.B.S./1',15,'.')      get OBS[1]  pict masc(1)+'S51'
@14,12 say padr('O.B.S./2',15,'.')      get OBS[2]  pict masc(1)+'S51'
@15,12 say padr('O.B.S./3',15,'.')      get OBS[3]  pict masc(1)+'S51'
@16,12 say padr('O.B.S./4',15,'.')      get OBS[4]  pict masc(1)+'S51'
@17,12 say padr('O.B.S./5',15,'.')      get OBS[5]  pict masc(1)+'S51'
@18,12 say padr('Dt.Entrada',15,'.')    get V_DTENT pict mDT
@19,12 say padr('Dt.Saida Prev',15,'.') get V_DTSAI pict mDT   valid V_DTSAI>=V_DTENT
@20,12 say padr('Valor ICMS',15,'.')    get V_VICMS pict mI102
@21,12 say padr('Valor IPI',15,'.')     get V_VIPI  pict mI102
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
		if PARAMORD->(reclock())
			replace PARAMORD->PA_SEQ with V_CODOR
		end
	end
	if LCONT
		V_OBS:=''
		for X=1 to 5
			V_OBS+=OBS[X]
		end
		for X=1 to fcount()
			X1='V'+substr(fieldname(X),3)
			replace &(fieldname(X)) with &X1
		next
	
		// dbcommitall()
		if pb_sn('Deseja imprimir Comprovante Agora ?')
			if PARAMORD->PA_TIPO=='E'
				ORDP2105E()
			elseif PARAMORD->PA_TIPO=='C'
				ORDP2105C()
			end
		end
	end
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2103()	//	Rotina de Pesquisa
local ORD:=alert('Selecione Ordem...',{'C¢digo','Cliente'},'R/W')
if ORD>0
	dbsetorder(ORD)
	PESQ(indexord())
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP2104()	//	Rotina de Exclusao
local ORD:=VM_CAMPO[2]
if pb_sn('Excluir '+trim(PARAMORD->PA_DESCR3)+':'+pb_zer(OR_CODOR,6)+' '+&(ORD)).AND.reclock()
	salvabd(SALVA)
	select('MOVORDEM')
	dbseek(str(ORDEM->OR_CODOR,6),.T.)
	salvabd(RESTAURA)
	if ORDEM->OR_CODOR#MOVORDEM->IT_CODOR
		fn_elimi()
	else
		beeperro()
		pb_msg('Ordem n„o deve ser eliminada, exitem dados digitados.',3,.T.)
	end
end
return NIL
