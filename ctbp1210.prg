*-----------------------------------------------------------------------------*
function CTBP1210()	//	Criacao de Totais de Lote										*
* Roberto Carlos Bonanomi - Setembro/90													*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'C->PARAMCTB',;
				'C->CTRLOTE'})
	return NIL
end
pb_dbedit1("CTBP121")  && tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_MUSC:={      mI8,   mDT,       mUUU,         mD132,        mD132,         mD132,"Y"}
VM_CABE:={"Nr.Lote","Data","Digitador","Vlr Tot Lote","Lcto Debito","Lcto Credito","F"}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL

*------------------------------------------------------------------------* 
function CTBP1211() && Rotina de Inclus„o
*------------------------------------------------------------------------* 
local ARQ
private VM_DIGIT:=space(10)
while lastkey()#27
	VM_NRLOTE = 0
	VM_DATA   = date()-1
	VM_VLRLT  = 0
	pb_box(17,33,,,,'Selecione')
	@18,35 say padr(VM_CABE[2],14,'.') get VM_DATA              valid year(VM_DATA)==PARAMCTB->PA_ANO.and.ValidaMesContabilFechado(VM_DATA,'CRIAR LOTES')
	@20,35 say padr(VM_CABE[3],14,'.') get VM_DIGIT  pict mUUU  valid !empty(VM_DIGIT)
	@21,35 say padr(VM_CABE[4],14,'.') get VM_VLRLT  pict mI122 valid VM_VLRLT > 0
	read
	setcolor(VM_CORPAD)
	if if(lastkey()#27,pb_sn(),.f.)
		if AddRec()
			VM_NRLOTE:=NovoLote()	
			replace  CL_NRLOTE with VM_NRLOTE,;
						CL_VLRLT  with VM_VLRLT,;
						CL_FECHAD with .F.,;
						CL_DATA   with VM_DATA,;
						CL_DIGIT  with VM_DIGIT
			fn_alote(VM_NRLOTE,.T.)
			select('LOTE')
			close
			select('CTRLOTE')
			dbrunlock(recno())
			dbcommitall()
			Alert('Criado Lote : '+pb_zer(VM_NRLOTE,8))
		end
	end
end
return NIL

*---------------------------------------------------------------------------*
function CTBP1212() // Rotina de Altera‡„o
*------------------------------------------------------------------------* 
local VM_NRLOTE:=CL_NRLOTE,;
		VM_DATA  :=CL_DATA,;
		VM_DIGIT :=CL_DIGIT,;
		VM_VLRLT :=CL_VLRLT

pb_box(17,33)
@18,35 say padr(VM_CABE[1],14)+":"+transform(CL_NRLOTE, mI8)
@19,35 say padr(VM_CABE[2],14)+":" get VM_DATA   pict mDT   valid ValidaMesContabilFechado(VM_DATA,'ALTERAR LOTES')
@20,35 say padr(VM_CABE[3],14)+":" get VM_DIGIT  pict mUUU  valid !empty(VM_DIGIT)
@21,35 say padr(VM_CABE[4],14)+":" get VM_VLRLT  pict mI122 valid VM_VLRLT > 0
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.F.)
	if reclock(120)
		replace  CL_VLRLT with VM_VLRLT,;
					CL_DATA with VM_DATA,;
					CL_DIGIT with VM_DIGIT
	end
end
return NIL

*---------------------------------------------------------------------------*
function CTBP1213() // Rotina de Pesquisa
*------------------------------------------------------------------------* 
local VM_DATA:=month(CL_DATA)
pb_box(20,40)
@21,42 say "Pesquisar Mes.:" get VM_DATA picture mI2
read
setcolor(VM_CORPAD)
dbseek(str(VM_DATA,2),.T.)
return NIL

*---------------------------------------------------------------------------*
function CTBP1214() && Rotina de Exclus„o
*------------------------------------------------------------------------* 
local ARQ:=''
local VM_NRLOTE:=CTRLOTE->CL_NRLOTE
local VM_DATA  :=CTRLOTE->CL_DATA
if reclock().and.pb_sn("Eliminar o LOTE ( "+transform(CL_NRLOTE,mI8)+") ?")
	fn_elimi()
	ARQ:=str(VM_NRLOTE,8)+".DBF"
	ferase(ARQ)
end
dbrunlock()
return NIL

*---------------------------------------------------------------------------*
function CTBP1215() && Rotina de Impress„o
*------------------------------------------------------------------------* 
if pb_ligaimp(chr(18))
	DbGoTop()
	VM_PAG = 0
	VM_REL = "Posicao de Lotes"
	VM_LAR = 80
	while !eof()
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,"CTBP1215A",VM_LAR)
		? " "+str(CL_NRLOTE,8)+" "
		??transform(CL_DATA  , mDT)+" "+CL_DIGIT
		??transform(CL_VLRLT,  mD132)
		??transform(CL_DEBITO, mD132)
		??transform(CL_CREDITO,mD132)+" "
		??if(CL_FECHAD, 'S','N')
		pb_brake()
 	end
	?replicate("-",VM_LAR)
	?"Impresso as "+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*---------------------------------------------------------------------------*
function CTBP1215A()
*------------------------------------------------------------------------* 
? padr(VM_CABE[1],9) +padc(VM_CABE[2],9) +padr(VM_CABE[3],10)
??padl(VM_CABE[4],18)+padl(VM_CABE[5],18)+padl(VM_CABE[6],18)+" S"
?replicate("-",VM_LAR)
return NIL

*---------------------------------------------------------------------------*
//EOF//
*---------------------------------------------------------------------------*
