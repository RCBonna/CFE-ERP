*-----------------------------------------------------------------------------*
 static aVariav:= {.T.,0, 0, 0, .F., 0, 500,0,132, 0,'',{} }
 //.................1.2...3..4...5...6...7..8...9 10.11.12
*-----------------------------------------------------------------------------*
#xtranslate lRT      => aVariav\[  1 \]
#xtranslate nX       => aVariav\[  2 \]
#xtranslate nProdPai => aVariav\[  3 \]
#xtranslate nVersao  => aVariav\[  4 \]
#xtranslate lCont    => aVariav\[  5 \]
#xtranslate nAux     => aVariav\[  6 \]
#xtranslate nLimite  => aVariav\[  7 \]
#xtranslate nReg     => aVariav\[  8 \]
#xtranslate VM_LAR   => aVariav\[  9 \]
#xtranslate VM_PAG   => aVariav\[ 10 \]
#xtranslate VM_REL   => aVariav\[ 11 \]
#xtranslate aOPC     => aVariav\[ 12 \]

*-----------------------------------------------------------------------------*
 function CFEPENGE()	// Cadastro de Itens de Engenharia 								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({	'R->PARAMETRO',;
				'R->CODTR'    ,;
				'R->ALIQUOTAS',;
				'C->XOBS'     ,;
				'C->GRUPOS'   ,;
				'C->PROD'     ,;
				'C->ENGPAI'   ,;
				'C->ENGFIL'})
	return NIL
end
select('GRUPOS')
set filter to GRUPOS->GE_CODGR%10000>0

select('PROD')
ORDEM CODIGO
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())

select('ENGPAI')
set relation to str(ENGPAI->ITP_CODPRP,L_P) into PROD
go top

pb_dbedit1('CFEPENG')
VM_CAMPO :=array(fcount())
VM_CABE  :=array(fcount())
afields(VM_CAMPO)

VM_CAMPO[1]:='str(ITP_CODPRP,L_P)+CHR(45)+left(PROD->PR_DESCR,25)'
VM_CABE [1]:='Prod.Pai'
VM_CABE [2]:='Versao'
VM_CABE [3]:='Dt Validad'
VM_CABE [4]:='QtdBase'
VM_CABE [5]:='OBS'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
// dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENG1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
	dbgobottom()
	dbskip()

CFEPENGT(.T.)
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENG2() // Rotina de Alteracao
*-----------------------------------------------------------------------------*
nReg    :=ENGPAI->(RecNo())
nProdPai:=ITP_CODPRP
nVersao :=ITP_VERSAO
nLimite :=ITP_VLIMIT
skip
if nProdPai#ITP_CODPRP
	go nReg
	if reclock()
		CFEPENGT(.F.)
		dbrunlock(recno())
	end
else
	alert('Nao pode alterar formula versao '+str(nVersao,3)+';Existe formula mais Recente.')
	go nReg
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENG3() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
return NIL

//-----------------------------------------------------------------------------*
  function CFEPENG4() // Rotina de Exclusao
//-----------------------------------------------------------------------------*
nProdPai:=ITP_CODPRP
nVersao :=ITP_VERSAO
if Elimina_Reg('Excluir PRODUTO..:'+pb_zer(ITP_CODPRP,L_P)+chr(45)+trim(PROD->PR_DESCR))
	select('ENGFIL')
	dbseek(str(nProdPai,L_P)+str(nVersao,3),.T.)
	while!eof().and.str(nProdPai,L_P)+str(nVersao,3)==str(ITF_CODPRP,L_P)+str(ITF_Versao,3)
		if reclock()
			delete
		end
		skip
	end
	select('ENGPAI')
end
return NIL

//-----------------------------------------------------------------------------*
  function CFEPENG5() // Impressao
