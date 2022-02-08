*-----------------------------------------------------------------------------*
function CotaEdit()	//	Edita Cota parte
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'R->PARAMETRO',;
				'C->CLIENTE',;
				'E->COTADV',;
				'E->COTAS'})
	return NIL
end

pb_tela()
pb_lin4(_MSG_,ProcName())
set relation to str(COTAS->CP_CODCL,5) into CLIENTE
pb_dbedit1("COTAEDIT")
VM_CAMPO := array(4)
afields(VM_CAMPO)
VM_CAMPO[1]:='pb_zer(CP_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,30)'
VM_MUSC:={       mXXX,      mDT,  mD132,mXXX}
VM_CABE:={"Associado","Dt Lcto","Valor","Historico"}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
	function COTAEDIT1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
private HISTOR:=CP_HISTOR
private DATAE
while lastkey()#K_ESC
	dbgobottom()
	DATAE :=PARAMETRO->PA_DATA
	dbskip()
	COTAEDITT(.T.)
	dbrunlock(recno())
	DATAE :=CP_DATAE
end
return NIL

*-----------------------------------------------------------------------------*
	function COTAEDIT2() // Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	COTAEDITT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
	function COTAEDITT(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST := {}
local LCONT   :=.T.
local VM_FLCTB:=if(VM_FL,'S','N')
local X
local VM_Y
private VM_FAT:={}
for X:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(X),3)
	&VM_Y:=fieldget(X)
next
if VM_FL
	VM_DATAE :=DATAE
	VM_FLCTB :='S'
end
VM_PARC:=1
X:=14
pb_box(X++,18,,,,'Edita Cotas Parte')
@X++,20 say 'Data.........:' get VM_DATAE  pict mDT
@X++,20 say 'Cod.Associado:' get VM_CODCL  pict mI5   valid fn_codigo(@VM_CODCL,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@X++,20 say 'Nr.Parcelas..:' get VM_PARC   pict mI2   valid VM_PARC>0     when VM_FL.and.VM_FLCTB=='S'.and.pb_msg('Maior que 1 (uma) parcela Gera parcelamento para quitacao em saldos')
@X++,20 say 'Valor Cota...:' get VM_VALOR  pict mI122 valid VM_VALOR#0
@X++,20 say 'Historico....:' get VM_HISTOR pict mXXX+'S40'                when if(VM_PARC>=2,len(VM_FAT:=fn_parc(VM_PARC,VM_VALOR,VM_CODCL,VM_DATAE))>=0,.T.)
@X++,20 say 'Contabilizar ?' get VM_FLCTB  pict mUUU  valid VM_FLCTB$'SN' when VM_FL.and.pb_msg('S=Gera lancamentos para quitacao em Saldos   N=So gera informacoes de extrato')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	GravaCota({	VM_CODCL,;
					VM_DATAE,;
					VM_VALOR,;
					VM_HISTOR;
					})
	if VM_FLCTB=='S'
		cTipo:=if(VM_VALOR>0,'R','P')
		if VM_PARC==1
			GravaCotaDV({	VM_CODCL,;	//1-Associado
								VM_DATAE,;	//2-Data Venc
								VM_VALOR,;	//3-Saldo Inicial
								0,;			//5-Vlr Ja pago
								cTipo,;		//4-Tipo movimento = Recebimento(+) Pagamento(+)
								.F.,;			//6-Flag de Contabilizado
								VM_DATAE})	//7-Dt Mov
		else
			for X:=1 to VM_PARC
				GravaCotaDV({	VM_CODCL,;		//1-Associado
									VM_FAT[X,2],;	//2-Data Venc
									VM_FAT[X,3],;	//3-Saldo Inicial
									0,;				//5-Vlr Ja pago
									cTipo,;			//4-Tipo movimento = Recebimento(+) Pagamento(+)
									.F.,;				//6-Flag de Contabilizado
									VM_DATAE})		//7-Dt Mov
			next
		end
		Alert('Criar as Parcelas no Contas a Pagar/Receber manualmente')
	end
	dbcommitAll()
	dbskip(0)
end
return NIL

*-----------------------------------------------------------------------------*
	function COTAEDIT3() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
local VM_CHAVE:=CP_CODCL
pb_box(20,26,,,,'Pesquisar')
@21,30 say 'Associado.: ' get VM_CHAVE pict mI5
read
setcolor(VM_CORPAD)
dbseek(str(VM_CHAVE,5),.T.)
return NIL

*-----------------------------------------------------------------------------*
	function COTAEDIT4() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir Cota Associado.: ' + &(VM_CAMPO[1])+' Valor:'+transform(CP_VALOR,mD132))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
	function COTAEDIT5() // Impressao de grupos
*-----------------------------------------------------------------------------*
local VM_PAG:=0,X,VM_REL
VM_DATA:={CP_DATAE,CP_DATAE}
pb_box(19,26,,,,'Intervalo de Datas')
@20,30 say 'Inicial.: ' get VM_DATA[1] pict mDT
@21,30 say 'Final...: ' get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
read

if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_REL:='Lista de Cota Parte no Periodo ('+transform(VM_DATA[1],mDT)+' a '+;
				transform(VM_DATA[2],mDT)+')'
	VM_LAR:= 132
	set filter to CP_DATAE>=VM_DATA[1].and.CP_DATAE<=VM_DATA[2]
	DbGoTop()
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'COTAEDITA',VM_LAR)
		?
		for X:=1 to len(VM_CAMPO)
			??transform(&(VM_CAMPO[X]),VM_MUSC[X])+space(2)
		next
		pb_brake()
	end
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	set filter to 
	DbGoTop()
end

*----------------------------------------------------------------------------*
function COTAEDITA() // Cabecalho Lista Grupos
?padr('Associado',40)+'Data Lct '+padl('Valor Cota',16)+'  Historico'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function GravaCotaDV(P1)
*-----------------------------------------------------------------------------*
local X
SALVABANCO
select COTADV
while !AddRec();end
for X:=1 to fcount()
	fieldput(X,P1[X])
next
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
function GravaCota(P1)
*-----------------------------------------------------------------------------*
local X
SALVABANCO
select COTAS
while !AddRec();end
for X:=1 to fcount()
	fieldput(X,P1[X])
next
RESTAURABANCO
return NIL
*-------------------------------------------[EOF]-------------------------------*
