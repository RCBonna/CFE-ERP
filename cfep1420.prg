*-----------------------------------------------------------------------------*
 function CFEP1420()	//	Digitacao dados para cheques									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->LAYOUT',;
				'C->CAIXAMB',;
				'E->CHEQUES'})
	return NIL
end
DbGoTop()

pb_dbedit1('CFEP142','IncluiAlteraPesquiExcluiChequeListarZera  ')
VM_CAMPO   :=array(5)
afields(VM_CAMPO)
ains(VM_CAMPO,1)
VM_CAMPO[1]:='recno()'
VM_MARKDEL := .F.

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
						 {masc(3),masc(1),masc(2),masc(7),masc(11)},;
						 {'Reg.','Portador','Valor','Data','Cheque'})

dbcommit()
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
function CFEP1421() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
VM_DATA := date()
while lastkey()#K_ESC
	dbgobottom()
	VM_PORTA = DA_PORTA
	VM_VALOR = DA_VALOR
	dbskip()
	CFEP1420T(.T.)
end
return NIL
*-----------------------------------------------------------------------------*
function CFEP1422() // Rotina de Alteracao
VM_PORTA = DA_PORTA
VM_DATA  = DA_DATA
VM_VALOR = DA_VALOR
CFEP1420T(.F.)
return NIL

*-----------------------------------------------------------------------------*
function CFEP1420T(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST  := {}
pb_box(16,24)
@17,25 say 'Registro.: '+pb_zer(recno(),4)
@19,25 say 'Data.....:' get VM_DATA  picture masc(7)
@20,25 say 'Portador.:' get VM_PORTA picture masc(1)
@21,25 say 'Valor....:' get VM_VALOR picture masc(5) valid VM_VALOR>0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		AddRec()
	end
	replace DA_PORTA with VM_PORTA,;
			  DA_VALOR with VM_VALOR,;
			  DA_DATA  with VM_DATA
	// dbcommit()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function CFEP1423() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
local VM_REG:= recno()
pb_box(20,40)
@21,42 say 'Pesquisar REGISTRO..:' get VM_REG picture masc(3)
read
setcolor(VM_CORPAD)
DbGoTo(VM_REG)
return NIL

*-----------------------------------------------------------------------------*
 function CFEP1424() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if pb_sn('Excluir REG..: '+pb_zer(recno(),4)+'-'+trim(DA_PORTA))
	fn_elimi()
	VM_MARKDEL = .T.
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP1425() // Impressao de cheques
*-----------------------------------------------------------------------------*
if pb_ligaimp(IESP1)
	fn_codly()  // Seleciona LAYOUT
	fn_chtes()  // Teste Impressao
	VM_NRCHE:=0
	VM_CHINI:=1
	VM_CHFIM:=9999
	pb_box(18,30)
	@19,31 say 'Reg. Inicial...:' get VM_CHINI picture masc(3) valid VM_CHINI>=0
	@20,31 say 'Reg. Final.....:' get VM_CHFIM picture masc(3) valid VM_CHFIM>=VM_CHINI
	@21,31 say 'N§ Chq.Inicial.:' get VM_NRCHE picture masc(9) valid VM_NRCHE>=0
	read
	setcolor(VM_CORPAD)
	DbGoTo(VM_CHINI)
	while !eof().and.recno()<=VM_CHFIM
		VLR:=transform(DA_VALOR,'@E **,***,***,***.**')
		EXT:=upper(pb_extenso(DA_VALOR))
		EXT+=replicate('*',120-len(EXT))
		EXT:=left(EXT,56)+chr(141)+chr(10)+chr(13)+chr(10)+right(EXT,65)
		POR:=upper(DA_PORTA)
		D  :=str(day(DA_DATA),2)
		M  :=pb_mesext(DA_DATA,'C')
		A  :=str(year(DA_DATA)-1900,2)
		fn_chimp()
		replace DA_NRCHE with VM_NRCHE
		GRAV_BCO(LAYOUT->LY_BANCO,DA_DATA,VM_NRCHE,'Pago ch '+alltrim(str(VM_NRCHE,6))+' '+DA_PORTA,-DA_VALOR,'EM')
		VM_NRCHE++
		pb_brake()
	end
	for VM_X= 1 to 30
		?
	next
	pb_deslimp(CESP1)
end
*-----------------------------------------------------------------------------*
 function CFEP1426() // Cheques Emitidos
*-----------------------------------------------------------------------------*
if pb_ligaimp(C15CPP)
	DbGoTop()
	VM_LAR  = 80
	VM_REL  = 'Cheques Emitidos'
	VM_PAG  = 0
	VM_TOT  = 0
	while !eof()
		VM_PAG = pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(), VM_REL, VM_PAG, 'CFEP1426A', VM_LAR, 66)
		? pb_zer(recno(),4) + space(2)
		??DA_PORTA + space(1) + transform(DA_VALOR,masc(2)) + space(2)
		??dtoc(DA_DATA) + space (2) + str(DA_NRCHE,6)
		VM_TOT+=DA_VALOR
		pb_brake()
	end
	?replicate('-',VM_LAR)
	?
	?space(19) + 'TOTAL GERAL' + replicate('.',15) + ': ' + transform(VM_TOT,masc(2))
	eject
	pb_deslimp(C15CPP)
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------------*
function CFEP1426A() // Cabecalho
*-----------------------------------------------------------------------------*
?'REG.  PORTADOR' + space(43) + 'VALOR' + space(6) + 'DATA' + space(2) + 'CHEQUE'
?replicate('-',VM_LAR)
return NIL

*-------------------------------------------------------------------------*
function CFEP1427()  // Zera Arquivo
*-----------------------------------------------------------------------------*
if pb_sn('Eliminar todos os Dados ?')
	dbeval({||dbdelete()})
	Pack
end
return NIL

*-------------------------------------------------------------------------*
function FN_LINCH()  // Substitui pelo MEMO
*-------------------------------------------------------------------------*
local XX:=LAYOUT->LY_LAYOU
		XX=strtran(XX,'#VLR',VLR)
		XX=strtran(XX,'#EXT',EXT)
		XX=strtran(XX,'#POR',POR)
		XX=strtran(XX,'#D',D)
		XX=strtran(XX,'#M',M)
		XX=strtran(XX,'#A',A)
return(trim(XX))
*-------------------------------------------------------------------------*
function FN_CODLY()  // Seleciona LAYOUT
*-------------------------------------------------------------------------*
local VM_RT
salvabd()
select('LAYOUT')
DbGoTop()
salvacor()
save screen
pb_box(08,01,22,19)
dbedit(09,02,21,17,{fieldname(1)},'','','','',' ¯ ')
restore screen
salvacor(.F.)
salvabd(.F.)
return NIL

*-------------------------------------------------------------------------*
function FN_CHTES()  // Teste de Impressao Cheques
*-------------------------------------------------------------------------*
VLR='**,***,***,***.**'
EXT=replicate('*',56)+chr(141)+chr(10)+chr(13)+chr(10)+replicate('*',65)
POR=replicate('*',30)
D='##'
M=replicate('*',9)
A='##'
while pb_sn('Fazer testes ?')
	fn_chimp()
end
return NIL

*-----------------------------------------------------------------------------*
 function FN_CHIMP()  // Impressao Cheque
*-------------------------------------------------------------------------*
XX:=fn_linch()
for VM_X=1 to mlcount(XX,70)
	? trim(memoline(XX,70,VM_X,,.F.))
next
return NIL
*------------------------------------------eof-----------------------------------*
