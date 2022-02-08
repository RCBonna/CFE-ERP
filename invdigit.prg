*-----------------------------------------------------------------------------*
function INVDIGIT(P1)	//	Digitacao Inventario
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'hbsix.ch'

local ArqTemp
private TipoMov:=if(P1==1,'I','P')
if !abre({	'C->PROD',;
				'C->GRUPOS',;
				'E->INVENT'})
	return NIL
end
pb_tela()

ordem CODIGO
if TipoMov=='P'
	ordem CODIGOP
end
dbgobottom()
	
VM_CODIN1:=IN_CODIN + 1
VM_SEQ1  :=1
SALVACOR
pb_box(5,0,7,79)
pb_lin4(_MSG_,ProcName())
if TipoMov=='I'
	@06,02 say 'Codigo Invetario:' get VM_CODIN1 pict mI4
else
	@06,02 say 'Codigo Pedido...:' get VM_CODIN1 pict mI4
end
if TipoMov=='I'
	@06,25 say '/'    get VM_SEQ1   pict mI2
end
read
RESTAURACOR
if lastkey()#K_ESC
	select PROD
	ordem CODIGO
	select INVENT
	ordem CODIGO
	if TipoMov=='P'
		ordem CODIGOP
	end
	set relation to str(INVENT->IN_CODPR,L_P) into PROD
	DbGoTop()
	pb_msg()
	cArq:=ArqTemp(,,'')
	SET SCOPE TO str(VM_CODIN1,4)+str(VM_SEQ1,2)
	subIndex on str(INVENT->IN_CODPR,L_P) tag TEMINV to (cArq) // eval Odomentro(cArq,'TEMINV')
	DbGoTop()
	pb_dbedit1("INVDIG")
	VM_CAMPO:={'str(IN_CODPR,L_P)+chr(45)+left(PROD->PR_DESCR,20)',;
					fieldname(4),;
					fieldname(5)}
 
	VM_MUSC:={  mXXX,      mI6,       mDT}
	VM_CABE:={"Item","Qtdade ","Dt Movto"}

	dbedit(08,01,21,78,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
	// dbcommit()
end
dbcloseall()
FileDelete(cArq+'.*')
return NIL

*-----------------------------------------------------------------------------*
function INVDIG1() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	INVDIGT(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function INVDIG2() // Rotina de Alteracao
if reclock()
	INVDIGT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function INVDIGT(FL)
local LCONT:=.T.
local X,Y
for X:=1 to fcount()
	Y :='VM'+substr(fieldname(X),3)
	&Y:=fieldget(X)
next
if FL
	VM_CODIN:=VM_CODIN1
	VM_SEQ  :=VM_SEQ1
	VM_DATA :=date()
	VM_TIPOM:=TipoMov
end
X:=19
pb_box(X++,18,,,,'Digitar '+if(TipoMov=='I','Inventario','Pedido'))
@X++,20 say padr('Produto',        20,'.') get VM_CODPR  pict masc(21) valid fn_codpr(@VM_CODPR,77).and.pb_ifcod2(str(VM_CODIN,4)+str(VM_SEQ,2)+str(VM_CODPR,L_P),NIL,.F.,1) when FL
if !FL
	fn_codpr(@VM_CODPR,77)
end
@X++,20 say padr('Quantidade', 20,'.') get VM_QTDE pict mI6 valid VM_QTDE>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if FL
		LCONT:=AddRec()
	end
	if LCONT
		for X:=1 to fcount()
			Y:="VM"+substr(fieldname(X),3)
			fieldput(X,&Y)
		next
	end
end
dbskip(0)
return NIL
*-----------------------------------------------------------------------------*

function INVDIG3()	//	Rotina de Pesquisa
local VM_CODPR:=IN_CODPR
pb_box(19,20,,,,'Pesquisa')
@21,22 say 'Produto:' get VM_CODPR pict masc(21)
read
if lastkey()#K_ESC
	dbseek(str(VM_CODIN1,4)+str(VM_SEQ1,2)+str(VM_CODPR,L_P),.T.)
end
return NIL
*-----------------------------------------------------------------------------*

function INVDIG4()	//	Rotina de Exclusao
if reclock().and.pb_sn('Excluir produto..: ' + transform(IN_CODPR,masc(21)))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function INVDIG5()	//	Impressao
return NIL
