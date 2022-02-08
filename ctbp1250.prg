*-----------------------------------------------------------------------------*
function CTBP1250()	//	Atualizacao de saldo inicial									*
*								Roberto Carlos Bonanomi - Jun/93								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4('MOVIMENTA€AO - Saldo Inicial',ProcName())
if !abre({'E->CTADET'})
	return NIL
end
dbsetorder(2)
DbGoTop()

pb_dbedit1('CTBP125','SldIniLista Zerar ')  && tela
VM_CAMPO:=array(4)
afields(VM_CAMPO)
VM_CAMPO[4]:='FN_DBCR(CD_SLD_IN)'

VM_MUSC={MASC_CTB,'@9','@X','@X'}
VM_CABE={'C¢d.Conta','Redz','Descri‡„o','Saldo Inicial'}

private VM_SALDO:=0.00

set key K_F7 to CTBPREC
pb_msg('F7-Reprocessar Saldo das Contas. Use (+) e (-) para avancar ou retornar.')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
// dbcommitall()
set key -6 to
dbcloseall()
return NIL
*------------------------------------------------------------------------* Fim

function CTBP1251() && Saldo Inicial
local VM_RT1:=.T.
set key 45 to CTBP125V
set key 43 to CTBP125F
ctbprec()
while .t.
	VM_VALORD := if(CD_SLD_IN>0,abs(CD_SLD_IN),0)
	VM_VALORC := if(CD_SLD_IN<0,abs(CD_SLD_IN),0)
	pb_box(18,18,,,,'Informe')
	@19,20 say 'C¢digo.:'+transform(CD_CONTA,VM_MUSC[1])+' - '+CD_DESCR
	@20,20 say 'Vlr a DEBITO...:' get VM_VALORD picture '@E 9999999999.99' valid VM_VALORD>=0
	@21,20 say 'Vlr a CREDITO..:' get VM_VALORC picture '@E 9999999999.99' valid VM_VALORC>=0 when str(VM_VALORD,15,2)=str(0,15,2)
	@21,52 say 'Saldo '+fn_dbcr(VM_SALDO+(DEB*VM_VALORD+CRE*VM_VALORC)-(CD_SLD_IN))
	read
	VM_VALORC:=if(VM_VALORD>0,0.00,VM_VALORC)
	@21,52 say 'Saldo '+fn_dbcr(VM_SALDO+(VM_VALORD*DEB+VM_VALORC*CRE)-(CD_SLD_IN))
	setcolor(VM_CORPAD)
	if lastkey()#27
		if pb_sn()
			VM_SALDO:=VM_SALDO+(DEB*VM_VALORD+CRE*VM_VALORC)-(CD_SLD_IN)
			replace CD_SLD_IN with DEB*VM_VALORD+CRE*VM_VALORC
			// dbcommit()
			dbskip()
			if eof()
				DbGoTop()
			end
		end
	else
		exit
	end
end
set key 45 to
set key 43 to
ctbprec()
return NIL

*-------------------------------------------------------------------------*
function CTBP1252() && Listagem
if pb_ligaimp(chr(18))
	DbGoTop()
	VM_PAG := 0
	VM_REL := 'Listagem dos Saldos Iniciais'
	VM_LAR := 80
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1255A',VM_LAR)
		? transform(CD_CONTA, VM_MUSC[1])+' '+str(CD_CTA,4)+' - '+CD_DESCR
		??' '+fn_dbcr(CD_SLD_IN)
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*---------------------------------------------------------------------------*
function CTBP1255A()
? padr(VM_CABE[1],VM_LENMAS+1)+padr(VM_CABE[2],7)
??padr(VM_CABE[3],31)+padl(VM_CABE[4],18)
?replicate('-',VM_LAR)
return NIL

*---------------------------------------------------------------------------*
function CTBP125V() // Volta uma conta
dbskip(-1)
if bof()
	dbgobottom()
end
clear gets
keyboard 'N'
return NIL

*--------------------------------------------------------------------------*
function CTBP125F() // Avanca uma conta
dbskip(+1)
if eof()
	DbGoTop()
end
clear gets
keyboard 'N'
return NIL


function CTBP1253() // ZERAR
if pb_sn('Zerar todos os saldos Iniciais ?')
	pb_msg()
	DbGoTop()
	while !eof()
		replace CD_SLD_IN with 0
		dbskip()
	end
	DbGoTop()
end
*-------------------------------------------------------------------------*
function CTBPREC()
local VM_REG:=recno()
save screen
VM_CORANT:=setcolor()
pb_box(10,10,13,70)
DbGoTop()
VM_SALDO:=0.00
while !eof()
	VM_SALDO+=CD_SLD_IN
	@11,12 say 'F7 - Aguarde, Reprocessando saldo conta ('+transform(CD_CONTA,VM_MUSC[1]+')')
	@12,30 say 'Saldo R$ '+fn_dbcr(VM_SALDO)
	dbskip()
end
alert('Saldo : '+fn_dbcr(VM_SALDO)+';'+if(str(VM_SALDO,15,2)#str(0.00,15,2),'ABERTO','FECHADO'))

DbGoTo(VM_REG)
restore screen
setcolor(VM_CORANT)
return NIL
