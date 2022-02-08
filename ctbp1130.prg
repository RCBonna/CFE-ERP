*-----------------------------------------------------------------------------*
function CTBP1130()	// ATUALIZACAO DE CADASTROS DE CONTAS DETALHE				*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMCTB',;
				'C->RAZAO',;
				'R->CTATIT',;
				'C->CTADET'})
	dbcloseall()
	return NIL
end

pb_dbedit1('CTBP113','IncluiAlteraRevisaExcluiLista Ordem ')  // tela
VM_CAMPO:=array(4)
afields(VM_CAMPO)
VM_CAMPO[4]='FN_DBCR(CD_SLD_IN)'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
		{MASC_CTB,masc(3),mXXX,       masc(1)},;
		{'C¢digo',   'Redz','Descri‡„o','Saldo Inicial'})
dbcommitall()
dbcloseall()
return NIL

*-----------------------------------------------------------------------* Fim
function CTBP1131() // Rotina de Inclus„o
*-----------------------------------------------------------------------* 
while lastkey()#27
	dbgobottom()
	dbskip()
	CTBP1130T(.T.)
end
return NIL

*-----------------------------------------------------------------------* 
function CTBP1132() // Rotina de Altera‡„o
*-----------------------------------------------------------------------* 
if reclock()
	CTBP1130T(.F.)
end
return NIL

*-----------------------------------------------------------------------* 
function CTBP1133() // Rotina de Pesquisa
*-----------------------------------------------------------------------* 
local VM_CONTA:=CD_CONTA
dbsetorder(2)
pb_box(20,40)
@21,42 say 'Pesquisar CONTA..:' get VM_CONTA picture MASC_CTB
read
setcolor(VM_CORPAD)
dbseek(VM_CONTA,.T.)
dbsetorder(1)
return NIL

*-----------------------------------------------------------------------* 
function CTBP1134() // Rotina de Exclus„o
*-----------------------------------------------------------------------* 
local RT:=.T.
if reclock().and.pb_sn('Eliminar o CONTA ('+transform(CD_CONTA,MASC_CTB)+' '+trim(CD_DESCR)+') ?')
	select('RAZAO')
	dbseek(CTADET->CD_CONTA,.T.)
	if CTADET->CD_CONTA==RAZAO->RZ_CONTA
		beepaler()
		alert('Esta Conta tem lan‡amentos. NÆo posso Excluir.')
		RT:=.F.
	end
	select('CTADET')
	if RT
		fn_elimi()
	end
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------* 
function CTBP1135() // Rotina de Impress„o
*-----------------------------------------------------------------------* 
local VM_X
local VM_CT
if pb_ligaimp(C15CPP)
	DbGoTop()
	VM_MUSCARA := transform(CD_CONTA,MASC_CTB)
	VM_X       := len(VM_MUSCARA)-len(strtran(VM_MUSCARA,'-','')) // Nr de quebra
	VM_CT      := 0
	VM_PAG     := 0
	declare VM_QB[VM_X],VM_QBR[VM_X]
	afill(VM_QB, 0)
	afill(VM_QBR,'')

	for VM_X:=1 to len(VM_MUSCARA)
		if substr(VM_MUSCARA,VM_X,1)=='-'
			VM_CT++
			VM_QB[VM_CT]=VM_X-1
		end
	next

	declare VM_TT[len(VM_QB)*4+4]
	afill(VM_TT,0)
	VM_REL := 'Plano de Contas'
	VM_LAR := 50+len(MASC_CTB)
	for VM_X=1 to len(VM_QB)
		VM_QBR[VM_X]=if(VM_QB[VM_X]>0,substr(transform(CD_CONTA,MASC_CTB),1,VM_QB[VM_X]),'')
	next
	if VM_PAG#0
		setprc(64,1)
	end
	while !eof()

		VM_CONTA:=transform(CD_CONTA,MASC_CTB)
		VM_PAG  :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1130A',VM_LAR)

		CTBP11311()   // Verifica quebra

		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1130A',VM_LAR)
		? VM_CONTA+'-'+space(1)+pb_zer(CD_CTA,4)+space(1)+CD_DESCR+space(1)
		pb_brake()

	end
	VM_CONTA = transform(0,MASC_CTB)

	CTBP11311()  // Verifica quebra

	?replicate('-',VM_LAR)
	eject
	pb_deslimp(chr(18))
