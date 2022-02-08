*-----------------------------------------------------------------------------*
 static aVariav := {0,0,'',.T.,0,'ADT',0,0, 0, 0, 0, 0,{}, 0, 0, 0, 0,'','A'}
 //.................1.2..3..4, 5..6,  7,  8,9,10,11.12,13,14.15.16,17.18.19,20
*---------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nX1        => aVariav\[  2 \]
#xtranslate cARQ       => aVariav\[  3 \]
#xtranslate lCont      => aVariav\[  4 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function FATPDEST()	//	
*-----------------------------------------------------------------------------*
*--------------------------------MODELOS
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->CTADET',;
				'E->CTACTB',;
				'C->DESTRANSF'})
	return NIL
end
pb_dbedit1('FATPDEST')  // Tela
VM_CAMPO:=fcount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{  mI2,      mUUU , mUUU, mI4,mI1},;
			{'Cod','Descricao', 'TP','CC','M'};
			)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------* Fim
 function FATPDEST1() // Rotina de Inclus„o
*-------------------------------------------------------------------* Fim
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FATPDESTT(.T.)
end
return NIL
*-------------------------------------------------------------------* 
 function FATPDEST2() // Rotina de Altera‡„o
*-------------------------------------------------------------------* 
if RecLock()
	FATPDESTT(.F.)
end
return NIL
*-------------------------------------------------------------------* 
 function FATPDEST3() // Rotina de Pesquisa
return NIL
*-------------------------------------------------------------------* 
function FATPDEST4() // Rotina de Exclusao
if reclock().and.pb_sn('Eliminar ( '+trim(DT_DESC)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL

function FATPDEST5() // Rotina de Exclusao
return NIL


*-------------------------------------------------------------------* 
 function FATPDESTT(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {}
local X1
lCont:=.T.
for nX :=1 to fcount()
	X1 :="VM"+substr(fieldname(nX),3)
	&X1:=fieldget(nX)
next
nX:=16
pb_box(nX++,35,,,,'Informe')
@nX++,37 say 'Codigo.......:' get VM_CODDT  pict mI2  valid !empty(VM_CODDT).and.pb_ifcod2(str(VM_CODDT,2),NIL,.F.,1) when VM_FL
@nX++,37 say 'Descricao....:' get VM_DESC   pict mUUU valid !empty(VM_DESC)
@nX++,37 say 'Tipo.........:' get VM_TIPO   pict mUUU valid VM_TIPO$'ES'          when pb_msg('Tipo Destino Transferencia  <E>ntrada   <S>aida')
@nX++,37 say 'Conta Contab.:' get VM_CC     pict mI4  valid fn_ifconta(,@VM_CC)   when pb_msg('Informe Conta Contabil de Transferencia')
@nX++,37 say 'Modalidade Tr:' get VM_MODTRA pict mI1  valid str(VM_MODTRA,1)$'12' when pb_msg('Modalidade Preco Transferencia  <1>Custo   <2>Venda')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		lCont:=AddRec()
	end
	if lCont
		for nX:=1 to fcount()
			X1:="VM"+substr(fieldname(nX),3)
			FieldPut(nX,&X1)
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL

*------------------------------------------------* Destino Transferencia
 function Cria_DesTr(P1,P2)
*------------------------------------------------* Destino Transferencia
cARQ:='FATADT'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cARQ,;
				{{'DT_CODDT', 'N',  2, 0},;	// 1-Código Destino Transferencia
				 {'DT_DESC',  'C', 20, 0},;	// 2-Descricao 
				 {'DT_TIPO',  'C',  1, 0},;	// 3-Tipo <E>ntradas   <S>aidas
				 {'DT_CC',    'N',  4, 0},;	// 4-Código Contábil
				 {'DT_MODTRA','N',  1, 0}},;	// 5-Modalidade Transf 1-Preco Custo   2-Preco Venda
				  RDDSETDEFAULT())
	ferase(cARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(cARQ+OrdBagExt()).or.P1
	if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Comp. CTRL DAS NF/PEDIDOS',NIL,.F.)
		pack
		pb_msg('Reorg. Destino Transferencias',NIL,.F.)
		Index on str(DT_CODDT,2) tag CODIGO to (cARQ) eval ODOMETRO()
		Index on     DT_DESC     tag ALFA   to (cARQ) eval ODOMETRO()
		close
	end
end
return NIL
*--------------------------------------------------------EOF---------------
