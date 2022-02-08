*-----------------------------------------------------------------------------*
function CFEP5610() // - Cadastro de Vendedores											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR'})
	return NIL
end

select('CLIENTE');dbsetorder(4)
select('VENDEDOR');dbsetorder(2);DbGoTop()
pb_dbedit1('CFEP561')  && tela
VM_CAMPO=array(fcount())
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
									{masc(12),masc(1),        masc(1),   masc(10),masc(1),masc(1),masc(17),masc(1),masc(7),masc(1),    masc(14),  masc(14)},;
									{'C¢d',  'Nome Vendedor','Endere‡o','CEP',   'Cidade','UF',  'CPF',   'R.G', 'Dt Nasc','Telefone',  '%ComPraz','%ComVist'})
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEP5611() && Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP5610T(.T.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEP5612() && Rotina de Altera‡„o
if reclock()
	CFEP5610T(.F.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEP5610T(VM_FL)
local GETLIST:={},X,VM_CTCPL,LCONT:=.T.
for X=1 to fcount()
	VM_CPO ='VM'+substr(fieldname(X),3)
	&VM_CPO=&(fieldname(X))
next
pb_box(10,25,,,,'Cadastro de Vendedores')
@11,26 say 'C¢digo....:' get VM_CODIG picture masc(12) valid VM_CODIG>0.and.pb_ifcod2(str(VM_CODIG,3),NIL,.F.,1) when VM_FL
@12,26 say 'Nome......:' get VM_NOME  picture masc(01) valid !empty(VM_NOME)
@13,26 say 'Endere‡o..:' get VM_ENDER picture masc(01)+'S40'
@14,26 say 'Cidade....:' get VM_CIDAD picture masc(01)
@14,63                   get VM_CEP   picture masc(10)
@14,75                   get VM_UF    picture masc(01) valid pb_uf(@VM_UF)
@15,26 say 'C.P.F.....:' get VM_CPF   picture masc(17) valid if(len(trim(VM_CPF))==11,pb_chkdgt(VM_CPF,2),.T.)
@16,26 say 'R.G.......:' get VM_RG    picture masc(01)
@17,26 say 'Fone......:' get VM_FONE  picture masc(01)
@18,26 say 'Data Nasc.:' get VM_DTNAS picture masc(07)
@19,26 TO 19,78
@19,37 say '[COMISSAO]' COLOR 'R/W'
@20,26 say '% Prazo...:' get VM_PERC  picture masc(14) valid VM_PERC>=0
@21,26 say '% Vista...:' get VM_PERCV picture masc(14) valid VM_PERCV>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for X=1 to fcount()
			VM_CPO ='VM'+substr(fieldname(X),3)
			replace &(fieldname(X)) with &VM_CPO
		next
	end
end
dbrunlock(recno())
// dbcommitall()
return NIL

*-------------------------------------------------------------------* 
function CFEP5613() && Rotina de Pesquisa
local VM_ORD:=indexord(),VM_CHAVE
pb_box(18,20)
@19,22 say 'Ordem de pesquisa:'
@19,52 prompt padc('C¢digo',25)
@20,52 prompt padc('Alfabetica',25)
menu to VM_ORD
if VM_ORD>0
	VM_CHAVE=if(VM_ORD=1,VE_CODIG,VE_NOME)
	@21,22 say 'Procurar.:' get VM_CHAVE picture if(VM_ORD=1,masc(12),masc(1))
	read
	dbsetorder(VM_ORD)
	dbseek(if(indexord()=1,str(VM_CHAVE,3),VM_CHAVE),.T.)
end
setcolor(VM_CORPAD)
return NIL

*-------------------------------------------------------------------* 
function CFEP5614() && Rotina de Exclus„o
if reclock().and.pb_sn('Eliminar ( '+pb_zer(VE_CODIG,3)+'-'+trim(VE_NOME)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL
*-------------------------------------------------------------------* 

function CFEP5615() && Rotina de Impress„o
local VM_OPC:=alert('Selecione op‡„o de Impress„o ...',{'Somente Vendedores','Vendedores e Clientes'},'R/W')
local VM_PAG:=0,VM_REL
if if(VM_OPC>0,pb_ligaimp(I15CPP),.F.)
	DbGoTop()
	VM_REL='Cadastro de Vendedores ('+if(indexord()=1,'Codigo','Alfabetica')+')'
	VM_REL+=if(VM_OPC=2,'-com seus clientes','')
	VM_LAR:=132
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP5615A',VM_LAR,66)
		?  pb_zer(VE_CODIG,5)+'-'
		?? VE_NOME+space(1)
		?? VE_CIDAD+space(1)
		?? VE_UF+space(1)
		?? transform(VE_CPF,masc(17))+space(1)
		?? VE_RG  +space(1)
		?? padl(VE_FONE,12)+space(1)
		?? transform(VE_DTNAS,mDT)+space(1)
		?? transform(VE_PERC ,masc(14))
		?? transform(VE_PERCV,masc(14))
		?
		if VM_OPC=2
			salvabd()
			select('CLIENTE')
			dbseek(str(VENDEDOR->VE_CODIG,3),.T.)
			while !eof().and.CL_VENDED==VENDEDOR->VE_CODIG
				? space(4)+pb_zer(CL_CODCL,5)+chr(45)
				??CL_RAZAO+chr(32)
				??CL_CGC  +chr(32)
				??CL_FONE +chr(32)
				??CL_FAX
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP5615A',VM_LAR)
				dbskip()
			end
			salvabd(.F.)
			?
		end
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(masc(1))
	DbGoTop()
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP5615A()
? 'Cod Nome do Vendedor'+space(15)
??'Cidade'+space(20)+'UF C.P.F.'+space(9)+'Reg.Geral'+space(8)
??'Fone'+space(12)+'Data Nasc Percen'
? replicate('-',VM_LAR)
return NIL
*----------------------------------------------------------------------------*