//-----------------------------------------------------------------------------*
VM_LAR:=80
VM_PAG:=0
VM_REL:="Lista Prod-Engenharia"
//......1...................2..3..4..5.6
aOPC:={'U',ENGPAI->ITP_CODPRP,'','','',0}
pb_box(18,20,,,,'Selecao')
@19,22 say 'Imprimir Versao..:' get aOPC[1] pict mUUU     valid aOPC[1]$'UT'                           when pb_msg('Opcao : <U>ltima Versao     <T>odas Versoes')
@20,22 say 'Produto..........:' get aOPC[2] pict masc(21) valid empty(aOPC[2]).or.fn_codpr(aOPC[2],78) when pb_msg('Selecione um Produto ou Zero para todos')
read
if iif(lastkey()#K_ESC,pb_ligaimp(I10CPP),.F.)
	select ENGPAI
	go top
	
	if str(aOPC[2],L_P)#str(0,L_P)
		dbseek(str(aOPC[2],L_P),.T.)
	end
	aOPC[5]:=ENGPAI->ITP_CODPRP
	
	while !eof().and.(if(aOPC[2]>0,aOPC[2]==ENGPAI->ITP_CODPRP,.T.))
		if aOPC[1]=='U'
			while !eof().and.aOPC[5]==ENGPAI->ITP_CODPRP
				aOPC[6]:=RecNo()
				skip
			end
			DbGoTo(aOPC[6])
		end
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,'CFEPENG',VM_REL,VM_PAG,'CFEPENG5C',VM_LAR)
		PROD->(dbseek(str(aOPC[5],L_P)))
		? str(ENGPAI->ITP_CODPRP,L_P)
		??'-'+PROD->PR_DESCR
		??space(6)+'Versao:'+pb_zer(ENGPAI->ITP_VERSAO,3)
		select ENGFIL
		dbseek(str(ENGPAI->ITP_CODPRP,L_P)+str(ENGPAI->ITP_VERSAO,3),.T.)
		while !eof().and.	ENGPAI->ITP_CODPRP==ENGFIL->ITF_CODPRP.and.;
								ENGPAI->ITP_VERSAO==ENGFIL->ITF_VERSAO
			PROD->(dbseek(str(ENGFIL->ITF_CODPR,L_P)))
			? space(20)+str(ENGFIL->ITF_CODPR,L_P)
			??space(01)+PROD->PR_DESCR
			??space(01)+transform(ITF_QTDADE,mD42+'9')
			skip
		end
		?replicate('-',VM_LAR)
		select ENGPAI
		skip
		aOPC[5]:=ENGPAI->ITP_CODPRP
	end
	?replicate('-',VM_LAR)
	eject
	pb_deslimp()
end
go top
return NIL

//-----------------------------------------------------------------------------*
function CFEPENG5C()
//-----------------------------------------------------------------------------*
?padr('Cod.Prd',L_P)+' Descricao Produto Pai'
?space(20)+padr('Cod.Prd',L_P)+' Descricao Produto Filho'+space(17)+'Quantidade'
?replicate('-',VM_LAR)
return NIL

//-----------------------------------------------------------------------------*
  function CFEPENGT(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
lCont := .T.
for nX:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(nX),3)
	&VM_Y:=&(fieldname(nX))
next
VMP_VLIMIT:=if(empty(VMP_VLIMIT),500,VMP_VLIMIT)
VMP_VERSAO:=if(VM_FL,1,VMP_VERSAO)
pb_box(06,01,10,78,,'Engenharia Produtos/Pai')
@07,03 say 'C¢d Produto.....:' get VMP_CODPRP  pict masc(21) valid fn_codpr(@VMP_CODPRP,78)       when VM_FL
if !VM_FL
	@07,col()+1 say PROD->PR_DESCR
end
@08,03 say 'Versao..........:' get VMP_VERSAO  pict mI3                                           when EngVersao(VMP_CODPRP,@VMP_VERSAO,VM_FL).and..F.
@08,43 say 'Dt.Inic.Validade:' get VMP_DTVALI  pict mDT      valid VMP_DTVALI>=PARAMETRO->PA_DATA
@09,03 say 'Observacao......:' get VMP_OBS     pict mUUU
@09,43 say 'Qtdade KG Limite:' get VMP_VLIMIT  pict mI3      valid VMP_VLIMIT>0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		lCont := AddRec()
		dbcommit()
	end
	if lCont
		for nX:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &VM_Y
		next
		nLimite :=ITP_VLIMIT
		dbcommit()
		dbskip(0)
		select('ENGFIL')
		set filter to  ITF_CODPRP==ENGPAI->ITP_CODPRP.and.;
							ITF_VERSAO==ENGPAI->ITP_VERSAO
		CFEPENGF(VMP_CODPRP,VMP_VERSAO) // componentes da fórula
		select('ENGPAI')
		set relation to str(ENGPAI->ITP_CODPRP,L_P) into PROD
	end
