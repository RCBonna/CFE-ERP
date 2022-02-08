*-----------------------------------------------------------------------------*
function CXAPALTE(P1)	//	Altera Lancamentos do Caixa
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local LogStat
private KindCxa:=2
private NroCxa :=NUM_CXA
private VM_DTCXA
if P1==NIL
	KindCxa:=1
end
if !abre({	'C->CAIXAPA',;
				'R->CAIXA01',;
				'C->CAIXACG',;
				'C->CAIXAMC'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())
select('CAIXAMC')
if KindCxa==1
		
	set filter to CAIXAMC->MC_DATA > CAIXAPA->PA_DTFECC

else
	NroCxa:=FN_SelCxa('Digitar Entradas/Retiradas do Caixa')
	if NroCxa==0
		dbcloseall()
		Return Nil
	end
	LogStat:=fn_StatCxa(NroCxa)
	if LogStat=="ERRO-1"
		Alert('Erro na Abertura do Caixa='+LogStat)
		dbcloseall()
		return NIL
	end
	if LogStat=='FECHADO'
		alert("Caixa Numero : "+pb_zer(NUM_CXA,2)+";Esta Fechado em: "+dtoc(CAIXA01->AX_DATA))
		dbcloseall()
		return NIL
	end
	VM_DTCXA:=CAIXA01->AX_DATA
	select CAIXAMC
	ORDEM CODCXA
	pb_lin4(_MSG_+"/Caixa="+pb_zer(NroCxa,2),ProcName())
	Set filter to CAIXAMC->MC_CODCXA == NroCxa
end

set relation to str(CAIXAMC->MC_CODCG,3) into CAIXACG
DbGoTop()
pb_dbedit1("CXAPALTE")
VM_CAMPO   :=array(fcount())
afields(VM_CAMPO)

VM_CAMPO[2]:='pb_zer(MC_CODCG,3)+chr(45)+CAIXACG->CG_DESCR'
VM_MUSC    :={   mDT, mXXX,                  mD132 , mUUU,       mXXX ,   mI4, mUUU,  mI2,    mI9}
VM_CABE    :={"Data","Cod-Despesa/Receita", "Valor",  "T","Historico","CCtb","Orig","CXA","Docto"}
DbGoTop()
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,"PB_DBEDIT2",VM_MUSC,VM_CABE)
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*
function CXAPALTE1() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CXAPALTET(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPALTE2() // Rotina de Alteracao
if reclock()
	CXAPALTET(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPALTET(VM_FL)
local GETLIST  := {},LCONT:=.T.
local X
local Y
local LogDT:=.T.
for X:=1 to fcount()
	Y:='VM'+substr(fieldname(X),3)
	&Y:=&(fieldname(X))
next
if VM_FL
	dbgobottom()
	VM_DATA  :=date()
	VM_TIPO  :='+'
	VM_CODCXA:=NroCxa
end
X:=16
pb_box(X++,10,,,,'CAIXA-Lancamentos')
if KindCxa==2
	@X++,12 say 'Nro do Caixa..: '+transform(VM_CODCXA, mI2)
	VM_DATA:=VM_DTCXA
	LogDT  :=.F.
end
@X++,12 say 'Data Lcto.....:' get VM_DATA  pict masc(07) valid VM_DATA>CAIXAPA->PA_DTFECC when LogDT
@X++,12 say 'Codigo Conta..:' get VM_CODCG pict masc(12) valid fn_codigo(@VM_CODCG,{'CAIXACG',{||CAIXACG->(dbseek(str(VM_CODCG,3)))},{||CXAPCDGRT(.T.)},{2,1}})
@X++,12 say 'Historico.....:' get VM_HISTO pict masc(23)+'S50'
@X  ,12 say 'Valor.........:' get VM_VALOR pict masc(05) valid VM_VALOR>0
@X  ,40                       get VM_TIPO  pict masc(01) valid VM_TIPO$'+-' when pb_msg('Tipo de Lancamento <+>ENTRADA  <->Saida')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT  :=AddRec()
		VM_ORIG:='DG'
	end
	if LCONT
		for X:=1 to fcount()
			Y:="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &Y
		next
		dbskip(0)
		// dbcommit()
	end
end
return NIL

*-----------------------------------------------------------------------------*
function CXAPALTE3() // Rotina de Pesquisa
local VM_DATA:=MC_DATA
pb_box(20,40,,,,'Pesquisa')
@21,42 say 'Pesquisar.:' get VM_DATA pict mDT
read
dbseek(dtos(VM_DATA),.T.)
return NIL

*-----------------------------------------------------------------------------*
function CXAPALTE4() // Rotina de Exclusao
if reclock().and.pb_sn('Excluir LANCAMENTO.: ' + transform(MC_DATA,masc(07))+'-' +trim(MC_HISTO))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function CXAPALTE5() // Impressao
return NIL
*-----------------------------------------------------------------------------*
