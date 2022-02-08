*-----------------------------------------------------------------------------*
 static aVariav:= {0,0,.T.,0,0,'','' }
 //.................1.2..3.4.5,6..7
#xtranslate nDT     => aVariav\[  1 \]
#xtranslate nX      => aVariav\[  2 \]
#xtranslate lCont   => aVariav\[  3 \]
#xtranslate nPag    => aVariav\[  4 \]
#xtranslate nLar    => aVariav\[  5 \]
#xtranslate cRel    => aVariav\[  6 \]
#xtranslate cArq    => aVariav\[  7 \]

function CTRPSUIN()	//	Cadastro de Grupos de Produtos							*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->CLIENTE',;
				'C->CTRASUIN'})
	return NIL
end
ordem CSDATA
pb_tela()
pb_lin4(_MSG_,ProcName())
set relation to str(CS_CODCL,5) into CLIENTE

pb_dbedit1('CTRPSUIN','IncluiAlteraPesquiExcluiLista Gerar ')
VM_CAMPO := array(fCount())
VM_CABE  := array(fCount())
afields(VM_CAMPO)
aeval(VM_CAMPO,{|DET,N|VM_CABE[N]:=substr(DET,4)})
VM_CAMPO[1]:='str(CS_CODCL,5)+chr(45)+left(CLIENTE->CL_RAZAO,20)'

dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',,VM_CABE)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUIN1() // Rotina de Inclus„o
*-----------------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	nDT:=CS_DTLEVA
	dbskip()
	CTRPSUINT(.T.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUIN2() // Rotina de Alteracao
if reclock()
	CTRPSUINT(.F.)
	dbrunlock(recno())
end
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUINT(VM_FL)
*-----------------------------------------------------------------------------*
for X :=1 to fcount()
	X1 :="VM"+substr(fieldname(X),3)
	&X1:=&(fieldname(X))
next
VM_DTLEVA:=if(empty(VM_DTLEVA), nDT,VM_DTLEVA)
VM_CODPRO:=if(empty(VM_CODPRO),   1,VM_CODPRO)
VM_CODPOC:=if(empty(VM_CODPOC),   1,VM_CODPOC)
VM_TPCRIA:=if(empty(VM_TPCRIA),   1,VM_TPCRIA)
VM_TPRACA:=if(empty(VM_TPRACA),'VC',VM_TPRACA)

pb_box(05,00,,,,'Informacoes - Controle de Suinos')
X:=6
@X++,02 say 'Dt Levantamento:' get VM_DTLEVA pict mDT when VM_FL
@X++,02 say 'Cod Associado..:' get VM_CODCL ;
		  valid fn_codigo(@VM_CODCL,  {'CLIENTE', {||CLIENTE-> (dbseek(str(VM_CODCL,5)))},{||CFEP3100T(.T.)},{2,1,8,7}});
		  pict mI5 ;
		  when VM_FL

@X++,02 say 'Cod.Propriedade:' get VM_CODPRO pict mI1  valid VM_CODPRO>0 when VM_FL
@X++,02 say 'Cod.Pociga.....:' get VM_CODPOC pict mI1  valid VM_CODPRO>0.and.pb_ifcod2(dtos(VM_DTLEVA)+str(VM_CODCL,5)+str(VM_CODPRO,2)+str(VM_CODPOC,2),NIL,.F.,2) when VM_FL
@X++,02 say 'Tipo Criacao...:' get VM_TPCRIA pict mI1  valid VM_TPCRIA>0.and.VM_TPCRIA<3 when pb_msg('Tipo Criacao: 1-Ciclo Completo, 2-Iniciador,  3-Terminador')
@X++,02 say 'Raca Suino.....:' get VM_TPRACA pict mUUU valid VM_TPRACA$'VC#' when pb_msg('Tipo Raca: VC')

@X++,02 say 'Qtde Machos Integrados.:' get VM_QTMACI pict mI4  valid VM_QTMACI>=0
@X++,02 say 'Qtde Machos Eliminados.:' get VM_QTMACE pict mI4  valid VM_QTMACE>=0

@X++,02 say 'Qtde Femeas Integrados.:' get VM_QTFEMI pict mI4  valid VM_QTFEMI>=0
@X++,02 say 'Qtde Femeas Eliminados.:' get VM_QTFEME pict mI4  valid VM_QTFEME>=0

@X++,02 say 'Qtde Machos............:' get VM_QTMACX pict mI4  valid VM_QTMACX>=0
@X++,02 say 'Qtde Femeas............:' get VM_QTFEMX pict mI4  valid VM_QTFEMX>=0
@X++,02 say 'Qtde Leitoas...........:' get VM_QTLEIT pict mI4  valid VM_QTLEIT>=0
@X++,02 say 'Qtde Suinos Mamados....:' get VM_QTMAMA pict mI4  valid VM_QTMAMA>=0
@X++,02 say 'Qtde Suinos Recrias....:' get VM_QTRECR pict mI4  valid VM_QTRECR>=0
@X++,02 say 'Qtde Suinos Engorda....:' get VM_QTENGO pict mI4  valid VM_QTENGO>=0
X:=X-4
@X++,42 say 'Qtde Prev.Entr. 30 Dias:' get VM_QTPR30 pict mI4  valid VM_QTPR30>=0
@X++,42 say 'Qtde Prev.Entr. 60 Dias:' get VM_QTPR60 pict mI4  valid VM_QTPR60>=0
@X++,42 say 'Qtde Prev.Entr. 90 Dias:' get VM_QTPR90 pict mI4  valid VM_QTPR90>=0
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	lCont:=.T.
	if VM_FL
		LCONT:=AddRec()
	end
	if lCont
		for X :=1 to fcount()
			X1 :='VM'+substr(fieldname(X),3)
			fieldPut(X,	&X1)
		next
	end
end
return NIL
*-----------------------------------------------------------------------------*
function CTRPSUIN3() // Rotina de Pesquisa
*-----------------------------------------------------------------------------*
pb_box(20,26,,,,'Pesquisar')
nDT:=CS_DTLEVA
@21,30 say 'Dt Levant' get nDT pict mDT
read
setcolor(VM_CORPAD)
dbseek(dtos(nDT),.T.)
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUIN4() // Rotina de Exclusao
*-----------------------------------------------------------------------------*
if reclock().and.pb_sn('Excluir DT: '+transform(CS_DTLEVA,mDT)+'-'+trim(&(VM_CAMPO[1])))
	fn_elimi()
end
dbrunlock()
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUIN5() // Impressao de grupos
*-----------------------------------------------------------------------------*
nPag:=0
nLar:=132
DbGoTop()
pb_box(20,26,,,,'Selecao impressao')
nDT:=CS_DTLEVA
@21,30 say 'Data Levantantamento:' get nDT pict mDT
read
setcolor(VM_CORPAD)
dbseek(dtos(nDT),.T.)
if pb_ligaimp(I15CPP)
	cRel:='Lista Controle Suinos - Data Levantamento: '+transform(nDT,mDT)
	while !eof().and.dtos(CS_DTLEVA)==dtos(nDT)
		nPag:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),cRel,nPag,'CTRPSUIN5A',nLar)
		? &(VM_CAMPO[1])+space(3)
		??str(CS_CODPRO,  2)+space(3)
		??str(CS_CODPOC,  2)+space(3)
		??str(CS_TPCRIA,  1)+space(3)
		??CS_TPRACA+space(3)
		??str(CS_QTMACI,  4)+space(3)
		??str(CS_QTMACE,  4)+space(3)
		??str(CS_QTFEMI,  4)+space(3)
		??str(CS_QTFEME,  4)+space(3)
		??str(CS_QTMACX,  4)+space(3)
		??str(CS_QTFEMX,  4)+space(3)
		??str(CS_QTLEIT,  4)+space(3)
		??str(CS_QTMAMA,  4)+space(3)
		??str(CS_QTRECR,  4)+space(2)
		??str(CS_QTENGO,  4)+space(2)
		??str(CS_QTPR30,  4)+space(2)
		??str(CS_QTPR60,  4)+space(2)
		??str(CS_QTPR90,  4)
		pb_brake()
	end
	DbGoTop()
	? replicate('-',nLar)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
DbGoTop()
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUIN5A() // Cabecalho Lista Grupos
*-----------------------------------------------------------------------------*
?'Codigo-Nome Associado     Propr Poci Tipo Raca M Ini  M Eli  F Ini  F Eli Qd Mac Qd Fem Q Leit Qd Mam Q Recr Q Eng Q 30d Q 60d Q 60d'
?replicate('-',nLar)
return NIL

