*-----------------------------------------------------------------------------*
 function CFEP2100()	//	Cadastro de Fornecedores										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local nX
local VM_CAMPO
local VM_CABE:={}
local Opcoes
//pb_tela()
setcolor(VM_CORPAD)
pb_lin4('FORNECEDORES/CORRECAO',ProcName())

if file('CFEAFO.DBF')
	if !abre({	'C->PARAMETRO',;
					'C->DPFOR',;
					'C->FORNEC'}) //<<---------MANTEM 
		return NIL
	end
else
	alert('Programa nao sera mais usado por esta versao')
	return NIL
end
if PARAMETRO->PA_CONVCF
	alert('Fornecedores ja convertidos para Clientes')
	dbcloseall()
return NIL
	
else
end

Opcoes:='IncluiAlteraPesqu.'

Select DPFOR
ORDEM FORDTV

select('FORNEC');dbsetorder(2);DbGoTop() // ORDEM ALFA

pb_dbedit1('CFEP210',Opcoes)  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)
for nX:=1 to len(VM_CAMPO)
	aadd(VM_CABE,substr(VM_CAMPO[nX],4))
next
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
dbcommit()
if !PARAMETRO->PA_CONVCF
	alert('Enquanto todos os fornecedores nao forem convertidos nao e possivel continuar')
end
dbcloseall()
clear
return NIL

*-------------------------------------------------------------------* Fim
function CFEP2101() // Rotina de Inclus„o
*-------------------------------------------------------------------* 
return NIL

*-------------------------------------------------------------------* 
function CFEP2102() // Rotina de Altera‡„o
*-------------------------------------------------------------------* 
return NIL

*-------------------------------------------------------------------* 
function CFEP2103() // Rotina de Pesquisa
*-------------------------------------------------------------------* 
local VM_ORD:=indexord(),VM_CHAVE
pb_box(16,20)
@17,22 say 'Ordem de pesquisa:'
@17,52 prompt padc('C¢digo',25)
@18,52 prompt padc('Alfabetica',25)
@19,52 prompt padc('CGC/CPF',25)
menu to VM_ORD
if VM_ORD>0
	VM_CHAVE:= if(VM_ORD==1,FO_CODFO,if(VM_ORD==2,FO_RAZAO,FO_CGC))
	@21,22 say 'FORNECEDOR.:' get VM_CHAVE pict if(VM_ORD==1,masc(4),masc(1))
	read
	dbsetorder(VM_ORD)
	dbseek(if(indexord()==1,str(VM_CHAVE,5),VM_CHAVE),.T.)
end
setcolor(VM_CORPAD)
return NIL

