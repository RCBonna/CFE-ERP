//-----------------------------------------------------------------------------*
  static aVariav := {{}, 0,'T',.F.,'' ,'',.T.}
*.....................1..2..3...4...5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate aLinDet    => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]
#xtranslate LCONT      => aVariav\[  3 \]
#xtranslate lRT	     => aVariav\[  4 \]
#xtranslate cTF	     => aVariav\[  5 \]


*-----------------------------------------------------------------------------*
 function CFEPUNF() // Cadastro unidades - FATORES										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_FLAG:=.T.
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->UNIDADE',;
				'C->UNIDFAT'})
	return NIL
end
DbGoTop()

pb_dbedit1('CFEPUNF')  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_MUSC    :={      mUUU,       mUUU,   mI156 }
VM_CABE    :={'UnidEntr','UnidEstoq',  'Fator'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEPUNF1	() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPUNFT(.T.,space(6),space(6))
end
return NIL

*-------------------------------------------------------------------* 
function CFEPUNF2() // Rotina de Altera‡„o
*-------------------------------------------------------------------* 
if reclock()
	CFEPUNFT(.F.)
end
return NIL

*-------------------------------------------------------------------* 
function CFEPUNFT(VM_FL,pCODUNC,pCODUNE)
*-------------------------------------------------------------------* 
local GETLIST := {}
local VM_Y
LCONT :=.T.
for nX:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(nX),3)
	&VM_Y:=fieldget(nX)
next
if VM_FL  // cadastro novo
	VM_CODUNC:=pCODUNC
	VM_CODUNE:=pCODUNE
end
nX:=15
pb_box(nX++,18,,,,'Cadastro Unidades X Fator')
nX++
@nX++,20 say padr('Un Entrada' ,15,'.') get VM_CODUNC  pict mUUU  valid fn_codigo(@VM_CODUNC,{'UNIDADE',{||UNIDADE->(dbseek(VM_CODUNC))},{||CFEPUNT(.T.)},{2,1}}) when VM_FL
@nX++,20 say padr('Un Estoque' ,15,'.') get VM_CODUNE  pict mUUU  valid fn_codigo(@VM_CODUNE,{'UNIDADE',{||UNIDADE->(dbseek(VM_CODUNE))},{||CFEPUNT(.T.)},{2,1}}) when VM_FL
@nX++,20 say padr('Fator'      ,15,'.') get VM_FATOR   pict mI156 valid VM_FATOR>0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for nX:=1 to fcount()
			VM_Y="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &VM_Y
		next
		// dbcommit()
	end
end
dbrunlock(recno())
return NIL

//-------------------------------------------------------------------* 
 function CFEPUNF3() // Rotina de Pesquisa
//-------------------------------------------------------------------* 
return NIL

//-------------------------------------------------------------------* 
  function CFEPUNF4() && Rotina de Exclus„o
//-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar '+UN_CODUNC+'-'+UN_CODUNE+'?')
	fn_elimi()
end
dbrunlock()
return NIL

//-------------------------------------------------------------------* 
  function CFEPUNF5() // Rotina de Impress„o
return NIL
//-------------------------------------------------------------------*

*-------------------------------------------------------------------*
function ChkUnNFUnEstoque(pUnNF,pUnEST) // valida unidade entrada + unidade estoque
*-------------------------------------------------------------------*
lRT:=.F.
SALVABANCO
select UNIDFAT
if dbseek(pUnNF+pUnEST)
	lRT:=.T.
else
	alert("Unidade entrada "+pUnNF+";Unidade Estoque "+pUnEST+'; Nao cadastrado - sera solicitado cadastro')
	cTF  :=savescreen(12,0,24,79)
	CFEPUNFT(.T.,pUnNF,pUnEST)
	restscreen(12,0,24,79,cTF)
end
RESTAURABANCO
return lRT

*----------------------------------------------------------------------------------------------
 function CRIA_UNNFUNEST(P1,P2)
*------------------------------------------------* UNIDADES DO ESTOQUE X FATOR
local ARQ:='CFEAUNF'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'UN_CODUNC' ,'C',  5,  0},;		// 1-Codigo unidade item (COMPRA)
				 {'UN_CODUNE' ,'C',  5,  0},;		// 2-Codigo unidade item (ESTOQUE-VENDA)
				 {'UN_FATOR'  ,'N', 15,  6}},;	// 3-Fator de conversão * 
				RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Natureza de Operacao - indices
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(ARQ+' UNIDADES DE ENTRADA - ESTOQUE X FATOR - Reg:'+str(LastRec(),7))
		pack
		Index on UN_CODUNC+UN_CODUNE tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end
return NIL

*----------------------------------------------------------EOF---------* 
