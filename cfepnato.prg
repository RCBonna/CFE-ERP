//-----------------------------------------------------------------------------*
  static aVariav := {{}, 0,'T',.F.,0 ,'',.T.}
//....................1..2..3...4..5...6..7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate aLinDet    => aVariav\[  1 \]
#xtranslate nX         => aVariav\[  2 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
	function CFEPNATO() // Cadastro de Nat Opera‡”es										*
*-----------------------------------------------------------------------------*

local VM_FLAG:=.T.
pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'C->NATOP',;
				'R->CTADET',;
				'R->CTACTB';
			})
	return NIL
end
select('NATOP')
DbGoTop()
//dbeval({||VM_FLAG:=.F.},{||NO_ILIVRO})
//if VM_FLAG
//	dbeval({||NATOP->NO_ILIVRO:=.T.},{||reclock()})
//end
//DbGoTop()

pb_dbedit1('CFEPNAT')  // tela
VM_CAMPO:=array(fcount())
afields(VM_CAMPO)

VM_MUSC    :={    mNAT,       mXXX, mXXX , mI2 ,     mXXX ,     mXXX , mI3 , mUUU ,  mUUU ,   mUUU , mUUU, mUUU,    mUUU, mUUU, mUUU, mUUU,      mDT }
VM_CABE    :={'Codigo','Descricao',  'TP','Cod','Operacao','No Livro','OBS','Ctb?','Trans','PisCof','IntG','IntA','Cota','Fin','Est','Devolucao','DtAtualiz'}
VM_CAMPO[5]:="if(NO_TPOPER,'Inter','Estad')"
VM_CAMPO[6]:="if(NO_ILIVRO,'Imprime','Descons')"

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MUSC,VM_CABE)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
function CFEPNAT1() // Rotina de Inclus„o
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPNATT(.T.)
end
return NIL
*-------------------------------------------------------------------* 

function CFEPNAT2() // Rotina de Altera‡„o
if reclock()
	CFEPNATT(.F.)
end
return NIL
//-------------------------------------------------------------------* 
  function CFEPNATT(VM_FL)
//-------------------------------------------------------------------* 
local GETLIST := {}
local X
local VM_Y
local LCONT:=.T.

for X:=1 to fcount()
	VM_Y:='VM'+substr(fieldname(X),3)
	&VM_Y:=fieldget(X)
next
VM_ILIVRO:=if(VM_ILIVRO       ,'I',      'D')
VM_TPOPER:=if(VM_TPOPER       ,'I',      'E')
VM_FLCTB :=if(empty(VM_FLCTB ),'S', VM_FLCTB)
VM_FLTRAN:=if(empty(VM_FLTRAN),'N',VM_FLTRAN)
VM_CONCP :=if(empty(VM_CONCP) ,'S', VM_CONCP)
VM_DEVOL :=if(empty(VM_DEVOL) ,'N', VM_DEVOL)
X        :=08
pb_box(X++,18,,,,'Natureza de Opera‡„o')
@X++,20 say padr('C¢digo'        ,15,'.') get VM_CODIG  pict mNAT			valid VM_CODIG>=1000000.and.pb_ifcod2(str(VM_CODIG,7),NIL,.F.,1) when VM_FL
@X++,20 say padr('Descri‡„o'     ,15,'.') get VM_DESCR  pict masc(23)	valid !empty(VM_DESCR)   
@X++,20 say padr('Tipo'          ,15,'.') get VM_TIPO   pict masc(01)	valid VM_TIPO$'ESO'      when pb_msg('Opcoes  :  <E>ntrada    <S>aida    <O>utros')
@X++,20 say padr('Cod Vlr Fisc'  ,15,'.') get VM_CDVLFI pict '9'			valid fn_codar(@VM_CDVLFI,'CODVLRFI.ARR') when pb_msg('Codigo do livro fiscal')
@X  ,20 say padr('Tipo Operacao' ,15,'.') get VM_TPOPER pict '!'			valid VM_TPOPER$'IE'     when pb_msg('Opcoes  :  <I>nterEstadual  <E>stadual')
@X++,50 say padr('Impr. Livro Fiscal' ,20,'.') get VM_ILIVRO pict '!'	valid VM_ILIVRO$'ID'     when pb_msg('Opcoes  :  <I>mprimir  <D>esconsiderar')