*-----------------------------------------------------------------------------*
function CTRPSUIN6() // Gerar
*-----------------------------------------------------------------------------*
DbGoTop()
pb_box(19,26,,,,'Selecao Geracao')
nDT:=CS_DTLEVA
cArq:='COOLACER'
@20,30 say 'Nome Arquivo........:' get cArq pict mUUU valid !empty(cArq)
@21,30 say 'Data Levantantamento:' get nDT pict mDT
read
setcolor(VM_CORPAD)
dbseek(dtos(nDT),.T.)
cArq:='\TEMP\'+cArq+'.TXT'
if pb_ligaimp(,cArq)
	while !eof().and.dtos(CS_DTLEVA)==dtos(nDT)
		??'10;'
		??pb_zer(CS_CODCL, 6)+';'
		??pb_zer(CS_CODPRO,2)+';'
		??pb_zer(CS_CODPOC,2)+';'
		??dtos(CS_DTLEVA)+';'
		??pb_zer(CS_TPCRIA,1)+';'
		??CS_TPRACA+';'
		??pb_zer(CS_QTMACI,4)+';'
		??pb_zer(CS_QTMACE,4)+';'
		??pb_zer(CS_QTFEMI,4)+';'
		??pb_zer(CS_QTFEME,4)+';'
		??pb_zer(CS_QTMACX,4)+';'
		??pb_zer(CS_QTFEMX,4)+';'
		??pb_zer(CS_QTLEIT,4)+';'
		??pb_zer(CS_QTMAMA,4)+';'
		??pb_zer(CS_QTRECR,4)+';'
		??pb_zer(CS_QTENGO,4)+';'
		??pb_zer(CS_QTPR30,4)+';'
		??pb_zer(CS_QTPR60,4)+';'
		??pb_zer(CS_QTPR90,4)+';'
		??space(28)+';'
		?
		pb_brake()
	end
	DbGoTop()
	pb_deslimp(,,.F.)
	alert('Arquivo '+cArq+';Gerado com sucesso')
end
DbGoTop()
return NIL

*----------------------------------------------------------------------------------------------
 function CRIA_CTRASUIN(P1,P2)
*------------------------------------------------* Criacao - arquivo - Controle de Suino
local ARQ:='CTRASUIN'
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'CS_CODCL', 'N',  5, 0},;	// 01-CODIGO ASSOCIADO
				 {'CS_CODPRO','N',  2, 0},;	// 02-Codigo Propriedade
				 {'CS_CODPOC','N',  2, 0},;	// 03-Codigo Pocilga
				 {'CS_DTLEVA','D',  8, 0},;	// 04-Data Levantamento
				 {'CS_TPCRIA','N',  1, 0},;	// 05-Tipo Cria‡„o (1=Ciclo Completo, 2=Iniciador,3=Terminador)
				 {'CS_TPRACA','C',  2, 0},;	// 06-Tipo Ra‡a Suino ("VC")
				 {'CS_QTMACI','N',  4, 0},;	// 07-Quantidade Machos Integrados
				 {'CS_QTMACE','N',  4, 0},;	// 08-Quantidade Machos Eliminados
				 {'CS_QTFEMI','N',  4, 0},;	// 09-Quantidade Femeas Integrados
				 {'CS_QTFEME','N',  4, 0},;	// 10-Quantidade Femeas Eliminadas
				 {'CS_QTMACX','N',  4, 0},;	// 11-Quantidade Machos
				 {'CS_QTFEMX','N',  4, 0},;	// 08-Quantidade Femeas
				 {'CS_QTLEIT','N',  4, 0},;	// 08-Quantidade Leitoas
				 {'CS_QTMAMA','N',  4, 0},;	// 08-Quantidade Suinos Mamados
				 {'CS_QTRECR','N',  4, 0},;	// 08-Quantidade Suinos Recrias
				 {'CS_QTENGO','N',  4, 0},;	// 08-Quantidade Suinos Engordas
				 {'CS_QTPR30','N',  4, 0},;	// 08-Quantidade Prevista Entrega 30 Dias
				 {'CS_QTPR60','N',  4, 0},;	// 08-Quantidade Prevista Entrega 60 Dias
				 {'CS_QTPR90','N',  4, 0}},;	// 08-Quantidade Prevista Entrega 90 Dias
				 RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end

*------------------------------------------------* Criacao - indices - Controle de Suino
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
	pb_msg(ARQ+'Reorg. Controle Suinos/Pocilgas - Reg:'+str(LastRec(),7))
		pack
		Index on str(CS_CODCL,5)+str(CS_CODPRO,2)+str(CS_CODPOC,2)+dtos(CS_DTLEVA) tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		Index on dtos(CS_DTLEVA)+str(CS_CODCL,5)+str(CS_CODPRO,2)+str(CS_CODPOC,2) tag CSDATA to (Arq) eval {||ODOMETRO('DATA')}
		close
	end
end
return NIL
*----------------------------------------------------------------------------------------------
