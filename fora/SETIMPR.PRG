*-----------------------------------------------------------------------------*/
* Manutencao de Impressoras
* Neste programa temos :
* Funcao SETIMPR()	-  Criar a primeira Impressora e colocando-a como padrao
* Funcao SELEIMPR()	-  Muda a Impressao Padrao
* Funcao IMPNOVO()	-  Inclui/Altera/Exclui impressora no Cadastro
*-----------------------------------------------------------------------------*/
static IMPR:={}
static ARQ:='PRINTER.CFG'

function SETIMPR()
#include 'INKEY.CH'
local REG

if !file(ARQ)
	dbcreate(ARQ,{	{'DESCR' , 'C', 35,0},;
						{'STATUS', 'L',  1,0},;// impr selecionada
						{'RST',    'C', 50,0},;// 01-RESETAR IMPRESSORA
						{'I5CPP',  'C', 50,0},;// 02-EXPANDIDO   5 CPP
						{'C5CPP',  'C', 50,0},;// 03-CANCELA EXPANDIDO   5 CPP
						{'I10CPP', 'C', 50,0},;// 04-NORMAL     10 CPP
						{'I12CPP', 'C', 50,0},;// 05-COMPACTADO 12 CPP
						{'C12CPP', 'C', 50,0},;// 06-CANCELA COMPACTADO 12 CPP
						{'I15CPPP', 'C',50,0},;// 07-COMPACTADO 15 CPP
						{'C15CPP', 'C', 50,0},;// 08-CANCELA COMPACTADO 15 CPP
						{'I20CPPP', 'C',50,0},;// 09-COMPACTADO 20 CPP
						{'C20CPP', 'C', 50,0},;// 10-CANCELA COMPACTADO 20 CPP
						{'INEGR',  'C', 50,0},;// 11-NEGRITO    
						{'CNEGR',  'C', 50,0},;// 12-CANCELA NEGRITO
						{'IITALI', 'C', 50,0},;// 13-ITALICO
						{'CITALI', 'C', 50,0},;// 14-CANCELA ITALICO
						{'I6LPP',  'C', 50,0},;// 15-1/6 LPP
						{'I8LPP',  'C', 50,0},;// 16-1/6 LPP
						{'I33LPPPP','C',50,0},;// 17-33 LINHAS POR PAGINA
						{'I44LPP', 'C', 50,0},;// 18-44 LINHAS POR PAGINA
						{'I66LPP', 'C', 50,0},;// 19-66 LINHAS POR PAGINA
						{'I88LPP', 'C', 50,0},;// 20-88 LINHAS POR PAGINA
						{'IESP1',  'C', 50,0},;// 21-44 Impr Especial 1
						{'CESP1',  'C', 50,0},;// 22-66 Canc Especial 1
						{'IESP2',  'C', 50,0},;// 23-44 Impr Especial 2
						{'CESP2',  'C', 50,0},;// 24-66 Canc Especial 2
						{'IESP3',  'C', 50,0},;// 25-44 Impr Especial 3
						{'CESP3',  'C', 50,0},;// 26-66 Canc Especial 3
						{'IESP4',  'C', 50,0},;// 27-44 Impr Especial 4
						{'CESP4',  'C', 50,0}},; // 28-66 Canc Especial 4
						RDDSETDEFAULT())

	if !net_use(ARQ,.T.,,'IMPRESS',,.F.,RDDSETDEFAULT())
		pb_msg('Arquivo '+ARQ+' n„o pode ser aberto.',3,.T.)
		quit
	else
		if lastrec()<1
			dbappend()
			replace  DESCR		with "PADRAO EPSON FX",;
						STATUS	with .T.,;
						RST		with 'chr(27)+"@"',;
						I5CPP		with 'chr(14)',;
						C5CPP		with 'chr(20)',;
						I10CPP	with 'chr(18)',;
						I12CPP	with 'chr(27)+"M"',;
						C12CPP	with 'chr(27)+"P"',;
						I15CPPP	with 'chr(15)',;
						C15CPP	with 'chr(18)',;
						I20CPPP	with 'chr(27)+"M"+chr(15)',;
						C20CPP	with 'chr(27)+"P"+chr(18)',;
						INEGR		with 'chr(27)+"E"',;
						CNEGR		with 'chr(27)+"F"',;
						IITALI	with 'chr(27)+"E"',;
						CITALI	with 'chr(27)+"F"',;
						I6LPP		with 'chr(27)+"2"',;
						I8LPP		with 'chr(27)+"0"',;
						I33LPPPP	with 'chr(27)+"C"+chr(33)',;
						I44LPP	with 'chr(27)+"C"+chr(44)',;
						I66LPP	with 'chr(27)+"C"+chr(66)',;
						I88LPP	with 'chr(27)+"C"+chr(88)'
		end
		close
	end
