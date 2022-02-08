//-----------------------------------------------------------------------------*
  static aVariav := {{},.T.,0,'',''}
//....................1..2..3..4.5..6...7...8...9, 10, 11, 12,13,14,15
//-----------------------------------------------------------------------------*
#xtranslate VM_CAMPO  => aVariav\[  1 \]
#xtranslate lCont     => aVariav\[  2 \]
#xtranslate nX        => aVariav\[  3 \]
#xtranslate cY        => aVariav\[  4 \]
#xtranslate cARQ      => aVariav\[  5 \]
*-----------------------------------------------------------------------------*
 function SAGPUMI()	// Tabela de Umidade
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'HBSIX.CH'

if !abre({	'C->PARAMETRO',;
				'C->CODTR',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->UMIDADE'})
	return NIL
end

select('PROD')
ORDEM CODIGO
select('UMIDADE')
DbGoTop()
pb_tela()
pb_lin4(_MSG_,ProcName())
while .T.
	VM_CODPR := 0
	pb_box(5,0,7,79,,'Selecione')
	@6,2 say 'Produto:' get VM_CODPR pict masc(21) ;
	         valid fn_codigo(@VM_CODPR,{'PROD',  {||PROD->(dbseek(str(VM_CODPR,L_P)))},NIL,{3,2}});
				when pb_msg('Selecione um produto ou <ESC> para sair.')
	read
	setcolor(VM_CORPAD)
	if lastkey()#K_ESC
		select('UMIDADE')
		pb_msg('Selecionando Produto')
		SET SCOPE TO str(VM_CODPR,L_P)
		subIndex on UMIDADE->UM_CODPR to SAGATMPU
		DbGoTop()
		SAGPUMI0()
		EXIT
	else
		exit
	end
end
dbcommit()
dbcloseall()

//-----------------------------------------------------------------------------*
  function SAGPUMI0()	// Tabela de Umidade
//-----------------------------------------------------------------------------*
pb_dbedit1('SAGPUMI')
VM_CAMPO:={field(2),field(3),field(4),field(5)}
dbedit(08,01,21,78,VM_CAMPO,'PB_DBEDIT2',;
						{     mI62 ,     mI62 ,       mI62 ,        mI62 },;
						{'%Umidade','%Secagem','%Desc Umid','%Desc Armaz'})
return NIL

//-----------------------------------------------------------------------------*
  function SAGPUMI1() // Rotina de Inclus„o
//-----------------------------------------------------------------------------*
while lastkey()#27
	dbgobottom()
	dbskip()
	SAGPUMIT(.T.)
	dbrunlock(recno())
end
return NIL

//-----------------------------------------------------------------------------*
  function SAGPUMI2() // Rotina de Alteracao
//-----------------------------------------------------------------------------*
if reclock()
	SAGPUMIT(.F.)
	dbrunlock(recno())
end
return NIL

//-----------------------------------------------------------------------------*
  function SAGPUMIT(VM_FL)
//-----------------------------------------------------------------------------*
local GETLIST := {}
lCont := .T.
for nX:=2 to fcount()
	cY :='VM'+substr(fieldname(nX),3)
	private &cY
	&cY:=fieldget(nX)
next
nX:=21-4
pb_box(X++,33,,,,'Tabela de Umidade')
@nX++,35 say '% Umidade.........:' get VM_PERUM pict mI62 valid VM_PERUM >=0.and.pb_ifcod2(str(VM_CODPR,L_P)+str(VM_PERUM,6,2),.F.) when VM_FL
@nX++,35 say '% Secagem.........:' get VM_PERSE pict mI62 valid VM_PERSE >=0
@nX++,35 say '% Desc Umidade....:' get VM_PERDU pict mI62 valid VM_PERDU >=0
@nX++,35 say '% Desc Armazenagem:' get VM_PERDA pict mI62 valid VM_PERDA >=0
//-----------------------------------------------------------------------
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		lCont:=addrec()
	end
	if lCont
		for nX:=1 to fcount()
			Y:="VM"+substr(fieldname(nX),3)
			replace &(fieldname(nX)) with &Y
		next
		dbcommit()
		dbskip(0)
	end
end
return NIL
//-----------------------------------------------------------------------------*
  function SAGPUMI3() // Rotina de Pesquisa
  return NIL

//-----------------------------------------------------------------------------*
  function SAGPUMI4() // Rotina de Exclusao
  elimina_reg('Excluir PRODUTO..:'+pb_zer(UM_CODPR,L_P)+' % Secagem '+str(UM_PERSE,6,2))
  return NIL

//-----------------------------------------------------------------------------*
  function SAGPUMI5() // Rotina de Impressao
  return NIL

//-----------------------------------------------------------------------------*
  function SAGPUMIX(P1)
//-----------------------------------------------------------------------------*
cARQ:='SAGAUM'
if dbatual(cARQ,;
				{{'UM_CODPR' ,'N',L_P,  0},;	// 01-Cod.Produto
				 {'UM_PERUM' ,'N',  6,  2},;	// 02-% Umidade
				 {'UM_PERSE' ,'N',  6,  2},;	// 03-% Secagem
				 {'UM_PERDU' ,'N',  6,  2},;	// 04-% Desconto Umidade
				 {'UM_PERDA' ,'N',  6,  2}},;	// 05-% Desconto Armazenagem
				 RDDSETDEFAULT())
	ferase(cARQ+OrdBagExt())
end
//------------------------------------------------* PRODUTOS DO ESTOQUE
if !file(cARQ+OrdBagExt()).or.P1
	if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg(cARQ+' Reorg.TABELA UMIDADE - Reg:'+str(LastRec(),7))
		pack
		Index on str(UM_CODPR,L_P)+str(UM_PERUM,6,2) tag CODIGO of (cARQ) eval {||ODOMETRO('CODIGO')}
		close
	end
end
return NIL
//------------------------------------------------EOF