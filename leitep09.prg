*-----------------------------------------------------------------------------*
 static aVariav := {0,0,0,{},0,'',0,.T.}
 //.................1.2.3.4..5..6.7..8
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]
#xtranslate nOPC       => aVariav\[  3 \]
#xtranslate aDATA      => aVariav\[  4 \]
#xtranslate nPag       => aVariav\[  5 \]
#xtranslate cRel       => aVariav\[  6 \]
#xtranslate nLar       => aVariav\[  7 \]
#xtranslate lFlag      => aVariav\[  8 \]

*-----------------------------------------------------------------------------*
function LEITEP09()	//	TABELA MUNICIPIOS AURORA
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->CLIENTE',;
				'C->LEIMUNAU'})
	return NIL
end
DbGoTop()

pb_dbedit1('LEITEP09')
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
						 {           mI6, mUUU,    mUUU },;
						 {'CodMunAurora', 'UF', 'Cidade'})
						 //..........1.......2.......3.......
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
function LEITEP091() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FATPLOTET(.T.)
end
return NIL

*-----------------------------------------------------------------------------*
function LEITEP092() // Rotina de Alteracao
if reclock()
	LEITEP09T(.F.)
end
return NIL

*-----------------------------------------------------------------------------*
function LEITEP09T(VM_FL)
*-----------------------------------------------------------------------------*
local GETLIST  := {}
local LCONT    := .T.
for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=&(fieldname(nX))
next
nX:=MaxRow()-6
pb_box(nX++,24,,,,'Informe')
@nX++,25 say 'Cod.Municipio:' get VM_CODMUN pict mI5  valid pb_ifcod2(VM_CODMUN,NIL,.F.,1)   when VM_FL
@nX++,25 say 'Estado(UF)...:' get VM_UF     pict mUUU valid pb_uf(@VM_UF)
@nX++,25 say 'Cidade.......:' get VM_CIDAD  pict mUUU valid !empty(VM_CIDAD)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for nX:=1 to fcount()
			X1:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &X1
		next
	end
	dbcommit()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function LEITEP093() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
nX :=MaxRow()-5
ORDEM ALFA
cChave:=MA_UF+MA_CIDAD
pb_box(nX++,30,,,,'Pesquisa UF+Cidade')
@nX++,32 get cChave pict mUUU
read
setcolor(VM_CORPAD)
dbseek(trim(cChave),.T.)
ORDEM CODIGO
return NIL

*-----------------------------------------------------------------------------*
 function LEITEP094() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Eliminar ( '+MA_UF+'-'+trim(MA_CIDAD)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
 function LEITEP095() // Rotina de impressão
*-----------------------------------------------------------------------------*
NAO()
return NIL

*----------------------------------------------------------------------------------------------
 function LEIMUNAUX(P1,P2)
*------------------------------------------------* Codigos Municipios Aurora
local Arq:='LEIMUNAU'
if P2=='VER ARQUIVOS'.and.;
	dbatual(Arq,;
				{{'MA_CODMUN', 'N',  5, 0},;	// 01-Código Municipio
				 {'MA_UF',     'C',  2, 0},;	// 01-Estado-UF
				 {'MA_CIDAD',	'C', 20, 0}},;	// 02-Cidade
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Natureza de Operacao - indices
if !file(Arq+OrdBagExt()).or.P1
	if net_use(Arq,.T.,20,Arq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. Cod.Municipios Aurora '+Str(LastRec(),7),NIL,.F.)
		pack
		if LastRec()<=0 // Não tem registros
			ImportaMunicAurora()
		end
		Index on str(MA_CODMUN,5) tag CODIGO to (Arq) eval {||ODOMETRO()}
		Index on MA_UF+MA_CIDAD   tag ALFA   to (Arq) eval {||ODOMETRO()}
		close
	end
end
return NIL

*-----------------------------------------------------------------------------*
 static function ImportaMunicAurora() // importar de arquivo CSV
*-----------------------------------------------------------------------------*
cCSVARQ:="MUNAURORA.CSV"
if file(cCSVARQ)
	Append From (cCSVARQ) DELIMITED with ({";",";"})
end
return NIL
//-----------------------EOF
