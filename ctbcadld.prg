*-----------------------------------------------------------------------------*
function CTBCADLD()	// ATUALIZACAO DE CADASTROS DE LANCAMENTOS DIRETOS
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'hbsix.ch'

pb_tela()
pb_lin4(_MSG_,ProcName())
scroll(6,1,21,78)
if !abre({	'R->PARAMETRO',;
				'R->CTATIT',;
				'C->CTADET',;
				'C->LCTODIR'})
	return NIL
end

DbGoTop()
private VM_GRUPO:=LCTODIR->LD_GRUPO
private VM_TIPO :=LCTODIR->LD_TIPO
@07,01 to 07,78
@06,02 say 'Grupo Contas :' get VM_GRUPO pict mUUU valid !empty(VM_GRUPO).and.if(dbseek(VM_GRUPO),.T.,.T.).and.(VM_TIPO:=LCTODIR->LD_TIPO)>=''
@06,30 say 'Tipo:'          get VM_TIPO  pict mUUU valid VM_TIPO$'CE' when !LCTODIR->LD_TIPO$'EC'.and.pb_msg('<C> Conta       <E> Estrutura')
read
if lastkey()#K_ESC
	cArq:=ArqTemp(,,'')

	SET SCOPE TO VM_GRUPO
	subIndex on LCTODIR->LD_GRUPO to (cArq)

	DbGoTop()
	pb_lin4('Grupo de Lancamento Direto :'+VM_GRUPO,ProcName())
	VM_CAMPO    :={'DESC_CTA(LD_CONTO,1)','DESC_CTA(LD_CONTD,2)','LD_HISTOO','LD_HISTOD'}
	VM_MASC     :={                mXXX,                mXXX,          mXXX,  mXXX}
	VM_CABE     :={        'Cta Origem',       'Cta Destino',   'Historico-Origem','Historico-Destino'}
	pb_dbedit1('CTBCADLD')
	dbedit(08,01,21,78,VM_CAMPO,"PB_DBEDIT2",VM_MASC,VM_CABE)
	dbcloseall()
	deletefile(cArq)
end
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function DESC_CTA(P1,P2) // RETORNA DESCRICAO DA CONTA
*-------------------------------------------------------------------* Fim

local DESCR:=''
CTADET->(dbseek(str(P1,4)))
DESCR:=CTADET->CD_DESCR
if P2==1
	if VM_TIPO=='E'   // Conta
		fn_valest(P1)
		DESCR:=CTATIT->CT_DESCR
	end
end
return (pb_zer(P1,4)+'-'+DESCR)

*-------------------------------------------------------------------* Fim
function fn_LctoDir(P1)
*-------------------------------------------------------------------* Fim
local RT:=.F.
local TF
SALVABANCO
select LCTODIR
ordem GRUPOS
DbGoTop()
if dbseek(P1)
	RT:=.T.
else	
	salvacor()
	DbGoTop()
	TF:=savescreen(5,0)
	pb_box(05,00,22,10,,'Grupos Lancamentos')
	VM_TECLA:=''
	dbedit(06,01,21,08,{fieldname(1)},'FN_TECLAx','','','',' ¯ ')
	P1:=&(fieldname(1))
	RT:=.F.
	restscreen(5,0,,,TF)
	salvacor(.F.)
end
ordem CODIGO
RESTAURABANCO
return RT

*-------------------------------------------------------------------* 
function CTBCADLD1() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CTBCADLDT(.T.)
end
return NIL

*-------------------------------------------------------------------* 
function CTBCADLD2() // Rotina de Altera‡„o
if reclock()
	CTBCADLDT(.F.)
end
return NIL

*-------------------------------------------------------------------* 
function CTBCADLD3() // Rotina de Pesquisa
local VM_CONTO:=LD_CONTO
pb_box(20,40,,,,'Pesquisar')
@21,42 say "CONTA:" get VM_CONTO pict mI4
read
setcolor(VM_CORPAD)
ordem CODIGO
dbseek(VM_GRUPO+str(VM_CONTO,4),.T.)
return NIL

*-------------------------------------------------------------------* 
function CTBCADLD4() // Rotina de Exclus„o
if reclock().and.pb_sn("Eliminar ("+transform(LD_CONTO,mI4)+" "+trim(desc_cta(LD_CONTO,1))+")?")
	fn_elimi()
end
dbrunlock()
return NIL

