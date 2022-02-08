*-----------------------------------------------------------------------------*
 static aVariav2:= {0, 0,.T.,''}
 //.................1..2..3..4
*-----------------------------------------------------------------------------*
#xtranslate nReg			=> aVariav2\[  1 \]
#xtranslate nQTD			=> aVariav2\[  2 \]
#xtranslate lRT			=> aVariav2\[  3 \]
#xtranslate cTecla		=> aVariav2\[  4 \]

#DEFINE DEF_CSEP " "+CHR(179)+" "             // define o caracter da coluna
#DEFINE FOOT_SEP CHR(196)+CHR(193)+CHR(196)   // define o caracter do horizontal
#DEFINE HEAD_SEP CHR(196)+CHR(194)+CHR(196)   // define o caracter do horizontal


*-----------------------------------------------------------------------------*
*  CFEPFUNC - Funcoes Gerais																	*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'TBrowse.ch'

*-----------------------------------------------------------------------------------*
function FN_CODIG(P1,P2)
*....................P2=(Arquivo,{||dbseek(str(XXXXX,6))},{||ASAP1200(.T.),{2,1}})
*................ P1=Variavel
*----------------------------------------------------------------------------------*
local VM_TF
local CPO:={}
local X
lRT:=.T.
if !eval(P2[2])
	salvabd(SALVA)
	select(P2[1])
	X:=indexord()
	dbsetorder(P2[4,1])
	DbGoTop()
	salvacor(SALVA)
	VM_TF		:=savescreen(5,0)
	pb_box(05,00,maxrow()-2,maxcol(),'W+/W',P2[1])
	if valtype(P2[3])=='B'
		pb_msg('Para incluir '+P2[1]+'. Press <INS>',NIL,.F.)
		private VM_ROT:=P2[3]
	end
	for VM_RT:=1 to len(P2[4])
		aadd(CPO,fieldname(P2[4,VM_RT]))
	next
	MyDbedit({06,1,maxrow()-2,maxcol()-1},CPO,'FN_TECLAx','','','')
	if P2[4,1]==1
		P1:=&(fieldname(P2[4,1]))
	else
		P1:=&(fieldname(P2[4,2]))
	end
	lRT:=.F.
	keyboard chr(if(lastkey()==K_ESC,0,K_ENTER))
	restscreen(5,0,,,VM_TF)
	salvacor(RESTAURA)
	dbsetorder(X)
	salvabd(RESTAURA)
else
	if P2[4,1]==1
		X:=P2[1]+'->(fieldname('+str(P2[4,2],2)+'))'
	else
		X:=P2[1]+'->(fieldname('+str(P2[4,1],2)+'))'
	end
	@row(),col() say '-'+trim(padr(&(P2[1]+'->'+&X),77-col()))
end
return(lRT)

//-----------------------------------------------------------------------------------------
function MyDbEdit(pPosicao,pColunas)
//-----------------------------------------------------------------------------------------
local oTBrowse
local oTBColumn
local bFieldBlock
local cFieldName
local X
local nKey
local ColFix

cTecla:=''

// Private bColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , { 222,222,222 } , { 192,192,192 } ) }   
// Private fColor := { || if ( This.CellRowIndex/2 == int(This.CellRowIndex/2) , { 0,255,0 } , { 0,0,255 } ) }   
//...................Create TBrowse object

oTBrowse				:= TBrowse():new(pPosicao[1],pPosicao[1],pPosicao[3],pPosicao[4])
oTBrowse:headSep	:= HEAD_SEP  // desenha colunas Horizontais superior
oTBrowse:colSep	:= DEF_CSEP  // desenha colunas Verticais
oTBrowse:footSep	:= FOOT_SEP
oTBrowse:colorSpec:= 'W+/W,W+/R'
*                       1      2       3       4      5       6     7      8     9      10       11      12      13
*oTBrowse:colorSpec :='w+/n+ , W+/BG , W+/B , R+*/W , W*/W+ , RJ/W , W/B , R/N , B+*/W , RW*/W , N+*/W, BG+*/W, RG+*/W'

// add code blocks for navigating the record pointer
oTBrowse:goTopBlock    := {|| DbGoTop() }
oTBrowse:goBottomBlock := {|| DbGoBottom() }
oTBrowse:skipBlock     := {|nSkip| DbSkipper(nSkip) }

// create TBColumn objects and add them to TBrowse object
for X:=1 to len(pColunas) // Nome dos campos a sere criado
	bFieldBlock := FieldBlock( pColunas[X] )
//	oTBColumn   := TBColumn():new( pColunas[X], bFieldBlock )
	oTBColumn   := TBColumn():new( 				, bFieldBlock )
	oTBrowse:addColumn( oTBColumn )
	/*
		************ Mascara das colunas ***********
		oTbc2:picture:="@R (99) 9999-9999"
		oTbc3:picture:="@R (99) 9999-9999"
		oTbc5:picture:="@R (99) 9999-9999"
		*******************************************
	*/
next

*--------------------------- COLUNAS A CONGELAR ----------------------------
ColFix := 1              // atraves de variaval colfix
oTBrowse:freeze := ColFix

// display browser and process user input
do while .T.
	oTBrowse:forceStable()
	nKey := Inkey(0)
	if oTBrowse:applyKey( nKey ) == TBR_EXIT
		exit
	//elseif 
	
   end
end
return NIL
*-------------------------------------------------------------------------------------------------
// oTBrowse:refreshall()
*----------------------------------------------------EOF------------------------------------------
