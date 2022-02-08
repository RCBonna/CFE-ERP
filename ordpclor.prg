//-----------------------------------------------------------------------------*
  static aVariav := {'','',0,'',0,0,{}}
//.....................................................1.......2....3.....4....5...6
#xtranslate aCab     => aVariav\[  1 \]
#xtranslate aDet     => aVariav\[  2 \]
#xtranslate X		   => aVariav\[  3 \]
#xtranslate TXTPARC  => aVariav\[  4 \]
#xtranslate nProd    => aVariav\[  5 \]
#xtranslate nCodTrib => aVariav\[  6 \]
#xtranslate aTOT     => aVariav\[  7 \]

*-----------------------------------------------------------------------------*
function ORDPCLOR()	//	Cliente // Ordem													*
*-----------------------------------------------------------------------------*
local VM_TF:=savescreen()
local MSG:='Consultas a Clientes X Ordens'
#include 'RCB.CH'

if used()
	alert(MSG+' Somente no MENU.')
	return NIL
end

pb_tela()
pb_lin4(MSG,ProcName())

if !abre({	'E->DPCLI',;
				'E->BANCO',;
				'E->HISCLI',;
				'E->PARAMETRO',;
				'E->CLIOBS',;
				'E->PROD',;
			 	'E->CLIENTE',;
				'E->PARAMORD',;
				'E->MECMAQ',;
				'E->EQUIDES',;
				'E->ORCACAB',;
				'E->ATIVIDAD',;
				'E->MOVORDEM',;
				'E->ORDEM'})
	return NIL
end

PROD->(dbsetorder(2))
MOVORDEM->(dbsetorder(3))
ORDEM->(dbsetorder(2))
if lastrec()=0
	alert('Arquivo de '+trim(PARAMORD->PA_DESCR3)+' n„o contem dados.')
	dbcloseall()
	restscreen(,,,,VM_TF)
	return NIL
end

set relation   to str(OR_CODCL,5) into CLIENTE,;
					to     OR_CODED    into EQUIDES

VM_CAMPO:={};aeval(dbstruct(),{|DET|aadd(VM_CAMPO,DET[1])})
VM_CAMPO[1]='pb_zer(OR_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,25)'
VM_CAMPO[2]='pb_zer(OR_CODOR,5)'
VM_CAMPO[3]='OR_CODED+chr(45)+left(EQUIDES->ED_DESCR,20)'
VM_CAMPO[7]='if(OR_FLAG,"Fechada","Aberta ")'
DbGoTop()
VM_FCLI:=0
VM_FED :=SPACE(12)
BLKS:={setkey(K_LEFT,NIL),setkey(K_RIGHT,NIL)}

pb_dbedit1('ORDPCLOR','Selec.Detalh')
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2', {masc(1),masc(1),masc(1),masc(1),masc(7),masc(7),masc(1)},;
														{'Cliente','Ordem',trim(PARAMORD->PA_DESCR2),'OBS','DtEntr','DtSaid','Situacao','Parc'})
dbcloseall()


setkey(K_LEFT, BLKS[1])
setkey(K_RIGHT,BLKS[2])

return NIL

*---------------------------------------------------------------------------*
function ORDPCLOR1()	//	Rotina de pesquisa
*---------------------------------------------------------------------------*
pb_box(18,10,,,,'Filtro de Selecao')
@19,12 say padr('Selecionar Cliente',20,'.')      get VM_FCLI pict masc(04) valid VM_FCLI=0.or.fn_codigo(@VM_FCLI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_FCLI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
@21,12 say padr(trim(PARAMORD->PA_DESCR2),20,'.') get VM_FED  pict masc(1)  valid fn_codigo(@VM_FED,{'EQUIDES',{||EQUIDES->(dbseek(VM_FED))},{||ORDP1300T(.T.)},{2,1}}) when empty(VM_FCLI)
read
if lastkey()#K_ESC
	if !empty(VM_FCLI)
		set filter to ORDEM->OR_CODCL==VM_FCLI
	else
		set filter to ORDEM->OR_CODED==VM_FED
	end
else
	set filter to
end
DbGoTop()
return NIL

*---------------------------------------------------------------------------*
 function ORDPCLOR2()	//	Rotina de pesquisa
*---------------------------------------------------------------------------*
local OBS     :={}
local	VM_PARC :=0
local VM_BCO  :=0
local VM_VDESC:=0
local VM_DTSAI:=OR_DTSAI
local VM_DPL  :=OR_CODOR
	EQUIDES->(dbseek(ORDEM->OR_CODED))
	aTot:=fn_OrdCal()
	for X:=1 to 5
		aadd(OBS,substr(OR_OBS,X*60-59,60))
	end
	pb_box(5,0)
	@05,01 say '['+trim(PARAMORD->PA_DESCR3)+' - '+pb_zer(OR_CODOR,6)+']' color 'R/W'
	@06,01 say padr('C¢d.Cliente',18,'.')+  &(VM_CAMPO[2])
	@07,01 say padr(trim(PARAMORD->PA_DESCR2),18,'.')+&(VM_CAMPO[3])
	@08,01 say padr('OBS/1',18,'.')        +OBS[1]
	@09,01 say padr('OBS/2',18,'.')        +OBS[2]
	@10,01 say padr('OBS/3',18,'.')        +OBS[3]
	@11,01 say padr('OBS/4',18,'.')        +OBS[4]
	@12,01 say padr('OBS/5',18,'.')        +OBS[5]
	@13,01 say padr('Dt.Entrada',18,'.')   +dtoc(OR_DTENT)
	@14,01 say padr('Valor Produtos',18,'.')+transform(aTot[1],masc(2))
	@15,01 say padr('Valor Mao-Obra',18,'.')+transform(aTot[2],masc(2))
	@16,01 say padr('Valor Total',18,'.')+transform(aTot[1]+aTot[2],masc(2))
	@17,01 say padr('Valor Desconto',18,'.')+'   '+transform(VM_VDESC,masc(5))
	@18,01 say padr('Dt.Saida Efetiva',18,'.')+transform(VM_DTSAI,masc(7))
	@19,01 say padr('0-Vista/1,2..Parc',18,'.')+str(VM_PARC,1)
	@20,01 say padr('Nr DPL Basico',18,'.')    +transform(VM_DPL,masc(16))
	@21,01 say padr('C¢digo Banco',18,'.')     +transform(VM_BCO,masc(11))
	read
	setcolor(VM_CORPAD)
	pb_msg('Pressione <ENTER> para ver lancamentos.',0,.T.)
	VM_FLNOME:='N'
	ORDPCLOR2I()
return NIL
*---------------------------------------------------------------------------*
function ORDPCLOR2I()
*---------------------------------------------------------------------------*

VM_REL:='Lista '+trim(PARAMORD->PA_DESCR3)+' N.'+pb_zer(OR_CODOR,6)
VM_LAR:=78
VM_PAG:=0
set printer to ORDEM.
set print on
set console off
salvabd(SALVA)
ORDP310I(OR_CODOR)
salvabd(RESTAURA)
set console on
set print off
set printer to

txtela('ORDEM',8,0,22,79)

return NIL
