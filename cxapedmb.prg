//-----------------------------------------------------------------------------*
  static aVariav := {0}
//...................1
//-----------------------------------------------------------------------------*
#xtranslate nBC     => aVariav\[  1 \]
*-----------------------------------------------------------------------------*
function CXAPEDMB()	//	Digitacao de Depositos/Entradas								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
#include 'hbsix.ch'

private VM_CODBC
if !abre({	'C->PARAMETRO',;
				'C->CTACTB',;
				'C->BANCO',;
				'C->CAIXACG',;
				'C->DIARIO',;
				'C->CTADET',;
				'C->CAIXAMB'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if !cxa_cont()
	dbcloseall()
	return NIL
end

VM_CODBC:=if(BANCO->(lastrec())>1,0,BANCO->BC_CODBC)
if BANCO->(lastrec())>1
	VM_CODBC:=fn_banco()
	if VM_CODBC==0
		dbcloseall()
		return NIL
	end
	KEYBOARD chr(0)
end

pb_msg('Selecionando Banco')
cArq:=ArqTemp(,,'')

//	replace  MB_CODBC with VM_CODBC,;
	//			MB_DATA  with VM_DATA,;
		//		MB_TIPO  with VM_TIPO,;
			//	MB_DOCTO with VM_DOCTO,;


//SET SCOPE TO VM_CODBC
//Index on CAIXAMB->MB_CODBC tag TEMPBANCO to (cArq) // eval ODOMETRO(cArq,'TEMPBANCO')

pb_msg('Selecionando registros do Banco '+Str(VM_CODBC,2)+'-'+BANCO->BC_DESCR)
Index on str(MB_CODBC,2)+dtos(MB_DATA)+str(MB_DOCTO,9) tag DATA2 to (cArq) for MB_CODBC==VM_CODBC additive Temporary

DbGoTop()

pb_tela()
pb_lin4(_MSG_,STR(BANCO->BC_CODBC,2)+'-'+BANCO->BC_DESCR+'SldInic:'+transform(BANCO->BC_SLDINI,masc(2)))

VM_CAMPO    :={'MB_DATA','MB_DOCTO','left(MB_HISTO,32)',    'MB_VALOR',    'MB_CODBC'} //  'MB_SALDO'}
VM_MASC     :={      mDT,       mI9,               mXXX,          mXXX,           mI3} //   mXXX}
VM_CABE     :={   'Data',  'NrDoct',        'Historico','Ext Vlr Lcto',         'BCO'} //  'Saldos'}

VM_CAMPO[04]:='if(MB_EXTRA,"û"," ")+transform(MB_VALOR,masc(25))+MB_TIPO'

setcolor(VM_CORPAD)
pb_dbedit1("CXAPEDMB")
dbedit(06,01,maxrow()-3,maxcol()-1,VM_CAMPO,'PB_DBEDIT2',VM_MASC,VM_CABE)
//SET SCOPE TO VM_CODBC

dbcommit()
dbcloseall()
FileDelete(cArq+'.*')
return NIL

*-----------------------------------------------*  INCLUSAO
function CXAPEDMB1() && Rotina de Inclus„o
while lastkey()#27
	VM_DOCTO := MB_DOCTO + 1
	CXAPEDMBT(.T.)
end
//if pb_sn('Recalcular Saldos?')
//	fn_recsld()
//end
//DbGoTop()
return NIL

*-----------------------------------------------*  ALTERACAO
function CXAPEDMB2() && Rotina de Altera‡„o
VM_DOCTO:=MB_DOCTO
if reclock()
	CXAPEDMBT(.F.)
end
dbrunlock()
return NIL

*-----------------------------------------------*  DIGITACAO INCLUI/ALTERA
function CXAPEDMBT (VM_FL)
VM_DATA := if(VM_FL,date(),MB_DATA)
VM_TIPO := if(VM_FL,'-',MB_TIPO)
VM_HISTO:= if(VM_FL,space(len(MB_HISTO)),MB_HISTO)
VM_VALOR:= if(VM_FL,0.00,MB_VALOR)
VM_ORIG := MB_ORIG
pb_box(17,18,,,,'Movimenta‡Æo da Conta')
@18,20 say 'Data Lan‡amento:' get VM_DATA  pict mDT
@19,20 say 'Nr Documento...:' get VM_DOCTO pict mI6 valid VM_DOCTO>=0 // .and.fn_chkdoc(str(VM_CODBC,2),VM_NRDCT,VM_FL)
@20,20 say 'Historico......:' get VM_HISTO pict mUUU+'S42'
@21,20 say 'Valor/(-)(+)...:' get VM_VALOR pict mI102 valid VM_VALOR>0
@21,50                        get VM_TIPO  pict mUUU  valid VM_TIPO$'-+' when pb_msg('Informe + para entradas ou - para saidas')
read
setcolor(VM_CORPAD)
if if(lastkey()#27,pb_sn(),.F.)
	if VM_FL
		AddRec()
		VM_ORIG:='I'
	end
	replace  MB_CODBC with VM_CODBC,;
				MB_DATA  with VM_DATA,;
				MB_TIPO  with VM_TIPO,;
				MB_DOCTO with VM_DOCTO,;
				MB_HISTO with VM_HISTO,;
				MB_VALOR with VM_VALOR,;
				MB_ORIG  with VM_ORIG
//	if !VM_FL
	//	if pb_sn('Recalcular Saldos?')
	//		fn_recsld()
	//	end
//	end
	dbcommit()
	dbrunlock()
end
return NIL

*-----------------------------------------------*  Pesquisa
function CXAPEDMB3()
local ORD:=max(alert('Ordem de Procura...',{'Data','Documento'}),1)
local CHAVE :=if(ORD==1,{fieldget(2),mDT},{fieldget(3),mI6})
dbsetorder(ORD)
pb_box(17,40)
@18,42 say 'Pesquisa:' get CHAVE[1] pict CHAVE[2]
read
setcolor(VM_CORPAD)
CHAVE[1]:=str(VM_CODBC,2)+if(ORD==1,dtos(CHAVE[1]),str(CHAVE[1],6))
fn_recsld()
dbseek(CHAVE[1],.T.)
return NIL

*-----------------------------------------------*  EXCLUSAO
function CXAPEDMB4() && Rotina de Exclus„o
if reclock().and.pb_sn('Eliminar LANCTO (BCO :'+pb_zer(MB_CODBC,2)+' dcto'+pb_zer(MB_DOCTO,6)+' Vlr $ '+alltrim(transform(MB_VALOR,masc(25)))+') ?')
	VM_MARKDEL=.T.
	dbdelete()
	dbskip()
	if eof();DbGoTop();end
	pb_msg('Registro Eliminado.',1)
end
dbrunlock()

return NIL

*-----------------------------------------------*  IMPRESSAO
function CXAPEDMB5() // Rotina de Impress„o
local   VM_TOTAL:={0,0}
private VM_TIPO :='T'
private VM_DATA :={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
pb_box(15,40)
@16,42 say 'Data Inicial.:' get VM_DATA[1] pict mDT
@17,42 say 'Data Final...:' get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
@18,42 say 'Tipo de Lcto.:' get VM_TIPO    pict masc(1) valid VM_TIPO$'-+T' when pb_msg('Informe + para entradas ou - para saidas T todos')
read
if if(lastkey()#27,pb_ligaimp(chr(18)),.F.)
	ordem GDATA
	set filter to 	CAIXAMB->MB_CODBC==VM_CODBC .and.;
						CAIXAMB->MB_DATA>=VM_DATA[1].and.;
						CAIXAMB->MB_DATA<=VM_DATA[2].and.;
						if(VM_TIPO#'T',CAIXAMB->MB_TIPO==VM_TIPO,.T.)
	DbGoTop()
	VM_PAG := 0
	VM_REL := 'Conf.Movimento'
	VM_REL+='('+dtoc(VM_DATA[1])+' a '+dtoc(VM_DATA[2])+')'
	VM_LAR := 78
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CXAPEDMBC',VM_LAR)
		? dtoc(MB_DATA)    +space(1)
		?? str(MB_DOCTO,7) +space(1)
		??left(MB_HISTO,44)+space(1)
		??transform(MB_VALOR,mD82)
		??MB_TIPO
		VM_TOTAL[if(MB_TIPO=='+',1,2)]+=MB_VALOR
		pb_brake()
 	end
	?replicate('-',VM_LAR)
	if VM_TOTAL[1]>0
		?padr('Total Lancamentos-Entradas',64,'.')+transform(VM_TOTAL[1],mD82)+'+'
	end
	if VM_TOTAL[2]>0
		?padr('Total Lancamentos-Saidas',64,'.')  +transform(VM_TOTAL[2],mD82)+'-'
	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(chr(18))
	set filter to
	KEYBOARD CHR(27)+CHR(27)
end
return NIL

*-----------------------------------------------*  CABECALHO
function CXAPEDMBC()
?padc('Banco : '+BANCO->BC_DESCR,VM_LAR)
?
? padc(VM_CABE[1],9)
??padc(VM_CABE[2],8)
??padr(VM_CABE[3],41)
??padl(VM_CABE[4],14)
//??padl(VM_CABE[5],2)
? replicate('-',VM_LAR)
return NIL

*-----------------------------------------------*  RECALCULAR SALDO
function FN_RECSLD()
local SALDO:=BANCO->BC_SLDINI
pb_msg('Re-Calculando Saldo...')
DbGoTop()
//dbeval({||CAIXAMB->MB_SALDO:=(SALDO+=MB_VALOR*if(MB_TIPO=='+',1,-1))},{||reclock()})
dbrunlock()
DbGoTop()
return NIL

//----------------------------------------------------------------------------
function FN_CHKDOC(P1,P2,P3)
local REG:=recno(),ORD:=indexord()
if P3 // inclusao
	dbsetorder(2)
	if dbseek(P1+str(P2,7))
		tone(900,2)
		pb_msg('Codigo e Documento j  cadastrado. Verifique...')
	end
	dbsetorder(ORD)
	DbGoTo(REG)
end
return .T.

*----------------------------------------------------------------------------
function FN_BANCO()     // -> Selecao por DBEDIT - BANCO
*----------------------------------------------------------------------------
nBC:=0
salvabd(SALVA)
select("BANCO")
set filter to trim(RT_NOMEUSU())+'@'$BC_USER.or.RT_NRUSU()==' '.or.len(BC_USER)==0
	VM_CAMPO:={'BC_CODBC','BC_DESCR'}
	afields(VM_CAMPO)
	DbGoTop()
	save screen
	pb_box(09,maxcol()-42,maxrow()-3,maxcol()-1,,'Selecionar Banco')
	dbedit(10,maxcol()-40,maxrow()-4,maxcol()-1,VM_CAMPO,"",,"",""," ")
	if lastkey()#K_ESC
		nBC:=BC_CODBC
	end
	restore screen
set filter to
salvabd(RESTAURA)
return(nBC)
*----------------------------------------------------------EOF
