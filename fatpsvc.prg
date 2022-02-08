*-----------------------------------------------------------------------------*
function FATPSVC()	//	Digitacao de vendas												*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local X1
if !abre({	'C->PARAMETRO',;
				'C->DIARIO',;
				'C->CTRNF',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->MOVEST',;
				'C->CTACTB',;
				'C->TABICMS',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->BANCO',;
				'C->VENDEDOR',;
				'C->OBS',;
				'C->CAIXACG',;
				'C->CAIXAMB',;
				'C->CONDPGTO',;
				'C->ATIVIDAD',;
				'C->PEDSVC',;
				'R->CODTR',;
				'C->PEDDET',;
				'C->PEDCAB',;
				'C->PEDPARC',;
				'C->ADTOSD',;	//ADIANTAMENTO A CLIENTE - DETALHE
				'C->ADTOSC',;	//ADIANTAMENTO A CLIENTE - CABEÇALHO
				'C->NATOP'})
	return NIL
end
pb_tela()
pb_lin4(_MSG_,ProcName())
select('PROD')
dbsetorder(2) // Produtos
select('PEDCAB')
dbsetorder(2) // Pedido  Cabec

set relation to str(PC_CODCL,5) into CLIENTE
DbGoTop()

pb_dbedit1('FATPSVC','IncluiAlteraExcluiLista Atuali')  // tela
dbedit(06,01,maxrow()-3,maxcol()-1,;
		{'PC_PEDID','pb_zer(PC_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,30)','PC_DTEMI','PC_CODOP','PC_SERIE','if(PC_FLSVC,"Serv","Prod")','PC_TOTAL'},;
		'PB_DBEDIT2',;
		{      mI6 ,                                                  mXXX ,      mDT ,      mNAT,     mUUU ,                       mXXX ,     mD112},;
		{  'Pedido',                                              'Cliente','Dt Emiss',  'NatOpe',   'Serie',                     'TpNF' ,   'Total'})
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
 function FATPSVC1()
*-----------------------------------------------------------------------------*
setcolor(VM_CORPAD)
pb_tela()
pb_lin4('Digitacao Nota de Servico',ProcName())
scroll(6,1,21,78,0)
setcolor('W+/B,N/W,,,W+/B')
CODTR->(DbGoTop())

private VM_CODOP :=0
private VM_NSU   :=0
private VM_OPC   :=0
private VM_CLI   :=0
private VM_TOT   :=0
private VM_ICMSPG:=0
private VM_PARCE :=0
private VM_VEND  :=0
private VM_RT    :=.T.
private VM_OBS   :=space(132)
private VM_SVC   :=space(80)
private VM_DET   :={}
private VM_ICMS  :={} // %ICMS,BASE
private VM_SERIE :=space(3)
private VM_CODFC :=space(10)
private VM_VARAMB:=upper(getenv('CFE'))
private VM_ULTPD :=0
private VM_NOMNF :=''
private VM_ENCFI :=0
private VM_LOTE  :=0
private VM_FLADTO:="N"

//-------------------------------------------->pega padrpo do micro se houver
if 'SERIE:'$VM_VARAMB // PARA PEDIR SERIE
	VM_SERIE:=padr(substr(VM_VARAMB,at('SERIE:',VM_VARAMB)+6),3)
end
VM_ULTPD:=fn_psnf('PED')
ORDEM GPEDIDO
while dbseek(str(VM_ULTPD,6))
	VM_ULTPD:=fn_psnf('PED')
end
ORDEM FPEDIDO
@06,01 say 'Pedido...: '+pb_zer(VM_ULTPD,6)
@06,20 say 'Serie:'       get VM_SERIE pict mUUU valid VM_SERIE==SCOLD.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}}).and.CTRNF->NF_NRLIN>0 color 'R/W'
@07,01 say 'Cliente..:'   get VM_CLI   pict mI5  valid fn_codigo(@VM_CLI,  {'CLIENTE', {||CLIENTE->(dbseek(str(VM_CLI,5)))},  {||CFEP3100T(.T.)},{2,1,8,7}}).and.fn_icms(@VM_ICMSPG,'S').and.fn_libcli(VM_PARCE>0).and.eval({||VM_VEND:=CLIENTE->CL_VENDED})>=0
@06,45 say 'Nat.Oper.:'   get VM_CODOP pict mNAT valid fn_codigo(@VM_CODOP,{'NATOP',   {||NATOP->(dbseek(str(VM_CODOP,7)))},  {||CFEPNATT(.T.)},{2,1,3}}).and.NATOP->NO_TIPO$'O'.and.confNatOp(CLIENTE->CL_UF,'CLIENTE')
read
if lastkey()==K_ESC
	fn_backnf('PED',VM_ULTPD)
	DbGoTop()
	dbunlockall()
	return NIL
end
salvabd(SALVA)

for VM_X:=1 to CTRNF->NF_NRLIN
	aadd(VM_DET,LinDetProd(VM_X))
next

@16,01 to 16,78
while .T.
	pb_msg('Selecione um item e press <Enter> ou <ESC> para sair.',NIL,.F.)
	X:=abrowse(8,1,16,78,;
					VM_DET,;
				{    'Sq', 'CodSVC','Descricao','Qtdade','Vlr Venda T','Vlr Desconto','EncFin',    'CT',   '%ICMS', 'Unid','%Tribut'},;
				{       2,        6,         20,      10,           12,            12,       6,       2,         5,      6,       6 },;
				{     mI2,      mI6,       mXXX, masc(6),     masc(25),      masc(25), masc(20),masc(11), masc(14),   mUUU,masc(20)})
	if X>0		//......1........2...........3........4.............5..............6.........7........8.........9......10........11
		VM_ICMS:=FATPSVCD(VM_DET,X,.T.,@VM_TOT) // editar * retorna ICMS *
		keyboard replicate(chr(K_DOWN),X)
	else
		exit
	end
