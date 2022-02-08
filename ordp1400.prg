static TIPO_ENTRADA:=1
*-----------------------------------------------------------------------------*
function ORDP1400(P1) // Cad Atividade
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

TIPO_ENTRADA:=if(P1==NIL,1,P1)

if !abre({	'E->PARAMORD',;
				'C->CTADET',;
				'C->CTATIT',;
				'C->FISACOF',;
				'C->ATIVIDAD';
				})
	return NIL
end
DbGoTop()

pb_tela()
pb_lin4('Atividades',ProcName())
if empty(PARAMORD->PA_DESCR1)
	alert('Modulo nao implantando corretamente; consulte pessoal de Suporte.')
	dbcloseall()
	return NIL
end

VM_CAMPO  :={}
aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_MARKDEL:= .F.

pb_dbedit1('ORDP140')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2', { mI2 , mXXX+'S35' ,  mD82 ,  mUUU ,      mI4 },;
														{'Cod','Nome',      'Preco','PIS/C','Cta Cred'})
pb_compac(VM_MARKDEL)
dbcommitall()
dbcloseall()
return NIL

function ORDP1401()	//	Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	ORDP1400T(.T.)
end
return NIL

function ORDP1402()	//	Rotina de Alteracao
if reclock()
	ORDP1400T(.F.)
end
return NIL

//--------------------------------------------------------------------------------
  function ORDP1400T( VM_FL )
//--------------------------------------------------------------------------------
local GETLIST:={},X,X1
private VM_CTCLP:=''
for X:=1 to fcount()
	X1:='VM'+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
X:=17
pb_box(X++,10,,,,'Cadastro Atividades')
@X++,12 say 'C¢digo....:' get VM_CODIG picture masc(11) valid VM_CODIG>0.and.pb_ifcod2(str(VM_CODIG,2),NIL,.F.,1) when VM_FL
@X++,12 say 'Descricao.:' get VM_DESCR picture masc(01) valid !empty(VM_DESCR)
if TIPO_ENTRADA==1
	@X++,12 say 'Valor Hora:' get VM_VLRHR picture masc(06) valid VM_VLRHR>0
else
	@X++,12 say 'PisCofins.:' get VM_CODCOS pict mUUU valid ChkPisCofins(@VM_CODCOS) when pb_msg('Tabela de Pis/Cofins para Saida')
	@X++,12 say 'CtaCredito:' get VM_CTAC   pict mI4  valid if(VM_CTAC==0,.T.,fn_ifconta(@VM_CTCLP,@VM_CTAC))
end
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.F.)
	if VM_FL
		while !AddRec();end
	end
	for X:=1 to fcount()
		X1:='VM'+substr(fieldname(X),3)
		replace &(fieldname(X)) with &X1
	next
	dbskip(0)
end
return NIL

//-----------------------------------------------------------------------------------
function ORDP1403()	//	Rotina de Pesquisa
local ORD:=alert('Selecione Ordem...',{'C¢digo','Alfabetico'},'R/W')
if ORD>0
	dbsetorder(ORD)
	PESQ(indexord())
end
return NIL

//-----------------------------------------------------------------------------------
function ORDP1404()	//	Rotina de Exclusao
if reclock().and.pb_sn('Excluir atividade '+fieldget(2))
	VM_MARKDEL:=.T.
	delete
	dbskip()
	if eof()
		DbGoTop()
	end
end
return NIL

//-----------------------------------------------------------------------------------
function ORDP1405()	//	Impressao dos locais
if pb_ligaimp(C15CPP)
	DbGoTop()
	VM_PAG:=0
	VM_LAR:=78
	VM_REL:='Cadastro de Atividades'
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP1405A',VM_LAR)
		? pb_zer(fieldget(1),2)+'-'+fieldget(2)
		??space(3)+transform(fieldget(3),masc(6))
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
return NIL

//----------------------------------------------------------------------------------
function ORDP1405A()	//	Cabe‡alho
? 'Cod/'+padr('Descricao da Atividade',32)
??'Valor Hora'
? replicate('-',VM_LAR)
return NIL
//-----------------------------------------------------------------EOF
