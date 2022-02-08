*-----------------------------------------------------------------------------*
	function CFEPATNF()	//	Cadastro de TIPO DE SERIE/NF
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*--------------------------------MODELOS
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->FISAMOD',;
				'C->CTRNF'})
	return NIL
end

pb_dbedit1('CFEPATNF')  // tela
VM_CAMPO:=fcount()
afields(VM_CAMPO)

dbedit(06,01,maxrow()-3,maxcol()-1,;
			VM_CAMPO,;
			'PB_DBEDIT2',;
			{  mUUU ,     mUUU  ,    mI8 ,   mI3 ,   mUUU ,   mUUU ,    mI62 ,   mUUU , mUUU,mUUU,  mUUU ,   mUUU },;
			{'SERIE','DESCRICAO','ULTIMA','NRLIN','FATURA','TRANSP','%FINANC','MODELO','ST','Cupom',"Sit","Cupom?"};
			)
dbcommit()
dbcloseall()
return NIL

*-------------------------------------------------------------------*
	function CFEPATNF1() // Rotina de Inclus„o
*-------------------------------------------------------------------*
while lastkey()#K_ESC
	dbgobottom()
	dbskip()
	CFEPATNFT(.T.)
end
return NIL
*-------------------------------------------------------------------* 
	function CFEPATNF2() // Rotina de Altera‡„o
*-------------------------------------------------------------------*
if reclock()
	CFEPATNFT(.F.)
end
return NIL
*-------------------------------------------------------------------* 
function CFEPATNF3() // Rotina de Pesquisa
*-------------------------------------------------------------------*
return NIL
*-------------------------------------------------------------------* 
function CFEPATNF4() // Rotina de Exclusao
*-------------------------------------------------------------------*
if reclock().and.pb_sn('Eliminar ( '+NF_TIPO+'-'+trim(NF_DESC)+' ) ?')
	fn_elimi()
end
dbrunlock()
return NIL
*-------------------------------------------------------------------* 
 function CFEPATNFT(VM_FL)
*-------------------------------------------------------------------* 
local GETLIST := {}
local VM_CTCPL
local X
local X1
local LCONT:=.T.
local ORDANT
for X :=1 to fcount()
	X1 :="VM"+substr(fieldname(X),3)
	&X1:=fieldget(X)
next
VM_TEMFAT := if(VM_TEMFAT,'S','N')
VM_TEMTRA := if(VM_TEMTRA,'S','N')
VM_CUPFIS := if(VM_CUPFIS,'S','N')
pb_box(12,25,,,,'SERIES/TIPOS')
@13,27 say 'Tipo/Serie...........:' get VM_TIPO   pict mUUU valid !empty(VM_TIPO).and.pb_ifcod2(VM_TIPO,NIL,.F.,1) when VM_FL
@14,27 Say 'Cupom Fiscal?         ' get VM_CUPFIS pict mUUU valid VM_CUPFIS$'SN'				when pb_msg('Serie de Cupom Fiscal ?').and.PARAMETRO->PA_EMCUFI
@15,27 say 'Descricao............:' get VM_DESC   pict mUUU valid !empty(VM_DESC)			when pb_msg('Descricao do tipo de documento interno')
@16,27 say 'Ultimo Nr............:' get VM_NUMER  pict mI6  valid VM_NUMER>=0					when VM_CUPFIS=='N'
@17,27 say 'Nr Linhas............:' get VM_NRLIN  pict mI6  valid VM_NRLIN>=0					when VM_CUPFIS=='N'
@18,27 say 'Usa Faturamento......:' get VM_TEMFAT pict mUUU valid VM_TEMFAT$'SN'				when VM_CUPFIS=='N'
@19,27 say 'Usa Transportador....:' get VM_TEMTRA pict mUUU valid VM_TEMTRA$'SN'				when VM_CUPFIS=='N'
@20,27 say '% Financeiro.........:' get VM_PERFIN pict mI62 valid VM_PERFIN>=0				when pb_msg('% de aumento financeiro quando da venda a prazo')
@21,27 say 'Modelo NF/Cod.Doc.Fis:' get VM_MODELO pict mUUU valid fn_codigo(@VM_MODELO, {'FISAMOD',{||FISAMOD->(dbseek(VM_MODELO))},{||FISPCFIST(.T.)},{2,1}}) ;
																				when  pb_msg('Codigo de Documento Fiscal - Tabela 3.1')
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if VM_FL
		LCONT:=AddRec()
	end
	if LCONT
		VM_TEMFAT:=VM_TEMFAT=='S'
		VM_TEMTRA:=VM_TEMTRA=='S'
		VM_CUPFIS:=VM_CUPFIS=='S'
		if VM_CUPFIS
			VM_NRLIN := 50
		end
		for X:=1 to fcount()
			X1:="VM"+substr(fieldname(X),3)
			replace &(fieldname(X)) with &X1
		next
		dbcommit()
	end
end
dbrunlock(recno())
return NIL

*-------------------------------------------------------------------------*
 static function FN_CODARNF(P1)
*-------------------------------------------------------------------------*
local RT:=.T.,TF
local P4:=ascan(MODNF,{|DET|DET[1]==P1})
if P4==0
	TF:=savescreen(5,0,17,60)
	salvacor(SALVA)
	setcolor('W+/RB')
	P4:=abrowse(5,0,17,60,MODNF,{'Mod','Descricao'},{5,len(MODNF[1,2])},{'99','@KX'})
	restscreen(05,0,17,60,TF)
	salvacor(RESTAURA)
	if P4>0
		keyboard chr(13)
		RT:=.F.
	else
		P4:=1
	end
	P1:=MODNF[P4,1]
else
	@row(),col() say '-'+MODNF[P4,2]
end
return (RT)

*------------------------------------------------* Numero de documentos
function Cria_Serie(P1,P2)
*------------------------------------------------* Numero de documentos
local ARQ:='CFEANF'
local ARRSERIE
local X1
if P2=='VER ARQUIVOS'.and.;
	dbatual(ARQ,;
				{{'NF_TIPO',  'C',  3, 0},;	// 1-SU // B1 // ...
				 {'NF_DESC',  'C', 15, 0},;	// 2-Descricao tipo NF
				 {'NF_NUMER', 'N',  9, 0},;	// 3-NUMERO DA NF
				 {'NF_NRLIN', 'N',  3, 0},;	// 4-NUMERO DE LINHAS
				 {'NF_TEMFAT','L',  1, 0},;	// 5-tem faturamento ?
				 {'NF_TEMTRA','L',  1, 0},;	// 6-tem transportador
				 {'NF_PERFIN','N',  5, 2},;	// 7-% financeiro 999,99
				 {'NF_MODELO','C',  2, 0},;	// 8-Modelo/Tipo de Documentos Fiscais
				 {'NF_SITUA', 'C',  1, 0},;	// 9-SITUACAO F/L/T
				 {'NF_CUPFIS','L',  1, 0}},;	// 10-Cupom Fiscal ?
				  RDDSETDEFAULT())
	ferase(ARQ+OrdBagExt())
end
*------------------------------------------------* reindexar
if !file(ARQ+OrdBagExt()).or.P1
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Comp. CTRL DAS NF/PEDIDOS - '+Str(LastRec(),7),NIL,.F.)
		pack
		Index on NF_TIPO tag TIPONR to (Arq) eval {||ODOMETRO('TIPONR')}
		close
	end
end
return NIL
*------------------------------------------EOF------------------------------------