end
*---------------------------------------------------------------Roda pe da NOTA
if VM_TOT>0
	if .not. FinalPedido('Novo','Servico')
		fn_backnf('PED',VM_ULTPD)
	end
else
	fn_backnf('PED',VM_ULTPD)
end
dbgobottom()
dbunlockall()
return NIL

//------------------------------------------------------------------------------------
function FATPSVC2()//alterar
CFEP5104(.F.) // Mostrar
return NIL

//------------------------------------------------------------------------------------
function FATPSVC3()//eliminar
if reclock().and.pb_sn('Eliminar Pedido N. '+pb_zer(PC_PEDID,6)+'-'+CLIENTE->CL_RAZAO)
	if !PC_FLAG
		CFEP5103E(.F.)
	else
		pb_msg('Pedido ja atualizado...',3,.T.)
	end
end
dbunlockall()
select('PEDCAB')
return NIL

//------------------------------------------------------------------------------------
function FATPSVC4()//listar
CFEP5104(.T.) // Mostrar
return NIL

//------------------------------------------------------------------------------------
function FATPSVC5()//IMPRIMIR NF
CFEP5201('NF')
return NIL


*-----------------------------------------------------------------------------*
function FATPSVCD(VM_DET,ORD,FL_NEW,TOTNF) // DIGITAR ITENS
*-----------------------------------------------------------------------------*
local VM_PROD  :=VM_DET[ORD,02]
local VM_QTD   :=max(VM_DET[ORD,04],1)
local VM_QTDAN :=VM_DET[ORD,12] // quantidade anterior para alteracao
local VM_VLVEN :=VM_DET[ORD,05]
local VM_DESC  :=VM_DET[ORD,06]
local VM_ENCFI :=VM_DET[ORD,07]
local VM_CODTR :=VM_DET[ORD,08]
local VM_ICMSP :=VM_DET[ORD,09]
local VM_PTRIB :=if(empty(VM_DET[ORD,11]),100,VM_DET[ORD,11])
local VM_ICMS  :={}
local VM_VLVENX:=0
local Z,X
salvacor(SALVA)
pb_box(8,0,16,79,'W+/G,N/W*,,,W+/G','Item '+pb_zer(ORD,2)+'/'+pb_zer(len(VM_DET),2))
if !FL_NEW
	@09,27 say ''
end
@11,38 say 'Total :'
@09,01 say padr('Cod.Servico',    20,'.') get VM_PROD  pict mI3          valid fn_codigo(@VM_PROD,{'ATIVIDAD',{||ATIVIDAD->(dbseek(str(VM_PROD,2)))},{||ORDP1400T(.T.)},{2,1}}).and.ChkProdArray(VM_PROD,VM_DET,ORD) when FL_NEW
@10,01 say padr('Quantidade',     20,'.') get VM_QTD   pict masc(06)     valid VM_QTD>0    when aeval(GETLIST,{|DET|DET:display()})==GETLIST
@11,01 say padr('Vlr VENDA(un)',  20,'.') get VM_VLVEN pict masc(05)+'9' valid VM_VLVEN>0.and.fn_vlrvenda(VM_VLVEN,VM_VLVENX) when fn_imprv(transform(round(VM_VLVEN*VM_QTD,2),masc(2)),{11,45})
@12,01 say padr('Desconto',       20,'.') get VM_DESC  pict masc(05)     valid VM_DESC >=0                                    when fn_imprv(transform(round(VM_VLVEN*VM_QTD,2),masc(2)),{11,45})
@14,01 say padr('Cod.Tributario', 20,'.') get VM_CODTR pict mI3          valid fn_codigo(@VM_CODTR,{'CODTR',{||CODTR->(dbseek(VM_CODTR))},{||NIL},{2,1,3}}) when !CODTR->(dbseek(VM_CODTR)).and.fn_imprv(CODTR->CT_DESCR,{14,30})
@15,01 say padr('% ICMS',         20,'.') get VM_ICMSP pict masc(14)     valid VM_ICMSP>=0 when .F.
@15,35 say padr('% Tributado',    15,'.') get VM_PTRIB pict masc(20)     valid VM_PTRIB>=0 when .F.
read
salvacor(RESTAURA)
if lastkey()#K_ESC
	if VM_PROD > 0
		VM_DET[ORD, 2]:=VM_PROD
		VM_DET[ORD, 3]:=ATIVIDAD->AT_DESCR
		VM_DET[ORD, 4]:=VM_QTD
		VM_DET[ORD, 5]:=VM_VLVEN
		VM_DET[ORD, 6]:=VM_DESC
		VM_DET[ORD, 7]:=VM_ENCFI
		VM_DET[ORD, 8]:=VM_CODTR
		VM_DET[ORD, 9]:=VM_ICMSP
		VM_DET[ORD,10]:='SVC'
		VM_DET[ORD,11]:=VM_PTRIB
		VM_DET[ORD,14]:=VM_VLVEN
	else
		VM_DET[ORD]:=LinDetProd(ORD)
	end
end
TOTNF         :=0
aeval(VM_DET,{|VM_DET1|TOTNF+=round(VM_DET1[4]*VM_DET1[5]-VM_DET1[6]+VM_DET1[7],2)})
@17,01 say 'TOTAL do Pedido.....:' + transform(TOTNF, masc(2))
return (VM_ICMS)
*----------------------------------EOF-----------------------------------------------------