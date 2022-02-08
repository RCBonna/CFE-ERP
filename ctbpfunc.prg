//-----------------------------------------------------------------------------*
  static aVariav := {.T.,"","",  0, 0, {},0}
//....................1...2..3...4..5...6.7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate RT =>				aVariav\[  1 \]
#xtranslate TF =>				aVariav\[  2 \]
#xtranslate cX =>				aVariav\[  3 \]
#xtranslate nX =>				aVariav\[  4 \]
#xtranslate nSaldo =>		aVariav\[  5 \]
#xtranslate nSaldoDC =>		aVariav\[  6 \]
#xtranslate nRegistro =>	aVariav\[  7 \]

*-----------------------------------------------------------------------------*
* CTBPFUNC - Funcoes exclusivas do sistema de Contabilidade							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

*-------------------------------------------------------------------------*
	function FN_IFCONTA(VM_P1,VM_P2) // -> SELECAO POR DBEDIT CONTA
*-------------------------------------------------------------------------*
RT:=.T.
TF:=""
cX:=""
salvabd()
select('CTADET')
if !dbseek(str(VM_P2,4))
	TF:=savescreen()
	dbsetorder(3)
	DbGoTop()
	salvacor()
	pb_box(5,26,,,,'Cadastro de Contas')
	set function 10 to '(-)'
	set key K_F9 to FN_CTNIVEIS()
	private VM_ROT:={||CTBP1130T(.T.)},VM_TECLA:=""
	pb_msg('Press <INS> para incluir uma nova CONTA, F9=Niveis da conta e F10=(-)',NIL,.F.)
	dbedit(6,27,21,78,{fieldname(3),fieldname(2),fieldname(1)},'FN_TECLAx',{masc(1),masc(3),MASC_CTB},"","")
	set function 10 to
	set key K_F9 to
	salvacor(.F.)
	restscreen(,,,,TF)
	RT:=.F.
	keyboard chr(if(lastkey()==27,0,13))
	dbsetorder(1)
else
	cX:='-('+trim(transform(CD_CONTA,MASC_CTB))+")-"+CD_DESCR
	@row(),col()+1 say left(cX,77-col())
end
VM_P1:=CD_CONTA
VM_P2:=CD_CTA
salvabd(.F.)
return(RT)

*-------------------------------------------------------------------------*
	function FN_CTNIVEIS() // -> MOSTRA NIVEIS DE CONTAS
*-------------------------------------------------------------------------*
local VM_CPO:={},;
		VM_P1 :=CD_CONTA,; // CONTA CONTABIL
		VM_W  := 0

RT :=.F.
TF :=savescreen(5)

