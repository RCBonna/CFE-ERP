//
// ...... alterar somente no diretório do ..\CFE
//
*-----------------------------------------------------------------------------*
static aVariav:= { '','',0,''}
//.................1...2.3.4
*-----------------------------------------------------------------------------*
#xtranslate F_CODOP	=> aVariav\[  1 \]
#xtranslate Filtro	=> aVariav\[  2 \]

*-----------------------------------------------------------------------------*
function Livros0()	//	Livros Fiscais
*-----------------------------------------------------------------------------*
#include 'SAG.CH'
local _LAB

pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'E->LIVRO';
				})
	return NIL
end
ORDEM ID
pb_dbedit1('LIVRO0','IncluiAlteraPesqu.ExcluiLista Filtro' )  // tela
VM_CAMPO:=array(fcount())
_LAB    :=array(fcount())

afields(VM_CAMPO)
aeval(VM_CAMPO,{|DET,X|_LAB[X]:=substr(VM_CAMPO[X],4)})
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',;
				/* MASC */,;
				_LAB)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function LIVRO01() // Rotina de Inclus„o
//	while lastkey()#K_ESC
//	dbgobottom()
//	dbskip()
//	BOLENTRT(.T.)
//	end
return NIL
*-------------------------------------------------------------------* 
function LIVRO02() // Rotina de Altera‡„o
//if reclock()
//	if recno()<=lastrec()
//		BOLENTRT(.F.)
//	end
//end
return NIL

*-------------------------------------------------------------------* 
function LIVRO03() // Rotina de Pesquisa
//	local VM_ORD:=indexord()
//	local CHAVE
//	local X
//	CHAVE := BE_CODIGO
//	X:=20
//	pb_box(X++,40,22,79,,'Pesquisa Boletim')
//	@X++,42 get CHAVE pict mI6
//	read
//	dbseek(CHAVE,.T.)
//	setcolor(VM_CORPAD)
return NIL

*-------------------------------------------------------------------* 
function LIVRO04() // Rotina de Exclus„o
local OPC :=Alert('Eliminar ?',{'Registro','Periodo','Tudo'})
local DATA:={bom(LV_DATA),eom(LV_DATA)}
if OPC==1
	elimina_reg('Movimento Livro : <Tipo>'+LV_TIPO+';<Nota> '+str(LV_NRDOC,8))
elseif OPC==2.and.pb_sn('Confime !;Eliminar dados do periodo '+dtoc(DATA[1])+' a '+dtoc(DATA[2])+' ?')
	pb_msg()
	delete ALL for (LV_DATA>=DATA[1].and.LV_DATA<=DATA[2])
	DbGoTop()
elseif OPC==3.and.pb_sn('Confime !;Eliminar todos os dados de Livros Fiscais?')
	ZAP
end
return NIL

//-------------------------------------------------------------------* 
	function LIVRO05() // Rotina de Impressao
//-------------------------------------------------------------------* 

return NIL

//-------------------------------------------------------------------* 
	function LIVRO06() // Rotina de Filtro
//-------------------------------------------------------------------* 
F_CODOP:=space(5) // Servirá para Filtro - Opção
pb_box(19,02)
@ 20,04 say 'Natureza Operacao:' get F_CODOP pict mUUU
read
if lastkey()<>K_ESC
	Filtro:='LIVRO->LV_CODFIS==F_CODOP'
	set filter To LIVRO->LV_CODFIS==F_CODOP
else
	Filtro:=''
	set filter To
end
DbGoTop()
return NIL

//------------------------------------------------------------------- Dados Livro Entrada/Saida
	function LIVROX(P1)
