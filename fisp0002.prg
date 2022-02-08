*-----------------------------------------------------------------------------*
function FISP0002()	// Edita Registro de Apuracao
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'C->PARAMETRO','R->NATOP',	'E->FISPARA',	'E->FISRAPU'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
set relation to str(val((RA_CODOPE+'00')),7) into NATOP
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)
VM_CAMPO[2]:='RA_CODOPE+chr(45)+NATOP->NO_DESCR'
pb_dbedit1('FISP0002')  // TELA
dbedit(06,01,maxrow()-3,maxcol()-1,;
		VM_CAMPO,;
		'PB_DBEDIT2',;
		{    mPER,          mXXX,           mD132,       mD132,          mD132,          mD132,         mD132},;
		{'Period','Cod.Operacao','Valor Contabil','Valor Base','Valor Imposto','Valor Isentas','Valor Outras'})
dbcloseall()
return NIL

function FISP00021() // inclusoes
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FISP000T(.T.) // tela
	
end
return NIL

function FISP00022() // Alteracos
	FISP000T(.F.) // tela
return NIL

function FISP000T(VM_FL) // tela
local GETLIST := {},X,X1
for X:=1 to fcount()
	X1:="VM"+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
if VM_FL
	VM_PERIOD:=left(dtos(PARAMETRO->PA_DATA),6)
end
VM_CODOPE:=val(VM_CODOPE+'00')
pb_box(10,00,,,,'Livro Registro Apuracao')
@11,02 say 'Periodo.........:' get VM_PERIOD pict mPER  valid fn_period(VM_PERIOD) when VM_FL
@12,02 say 'Cod.Operacao....:' get VM_CODOPE pict mNAT  valid fn_codigo(@VM_CODOPE,{'NATOP',{||NATOP->(dbseek(str(VM_CODOPE,7)))},{||CFEPNATT(.T.)},{2,1,3}}).and.pb_ifcod2(VM_PERIOD+left(str(VM_CODOPE,7),5),NIL,.F.,1) when VM_FL
@14,02 say 'Vlr Contabil....:' get VM_VLRCTB pict mI122 valid VM_VLRCTB>=0
@15,02 say 'Vlr Base-ICMS...:' get VM_VLRBAS pict mI122 valid VM_VLRBAS>=0
@16,02 say 'Vlr Imposto-ICMS:' get VM_VLRIMP pict mI122 valid VM_VLRIMP>=0
@17,02 say 'Vlr Isentas.....:' get VM_VLRISE pict mI122 valid VM_VLRISE>=0
@18,02 say 'Vlr Outros......:' get VM_VLROUT pict mI122 valid VM_VLROUT>=0
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		AddRec()
	end
	VM_CODOPE:=left(str(VM_CODOPE,7),5)
	for X:=1 to fcount()
		X1:="VM"+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
end
return NIL

function FISP00023() // pesquisa
local CHAVE:=RA_PERIOD
pb_box(18,30,,,,'Selecione Periodo')
@20,34 get CHAVE pict mPER
read
dbseek(CHAVE,.T.)
return NIL

function FISP00024() // exclusao
if pb_sn('Excluir lancamento de : '+RA_PERIOD+' - Cod Oper: '+RA_CODOPE)
	dbdelete()
	dbskip()
	if eof()
		DbGoTop()
	end
end
return NIL

function FISP00025() // lista

return NIL

function FN_PERIOD(P1)
local RT:=.T.
if val(left(P1,4))<1990.or.val(left(P1,4))>2100.or.val(right(P1,2))<1.or.val(right(P1,2))>12
	alert('Periodo informado : '+transform(P1,mPER)+';I N V A L I D O')
	RT:=.F.
end
return RT
