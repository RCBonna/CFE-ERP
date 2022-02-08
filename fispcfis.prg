static MODNF:={;
		{'01','Nota Fiscal                                     '},;
		{'02','Nota Fiscal de Venda a Consumidor               '},;
		{'03','Nota Fiscal de Entrada                          '},;
		{'04','Nota Fiscal de Produtor                         '},;
		{'06','Nota Fiscal/Conta de Energia Eletrica           '},;
		{'07','Nota Fiscal de Servico de Transporte            '},;
		{'08','Conhecimento de Transporte Rodoviario de Cargas '},;
		{'09','Conhecimento de Transporte Aquaviario de Cargas '},;
		{'10','Conhecimento Aereo                              '},;
		{'11','Conhecimento de Transporte Ferroviario de Cargas'},;
		{'13','Bilhete de Passagem Rodoviario                  '},;
		{'14','Bilhete de Passagem Aquaviario                  '},;
		{'15','Bilhete de Passagem e Nota de Bagagem           '},;
		{'16','Bilhete de Passagem Ferroviario                 '},;
		{'17','Despacho de Transporte                          '},;
		{'18','Resumo Movimento Diario                         '},;
		{'20','Ordem de Coleta de Carga                        '},;
		{'21','Nota Fiscal de Servico de Comunicacao           '},;
		{'22','Nota Fiscal de Servico de Telecomunicacoes      '},;
		{'24','Autorizacao de Carregamento e Transporte        '},;
		{'25','Manifesto de Carga                              '},;
		{'55','NF-e - Nota Fiscal Eletronica                   '},;
		{'57','Conhecimento de Transporte Eletronico - CT-e    '},;
		{'59','Cupom Fiscal Eletronico - CF-e                  '}}

*-----------------------------------------------------------------------------*
function FISPCFIS()	//	Cadastro de CODIGOS DE MODELOS FISCAL
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*--------------------------------MODELOS
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->FISAMOD'})
	return NIL
end
pb_dbedit1('FISPCFIS')  // tela
VM_CAMPO:=fcount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{  mUUU  ,      mXXX },;
			{'MODELO','DESCRICAO'};
			)
dbcommit()
dbcloseall()
return NIL
*-------------------------------------------------------------------*
	function FISPCFIS1() // Rotina de Inclus„o
*-------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	FISPCFIST(.T.)
end
return NIL
*-------------------------------------------------------------------* 
	function FISPCFIS2() // Rotina de Altera‡„o
*-------------------------------------------------------------------*
if reclock()
	FISPCFIST(.F.)
end
return NIL
*-------------------------------------------------------------------* 
	function FISPCFIS3() // Rotina de Pesquisa
*-------------------------------------------------------------------*
return NIL
*-------------------------------------------------------------------* 
function FISPCFIS4() // Rotina de Exclusao
*-------------------------------------------------------------------*
if reclock().and.pb_sn('Eliminar ( '+MD_CODMOD+'-'+trim(MD_DESC)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL
*-------------------------------------------------------------------* 
	function FISPCFIST(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {}
local LCONT   :=.T.
local X
local X1
for X :=1 to fcount()
	X1 :="VM"+substr(fieldname(X),3)
	&X1:=fieldget(X)
next
pb_box(19,00,,,,'TIPOS DE DOCUMENTO FISCAL/MODELOS DOCUMENTOS')
@20,01 say 'Modelo NF/Cod.Doc.Fis:' get VM_CODMOD pict mUUU valid !empty(VM_CODMOD).and.pb_ifcod2(VM_CODMOD,NIL,.F.,1) when VM_FL
@21,01 say 'Descricao............:' get VM_DESC   pict mXXX valid !empty(VM_DESC)			when pb_msg('Descricao do Tipo de Documento Interno/Modelo')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		for X:=1 to fcount()
			X1:="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &X1
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL

*------------------------------------------------* Modelo de documentos
function Cria_CFIS(P1,P2)
*------------------------------------------------* Modelo de documentos
local ARQ:='FISAMOD'
local X1
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'MD_CODMOD','C',  2, 0},;	// 1-SU // B1 // ...
				 {'MD_DESC',  'C', 50, 0}},;	// 2-Descricao tipo NF
				  RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Comp. Codigos Modelos Fiscais - '+Str(LastRec(),7),NIL,.F.)
		if LastRec()<2
			for X1:=1 to len(MODNF)
				AddRec(,{;
							MODNF[X1][1],;
							MODNF[X1][2],;
							})
			next
		end
		pack
		Index on MD_CODMOD tag CODIGO to (Arq) eval {||ODOMETRO('CODIGO')}
		close
	end
end
return NIL
*------------------------------------------EOF------------------------------------
