*-----------------------------------------------------------------------------*
function ORDP1300()	//	DESENHO/EQUIPAMENTO.												*
*-----------------------------------------------------------------------------*

#include 'RCB.CH'

if !abre({	'E->PARAMORD',;
				'E->EQUIDES'})
	return NIL
end
dbsetorder(2)
DbGoTop()

pb_tela()
pb_lin4(PARAMORD->PA_DESCR2,ProcName())
if empty(PARAMORD->PA_DESCR2)
	alert('M¢dulo n„o implantando corretamente, consulte pessoal de Suporte.')
	dbcloseall()
	return NIL
end

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})

VM_MARKDEL = .F.

pb_dbedit1('ORDP130')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',{masc(1),masc(1),masc(1),masc(7)},{'C¢digo','Descricao','Observacoes','Data'})
pb_compac(VM_MARKDEL)
// dbcommitall()
dbcloseall()
return NIL

function ORDP1301()	//	Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	ORDP1300T( .T.)
end
return NIL

function ORDP1302()	//	Rotina de Alteracao
ORDP1300T(.F.)
return NIL

function ORDP1300T( VM_FL )
local GETLIST:={},X,X1
for X=1 to fcount()
	X1='VM'+substr(fieldname(X),3)
	&X1=&(fieldname(X))
next
pb_box(17,0)
@17,1 say '['+trim(PARAMORD->PA_DESCR2)+']' color 'r/w'
@18,1 say 'C¢digo....:' get VM_CODIG picture masc(1) valid !empty(VM_CODIG).and.pb_ifcod2(VM_CODIG,NIL,.F.,1) when VM_FL
@19,1 say 'Descricao.:' get VM_DESCR picture masc(1) valid !empty(VM_DESCR)
@20,1 say 'OBS.......:' get VM_OBS   picture masc(1)+'S66'
@21,1 say 'Dt Ut Man.:' get VM_DTULM picture masc(7)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		dbappend(.T.)
	end
	for X=1 to fcount()
		X1='VM'+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
	// dbcommit()
end
return NIL

function ORDP1303()	//	Rotina de Pesquisa
ORDP13OR()
PESQ(indexord())
return NIL

function ORDP1304()	//	Rotina de Exclusao
if pb_sn('Excluir '+trim(PARAMORD->PA_DESCR2)+' '+(&(fieldname(2))))
	VM_MARKDEL=.T.
	delete
	dbskip()
	if eof()
		DbGoTop()
	end
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP1305()	//	Impressao dos locais
ORDP13OR()
if pb_ligaimp(chr(15))
	DbGoTop()
	VM_PAG=0
	VM_LAR=132
	VM_REL='Cadastro de '+trim(PARAMORD->PA_DESCR2)
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP1305A',VM_LAR)
		? &(fieldname(1))
		??'-'+&(fieldname(2))
		??padr(&(fieldname(3)),60)+' ' 
		??transform(&(fieldname(4)),masc(7))
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(chr(18))
end
return NIL

*-----------------------------------------------------------------------------*
function ORDP1305A()	//	Cabe‡alho
return NIL

function ORDP13OR()	//	Ordem
local ORD:=alert('Selecione Ordem...',{'C¢digo','Alfabetico'},'R/W')
if ORD>0
	dbsetorder(ORD)
end
return NIL
