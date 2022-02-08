*-----------------------------------------------------------------------------*
static TIPOCAD:=2 // sub-grupo
function CFEP4100(P1)	//	Cadastro de Grupos de Produtos							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
TIPOCAD:=if(P1==NIL,2,P1)
if !abre({	'C->PROD',;
				'C->GRUPOS'})
	return NIL
end
if TIPOCAD==1 // Grupo
	set filter to GE_CODGR % 10000 == 0
end

pb_tela()
pb_lin4(_MSG_,ProcName())

pb_dbedit1("CFEP410",'IncluiAlteraPesquiExcluiLista Repass')
VM_CAMPO := array(4)
afields(VM_CAMPO)

VM_CAMPO[1]:='fn_mosge(GE_CODGR)'
VM_CAMPO[4]:="if(GE_CODGR%10000==0,'    GRUPO','sub-grupo')"

VM_MUSC:={    mUUU,       mUUU,    mI62,    mUUU}
VM_CABE:={"C¢digo","DescriáÑo","%Venda",  "Tipo"}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
// dbcommit()
dbcloseall()
TIPOCAD:=2 // sub-grupo
return NIL

//-----------------------------------------------------------------------------*
  function fn_mosge(P1)
//-----------------------------------------------------------------------------*
local RT:=transform(P1,masc(13))
if GE_CODGR % 10000 == 0
	RT:=strtran(RT,' ','0')
	RT:=left(RT,2)+space(6)
elseif GE_CODGR % 100 == 0
	RT:='...'+substr(RT,4,2)+'   '
else
	RT:=padl(right(RT,2),8,'.')
end
return RT

