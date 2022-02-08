//-----------------------------------------------------------------------------*
  static aVariav := {0,''}
//...................1,2..3
//-----------------------------------------------------------------------------*
#xtranslate nX     => aVariav\[  1 \]
#xtranslate nULTPD => aVariav\[  2 \]

*-----------------------------------------------------------------------------*
* ORDPFUNC // FUNCOES DO SISTEMA																*
*-----------------------------------------------------------------------------*

#include 'RCB.CH'

*----------------------------------------------------------------------------
function PESQ(P1)
*----------------------------------------------------------------------------
local GETLIST  :={},VM_MASCAR
local VM_INDICE:=&('{||'+strtran(indexkey(),fieldname(P1),'VM_CHAVE')+'}')
VM_CHAVE :=&(fieldname(P1))
VM_MASCAR:=valtype(VM_CHAVE)
VM_MASCAR:=if(VM_MASCAR='C','@K!',if(VM_MASCAR='D','@D',replicate('9',10)))
salvacor(SALVA)
pb_box(20,06)
@21,08 say 'Pesquisar.:' get VM_CHAVE picture VM_MASCAR
read
setcolor(VM_CORPAD)
dbseek(eval(VM_INDICE),.T.)
salvacor(RESTAURA)
return NIL

*----------------------------------------------------------------------------*
function FN_ORDEM(P1,P2)
*----------------------------------------------------------------------------
local RT   := .T.
local TF   :=savescreen(2)
local VM_CAMPO
salvabd(SALVA)
select("ORDEM")
if !dbseek(str(P1,6))
	ordem CLIENTE
	if P2
		set filter to !OR_FLAG
	end
	VM_CAMPO:={'fn_devcli(ORDEM->OR_CODCL)',fieldname(1),fieldname(3),fieldname(5)}
	DbGoTop()
	pb_box(9,20,,,,'Ordem de Producao/Servico')
	dbedit(10,22,17,78,VM_CAMPO,,'','','',' ')
	P1:=fieldget(1)
	RT=.F.
	keyboard chr(if(lastkey()==27,0,13))
	restscreen(2,,,,TF)
	set filter to 
	ordem CODIGO
else
	if !OR_FLAG
		@row(),col()+1 say "-"+substr(fn_devcli(ORDEM->OR_CODCL),1,77-col())
	else
		alert('Ordem ja Fechada')
		if P2
			RT:=.F.
		end
	end
end
salvabd(RESTAURA)
return(RT)

function FN_DEVCLI(P1)
CLIENTE->(dbseek(str(P1,5)))
return left(pb_zer(P1,5)+chr(45)+CLIENTE->CL_RAZAO,25)


*-----------------------------------------------------------------------------*
function ORDPOCINP(P1,P2)
*----------------------------------------------------------------------------
local PROD,X:=0,VM_TOT
//......................SEQ....PROD....DESCRICAO.........QTD.......VLR-U
PROD:=ORDPCHPRO(P1,P2)
X:=1
salvacor(SALVA)
setcolor('W+/G,R/W,,,W+/G')
tone(800,1)
while X>0
	VM_TOT:=0
	aeval(PROD,{|VM_DET1|VM_TOT+=VM_DET1[5]})
	@23,64 say VM_TOT pict masc(2) color 'w+/b'
	pb_msg('Digite os produtos a serem usados',nil,.f.)
	X:=abrowse(12,0,22,79,;
					PROD,;
					{'Sq',     'Prod.','Descricao','Qtdade','Vlr Venda'},;
					{ 2,           L_P,     47-L_P,      10,        15 },;
					{masc(11),masc(21),    masc(1), masc(6),   masc(2) },,;
					'Cadastro de Produtos para Orcamento')
	if X>0
		VM_PROD  :=PROD[X,02]
		VM_QTD   :=PROD[X,04]
		VM_VLVEN :=PROD[X,05]
		VM_VLVENX:=0
		@row(),04 get VM_PROD  pict masc(21)     valid fn_codpr(@VM_PROD,77)
		@row(),53 get VM_QTD   pict masc(06)     valid VM_QTD>=0.and.(VM_VLVENX:=VM_VLVEN)>=0
		@row(),66 get VM_VLVEN pict masc(05)+'9' valid VM_VLVEN>=0 when (VM_VLVEN:=PROD->PR_VLVEN*VM_QTD)>=0.and.VM_QTD>0
		read
		if lastkey()#K_ESC
			PROD[X,2]:=VM_PROD
			PROD[X,3]:=PROD->PR_DESCR
			PROD[X,4]:=VM_QTD
			PROD[X,5]:=VM_VLVEN
			keyboard replicate(chr(K_DOWN),X)
		end
	end
end
return PROD

