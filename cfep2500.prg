*-----------------------------------------------------------------------------*
function CFEP2500()	//	Associa Produto & Fornecedor									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'C->CODTR',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->PROFOR'})
	return NIL
end

select('PROD');dbsetorder(2)
select('PROFOR')
set relation to str(PF_CODPR,L_P) into PROD,;
				 to str(PF_CODFO,5) into CLIENTE

pb_dbedit1('CFEP250','IncluiAlteraPesquiExcluiOrdem Lista ')
VM_CAMPO:=array(8)
VM_CAMPO[1]:= 'padr(pb_zer(PF_CODPR,len(masc(21)))+chr(45)+PROD->PR_DESCR,30)'
VM_CAMPO[2]:= 'pb_zer(PF_CODFO,5)+chr(45)+left(CLIENTE->CL_RAZAO,15)'
VM_CAMPO[3]:= 'PF_DATA'
VM_CAMPO[4]:= 'PF_PRECO'
VM_CAMPO[5]:= 'PF_OBS'
VM_CAMPO[6]:= 'CLIENTE->CL_CONTAT'
VM_CAMPO[7]:= 'CLIENTE->CL_FONE'
VM_CAMPO[8]:= 'CLIENTE->CL_FAX'

VM_MUSC:={      mXXX,          mXXX,    mDT,    mI102, mXXX,  mXXX,    mXXX,   mUUU}
VM_CABE:={'Produtos','Fornecedores', 'Data','Vlr Unit','OBS','Contato','Fone','Fax'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

function CFEP2501() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP2500T(.T.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEP2502() // Rotina de Alteracao
if reclock()
	VM_CODPR := PF_CODPR
	CFEP2500T(.F.)
end
return NIL
*-----------------------------------------------------------------------------*

function CFEP2500T(VM_FL)
local GETLIST:={},LCONT:=.T.,X,VM_Y
for X:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(X),3)
	&VM_Y:=&(fieldname(X))
next

pb_box(16,28,,,,'Informe')
@17,30 say 'Produto....:' get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,78) when VM_FL
@18,30 say 'Emitente...:' get VM_CODFO picture mI5      valid fn_codigo(@VM_CODFO,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODFO,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}) when VM_FL
@19,30 say 'Data Compra:' get VM_DATA  picture mDT      valid pb_ifcod2(str(VM_CODPR,L_P)+str(VM_CODFO,5)+dtos(VM_DATA),NIL,.F.,1) when VM_FL
@20,30 say 'Preco Unit.:' get VM_PRECO picture mI92     valid VM_PRECO>=0
@21,30 say 'Obs........:' get VM_OBS   picture mXXX
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for X:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &VM_Y
		next
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------------*

function CFEP2503() // Rotina de Pesquisa
VM_CHAVE := if(indexord()=1,PF_CODPR,PF_CODFO)
pb_box(20,26)
@21,30 say 'Pesquisar '+if(indexord()=1,'PRODUTO','FORNECEDOR')+'.: ' get VM_CHAVE pict if(indexord()=1,masc(21),masc(4))
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,if(indexord()=1,L_P,5)),.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEP2504() // Rotina de Exclusao
if pb_sn('Excluir PROD/FORN.: '+pb_zer(PF_CODPR,L_P)+'-'+left(PROD->PR_DESCR,20)+' '+left(CLIENTE->CL_RAZAO,20)).and.reclock()
	fn_elimi()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*

function CFEP2505() // Mudanca de Ordem
local OPC:=alert('Selecione ordem...',{'Produto','Fornecedor'})
if OPC>0
	dbsetorder(OPC)
end
return NIL

*-----------------------------------------------------------------------------*

function CFEP2506() // Mudanca de Impressao
local VM_TIPO,VM_CPO,VM_FL,X1,X2,VM_REL,VM_PAG
CFEP2505()
DbGoTop()
VM_TIPO:=if(indexord()==1,'Produto','Fornecedor')
dbgobottom();VM_FIM:=&(fieldname(indexord()))
DbGoTop();   VM_INI:=&(fieldname(indexord()))

pb_box(19,20)
@20,21 say padr(VM_TIPO,12,'.')+'Inicial.:' get VM_INI picture masc(21) valid if(indexord()==2,fn_codigo(@VM_INI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_INI,5)))},,{2,1}}),fn_codpr(@VM_INI,78))
@21,21 say padr(VM_TIPO,12,'.')+'Final...:' get VM_FIM picture masc(21) valid if(indexord()==2,fn_codigo(@VM_FIM,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_FIM,5)))},,{2,1}}),fn_codpr(@VM_FIM,78)).and.VM_FIM>=VM_INI
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_PAG:= 0
	VM_REL:= VM_TIPO+' por '+if(indexord()==2,'Produto','Fornecedor')
	VM_LAR:= 132
	
	VM_CPO=array(2)
	dbseek(str(VM_INI,if(indexord()==1,L_P,5)),.T.)
	
	while !eof().and.&(fieldname(indexord()))<=VM_FIM
		VM_FL=.T.
		VM_COD = &(fieldname(indexord()))
		
		while !eof().and.&(fieldname(indexord()))==VM_COD
			X1:=pb_zer(PF_CODPR,L_P)+chr(45)+PROD->PR_DESCR
			X2:=pb_zer(PF_CODFO,5)+chr(45)+CLIENTE->CL_RAZAO+space(2)+CLIENTE->CL_CONTAT+space(2)+CLIENTE->CL_FONE+space(2)+CLIENTE->CL_FAX
			VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP2506A',VM_LAR)
			if VM_FL
				? padr(if(indexord()==1,X1,X2),VM_LAR)
				VM_FL:=.F.
			end
			? padl(if(indexord()=1,X2,X1),VM_LAR)
			dbskip()
		end
		?
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
return NIL

function CFEP2506A()  // Cabecalho
if indexord()==1
	? 'Produto'+space(45)+'Fornecedor'+space(28)+'Contato'+space(15)+'Telefone'
else
	? 'Fornecedor'+space(28)+'Contato'+space(15)+'Telefone'+space(18)+'Produto'
end
? replicate('-',VM_LAR)
return NIL
