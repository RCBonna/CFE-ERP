*-----------------------------------------------------------------------------*
function ORDP1500()
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'E->PARAMORD',	'E->ATIVIDAD',	'E->PARAMETRO',;
				'E->CLIOBS',	'E->CLIENTE',	'E->CLIPRECO'})
	return NIL
end
DbGoTop()

pb_tela()
pb_lin4('Preco AtividadesXCliente',ProcName())
if empty(PARAMORD->PA_DESCR1)
	alert('M¢dulo n„o implantando corretamente, consulte pessoal de Suporte.')
	dbcloseall()
	return NIL
end

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})

VM_MARKDEL = .F.
set relation to str(PR_CODCL,5) into CLIENTE,;
				 to str(PR_CODAT,2) into ATIVIDAD
VM_CAMPO[1]:='pb_zer(PR_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)'
VM_CAMPO[2]:='pb_zer(PR_CODAT,2)+chr(45)+left(ATIVIDAD->AT_DESCR,25)'
pb_dbedit1('ORDP150')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2', {masc(23), masc(23),  masc(25)},;
														{'Cliente','Atividade','Preco'})
pb_compac(VM_MARKDEL)
dbcommitall()
dbcloseall()
return NIL

function ORDP1501()	//	Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	ORDP1500T( .T.)
end
return NIL

function ORDP1502()	//	Rotina de Alteracao
ORDP1500T(.F.)
return NIL

function ORDP1500T( VM_FL )
local GETLIST:={},X,X1
for X=1 to fcount()
	X1='VM'+substr(fieldname(X),3)
	&X1=&(fieldname(X))
next
pb_box(18,10,,,,'Cadastro de Precos Por Cliente')
@19,12 say 'Cliente...:' get VM_CODCL pict masc(04) valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}) when VM_FL
@20,12 say 'Atividade.:' get VM_CODAT pict masc(01) valid fn_codigo(@VM_CODAT,{'ATIVIDAD',{||ATIVIDAD->(dbseek(str(VM_CODAT,2)))},{||ORDP1400T(.T.)},{2,1}}).and.pb_ifcod2(str(VM_CODCL,5)+str(VM_CODAT,2),NIL,.F.,1) when VM_FL
@21,12 say 'Valor Hora:' get VM_VLRHR picture masc(06) valid VM_VLRHR>0
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

function ORDP1503()	//	Rotina de Pesquisa
PESQ(indexord())
return NIL

function ORDP1504()	//	Rotina de Exclusao
if pb_sn('Excluir PrecoXCliente '+&(VM_CAMPO[1])+' - '+&VM_CAMPO[2])
	VM_MARKDEL=.T.
	delete
	dbskip()
	if eof()
		DbGoTop()
	end
end
return NIL

function ORDP1505()	//	Impressao dos locais
if pb_ligaimp(chr(18))
	DbGoTop()
	VM_PAG=0
	VM_LAR=78
	VM_REL='Precos de Clientes x Atividades'
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP1505A',VM_LAR)
		VM_CODCL:=PR_CODCL
		? &(VM_CAMPO[1])
		while !eof().and.VM_CODCL==PR_CODCL
			? space(10)+&(VM_CAMPO[2])
			??space(03)+transform(fieldget(3),masc(6))
			pb_brake()
		end
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(chr(18))
end
return NIL

function ORDP1505A()	//	Cabe‡alho
? 'Cliente'+space(3)+padr('Descricao da Atividade',32)
??'Valor Hora'
? replicate('-',VM_LAR)
return NIL