*-------------------------------------------------------------------* 
function CTBCADLD5() // Rotina de Impress„o
/*
if pb_ligaimp(chr(18))
	DbGoTop()
	VM_PAG := 0
	VM_REL := "Contas Titulo"
	VM_LAR := 80
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1125A",VM_LAR)
		? space(20)+transform(CT_CONTA,MASC_CTB)+" - "+CT_DESCR
		pb_brake()
 	end
	?replicate("-",VM_LAR)
	?"Impresso as "+time()
	eject
	pb_deslimp()
	DbGoTop()
end
*/
return NIL

*-------------------------------------------------------------------* 
function CTBCADLD5A()
*-------------------------------------------------------------------
?space(20)+padr(VM_CABE[1],VM_LENMAS+3)+VM_CABE[2]
?replicate("-",VM_LAR)
return NIL

*-------------------------------------------------------------------* 
function CTBCADLDT(VM_FL)
*-------------------------------------------------------------------
local GETLIST :={}
local VM_CONTA:=space(20)
local LCONT   :=.T.
local X,Y
for X:=3 to fcount()
	Y :='VM'+substr(fieldname(X),3)
	private &Y:=fieldget(X)
next
if empty(VM_HISTOO)
	VM_HISTOO:=padr("PADRAO",60)
end
if empty(VM_HISTOD)
	VM_HISTOO:=padr("PADRAO",60)
end
X:=17
pb_box(X++,3,,,,'Lancamentos Diretos')
if VM_TIPO=='C'
	@X++,5 say padr('Conta Origem', 20,".") get VM_CONTO  pict mI4  valid fn_ifconta(VM_CONTA,@VM_CONTO).and.fn_chkld(VM_CONTO) when VM_FL
else
	@X++,5 say padr('Estrut Origem', 20,".") get VM_CONTO  pict mI1  valid fn_valest(VM_CONTO)
end
@X++,5 say padr('Conta Destino',       20,".") get VM_CONTD  pict mI4  valid VM_CONTO#VM_CONTD.and.pb_ifcod2(VM_GRUPO+str(VM_CONTO,4)+str(VM_CONTD,4),nil,.F.).and.fn_ifconta(VM_CONTA,@VM_CONTD) when VM_FL
@X++,5 say padr('Historico-Origem',    20,".") get VM_HISTOO pict mXXX+'S40' when pb_msg('Use comando #CTA1# (CONTA ORIGEM) e #CTA2# (CONTA DESTINO) p/substituicao no historico')
@X++,5 say padr('Historico-Destino',   20,".") get VM_HISTOD pict mXXX+'S40' when pb_msg('Use comando #CTA1# (CONTA ORIGEM) e #CTA2# (CONTA DESTINO) p/substituicao no historico')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		if empty(VM_HISTOO)
			VM_HISTOO:=padr("PADRAO",60)
		end
		if empty(VM_HISTOD)
			VM_HISTOD:=padr("PADRAO",60)
		end
//		for X:=1 to fcount()
//			Y :='VM'+substr(fieldname(X),3)
//			fieldput(X,&Y)
//		next
		replace ;
				LD_GRUPO  with VM_GRUPO,;	// 1-Conta contabil
				LD_TIPO   with VM_TIPO,;	// 2-Tipo=C/E
				LD_CONTO  with VM_CONTO,;	// 3-Data
				LD_CONTD  with VM_CONTD,;	// 4-Nr Lote
				LD_HISTOO with VM_HISTOO,;	// 5-Historico ORIGEM
				LD_HISTOD with VM_HISTOD	// 6-Historico DESTINO
		dbcommit()
	end
end
dbrunlock(recno())
dbcommit()
return NIL

*-----------------------------------------------------------------------------*
function FN_CHKLD(P1) // Verifica
*-------------------------------------------------------------------
local REG:=recno()
local RT:=.T.
select LCTODIR
ordem CODIGO
dbseek(VM_GRUPO+str(P1,4),.T.)
if P1==LD_CONTO
	alert('Conta J  utilizada como Origem')
	RT:=.F.
end
if RT
	ordem CODINV
	dbseek(VM_GRUPO+str(P1,4),.T.)
	if P1==LD_CONTD
		alert('Conta J  utilizada como Destino')
		RT:=.F.
	end
	ordem CODIGO
end
DbGoTo(REG)
return RT

*-------------------------------------------------------------------
function FN_VALEST(P1) // Verifica
*-------------------------------------------------------------------
local P2:=pb_zer(P1*10000000,8)
local RT:=.T.
SALVABANCO
select CTATIT
if !dbseek(P2)
	if P1>0
		alert('Estrutura nao encontrada')	
	end
	RT:=.F.
end
RESTAURABANCO
return RT
//--------------------------EOF