end
if !net_use(ARQ,.F.,,'IMPRESS',,.F.,RDDSETDEFAULT())
	pb_msg('Arquivo '+ARQ+' n„o pode ser aberto.',3,.t.)
	quit
end
if lastrec()<1
	pb_msg('Problemas com o arquivo de impressao.Elimine '+ARQ,3,.T.)
	quit
end
IMPR:={}
REG :=0
dbgoto(1)
dbeval({||REG:=recno()},{||IMPRESS->STATUS})
if REG==0
	dbgoto(1)
	REG:=recno()
end
dbgoto(REG)
for REG:=3 to fcount()
	aadd(IMPR,{trim(fieldget(REG))})
next
close
return NIL

*-----------------------------------------------------------------------------*
function SELEIMPR()
*-----------------------------------------------------------------------------*

local TOTPRO:={}
local VM_OPC:=1
local X
local VM_MASC
local VM_CAB
local VM_TAM
local VM_TOPO
local REG

if !net_use(ARQ,.F.,,'IMPRESS',,.F.,RDDSETDEFAULT())
	pb_msg('Arquivo '+ARQ+' n„o pode ser aberto.',3,.t.)
	return NIL
end
dbgotop()
while !eof()
	aadd(TOTPRO,{IMPRESS->DESCR,if(IMPRESS->STATUS,'Selecionada',space(11))})
	dbskip()
end
while	VM_OPC>0
	VM_MASC:={        '@X',       '@X'}
	VM_CAB :={'Impressora', 'Situa‡„o'}
	VM_TAM :={          35,        11 }
	VM_TOPO:=19-len(TOTPRO)
	setcolor('W+/BR,R/W,,,W+/BR')
	VM_OPC:=abrowse(VM_TOPO,30,22,maxcol(),TOTPRO,VM_CAB,VM_TAM,VM_MASC,,'Sele‡„o de Impressoras')
	if VM_OPC>0
		aeval(TOTPRO,{|DET|DET[2]:=space(11)})
		TOTPRO[VM_OPC,2]='Selecionada'
	else
		dbgotop()
		dbeval({||IMPRESS->STATUS:=.F.},{||reclock()})
		for X:=1 to len(TOTPRO)
			if !empty(TOTPRO[X,2])
				dbgoto(X)
				if reclock()
					replace	IMPRESS->STATUS	with .T.
					IMPR:={}
					for REG:=3 to fcount()
						aadd(IMPR,{fieldget(REG)})
					next
				end
			end
		next
	end
end
close
return NIL

*-----------------------------------------------------------------------------*
function IMPNOVO()	//Inclui novas impressoras
*-----------------------------------------------------------------------------*
local VM_CAMPO
local VM_CAB
local VM_TAM
local VM_MASC

#include 'IMPR.CH'
pb_tela('Manuten‡„o de Impressoras','1.0','Pomelle Frutas S/A')

if !net_use(ARQ,.F.,,'IMPRESS',,.F.,RDDSETDEFAULT())
	pb_msg('Arquivo '+ARQ+' n„o pode ser aberto.',3,.t.)
	quit
end
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)
VM_CAMPO[2]:="if(IMPRESS->STATUS,'Selecionada',space(11))"
VM_MASC:={        '@X',      '@X', '@X',   '@X',   '@X',    '@X',    '@X',    '@X',    '@X',    '@X',    '@X',    '@X',   '@X',   '@X',    '@X',    '@X',   '@X',   '@X',    '@X',    '@X',    '@X',    '@X',   '@X',   '@X',   '@X',   '@X',   '@X',   '@X',   '@X',   '@X'}
VM_CAB :={'Impressora','Situa‡„o','RST','I5CPP','C5CPP','I10CPP','I12CPP','C12CPP','I15CPPP','C15CPP','I20CPPP','C20CPP','INEGR','CNEGR','IITALI','CITALI','I6LPP','I8LPP','I33LPPPP','I44LPP','I66LPP','I88LPP','IESP1','CESP1','IESP2','CESP2','IESP3','CESP3','IESP4','CESP4'}
pb_dbedit1('IMPNOVO','IncluiAlteraExclui')