salvabd(SALVA)
select('CTATIT')
for nX:=1 to len(VM_P1)
	VM_P2:=left(VM_P1,nX)
	if dbseek(padr(VM_P2,len(VM_P1),'0')).and.if(VM_W>0,padr(VM_P2,len(VM_P1),'0')#VM_CPO[VM_W,1],.T.)
		aadd(VM_CPO,{CT_CONTA,space(VM_W)+CT_DESCR})
		VM_W++
	end
next
salvabd(RESTAURA)
aadd(VM_CPO,{CD_CONTA,space(VM_W)+CD_DESCR})
abrowse(5,0,16,55,VM_CPO,{'Conta','Descri‡„o'},{VM_LENMAS,38},{MASC_CTB,masc(1)})
restscreen(5,,,,TF)
return NIL

*---------------------------------------------------------------------------
	function FN_IFCONT1(VM_P1) // -> SELECAO POR DBEDIT CONTA
*-------------------------------------------------------------------------*
local ORDANT
local CPO:=array(3)
local OPC
RT:=.T.
TF:=savescreen(9)
salvabd(SALVA)
select('CTADET')
ORDANT:=indexord()
dbsetorder(2)
if !dbseek(VM_P1)
	OPC:=alert('Sele‡Æo das Contas Contabeis, por ',{'REDUZIDA','ESTRUTURADA','ALFABETICA'})
	dbsetorder(if(OPC==0,3,OPC))
	DbGoTop()
	afields(CPO)
	salvacor(SALVA)
	pb_box(9,26,,,,'Sele‡Æo das Contas')
	dbedit(10,27,21,78,CPO,'FN_TECLAx',{MASC_CTB,'@9','@XS40'},'','',' ')
	VM_P1:=CD_CONTA
	salvacor(RESTAURA)
	restscreen(9,,,,TF)
	RT:=.F.
	keyboard chr(if(lastkey()==27,0,13))
else
	@row(),col() say '-'+substr(CTADET->CD_DESCR,1,77-col())
end
dbsetorder(ORDANT)
salvabd(RESTAURA)
return(RT)

*---------------------------------------------------------------------------
	function FN_CTA(VM_P1)
*-------------------------------------------------------------------------*
RT:=.T.
for nX :=1 to len(VM_P1)
	if substr(VM_P1,nX,1)<"0".or.substr(VM_P1,nX,1)>"9"
		RT := .F.
		pb_msg("Conta com elemento estranho na sua composicao",1,.T.)
		exit
	end
next
return(RT)

*--------------------------------------------------------------------------
	function FN_ALOTE(NRLOTE,CRIA)  // -> Abertura de lotes
*-------------------------------------------------------------------------*
local ARQ:=pb_zer(NRLOTE,8)
CRIA:=if(CRIA==NIL,.F.,CRIA)
if CRIA
	ferase(ARQ+'.DBF')
end
*-----------------------------------------------------------------------* Lote
if dbatual(ARQ,;
			{{'LO_CONTA' ,'C',VM_MASTAM, 0},;	//		Conta Contabil
			 {'LO_CTA'   ,'N',        4, 0},;	//		Conta REDUZ    
			 {'LO_CONTRA','C',VM_MASTAM, 0},;	//		Conta Contabil Contrapart
			 {'LO_CTRA'  ,'N',        4, 0},;	//		Conta REDUZ Contrapartida
			 {'LO_VALOR' ,'N',       15, 2},;	//		Valor do Lcto
			 {'LO_HISTOR','C',       60, 0},;	//		Historico
			 {'LO_TPLCTO','C',        1, 0},;	//		TIPO LANCAMENTO = ' '/'E'
			 {'LO_DOCTO', 'C',       20, 0}},;	// 	DOCUMENTO			 
			 RDDSETDEFAULT())
end
return(net_use(ARQ,.T.,20,'LOTE',.T.,.F.,RDDSETDEFAULT()))

*--------------------------------------> Atualiza Contas Detalhes
	function FN_ATCTA(VM_CONTA,VM_VALOR,VM_DT)
*-------------------------------------------------------------------------*
local ORDANT
SALVABANCO
select('CTADET')
ORDANT:=IndexOrd()
dbsetorder(2)
if dbseek(VM_CONTA)
	while !RecLock(120);end
	if VM_VALOR>0 //.................................. Debito
		VM_PER:="CD_DEB_"+pb_zer(month(VM_DT),2)
	else	//.......................................... Credito
		VM_PER:="CD_CRE_"+pb_zer(month(VM_DT),2)
	end
	replace &VM_PER with &VM_PER+abs(VM_VALOR)
	dbrunlock(RecNo())
end
dbsetorder(ORDANT)
RESTAURABANCO
return NIL

*-----------------------------------------------------> Movimentação Razao
	function ChkMovRazao(pConta)
*-------------------------------------------------------------------------*
RT:=.T.
SALVABANCO
select('RAZAO')
if RAZAO->(dbseek(pConta,.T.))
	RT:=.F.
	Alert('Conta Contabil '+pConta+;
			';tem lancamentos no Diario/Razao;Nao pode ser modificada deve ser;alterada no Diario/Razao')
end
RESTAURABANCO
return RT

*--------------------------------------------------------> Atualiza Razao
	function FN_ATRAZ(VM_CONTA,VM_VALOR,VM_DT,VM_NRLOTE,VM_HISTOR,pDocto)
*-------------------------------------------------------------------------*
pDocto:=if(pDocto==NIL,'',pDocto)
salvabd()
select('RAZAO')
if !empty(VM_CONTA)
	if AddRec(120)
		replace  RZ_CONTA  with VM_CONTA,;
					RZ_DATA   with VM_DT,;
					RZ_NRLOTE with VM_NRLOTE,;
					RZ_HISTOR with VM_HISTOR,;
					RZ_VALOR  with VM_VALOR,;
					RZ_DOCTO  with pDocto
		dbrunlock(RecNo())
		dbcommit()
	end
end
salvabd(.F.)
return NIL

*---------------------------------------> Calcula Saldo da Conta ate o mes
	function fn_SaldoConta(pMes)
*-------------------------------------------------------------------------*
salvabd(SALVA)
select('CTADET')
nSaldo:=CD_SLD_IN
for nX:=1 to pMes // Mes -1
	VM:="CD_DEB_"+pb_zer(nX,2)
	nSaldo+=&VM*DEB
	VM:="CD_CRE_"+pb_zer(nX,2)
	nSaldo+=&VM*CRE
next
salvabd(RESTAURA)
return(nSaldo)

*---------------------------------------> Calcula Movimentação Razão------*
	function fn_SomaMovRazao(pConta,pData)
*-------------------------------------------------------------------------*
salvabd(SALVA)
select('RAZAO')
nRegistro:=RecNo() // Salvar Registro Inicial do Razão
nSaldo	:=0 // Valor Inicial
dbseek(pConta+DtoS(BoM(pData)),.T.) // Pegar movimentação (inicio Mes -> até o dia)
while !eof().and.RZ_CONTA==pConta.and.RZ_DATA<pData
	nSaldo+=RZ_VALOR // Soma valor a Débido + Crédito
	dbskip()
end
DbGoTo(nRegistro) // Voltar ao registro Inicial
salvabd(RESTAURA)
return(nSaldo)

*---------------------------------------> Retornar Vlr Deb/Cred Período_--*
	function fn_SomaMovRazaoDC(pConta,pData)
*-------------------------------------------------------------------------*
salvabd(SALVA)
select('RAZAO')
nRegistro:=RecNo() // Salvar Registro Inicial do Razão
nSaldoDC	:={0,0} // Valor D/C Inicial
DBseek(pConta+DtoS(pData[1]),.T.) // Pegar movimentação (Dia -> até o dia)
while !eof().and.RZ_CONTA==pConta.and.RZ_DATA<=pData[2]
	nSaldoDC[if(RZ_VALOR>0,1,2)]+=abs(RZ_VALOR)	//....1-Débito(>0) 2-Crédito(<0)
	DBskip()
end
DbGoTo(nRegistro) // Voltar ao registro Inicial
salvabd(RESTAURA)
return(nSaldoDC)

*-----------------------------------------------------------------------------
	function FN_MASC(VM_MUSC)
*-------------------------------------------------------------------------*
RT:=.T.
for nX:=1 to len(VM_MUSC)
	if substr(VM_MUSC,nX,1)$"9- "
		loop
	else
		pb_msg("Mascara com formato errado.",2)
		RT:=.F.
	end
next
return(RT)

*-------------------------------------------------------------------------*
	function FN_MES(VM_P1)
*-------------------------------------------------------------------------*
RT:=.F.
if VM_P1>0.and.VM_P1<13
	@row(),col()+1 say "- "+pb_mesext(VM_P1)
	RT:=.T.
end
return(RT)

*-----------------------------------------------------------------------------*
	function FN_DBCR(VM_P1)
return(transform(abs(VM_P1),masc(2))+' '+if(VM_P1<0,'C',if(VM_P1>0,'D',' ')))

*----------------------------------------------------------------------------*
// Atual saldo das Contas - 	P1 - Data
//										P2 - Conta
//										P3 - Valor
//										P4 - Historico
//										P5 - Docto
*-------------------------------------------------------------------------*
	function FN_ATDIARIO(pData,pCtaCtb,pValor,pHist,pCodDocCtb)
*-------------------------------------------------------------------------*
//alert('CONTABILIZACAO; Data='+dtoc(pData)+';Conta='+str(pCtaCtb,4)+';Valor='+str(pValor,15,2)+';Hist.='+pHist+';Numer='+pCodDocCtb)
if str(pCtaCtb,15,2)<>str(0,15,2).and.;
	str(pValor,15,2) <>str(0,15,2).and.;
	PARAMETRO->PA_CONTAB==USOMODULO
	SALVABANCO
	select 'DIARIO'
	while !AddRec();end
	fieldput(1,pData)
	fieldput(2,pCtaCtb)
	fieldput(3,pValor)
	fieldput(4,pHist)
	fieldput(5,pCodDocCtb)
	dbrunlock(RecNo())
	RESTAURABANCO
end
return NIL

*-------------------------------------------------------------------------*
	function NovoLote() // Buscar próximo número de lote contábil..........*
*-------------------------------------------------------------------------*
SALVABANCO
select('PARAMCTB')
while !RecLock();end
replace PARAMCTB->PA_SEQLOT with PARAMCTB->PA_SEQLOT + 1 // Novo número de lote
dbrunlock(RecNo())
RESTAURABANCO
return (PARAMCTB->PA_SEQLOT)

*-------------------------------------------------------------------------*
	function ValidaMesContabilFechado(pData,pDescr)
*-------------------------------------------------------------------------*
if year(pData)==PARAMCTB->PA_ANO
	if month(pData)<=MESCTBFECHADO
		alert('A L E R T A - '+pDescr+';A contabilizacao para este Mes informado '+;
				DtoC(pData)+';ja esta fechado no Sistema Contabil ('+pb_zer(MESCTBFECHADO,2)+;
				');VERIFICAR COM RESPONSAVEL.')
		return (.F.)
	end
else
	Alert('A L E R T A - '+pDescr+';O esta data '+DtoC(pData)+;
			' nao e compativel com ano CONTABIL '+str(PARAMCTB->PA_ANO,4)+;
			';Rever....')
	return (.F.)
end
return (.T.)
//-------------------------------------------------------*EOF*---------------*