//-------------------------------------------------------------------* 
local ARQ:='LIVRO'
if dbatual(ARQ,;
				{{'LV_TIPO'		,'C',  1, 0},;	// 01-Tipo de Livro (E=entrada/S=saida)
				 {'LV_DATA'		,'D',  8, 0},;	// 02-Data Entrada/Saida
				 {'LV_ESPECIE'	,'C',  3, 0},;	// 03-Especie NF / CEE / CTC...
				 {'LV_SERIE'	,'C',  3, 0},;	// 04-Serie
				 {'LV_NRDOC'	,'N', 12, 0},;	// 05-Numero do Documento
				 {'LV_DTDOC'	,'D',  8, 0},;	// 06-Data Documento
				 {'LV_CODEMI'	,'N',  6, 0},;	// 07-Codigo Emitente
				 {'LV_UFEMI'	,'C',  2, 0},;	// 08-UF-EMITENTE
				 {'LV_CODCTB'	,'N',  1, 0},;	// 09-Código Contabil = 1,2,3 (Livro)
				 {'LV_VLRCTB'	,'N', 15, 2},;	// 10-Valor Contabil
				 {'LV_CODFIS'	,'C',  5, 0},;	// 11-CFOP-Cód Fiscal / Natureza Operação(do governo)
				 {'LV_ICMSBAS'	,'N', 15, 2},;	// 12-Vlr Base    ICMS...........(1)
				 {'LV_ICMSPER'	,'N',  6, 2},;	// 13-Vlr %       ICMS...........(1)
				 {'LV_ICMSVLR'	,'N', 15, 2},;	// 14-Vlr DEB/CRE ICMS...........(1) 
				 {'LV_VLRISE'	,'N', 15, 2},;	// 15-Vlr Isentas/Não Tributada..(3)
				 {'LV_VLROUT'	,'N', 15, 2},;	// 16-Vlr Outras.................(2)
				 {'LV_VLROUTX'	,'N', 15, 2},;	// 17-Vlr Outras (AJU-ste)
				 {'LV_IPI_BAS'	,'N', 15, 2},;	// 18-Vlr Base    IPI
				 {'LV_IPI_PER'	,'N',  6, 2},;	// 19-%           IPI
				 {'LV_IPI_VLR'	,'N', 15, 2},;	// 20-Valor       IPI
				 {'LV_OBS'		,'C', 80, 0}},;// 21-Observação
				 RDDSETDEFAULT())
	ferase(ARQ+indexext())
end
if !file(ARQ+indexext()).or.P1
	pb_msg('Reorg. Dados do Livro Fiscal',NIL,.F.)
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		Pack
		index on dtos(LV_DATA)+LV_TIPO+LV_SERIE+str(LV_NRDOC,12)+str(LV_ICMSPER,6,2) tag ID       to (Arq) eval {||Odometro('TodasNF')}
		index on dtos(LV_DATA)+        LV_SERIE+str(LV_NRDOC,12)+str(LV_ICMSPER,6,2) tag ENTRADAS to (Arq) eval {||Odometro('NF-Entr')} for LV_TIPO=='E'
		index on dtos(LV_DATA)+        LV_SERIE+str(LV_NRDOC,12)+str(LV_ICMSPER,6,2) tag SAIDAS   to (Arq) eval {||Odometro('NF-Said')} for LV_TIPO=='S'
		close
	end
end
//------------------------------------------------------------------------------
ARQ:='LIVROPA'
if dbatual(ARQ,;
				{{'PL_PERIO'	,'C',  6, 0},;	// 1-Ultimo periodo Gerado
				 {'PL_DATA'		,'D',  8, 0},;	// 2-Data ultima geracado
				 {'PL_LIVENT'	,'N',  5, 0},;	// 3-Ultimo livro de ENTRADA
				 {'PL_PAGENT'	,'N',  5, 0},;	// 4-Ultima Pagina para livro de Entrada
				 {'PL_LIVSAI'	,'N',  5, 0},;	// 5-Ultimo livro de SAIDA
				 {'PL_PAGSAI'	,'N',  5, 0},;	// 6-Ultima Pagina para livro de SAIDA
				 {'PL_LIVINV'	,'N',  5, 0},;	// 7-Ultimo livro de SAIDA
				 {'PL_PAGINV'	,'N',  5, 0},;	// 8-Ultima Pagina para livro de SAIDA
				 {'PL_OBS'		,'C', 80, 0},;	// 9-Observação
				 {'PL_ASS1'     ,'C', 80, 0},;	//10-Assinatura 1
				 {'PL_ASS2'     ,'C', 80, 0},;	//11-Assinatura 2
				 {'PL_ASS3'     ,'C', 80, 0}},;	//12-Assinatura 3
				 RDDSETDEFAULT())

	use (ARQ) new EXCLUSIVE
	if lastrec()==0
		dbappend(.T.)
		replace 	PL_PERIO 	with '000000',;
					PL_DATA		with  date(),;
					PL_LIVENT	with 1,;
					PL_PAGENT	with 1,;
					PL_LIVSAI	with 1,;
					PL_PAGSAI	with 1,;
					PL_LIVINV	with 1,;
					PL_PAGINV	with 1,;
					PL_OBS		with '',;
					PL_ASS1		with '          ADEMIR  PRONER                           CLAUDIO  DACAS',;	//  8-Assinatura L=1
					PL_ASS2		with '     CONTADOR CRC SC-017875/0-8                      PRESIDENTE '	,;	//  9-Assinatura L=2
					PL_ASS3		with '        CPF 518.043.339-53                       CPF 445.525.139-15'	// 10-Assinatura L=3
	end
end
return NIL
//---------------------------------------------------------eof-------------------------------------------------------------------