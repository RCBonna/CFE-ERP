*-----------------------------------------------------------------------------*
  static aVariav := {.T.,'','',0,.T.,{}}
*....................1..2...3.4...5..6..7..8...9.10.11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate cFilter			=> aVariav\[  1 \]
#xtranslate Data_Ini			=> aVariav\[  2 \]
#xtranslate Data_Fim			=> aVariav\[  3 \]
#xtranslate nContador		=> aVariav\[  4 \]
#xtranslate lLibMSG			=> aVariav\[  5 \] // ALT + A
#xtranslate aLog				=> aVariav\[  6 \] // ALT + A

#include 'RCB.CH'
*-----------------------------------------------------------------------------
	function EXCESSAO()	//	Arquivo de Excessão
*-----------------------------------------------------------------------------
cFilter:=''
pb_lin4(_MSG_,ProcName())
if !abre({	'C->PARAMETRO',;
				'C->EXCESSAO'})
	return NIL
end
pb_dbedit1('EXCESSAO','FiltroPesqu Exclui')  // tela
VM_CAMPO:=FCount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{	mDT,	  mUUU,		mUUU,			mUUU,		mUUU},;
			{'Data', 'Hora','Tipo Log','Descricao','Usuario'};
			)
dbcommit()
dbcloseall()
return NIL

*-----------------------------------------------------------------------------
	function EXCESSAO1()	//	Filtro do LOG
*-----------------------------------------------------------------------------
if len(cFilter)=0
	Data_Ini:=DATA_O-7
	Data_Fim:=DATA_O
	pb_box(19,50,,,,'Filtro Selecione Limites')
	@20,51 say 'Data Inicio:' Get Data_Ini Pict mDT
	@21,51 say 'Data Final.:' Get Data_Fim Pict mDT valid Data_Fim>=Data_Ini
	read
	if lastkey()#K_ESC
		DbSetFilter( {|| DtoS(DATA_O)>=DtoS(Data_Ini).and.DtoS(DATA_O)<=DtoS(Data_Fim) },;
							 "DtoS(DATA_O)=>DtoS(Data_Ini).and.DtoS(DATA_O)<=DtoS(Data_Fim)")
		cFilter:='-Com Filtro'
	end
else
	DbClearFilter()
	pb_msg('Limpeza do Filtro...',2)
	cFilter:=''
end
DbGoTop()
pb_lin4(_MSG_,ProcName()+cFilter)
return NIL

*-----------------------------------------------------------------------------
	function EXCESSAO2()	//	Pesquisar uma data do LOG
*-----------------------------------------------------------------------------
Data_Ini:=DATA_O
pb_box(19,50,,,,'Pesquisar Data')
@21,51 say 'Data Inicio:' Get Data_Ini Pict mDT
read
if lastkey()#K_ESC
	dbseek(DtoS(Data_Ini),.T.)
end
return NIL

*-----------------------------------------------------------------------------
	function EXCESSAO3()	//	Ecluir Registros
*-----------------------------------------------------------------------------
if empty(cFilter)
	Data_Ini	:=DATA_O-7
	Data_Fim	:=DATA_O
	nContador:=0
	pb_box(19,50,,,,'Periodo de exclusao')
	@20,51 say 'Data Inicio:' Get Data_Ini Pict mDT
	@21,51 say 'Data Final.:' Get Data_Fim Pict mDT valid Data_Fim>=Data_Ini
	read
	if lastkey()#K_ESC
		DbSetFilter( {|| DtoS(DATA_O)>=DtoS(Data_Ini).and.DtoS(DATA_O)<=DtoS(Data_Fim) },;
							 "DtoS(DATA_O)=>DtoS(Data_Ini).and.DtoS(DATA_O)<=DtoS(Data_Fim)")
		DbGoTop()
		while !eof()
			if RecLock()
				DbDelete()
				DbRUnlock()
				nContador++
				pb_msg('Eliminando Registro de Log:'+Str(nContador,5))
			end
		end
		DbClearFilter()
		DbGoTop()
		Alert('Eliminado '+Str(nContador,5)+' Registros de Log')
	end
else
	Alert('Foi definido Filtro;Favor liberar Fitro;Nao pode ser eliminado registros')
end
return NIL

*-----------------------------------------------------------------------------
	function EXCESSAO4()	//	Arquivo de Excessão
*-----------------------------------------------------------------------------


*-----------------------------------------------------------------------------
	function EXCESSAO5()	//	Arquivo de Excessão
*-----------------------------------------------------------------------------


*-----------------------------------------------------------------------------
	function EXCESSAO_Grava(dDados)	//	Arquivo de Excessão
*-----------------------------------------------------------------------------
SALVABANCO
select EXCESSAO
if len(dDados)>0 // Tem Log Para Gravar
	for X:=1 to len(dDados)
		addrec(,dDados[X])
	next
end
RESTAURABANCO

return NIL
//-----------------------------------------------------------------------------
	function EXCESSAO_Cria(P1,P2)	//	Arquivo de Excessão
//-----------------------------------------------------------------------------
cArq:='EXCESSAO'
if P2=='VER ARQUIVOS'.and.;
	dbatual(cArq,;
				{{'DATA_O',		'D',  8, 0},;	// 1-
				 {'HORA_O',		'C',  8, 0},;	// 2-
				 {'TIPO_O',		'C', 15, 0},;	// 3-
				 {'DESC_O',		'C', 60, 0},;	// 4-
				 {'USUA_O',		'C', 15, 0};	// 5-
				},;
				RDDSETDEFAULT())
	ferase(cArq+OrdBagExt())
end
*------------------------------------------------* Reindexar
if !file(cArq+OrdBagExt()).or.P1
	if net_use(cArq,.T.,20,cArq,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Reorg. OCORRENCIAS',NIL,.F.)
		pack
		Index on DtoS(DATA_O)+HORA_O;
					tag ODTHORA			to (cArq) eval ODOMETRO()	DESCENDING // 
		close
	end
end
*------------------------------------------EOF-----------------------------------------------