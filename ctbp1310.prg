//-----------------------------------------------------------------------------*
  static aVariav := {{},"","",  0, {}}
//....................1..2..3...4..5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate dIniFim 	=> aVariav\[  1 \]
#xtranslate cConta	=> aVariav\[  2 \]
#xtranslate cX 		=>	aVariav\[  3 \]
#xtranslate nX 		=>	aVariav\[  4 \]
#xtranslate nSaldo 	=> aVariav\[  5 \]

*-----------------------------------------------------------------------------*
function CTBP1310()	//	LISTAGEM DO BALANCETE											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local 	VM_CTIPO:='S'
local  	VM_MES  :=1
local 	NIVEL   :=9
local 	VM_CTAIN
local 	VM_CTAFI

private	VM_PAG    :=01,;
			VM_FORM   :=80,;
			VM_CTRAFI,;
			VM_CTRAIN,;
			VM_PQB    :={},;
			VM_CQB    :={},;
			VM_TOT    :={},;
			VM_CT     :=0,;
			cArq		:=''

pb_lin4('Impressäo do Balancete Mensal',ProcName())

if !abre({	'R->PARAMCTB',;
				'R->PARAMETRO',;
				'R->CTATIT',;
				'R->CTADET',;
				'R->RAZAO';
			})
	return NIL
end
dIniFim:={BoM(PARAMETRO->PA_DATA),EoM(PARAMETRO->PA_DATA)} // data de inicio e fim 

select('CTADET')
dbsetorder(2)
dbgobottom();VM_CTAFI:=CD_CONTA;VM_CTRAFI:=CD_CTA
DbGoTop();   VM_CTAIN:=CD_CONTA;VM_CTRAIN:=CD_CTA
nX:=14
pb_box(nX++,25,,,,'Selecao')
@nX	,27 say 'Formulario....:' get VM_FORM  pict masc(12)	valid VM_FORM==132.or.VM_FORM==80 when pb_msg('<132>-Colunas ou <80>-Colunas')
@nX++	,col()+2 say 'Colunas'
@nX	,27 say 'Dt Inicial....:'	get dIniFim[1]  picture mDT
@nX++	,56 say 'Dt Final.:'			get dIniFim[2]  picture mDT	valid dIniFim[2]>=dIniFim[1]
//@X++,27 say 'Mês Impressäo.:' get VM_MES   pict mI2      valid fn_mes(VM_MES)
@nX++	,27 say 'Pagina Inicial:'	get VM_PAG   pict mI3			valid VM_PAG>0
@nX++	,27 say 'Conta Inicial.:'	get VM_CTAIN pict MASC_CTB	valid fn_ifcont1(@VM_CTAIN)
@nX++	,33 say       'Final...:'	get VM_CTAFI pict MASC_CTB	valid fn_ifcont1(@VM_CTAFI).and.VM_CTAIN<=VM_CTAFI
@nX++	,27 say 'So Ctas c/Sald:'	get VM_CTIPO pict mUUU		valid VM_CTIPO$'SN'
@nX++	,27 say 'Nivel Impress.:'	get NIVEL    pict mI2			valid NIVEL>0
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	select('CTADET')
	dbseek(VM_CTAIN)
	if pb_ligaimp(RST+if(VM_FORM==80,I15CPP,C15CPP))
		pb_msg('Processando relatório, aguarde...',NIL,.F.)
		cARQ   := ArqTemp(,,'')
		dbcreate(cARQ,{{'WO_DATA','C',150,0}})
		if net_use(cARQ,.T.,20,'WORK',.T.,.F.,RDDSETDEFAULT())
			CTBPBALM(VM_MES,VM_CTIPO,VM_CTAIN,VM_CTAFI,NIVEL,'B',VM_PAG)	// Montar Balancete
			Eject
			pb_deslimp(C15CPP)
		end
	end
end
dbcloseall()
fileDelete (cARQ + '.*')
return NIL

