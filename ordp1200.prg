*-----------------------------------------------------------------------------*
function ORDP1200()	//	Maquina/Mecanico...												*
#include 'RCB.CH'
*-----------------------------------------------------------------------------*

if !abre({	'E->PARAMORD',;
				'E->PROD',;
				'E->MECMAQ'})
	return NIL
end
dbsetorder(2)
DbGoTop()

pb_tela()
pb_lin4(PARAMORD->PA_DESCR1,ProcName())
if empty(PARAMORD->PA_DESCR1)
	alert('M¢dulo n„o implantando corretamente, consulte pessoal de Suporte.')
	dbcloseall()
	return NIL
end

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_MARKDEL = .F.

pb_dbedit1('ORDP120')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
		 {  mI2,  mXXX,    mXXX,     mI92,    mI3,    mI3,   mI3,     mI3,  masc(21)},;
		 {'C¢d','Nome','Funcao', 'VlrHora','HrMes','%Prod','%Ass','%Resp','CodPrdInt' })
pb_compac(VM_MARKDEL)
dbcommitall()
dbcloseall()
return NIL

*----------------------------------------------------
function ORDP1201()	//	Rotina de Inclus„o
*----------------------------------------------------
while lastkey()#27
	dbgobottom()
	dbskip()
	ORDP1200T( .T.)
end
return NIL

*----------------------------------------------------
function ORDP1202()	//	Rotina de Alteracao
*----------------------------------------------------
ORDP1200T(.F.)
return NIL

*----------------------------------------------------
function ORDP1200T( VM_FL )
*----------------------------------------------------
local GETLIST:={},X,X1
for X=1 to fcount()
	X1='VM'+substr(fieldname(X),3)
	&X1=&(fieldname(X))
next
X        :=MaxRow()-13

pb_box(X++,10,,,,trim(PARAMORD->PA_DESCR1))
@X++,12 say 'C¢digo............:' get VM_CODIG  pict mI2  valid VM_CODIG>0.and.pb_ifcod2(str(VM_CODIG,2),NIL,.F.,1) when VM_FL
@X++,12 say 'Nome..............:' get VM_NOME   pict mXXX valid !empty(VM_NOME)
@X++,12 say 'Funcao............:' get VM_FUNC   pict mUUU
@X++,12 say 'Valor Hora Custo..:' get VM_VLRHR  pict mI92 valid VM_VLRHR>0
@X++,12 say 'Horas no Mes......:' get VM_HRMES  pict mI3  valid VM_HRMES>0
if PARAMORD->PA_INTFAT
	@X++,12 say 'Prod.Estoque....:' get VM_CODPR pict masc(21) valid fn_codpr(@VM_CODPR,77)
end
@X  ,12 to X++,78
@X++,12 say '% Produtividade...:' get VM_PPROD  pict mI2 valid VM_PPROD >=0
@X++,12 say '% Assiduidade.....:' get VM_PASSID pict mI2 valid VM_PASSID>=0
@X++,12 say '% Responsabilidade:' get VM_PRESP  pict mI2 valid VM_PRESP >=0
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.F.)
	if VM_FL
		dbappend(.T.)
	end
	for X=1 to fcount()
		X1='VM'+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
	dbskip(0)
end
return NIL

*----------------------------------------------------
function ORDP1203()	//	Rotina de Pesquisa
*----------------------------------------------------
local ORD:=alert('Selecione Ordem...',{'C¢digo','Alfabetico'},'R/W')
if ORD>0
	dbsetorder(ORD)
	PESQ(indexord())
end
return NIL

*----------------------------------------------------
function ORDP1204()	//	Rotina de Exclusao
*----------------------------------------------------
if pb_sn('Excluir '+trim(PARAMORD->PA_DESCR1)+' '+(&(fieldname(2))))
	VM_MARKDEL=.T.
	delete
	dbskip()
	if eof()
		DbGoTop()
	end
end
return NIL

*----------------------------------------------------
function ORDP1205()	//	Impressao dos locais
*----------------------------------------------------
if pb_ligaimp(C15CPP)
	DbGoTop()
	VM_PAG=0
	VM_LAR=78
	VM_REL='Cadastro de '+trim(PARAMORD->PA_DESCR1)
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP1205A',VM_LAR)
		? pb_zer(fieldget(1),2)+'-'+fieldget(2)
		??space(3)+fieldget(3)
		??space(3)+transform(fieldget(4),mI92)
		??space(3)+transform(fieldget(5),mI4)
		??space(3)+transform(fieldget(6),mI3)
		??space(3)+transform(fieldget(7),mI3)
		??space(3)+transform(fieldget(8),mI3)
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(chr(18))
end
return NIL

*----------------------------------------------------
function ORDP1205A()	//	Cabe‡alho
*----------------------------------------------------
? 'Cod/'+padr('Nome '+trim(PARAMORD->PA_DESCR1),32)
??padr('Funcao',32)
??'Valor Hora'
? replicate('-',VM_LAR)
return NIL
*---------------------------------------EOF-------------------------*
