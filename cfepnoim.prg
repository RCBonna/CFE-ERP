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
 function CFEPNOIM() // Cadastro CFOP x Produto											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_FLAG:=.T.
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->PROD',;
				'C->NATOP',;
				'C->FISACOF',;
				'C->CFEAPRI'})
	return NIL
end
SELECT PROD
ORDEM CODIGO
SELECT CFEAPRI
set relation to str(CFEAPRI->PRI_CODPR,L_P) into PROD

DbGoTop()

pb_dbedit1('CFEPNOIM')  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)
VM_CAMPO[02]:="str(PRI_CODPR,L_P)+'-'+left(PROD->PR_DESCR,30)"

VM_MUSC    :={  mNAT,     mUUU,       mUUU,  mUUU }
VM_CABE    :={'CFOP','Produto',  'Entrada','Saida'}

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEPNOIM1	() // Rotina de Inclus„o
*-------------------------------------------------------------------* Fim
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPNOIMT(.T.)
end
return NIL

*-------------------------------------------------------------------* 
function CFEPNOIM2() // Rotina de Altera‡„o
*-------------------------------------------------------------------* 
if reclock()
	CFEPNOIMT(.F.)
end
return NIL

*-------------------------------------------------------------------* 
  function CFEPNOIMT(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {}
local VM_Y
LCONT :=.T.
for nX:=1 to fcount()
	VM_Y :='VM'+substr(fieldname(nX),3)
//	alert('Variaveis:'+VM_Y)
	&VM_Y:=fieldget(nX)
next
nX:=15
pb_box(nX++,18,,,,'Cadastro CFOP x Produto')
nX++
@nX++,20 say padr('CFOP'            ,15,'.') get VMI_CFOP     pict mNAT valid fn_codigo(@VMI_CFOP,{'NATOP',   {||NATOP->   (dbseek(str(VMI_CFOP,7)))},       {||CFEPNATT(.T.)},{1,2,3}}) when VM_FL
@nX++,20 say padr('Produto'         ,15,'.') get VMI_CODPR    pict mUUU valid fn_codpr(@VMI_CODPR,77).and.;
																										pb_ifcod2(str(VMI_CFOP,7)+str(VMI_CODPR,L_P),'CFEAPRI',.F.,1) ;
															when VM_FL
@nX++,20 say padr('PIS/COFINS-Entr' ,15,'.') get VMI_CODCOE   pict mUUU valid ChkPisCofins(@VMI_CODCOE)                   when pb_msg('Tabela de Pis/Cofins para Entrada')
@nX++,20 say padr('PIS/COFINS-Saida',15,'.') get VMI_CODCOS   pict mUUU valid ChkPisCofins(@VMI_CODCOS)                   when pb_msg('Tabela de Pis/Cofins para Saida')

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
 function CFEPNOIM3() // Rotina de Pesquisa
//-------------------------------------------------------------------* 
return NIL

//-------------------------------------------------------------------* 
  function CFEPNOIM4() && Rotina de Exclus„o
//-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar '+STR(PRI_CFOP,7)+'-'+STR(PRI_CODPR,L_P)+'-'+trim(PROD->PR_DESCR)+'?')
	fn_elimi()
end
dbrunlock()
return NIL

//-------------------------------------------------------------------* 
  function CFEPNOIM5() // Rotina de Impress„o
return NIL
//-------------------------------------------------------------------*


*----------------------------------------------------------EOF---------* 