*----------------------------------------------------------------------------*
function CTBPBALM(VM_MES,VM_CTIPO,VM_CTAIN,VM_CTAFI,NIVEL,VTIPO,VM_PAG)
//..............................................................Nro pagina
//........................................................B=só balancete
//........................................................D=a partir do diario
//.......................S=so contas com saldo
//.................
	VM_MES:=month(dIniFim[1])
	select('CTADET')
	dbseek(VM_CTAIN)

	for nX:=1 to VM_LENMAS
		if substr(transform(CD_CONTA,MASC_CTB),nX,1)=='-'
			VM_CT++
			aadd(VM_PQB,nX-1)
			aadd(VM_CQB,left(transform(CD_CONTA,MASC_CTB),nX-1))
			aadd(VM_TOT,{0,0,0}) // SLD ANT/ DEB/ CRED < sub totalizacoes
		end
	next

	aadd(VM_TOT,{0,0,0}) // SLD ANT/ DEB/ CRED << totalizacao conta CT+1
	aadd(VM_TOT,{0,0,0}) // SLD ANT/ DEB/ CRED << totalizacao final CT+2
	
	while !eof().and.CD_CONTA<=VM_CTAFI
		VM_CONTA	:=transform(CD_CONTA,MASC_CTB)
		cConta	:=CD_CONTA
		pb_msg('Classificacao Temporaria..'+VM_CONTA)
		CTBP1312(VM_CTIPO,VTIPO)

		//-------> Total da Conta
		VM_TOT[VM_CT+1,1]	:=fn_SaldoConta(VM_MES-1)	//.Saldo Inicial (mensal)
		VM_TOT[VM_CT+1,1]	+=fn_SomaMovRazao(cConta,dIniFim[1]) // Buscar Valore Razão até Dt Inicial
		nSaldo				:=fn_SomaMovRazaoDC(cConta,dIniFim)
		VM_TOT[VM_CT+1,2]	:=nSaldo[1]	//.DEB
		VM_TOT[VM_CT+1,3]	:=nSaldo[2]	//.CRE