end
return NIL

*---------------------------------------------------------------------------*
function CTBP1130A()
*---------------------------------------------------------------------------*
? substr('Conta'+space(20),1,len(VM_CONTA))+space(1)+'Redz Descricao da Conta'
?replicate('-',VM_LAR)
return NIL

*--------------------------------------------------------------------------*
function CTBP11311() // impressao da qubra
*---------------------------------------------------------------------------*
for VM_Q=len(VM_QB) to 1 step -1

	if substr(VM_CONTA,1,VM_QB[VM_Q]) # VM_QBR[VM_Q]
		VM_Q1=strtran(VM_QBR[VM_Q],'-','')
		VM_CTADET=VM_Q1+replicate('0',VM_MASTAM-len(VM_Q1))

		select('CTATIT')
		dbseek(VM_CTADET)
		select('CTADET')
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1130A',VM_LAR)
		if len(trim(CTATIT->CT_DESCR))>0
			? VM_QBR[VM_Q]+space(len(VM_CONTA)-len(VM_QBR[VM_Q]))+'-'
			??space(6)+CTATIT->CT_DESCR
			?
		end
		if VM_Q==1
			?replicate('-',VM_LAR)
			setprc(64,1)
		end
		VM_QBR[VM_Q]=substr(transform(CD_CONTA,MASC_CTB),1,VM_QB[VM_Q])
	end
next
return NIL

*-----------------------------------------------------------------------* 
function CTBP1136() // Rotina de Troca de Ordem
*-----------------------------------------------------------------------* 
dbsetorder(if(indexord()==1,2,1))
pb_msg('Troca para ordem '+if(indexord()==2,'Codigo Conta','Conta Reduzida'),2)
DbGoTop()
return NIL

*-----------------------------------------------------------------------* 
 function CTBP1130T(VM_FL)
*-----------------------------------------------------------------------* 
local    GETLIST  :={}
local    LCONT    :=.T.
local    aConta   :={CD_CONTA,CD_CTA,recno()}
private  VM_CONTA :=if(VM_FL,pb_zer(0,VM_MASTAM),CD_CONTA)
private 	VM_DESCR :=CD_DESCR
private  VM_CTA   :=CD_CTA+if(VM_FL,1,0)

pb_box(18,33,,,,'Cadastro de Contas Detalhe')
@19,35 say padr('C¢d.Conta',10,'.')+':' get VM_CONTA pict MASC_CTB valid if(VM_FL,;
																									pb_ifcod2(VM_CONTA,NIL,.F.,2),; // INCLUSÃO
																									aConta[1]==VM_CONTA.or.(pb_ifcod2(VM_CONTA,NIL,.F.,2).and.fn_cta(VM_CONTA).and.ChkMovRazao(aConta[1])))
@20,35 say padr('Cta Reduz',10,'.')+':' get VM_CTA   pict mI4      valid if(VM_FL,;
																									pb_ifcod2(str(VM_CTA,4),NIL,.F.,1),; // INCLUSÃO
																									aConta[2]==VM_CTA.or.(pb_ifcod2(str(VM_CTA,4),NIL,.F.,1)))
@21,35 say padr('Descri‡„o',10,'.')+':' get VM_DESCR pict mXXX     valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		if !VM_FL
			go aConta[3]
		end
		replace 	CD_CONTA with VM_CONTA,;
				 	CD_CTA   with VM_CTA,;
					CD_DESCR with VM_DESCR
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL
*-----------------------------------------------------------------------* 