dbedit(06,01,21,78,VM_CAMPO,'PB_DBEDIT2',VM_MASC,VM_CAB)
close
return NIL

function IMPNOVO1()	//	Rotina de Inclus„o
while lastkey()#27
	dbgobottom()
	dbskip()
	IMPNOVOT(.T.)
end
return NIL

function IMPNOVO2()	//	Rotina de Alteracao
if reclock()
	IMPNOVOT(.F.)
end
return NIL

function IMPNOVOT( VM_FL )
local GETLIST:={},X,X1,LCONT:=.T.
for X=1 to fcount()
	X1='VM_'+fieldname(X)
	&X1=&(fieldname(X))
next
pb_box(05,00,,,,'Cadastro de Impressoras')
@06,01 say 'Impressora.....:'	get VM_DESCR 		picture '@X' valid !empty(VM_DESCR)
@07,01 say 'Reseta.........:'	get VM_RST			picture '@X+S21'
@08,01 say 'Impr.05 cpp....:'	get VM_I5CPP		picture '@X+S21'
@08,40 say 'Canc.05 cpp....:'	get VM_C5CPP		picture '@X+S21'
@09,01 say 'Impr.10 cpp....:'	get VM_I10CPP		picture '@X+S21'
@10,01 say 'Impr.12 cpp....:'	get VM_I12CPP		picture '@X+S21'
@10,40 say 'Canc.12 cpp....:'	get VM_C12CPP		picture '@X+S21'
@11,01 say 'Impr.15 cpp....:'	get VM_I15CPPP		picture '@X+S21'
@11,40 say 'Canc.15 cpp....:'	get VM_C15CPP		picture '@X+S21'
@12,01 say 'Impr.20 cpp....:'	get VM_I20CPPP		picture '@X+S21'
@12,40 say 'Canc.20 cpp....:'	get VM_C20CPP		picture '@X+S21'
@13,01 say 'Impr.Negrito...:'	get VM_INEGR		picture '@X+S21'
@13,40 say 'Canc.Negrito...:'	get VM_CNEGR		picture '@X+S21'
@14,01 say 'Impr.Italico...:'	get VM_IITALI		picture '@X+S21'
@14,40 say 'Canc.Italico...:'	get VM_CITALI		picture '@X+S21'
@15,01 say 'Impr.06 lpp....:'	get VM_I6LPP		picture '@X+S21'
@15,40 say 'Impr.08 lpp....:'	get VM_I8LPP		picture '@X+S21'
@16,01 say 'Impr.33 lpp....:'	get VM_I33LPPPP	picture '@X+S21'
@16,40 say 'Impr.44 lpp....:'	get VM_I44LPP		picture '@X+S21'
@17,01 say 'Impr.66 lpp....:'	get VM_I66LPP		picture '@X+S21'
@17,40 say 'Impr.88 lpp....:'	get VM_I88LPP		picture '@X+S21'
@18,01 say 'Impr.Especial 1:'	get VM_IESP1		picture '@X+S21'
@18,40 say 'Canc.Especial 1:'	get VM_CESP1		picture '@X+S21'
@19,01 say 'Impr.Especial 2:'	get VM_IESP2 		picture '@X+S21'
@19,40 say 'Canc.Especial 2:'	get VM_CESP2 		picture '@X+S21'
@20,01 say 'Impr.Especial 3:'	get VM_IESP3 		picture '@X+S21'
@20,40 say 'Canc.Especial 3:'	get VM_CESP3 		picture '@X+S21'
@21,01 say 'Impr.Especial 4:'	get VM_IESP4 		picture '@X+S21'
@21,40 say 'Canc.Especial 4:'	get VM_CESP4		picture '@X+S21'
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for X=1 to fcount()
			X1='VM_'+fieldname(X)
			replace &(fieldname(X)) with &X1
		next
	end
end
return NIL

*-----------------------------------------------------------------------------*
function IMPNOVO3()	//	Rotina de Exclusao
if recno() >2
	if reclock().and.pb_sn('Excluir Impressora '+IMPRESS->DESCR+'?')
		dbdelete()
	end
	if fillock()
		pack
	end
	dbrunlock()
else
	alert('Essa impressora n„o pode ser Excluida')
end
return NIL

*-----------------------------------------------------------------------------*
function IMPR(P1)
return(&(IMPR[P1]))

*-----------------------------------------------------------------------------*/