@X++,20 say padr('Transferencia?',15,'.') get VM_FLTRAN	pict '!'			valid VM_FLTRAN$'SN'     when pb_msg('Opcoes  :  <S>im   <N>ao')
@X++,20 say padr('Contabiliza ?' ,15,'.') get VM_FLCTB	pict '!'			valid VM_FLCTB $'SN'     when pb_msg('Opcoes  :  <S>im   <N>ao')
@X++,20 say padr('Pis/Cofins ?'  ,15,'.') get VM_FLPISC	pict '!'			valid VM_FLPISC$'SN'     when pb_msg('Considerar para Pis/Cofins - Opcoes  :   <S>im   <N>ao')
@X++,20 say padr('Financeiro ?'  ,15,'.') get VM_FINANC	pict '!'			valid VM_FINANC$'SN'     when pb_msg('Considerar no Financeiro - Opcoes  :  <S>im   <N>ao')
@X++,20 say padr('Ctrl Estoque ?',15,'.') get VM_ESTOQ	pict '!'			valid VM_ESTOQ $'SN'     when pb_msg('Movimentacao do Estoque - Opcoes  :  <S>im   <N>ao')
X++
@X++,20 say padr('CtaContab DEB' ,15,'.') get VM_CTBDB	pict mI4			valid if(VM_TIPO=='S',fn_ifconta(,@VM_CTBDB),.T.);
																								when VM_FLCTB=='S'.and.VM_FINANC=='N'
@X++,20 say padr('CtaContab CRE' ,15,'.') get VM_CTBCR	pict mI4			valid if(VM_TIPO=='E',fn_ifconta(,@VM_CTBCR),.T.);
																								when VM_FLCTB=='S'.and.VM_FINANC=='N'

X:=X-7
@X++,50 say padr('CFOP Devolucao'      ,20,'.') get VM_DEVOL  pict '!'		valid VM_DEVOL $'NS'			when pb_msg('Considera CFOP tipo devolucao?    <S>im   <N>ao')
@X++,50 say padr('Consid. Cota Parte'  ,20,'.') get VM_CONCP  pict '!'		valid VM_CONCP $'NS'			when pb_msg('Considera Natureza na somatoria para Cota Parte?   <S>im   <N>ao')
@X++,50 say padr('Cod.Integrac.Geral'  ,20,'.') get VM_CODIN  pict mUUU											when pb_msg('Codigo de Integracao entre sistemas para Clientes Gerais')
@X++,50 say padr('Cod.Integrac.Assoc'  ,20,'.') get VM_CODINA pict mUUU											when pb_msg('Codigo de Integracao entre sistemas para Clientes Associados')



read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.f.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_ILIVRO:=(VM_ILIVRO=='I')
		VM_TPOPER:=(VM_TPOPER=='I')
		VM_DTALT :=date()
		for X:=1 to fcount()
			VM_Y="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &VM_Y
		next
		dbcommit()
	end
end
DbrUnLock(recno())
return NIL

*-------------------------------------------------------------------* 
function CFEPNAT3() && Rotina de Pesquisa
*-------------------------------------------------------------------* 
VM_CHAVE = &(fieldname(1))
pb_box(20,20)
@21,22 say 'Procurar :' get VM_CHAVE picture mNAT
read
setcolor(VM_CORPAD)
dbseek(VM_CHAVE,.T.)
return NIL