//		VM_TOT[VM_CT+1,2]:=&(fieldname(3+VM_MES*2))	//.DEB
//		VM_TOT[VM_CT+1,3]:=&(fieldname(4+VM_MES*2))	//.CRE

		// .......1º Sub Total
		VM_TOT[VM_CT  ,1]+=VM_TOT[VM_CT+1,1]
		VM_TOT[VM_CT  ,2]+=VM_TOT[VM_CT+1,2]
		VM_TOT[VM_CT  ,3]+=VM_TOT[VM_CT+1,3]

		//.......Soma Final
		VM_TOT[VM_CT+2,1]+=VM_TOT[VM_CT+1,1]
		VM_TOT[VM_CT+2,2]+=VM_TOT[VM_CT+1,2]
		VM_TOT[VM_CT+2,3]+=VM_TOT[VM_CT+1,3]

		if if(VM_CTIPO=='S',abs(VM_TOT[VM_CT+1,1])+abs(VM_TOT[VM_CT+1,2])+abs(VM_TOT[VM_CT+1,3])#0,.T.)
			CTBP1313(strtran(VM_CONTA,'-',' ')+' '+pb_zer(CD_CTA,4)+'-'+space(VM_CT+1)+CD_DESCR+space(1)+FN_TOTAL(VM_CT+1,VM_TOT,VTIPO)) // IMPR
		end
		dbskip()
	end
	VM_CONTA	:=transform(0,MASC_CTB)
	CTBP1312(VM_CTIPO,VTIPO)
	VM_PAG	:=CTBPBALI(VM_MES,NIVEL,VTIPO,VM_PAG)				// imprimir balancete

return (VM_PAG)

*-------------------------------------------------------------------------
static function CTBPBALI(VM_MES,NIVEL,VTIPO,VM_PAG)
*-------------------------------------------------------------------------
	VM_LAR := 110 + VM_LENMAS + VM_CT + 1 - (if(VTIPO='D',26,0))
	VM_REL := 'Balancete de Verificacao - '+DtoC(dIniFim[1])+' ate '+DtoC(dIniFim[2])
	VM_PAG--

	select('WORK')
	Index on left(WO_DATA,VM_LENMAS) to CFEIWO01 // Criar Indice para Tabela Temporária
	DbGoTop()
	pb_msg('Imprimindo, aguarde. <ESC> cancela impressäo.',NIL,.F.)
	if VM_PAG>0
		setprc(64,1)
	end
	VM_Q1:=left(WO_DATA,VM_PQB[1])
	VM_Q2:=left(WO_DATA,VM_PQB[VM_CT])
	while !eof()
		if VM_Q1#left(WO_DATA,VM_PQB[1])
			VM_Q1:=left(WO_DATA,VM_PQB[1])
			?replicate('-',VM_LAR)
			setprc(64,1)
		elseif VM_Q2#left(WO_DATA,VM_PQB[VM_CT])
			VM_Q2:=left(WO_DATA,VM_PQB[VM_CT])
		end
		if VTIPO=='B'
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1310A',VM_LAR)
		else
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CTBP1310B',VM_LAR)
		end
		CONTA :=trim(left(WO_DATA,at('-',WO_DATA)-1))
		if NIVEL>VM_CT
			?left(WO_DATA,VM_LAR)
		elseif len(trim(left(WO_DATA,VM_PQB[NIVEL])))>=len(CONTA)
			?left(WO_DATA,VM_LAR)
		end
		pb_brake()
	end
	?replicate('-',VM_LAR)
	?space(VM_LENMAS+43)+FN_TOTAL(VM_CT+2,VM_TOT,VTIPO) // IMPRES
	?replicate('-',VM_LAR)
	select('WORK')

return (VM_PAG)

*--------------------------------------------------------------------------*
	function CTBP1312(VM_CTIPO,VTIPO) // verifica quebras
*--------------------------------------------------------------------------*
local X
for X:=VM_CT to 1 step -1
	if left(VM_CONTA,VM_PQB[X]) # VM_CQB[X]
		VM_Q1:=padr(strtran(VM_CQB[X],'-',''),VM_MASTAM,'0')
		select('CTATIT')
		if dbseek(VM_Q1)
			VM_Q1:=strtran(transform(padr(strtran(VM_CQB[X],'-',''),VM_MASTAM,' '),MASC_CTB),'-',' ')
			if if(VM_CTIPO=='S',abs(VM_TOT[X,1])+abs(VM_TOT[X,2])+abs(VM_TOT[X,3])#0,.T.)
				CTBP1313(VM_Q1+space(5)+'-'+space(X)+CTATIT->CT_DESCR+space(VM_CT-X+2)+FN_TOTAL(X,VM_TOT,VTIPO))
			end
		end
		if X>1
			VM_TOT[X-1,1]+=VM_TOT[X,1]
			VM_TOT[X-1,2]+=VM_TOT[X,2]
			VM_TOT[X-1,3]+=VM_TOT[X,3]
		end
		VM_TOT[X,1]:=0
		VM_TOT[X,2]:=0
		VM_TOT[X,3]:=0
		select('CTADET')
		VM_CQB[X]:=substr(transform(CD_CONTA,MASC_CTB),1,VM_PQB[X])
	end
next
return NIL

*-----------------------------------------------------------------------------*
	function CTBP1313(VM_P1) // grava linha
*-----------------------------------------------------------------------------*
salvabd()
select('WORK')
dbappend(.T.)
replace WO_DATA with VM_P1
salvabd(.F.)
return NIL

*---------------------------------------------------------------------------*
function CTBP1310A()
*-----------------------------------------------------------------------------*
? padr('Conta',VM_LENMAS,'.')+space(1)+'Redz'+space(2)+'Descricao da Conta'
??space(VM_CT+15)
??'Saldo Anterior' +space(6)
??'Debito Periodo' +space(5)
??'Credit Periodo' +space(6)
??'Saldo Atual'
?replicate('-',VM_LAR)
return NIL

*---------------------------------------------------------------------------*
function CTBP1310B()
*-----------------------------------------------------------------------------*
? padr('Conta',VM_LENMAS,'.')+space(1)+'Redz'+space(2)
??padr('Descricao da Conta',VM_CT+56)
??'Saldo Atual'
?replicate('-',VM_LAR)
return NIL

*-----------------------------------------------------------------------------*
function FN_TOTAL(P1,VM_TOT,TIPO)
*-----------------------------------------------------------------------------*
local VM_RT:=''
if TIPO=='B'
	VM_RT+=fn_dbcr(VM_TOT[P1,1])+space(1)
	VM_RT+=transform(abs(VM_TOT[P1,2]),masc(22))+space(1+if(TIPO=='D',1,0))
	VM_RT+=transform(abs(VM_TOT[P1,3]),masc(22))
else
	VM_RT+=space(20)
end
VM_RT+=space(1)+fn_dbcr(VM_TOT[P1,1]+VM_TOT[P1,2]*DEB+VM_TOT[P1,3]*CRE)
return(VM_RT)
//---------------------------------------------------------eof---------------------*