*-----------------------------------------------------------------------------*
function CFEP4101() // Rotina de InclusÑo
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEP4100T(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4102() // Rotina de Alteracao
if reclock()
	CFEP4100T(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEP4100T(VM_FL)

local GETLIST  := {},LCONT:=.T.,FILTRO:=''
local DESCR:='Cadastro de Grupos',ORDANT:=indexord()
if TIPOCAD==2
	FILTRO:=dbfilter()
	DESCR :='Cadastro de Sub-Grupos'
	dbsetorder(1)
	set filter to
end
VM_CODGR := pb_zer(GE_CODGR,6)
VM_CODG1 := val(substr(VM_CODGR,1,2))
VM_CODG2 := val(substr(VM_CODGR,3,2))
VM_CODG3 := val(substr(VM_CODGR,5,2))
VM_DESCR := GE_DESCR
VM_PERVEN:= GE_PERVEN
FL1      :=.T.
pb_box(16,18,,,,DESCR)
@17,20 say 'Grupo.........:'    get VM_CODG1 pict masc(11) valid VM_CODG1>0.and.fn_grupos(VM_CODG1,     NIL,     NIL     ) when VM_FL
if TIPOCAD==2
	@18,20 say 'Sub-Grupo.....:' get VM_CODG2  pict masc(11) valid VM_CODG2 > 0.and.fn_grupos(VM_CODG1,VM_CODG2,     NIL,@FL1) when VM_FL
	@19,20 say 'Sub-Sub-Grupo.:' get VM_CODG3  pict masc(11) valid VM_CODG3 > 0.and.fn_grupos(VM_CODG1,VM_CODG2,VM_CODG3     ) when VM_FL.and.FL1
	@20,20 say '% Comissao....:' get VM_PERVEN pict mI62     valid VM_PERVEN>=0 when VM_CODG2+VM_CODG3 > 0
end
@21,20 say 'DescriáÑo.....:'    get VM_DESCR pict masc(01) valid !empty(VM_DESCR)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_CODGR:=VM_CODG1*10000+VM_CODG2*100+VM_CODG3
		replace	GE_CODGR  with VM_CODGR,;
					GE_DESCR  with VM_DESCR,;
					GE_PERVEN with VM_PERVEN
		// dbcommit()
	end
end
if !empty(FILTRO)
	set filter to &FILTRO
end
dbsetorder(ORDANT)
return NIL

*-----------------------------------------------------------------------------*
function CFEP4103() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
local VM_CHAVE:=GE_CODGR
pb_box(20,26,,,,'Pesquisar')

if TIPOCAD==1 // Grupo
	VM_CHAVE:=GE_CODGR/10000
	@21,30 say 'GRUPO.:' get VM_CHAVE pict mI2
	read
	VM_CHAVE:=str(VM_CHAVE*10000,6)
else
	@21,30 say 'SUB-GRUPO.:' get VM_CHAVE pict mI6
	read
	VM_CHAVE:=str(VM_CHAVE,6)
end
setcolor(VM_CORPAD)
dbseek(VM_CHAVE,.T.)
return NIL
*-----------------------------------------------------------------------------*

function CFEP4104() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir GRUPO..: ' + transform(GE_CODGR,masc(13))+'-' +trim(GE_DESCR))
	fn_elimi()
end
dbrunlock()
return NIL
*-----------------------------------------------------------------------------*

function CFEP4105() // Impressao de grupos
local VM_PAG:=0,X,CPO,;
		VM_REL:='Grupos e Sub-Grupos do ESTOQUE'
VM_LAR:= 78
if pb_ligaimp(C15CPP)
	DbGoTop()
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4105A',VM_LAR)
		? space(10) 
		for X:=1 to len(VM_CAMPO)
			CPO:=VM_CAMPO[X]
			??transform(&CPO,VM_MUSC[X]) + space(5)
		next
		pb_brake()
	end
	DbGoTop()
	? replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end

*-------------------------------------------------------------------
function CFEP4105A() // Cabecalho Lista Grupos
*-------------------------------------------------------------------
?space(5)+'Grupo/SubGrupo'+space(4)+padr('Descricao',32)+'%Comis'
?replicate('-',VM_LAR)
return NIL

*-------------------------------------------------------------------
function CFEP4106() // Repasse aos Produtos
*-------------------------------------------------------------------
if GE_CODGR % 10000 > 0
	if pb_sn('Repassar '+transform(GE_PERVEN,mI62)+ '% de comissao para produtos;do grupo '+GE_DESCR)
		select('PROD')
		ordem GRUPO
		dbseek(str(GRUPOS->GE_CODGR,6),.T.)
		while !eof().and.GRUPOS->GE_CODGR == PR_CODGR
			pb_msg('Processando produto ' + str(PR_CODPR,L_P))
			if reclock()
				replace PR_PRVEN with GRUPOS->GE_PERVEN
			end
			dbrunlock()
			dbskip()
		end
		select('GRUPOS')
	end
else
	alert('Repasse de comissao para produtos so com Sub-Grupos')
end
return NIL

*-----------------------------------------------------------------------------*
function FN_GRUPOS(P1,P2,P3,P4)  // Verifica existencia do GRUPO
*-----------------------------------------------------------------------------*
local RT:=dbseek(str(P1*10000,6)) // grupo existe ?
if TIPOCAD=1 // Cadastro de Grupo
	if RT
		pb_msg('Grupo J† Cadastrado')
		RT:=.F.
	else
		RT:=.T.
	end
else // Cadastr de Sub-Grupo
	if !RT
		pb_msg('Grupo n∆o Cadastrado')
		RT:=.F.
	else
		if P2#NIL // sub-grupo
			if !dbseek(str(P1*10000+P2*100,6)) // criar sub-grupo
				P4:=.F.
				@row(),col()+1 say '<<cadastrar>>'
			else
				if P3#NIL	// sub-sub-grupo
					if dbseek(str(P1*10000+P2*100+P3,6))
						pb_msg('SUB-SUB-Grupo j† Cadastrado')
						RT:=.F.
					end
				else
					@row(),col()+1 say GE_DESCR
				end
			end
		else
			@row(),col()+1 say GE_DESCR
		end
	end
end
return(RT)

*----------------------------------------------------------------------------*