*-------------------------------------------------------------------* 
function CFEPNAT4() && Rotina de Exclus„o
*-------------------------------------------------------------------* 
if reclock().and.pb_sn('Eliminar '+transform(NO_CODIG,mNAT)+'-'+NO_DESCR+'?')
	fn_elimi()
end
dbrunlock()
return NIL

*-------------------------------------------------------------------* 
function CFEPNAT5() && Rotina de Impress„o
*-------------------------------------------------------------------* 
if pb_ligaimp(C15CPP)
	VM_PAG = 0
	VM_REL = 'Listar Natureza Operacao'
	VM_LAR = 78
	while !eof()
		VM_PAG = pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPNAT5A',VM_LAR)
		?  space(10)+transform(NO_CODIG,mNAT)+space(5)
		?? NO_DESCR+space(5)
		?? if(NO_TIPO='E','Entrada','Saida')
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp()
	DbGoTop()
end
return NIL

*-------------------------------------------------------------------* 
function CFEPNAT5A
*-------------------------------------------------------------------* 
? space(10)+'Codigo'+space(9)+padr('Descricao',32)+'Tipo'
?replicate('-',VM_LAR)
return NIL
*-------------------------------------------------------------------* 

*----------------------------------------------------------------------------------------------
function CRIA_NATOP(P1,P2)
*------------------------------------------------* NATUREZA OPERACAO - Arquivos
local ARQ:='CFEANO'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'NO_CODIG', 'N',  7, 0},;	// 01-NNNN-XX.X
				 {'NO_DESCR', 'C', 25, 0},;	// 02-
				 {'NO_TIPO',  'C',  1, 0},;	// 03-TIPO=[E]ntrada [S]aida [O]Servicos
				 {'NO_CDVLFI','N',  1, 0},;	// 04-Codigo de VLR Fiscais 1-2-3-4
				 {'NO_TPOPER','L',  1, 0},;	// 05-S=Interestadual N=estadual
				 {'NO_ILIVRO','L',  1, 0},;	// 06-Imprime Natureza no Livro
				 {'NO_OBSPAD','N',  3, 0},;	// 07-Observacao NF Padrao
				 {'NO_FLCTB', 'C',  1, 0},;	// 08-Natureza Contabiliza / Não Contabiliza
				 {'NO_FLTRAN','C',  1, 0},;	// 09-Natureza Transferencia
				 {'NO_FLPISC','C',  1, 0},;	// 10-Considera - Pis+Cofins
				 {'NO_CODIN', 'C',  4, 0},;	// 11-Codigo de Integracao Geral (inicial para PH)
				 {'NO_CODINA','C',  4, 0},;	// 11-Codigo de Integracao Associado (inicial para PH)
				 {'NO_CONCP', 'C',  1, 0},;	// 12-Considera na Somatória Cota Parte(S/N)
				 {'NO_FINANC','C',  1, 0},;	// 13-Considera no Financeiro
				 {'NO_ESTOQ', 'C',  1, 0},;	// 14-Considera no Estoque
				 {'NO_DEVOL', 'C',  1, 0},;	// 15-Devolução
				 {'NO_DTALT', 'D',  8, 0},;	// 16-DT Alteração
				 {'NO_CTBDB', 'N',  4, 0},;	// 17-Conta Débido (direto da natureza)-Saida(Obrigratório)
				 {'NO_CTBCR', 'N',  4, 0}},;	// 18-Conta Credito (direto da natureza)-Entrada(Obrigatório)
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Natureza de Operacao - indices
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. NATUREZA OPERACAO - Reg:'+str(LastRec()))
		pack
		Index on str(NO_CODIG,7) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on upper(NO_DESCR) tag ALFA   to (Arq) eval {||ODOMETRO('ALFA')}
		close
	end
end
return NIL

*-------------------------------------------------------------------* 
function TrNatOper(P1)
if P1<99999
	P1:=(val(left(pb_zer(P1,5),3)+'00'+right(pb_zer(P1,5),2)))
end
return P1
*------------------------------------EOF----------------------------* 