*-----------------------------------------------------------------------------*
function ORDPOCINS(P1,P2)
local PROD,X:=0,VM_TOT
PROD:=ORDPCHMDO(P1,P2)
X:=1
tone(700,1)
salvacor(SALVA)
setcolor('W+/W,W+/N,,,W+/W')
while X>0
	VM_TOT:=0
	aeval(PROD,{|VM_DET1|VM_TOT+=VM_DET1[5]})
	@23,64 say VM_TOT pict masc(2) color 'w+/b'
	pb_msg('Digite as Atividades a serem usados',nil,.f.)
	X:=abrowse(12,0,22,79,;
					PROD,;
					{'Sq',     'Cod',trim(PARAMORD->PA_DESCR1),'Qtdade','Vlr Total'},;
					{ 2,           L_P,                 47-L_P,      10,        15 },;
					{masc(11),masc(21),                masc(1), masc(6),   masc(2) },,;
					'Cadastro de '+trim(PARAMORD->PA_DESCR1)+' para Orcamento')
	if X>0
		VM_PROD  :=PROD[X,02]
		VM_QTD   :=PROD[X,04]
		VM_VLVEN :=PROD[X,05]
		VM_VLVENX:=0
		@row(),09 get VM_PROD  pict masc(11) valid fn_codigo(@VM_PROD,{'ATIVIDAD',{||ATIVIDAD->(dbseek(str(VM_PROD,2)))},{||ORDP1400T(.T.)},{2,1}})
		@row(),53 get VM_QTD   pict masc(06) valid VM_QTD>=0
		@row(),66 get VM_VLVEN pict masc(05)+'9' valid VM_VLVEN>=0 when (VM_VLVEN:=ATIVIDAD->AT_VLRHR*VM_QTD)>=0.and.VM_QTD>0
		read
		if lastkey()#K_ESC
			PROD[X,2]:=VM_PROD
			PROD[X,3]:=ATIVIDAD->AT_DESCR
			PROD[X,4]:=VM_QTD
			PROD[X,5]:=VM_VLVEN
			keyboard replicate(chr(K_DOWN),X)
		end
	end
end
salvacor(RESTAURA)
return PROD

*----------------------------------------------------------------------------
function ORDPCHPRO(P1,P2)
*----------------------------------------------------------------------------
local PROD:=array(30,7),X:=0
//......................SEQ....PROD....DESCRICAO.........QTD.......VLR-U
aeval(PROD,{|DET|DET[1]:=++X,DET[2]:=0,DET[3]:=space(20),DET[4]:=0,DET[5]:=0,DET[7]:=0})
salvabd(SALVA)
select('ORCADET')
dbseek(str(P1,6),.T.)
X:=1
while !eof().and.P1==OD_CODOC // .and.P2==OD_SEQ
	if OD_TIPO==1 //produtos
		PROD->(dbseek(str(ORCADET->OD_CODPR,L_P)))
		PROD[X,2]:=OD_CODPR
		PROD[X,3]:=PROD->PR_DESCR
		PROD[X,4]:=OD_QTD
		PROD[X,5]:=OD_VLRRE
		PROD[X,6]:=OD_VLRUS
		PROD[X,7]:=recno()
		X++
	end
	dbskip()
end
salvabd(RESTAURA)
return PROD

*----------------------------------------------------------------------------
function ORDPCHMDO(P1,P2)
*----------------------------------------------------------------------------
local PROD:=array(30,7),X:=0
//......................SEQ....PROD....DESCRICAO.........QTD.......VLR-U
aeval(PROD,{|DET|DET[1]:=++X,DET[2]:=0,DET[3]:=space(20),DET[4]:=0,DET[5]:=0,DET[7]:=0})
salvabd(SALVA)
select('ORCADET')
dbseek(str(P1,6),.T.)
X:=1
while !eof().and.P1==OD_CODOC   // .and.P2==OD_SEQ
	if OD_TIPO==2
		ATIVIDAD->(dbseek(str(ORCADET->OD_CODPR,2)))
		PROD[X,2]:=OD_CODPR
		PROD[X,3]:=ATIVIDAD->AT_DESCR
		PROD[X,4]:=OD_QTD
		PROD[X,5]:=OD_VLRRE
		PROD[X,6]:=OD_VLRUS
		PROD[X,7]:=recno()
		X++
	end
	dbskip()
end
salvabd(RESTAURA)
return PROD

*-----------------------------------------------------------------------------*
function FN_GRORCDET(P1,P2)
*----------------------------------------------------------------------------
local VM_FL,X
salvabd(SALVA)
select('ORCADET')
for X:=1 to len(P1)
	VM_FL:=.F.
	if P1[X,7]>0 // regravacao
		DbGoTo(P1[X,7])
		if P1[X,4]>0	// existe produtos
			VM_FL:=.T.
		else
			dbdelete()
		end
	elseif P1[X,4]>0 // novo e existe
		AddRec()
		VM_FL:=.T.
	end
	if VM_FL
		replace 	OD_CODOC with V_CODOC,;
					OD_SEQ   with V_SEQ,;
					OD_CODPR with P1[X,2],;
					OD_TIPO  with P2,;
					OD_QTD 	with P1[X,4],;
					OD_VLRRE with P1[X,5],;
					OD_VLRUS with pb_divzero(P1[X,5],PARAMETRO->PA_VALOR)
	end
next
salvabd(RESTAURA)
// dbcommitall()
return NIL

*----------------------------------------------------------------------------EOF