end
return NIL

*-----------------------------------------------------------------------------*
 function EngVersao(pProdPai,pVersao,pInclui) 
*-----------------------------------------------------------------------------*
lRT    :=.T.
pVersao:=0
SALVABANCO
select ENGPAI
nReg   :=ENGPAI->(RecNo())
ENGPAI->(dbseek(str(pProdPai,L_P),.T.))
while !eof().and.pProdPai==ITP_CODPRP
	pVersao:=ITP_VERSAO
	skip
end
if pInclui#NIL
	if pInclui
		pVersao++ // Nova Versao
	else
		go nReg
		pVersao:=ITP_VERSAO
	end
else
	if pVersao == 0
		alert('Produto sem formula de producao')
		lRT:=.F.
	end
end
RESTAURABANCO
return lRT

*-----------------------------------------------------------------------------*
 static function CFEPENGF(pProdPai,pVersao)
*-----------------------------------------------------------------------------*
setcolor(VM_CORPAD)
set relation to str(ENGFIL->ITF_CODPR,L_P) into PROD
go top
pb_dbedit1('CFEPENGF','IncluiAlteraExclui')
VM_CAMPOF:={'str(ITF_CODPR,L_P)+CHR(45)+left(PROD->PR_DESCR,40)',Fieldname(4)}
VM_CABECF:={'Prod.Filho',                                        'Quantidade Padrao'}
while .T.
	dbedit(11,01,maxrow()-3,maxcol()-1,VM_CAMPOF,'PB_DBEDIT2',,VM_CABECF)
	go top
	nAux:=0
	while !eof()
		nAux+=ITF_QTDADE
		skip
	end
	if str(nLimite,10,3)==str(nAux,10,3)
		exit
	else
		alert('O total deve ser '+str(nLimite,5)+'; Mas vc digitou '+str(nAux,5)+';Fazer o ajuste.')
	end
end
pb_dbedit1('CFEPENG')
set relation to
setcolor(VM_CORPAD)
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGF1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
	dbgobottom()
	dbskip()
CFEPENGFT(.T.)
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGF2() // Rotina de Alteracao
*-----------------------------------------------------------------------------*
if reclock()
	CFEPENGFT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
 function CFEPENGF3() // Excluir Filhos
*-----------------------------------------------------------------------------*
Elimina_Reg('Excluir PRODUTO/Filho :'+pb_zer(ITF_CODPR,L_P)+chr(45)+trim(PROD->PR_DESCR))
return NIL

*-----------------------------------------------------------------------------*
 static function CFEPENGFT(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST := {}
lCont :=.T.
for nX:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(nX),3)
	&VM_Y:=&(fieldname(nX))
next

	VMF_CODPRP :=  ENGPAI->ITP_CODPRP
	VMF_VERSAO :=  ENGPAI->ITP_VERSAO

pb_box(18,30,,,,'Engenharia Produtos/Filhos')
@20,32 say 'C¢d Produto:' get VMF_CODPR   pict masc(21)  valid fn_codpr(@VMF_CODPR,78).and.pb_ifcod2(str(VMF_CODPRP,L_P)+str(VMF_VERSAO,3)+str(VMF_CODPR,L_P),NIL,.F.,1).and.VMF_CODPR#nProdPai;
																			when VM_FL
if !VM_FL
	@20,col()+1 say left(PROD->PR_DESCR,30)
end
@21,32 say 'Quantidade.:' get VMF_QTDADE  pict mD42 +'9' valid VMF_QTDADE>0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn('Incluir/Alterar Prod.Filho ?'),.F.)
	if VM_FL
		lCont := AddRec()
		dbcommit()
	end
	if lCont
		for nX:=1 to fcount()
			VM_Y:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &VM_Y
		next
		dbcommit()
		dbskip(0)
	end
end
return NIL
//-------------------------------------------eof-----------------------------------------\\
