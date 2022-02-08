*-----------------------------------------------------------------------------*
 static aVariav := {1}
 //.................1
*-----------------------------------------------------------------------------*
#xtranslate nFinalidArq    => aVariav\[  1 \]
*-----------------------------------------------------------------------------*
 function GDFPGERA(P_GDF) // gerar arquivo para a secretaria
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local ArqGerado:='C:\TEMP'
local ArqParam :='GDF_PARA.ARR'

DEFAULT P_GDF TO 'CFE'

dirmake(ArqGerado)
ArqGerado+='\GDF.TXT'

TIPO:=array(10)
TIPX:={10,11,50,54,60,61,70,71,75,90}
//      1, 2, 3, 4, 5, 6, 7, 8, 9 10
pb_lin4(_MSG_,ProcName())

if !file('GDFBAS.DBF')
	Alert('Entre em Preparar Informacoes GDF')
	Return NIL
end
if !abre({	'R->PARAMETRO',;
				'E->GDF60S',;
				'C->CTRNF',;
				'E->GDFBASE'})
	return NIL
end

if pb_msg('Gerar Arquivo para Secretaria da Fazenda?')
	if file(ArqParam)
//		ALERT('ARQUIVO RESTAURADO = '+ArqParam)
		V_GDF:=RestArray(ArqParam)
	else
		V_GDF:={	padr(VM_EMPR,35),;
					space(28),;
					BOM(BOM(PARAMETRO->PA_DATA)-1),;
					BOM(PARAMETRO->PA_DATA)-1;
					}
	end

	VM_NOMEE:=V_GDF[1]
	CONTATO :=V_GDF[2]
	DATA    :={V_GDF[3],V_GDF[4]}

	X    :=11
	Etiqueta:='N'
	pb_box(X++,28,,,,'Informe: '+ProcName())
	@X++,30 say 'Empresa.....:' get VM_NOMEE pict mUUU
	 X++
	@X++,30 say 'Contato......:' get CONTATO     pict mUUU  valid !empty(CONTATO)
	@X++,30 say 'Data INICIAL.:' get DATA[1]     pict mDT
	@X++,30 say 'Data FINAL...:' get DATA[2]     pict mDT  valid DATA[2]>DATA[1]
	@X++,30 say 'Impr.Etiqueta:' get Etiqueta    pict mUUU valid Etiqueta$'SN' when pb_msg('Sim   /  Nao')
	@X++,30 say 'Finalid.Arq..:' get nFinalidArq pict mI1  valid nFinalidArq >=1.and.nFinalidArq<=3 when pb_msg('1=Normal/2=Retif Total/3=Retif Aditiva/5=Dezfazer Datas')

	 X++
	@X++,30 Say 'Gerando arquivo em :' + ArqGerado
	read
	if if(lastkey()#K_ESC,pb_sn(),.F.)

		V_GDF[1]:=VM_NOMEE
		V_GDF[2]:=CONTATO
		V_GDF[3]:=DATA[1]
		V_GDF[4]:=DATA[2]
		SaveArray(V_GDF,ArqParam)
		
		afill(TIPO,0)
		set printer to (ArqGerado)
		set print ON
		set console OFF
		CONTADOR  :=1
		OP_EMPRESA:=1
//		set filter to 	OP_EMPRESA==GDFBASE->BD_EMPRESA
//		.and.;
//							GDFBASE->BD_DATA>=DATA[1].and.;
//							GDFBASE->BD_DATA<=DATA[2]
		pb_msg('Gerando reg=10')
		grava_r10()
		pb_msg('Gerando reg=11')
		grava_r11()
		pb_msg('Gerando reg=50')
		ORDEM REG50
		DbGoTop()
		while !eof()
			@24,65 say CONTADOR++
			grava_r50()
			dbskip()
		end

		pb_msg('Gerando reg=54')
		ORDEM REG54
		DbGoTop()
		while !eof()
			@24,65 say CONTADOR++
			grava_r54()
			dbskip()
		end

		pb_msg('Gerando reg=60')
		select GDF60S // ARQUIVO A PARTE
		while !eof()
			if G6_DATA>=DATA[1].and.G6_DATA<=DATA[2]
				GRAVA_R60()
			end
			dbskip()
		end

		select GDFBASE
		pb_msg('Gerando reg=61')
		ordem REG61
		DbGoTop()
		while !eof()
			TOTAL  :=0
			VLRBICM:=0
			VLRICMS:=0
			VLRISEN:=0
			VLROUTR:=0
			NF1    :=BD_NRNF
			DATA1  :=BD_DATA
			MODELO :=BD_MODELO
			SERIE  :=BD_SERIE
			SBSER  :=BD_SUBSERI
			@24,65 say CONTADOR++
			while !eof().and.DATA1==BD_DATA
				NF2    :=BD_NRNF
				ALICM  :=BD_AICMS
				TOTAL  +=BD_VLRTOT
				VLRBICM+=BD_BICMS
				VLRICMS+=BD_VICMS
				VLRISEN+=BD_ISENTR
				VLROUTR+=BD_OUTRAS
				dbskip()
			end
			VM_PRO:='GRAVA_R'+pb_zer(BD_TIPO,2)
			GRAVA_R61(TOTAL,NF1,NF2,VLRBICM,VLRICMS,VLRISEN,VLROUTR,ALICM)
		end

		ORDEM REG70
		DbGoTop()
		pb_msg('Gerando reg=70')
		while !eof()
			@24,65 say CONTADOR++
			grava_r70()
			dbskip()
		end

		ORDEM REG71
		DbGoTop()
		pb_msg('Gerando reg=71')
		while !eof()
			@24,65 say CONTADOR++
			grava_r71()
			dbskip()
		end
		
		ORDEM REG75
		DbGoTop()
		pb_msg('Gerando reg=75')
		while !eof()
			@24,65 say CONTADOR++
			grava_r75()
			dbskip()
		end

		grava_r90()
		set console OFF
		set print OFF
		set printer to

		if Etiqueta=='S'
			if pb_ligaimp(chr(15))
				?'CNP:'+transform(PARAMETRO->PA_CGC,masc(18))
				?'IE :'+PARAMETRO->PA_INSCR
				?'REGISTRO-FISCAL - ICMS 75/96   MIDIA 1/1'
				?VM_NOMEE
				?'Periodo Abrangencia '+dtoc(DATA[1])+' a '+dtoc(DATA[2])
				?'Dupla Face/ Alta Densidade/ MSDOS'
				pb_deslimp()
			end
		end

	end
end
dbcloseall()
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R10()
*----------------------------------------------------------------------------*
??'10'		//.................................... 1.Tipo
??padl(SONUMEROS(PARAMETRO->PA_CGC),14,   '0')//.. 2
??padr(SONUMEROS(PARAMETRO->PA_INSCR),     14)//.. 3
??padr(VM_NOMEE,                           35)//.. 4
??padr(PARAMETRO->PA_CIDAD,                30)//.. 5
??padr(PARAMETRO->PA_UF,                    2)//.. 6
??pb_zer(val(SONUMEROS(PARAMETRO->PA_FAX)),10)//.. 7
??dtos(DATA[1]) //................................ 8
??dtos(DATA[2]) //................................ 9
if dtos(DATA[1])<'20040101'
	??'2' //..........................................10.Cod.Tipo Conv => 31/99 (Posterior a 2002)
else
	??'3' //..........................................10.Cod.Tipo Conv => 76/03 (Posterior a 2003)
end
??'3' //..........................................11.Total das Operacoes (1-InterEstadual/Substitu/2-InterEstad Todas)3=Todas)
??str(nFinalidArq,1) //...........................12.Finalidade normal
?
TIPO[1]++ // TIPO DE REGISTRO 10
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R11()
*----------------------------------------------------------------------------*
??'11'					// tipo
??padr('Centro',34)	// logradouro
??'01196'				// NUM
??padr('CASA',22)		// COMPL
??padr('CENTRO',15)	// BAIRRO
??PARAMETRO->PA_CEP
??padr(CONTATO,28)	// CONTATO
??pb_zer(val(SONUMEROS(PARAMETRO->PA_FONE)),12)
TIPO[2]++ 				// TIPO DE REGISTRO 11
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R50()
*----------------------------------------------------------------------------*
? '50'		//.......................................1...Tipo
??padl(trim(GDFBASE->BD_CGC),14,'0') //..............2...
??padr(strtran(GDFBASE->BD_INSCR,'.',''),14) //......3...
??dtos(GDFBASE->BD_DATA            ) //..............4...
??padr(GDFBASE->BD_UF,            2) //..............5...
??GDFBASE->BD_MODELO //..............................6...
??padr(GDFBASE->BD_SERIE,         3) //..............7...
??pb_zer(GDFBASE->BD_NRNF,        6) //..............8...
??pb_zer(GDFBASE->BD_CFOP,        4) //..............9...
??GDFBASE->BD_TPEMIT //.............................10...
??pb_zer(GDFBASE->BD_VLRTOT*100, 13) //.............11...
??pb_zer(GDFBASE->BD_BICMS*100,  13) //.............12...
??pb_zer(GDFBASE->BD_VICMS*100,  13) //.............13...
??pb_zer(GDFBASE->BD_ISENTR*100, 13) //.............14...
??pb_zer(GDFBASE->BD_OUTRAS*100, 13) //.............15...
??pb_zer(GDFBASE->BD_AICMS*100,   4) //.............16...
??GDFBASE->BD_SITUA //..............................17...
TIPO[3]++ // SOMA TIPO DE REGISTRO 50
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R54()
*----------------------------------------------------------------------------*
? '54'		//..............................1..Tipo
??padl(trim(GDFBASE->BD_CGC),14,'0') //.....2..
??GDFBASE->BD_MODELO //.....................3..
??padr(GDFBASE->BD_SERIE,         3) //.....4..
??pb_zer(GDFBASE->BD_NRNF,        6) //.....5..
??pb_zer(GDFBASE->BD_CFOP,        4) //.....6..
??BD_SITTRIB //.............................7..
??pb_zer(GDFBASE->BD_ITEM,        3) //.....8..
??pb_zer(GDFBASE->BD_CODPROD,    14) //.....9..
??pb_zer(GDFBASE->BD_QTDADE*1000,11) //....10
??pb_zer(GDFBASE->BD_VLRTOT* 100,12) //....11
??pb_zer(GDFBASE->BD_DESCONT*100,12) //....12..Desconto
??pb_zer(GDFBASE->BD_BICMS*  100,12) //....13..
??pb_zer(0,                      12) //....14..BASE SUBSTITUICAO
??pb_zer(GDFBASE->BD_VLRIPI* 100,12) //....15..
??pb_zer(GDFBASE->BD_AICMS * 100, 4) //....16..
TIPO[4]++ // TIPO DE REGISTRO.................................54
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R60() // Cupom Fiscal
*----------------------------------------------------------------------------*
? '60'					// Tipo=60
??GDF60S->G6_TIPOAM	// TIPO A ou M
??dtos(GDF60S->G6_DATA)
??pb_zer(GDF60S->G6_NRCXA,3)
if GDF60S->G6_TIPOAM=='M'
	??padr(GDF60S->G6_NRSERIE,      15)
	??GDF60S->G6_MODELO
	??pb_zer(GDF60S->G6_NRCUPIN,     6)
	??pb_zer(GDF60S->G6_NRCUPFI,     6)
	??pb_zer(GDF60S->G6_CONTZ,       6)
	??pb_zer(GDF60S->G6_VLRTOTI*100,16)
	??pb_zer(GDF60S->G6_VLRTOTF*100,16)
	??space(                        45)
else
	??padr(GDF60S->G6_SITRIB,        4)
	??pb_zer(GDF60S->G6_VLRACMT*100,16)
	??space(                        96)
end
TIPO[5]++ // SOMA TIPO DE REGISTRO 60
return NIL

*------------------------------------------------------------------------------*
  static function GRAVA_R61(TOTAL,NF1,NF2,VLRBICM,VLRICMS,VLRISEN,VLROUTR,ALICM)
*------------------------------------------------------------------------------*
? '61' //..........................1..Tipo Registro NF TIPO D-Venda a consumidor
??space(14) //.....................2..
??space(14) //.....................3..
??dtos(DATA1) //...................4..
??MODELO //........................5..
??padr(SERIE,          3) //.......6..
??padr(SBSER,          2) //.......7..
??pb_zer(NF1,          6) //.......8..
??pb_zer(NF2,          6) //.......9..
??pb_zer(TOTAL*100,   13) //......10..
??pb_zer(VLRBICM*100, 13) //......11..
??pb_zer(VLRICMS*100, 12) //......12..
??pb_zer(VLRISEN*100, 13) //......13..
??pb_zer(VLROUTR*100, 13) //......14..
??pb_zer(ALICM*100,    4) //......15..
??space(               1) //......16..
TIPO[6]++ //......................................SOMA TIPO DE REGISTRO 61
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R70()		//	FRETE
*----------------------------------------------------------------------------*
? '70' //...........................................1.....Tipo Registro
??padl(trim(GDFBASE->BD_CGC),14,'0') //.............2..
??padr(strtran(GDFBASE->BD_INSCR,'.',''),14) //.....3..
??dtos(GDFBASE->BD_DATA) //.........................4..
??padr(GDFBASE->BD_UF,2) //.........................5..
??GDFBASE->BD_MODELO //.............................6..
??padr(GDFBASE->BD_SERIE,        1) //..............7..
??padr(GDFBASE->BD_SUBSERI,      2) //..............8..
??pb_zer(GDFBASE->BD_NRNF,       6) //..............9..
??pb_zer(GDFBASE->BD_CFOP,       4) //.............10..
??pb_zer(GDFBASE->BD_VLRTOT*100,13) //.............11..
??pb_zer(GDFBASE->BD_BICMS*100, 14) //.............12..
??pb_zer(GDFBASE->BD_VICMS*100, 14) //.............13..
??pb_zer(GDFBASE->BD_ISENTR*100,14) //.............14..
??pb_zer(GDFBASE->BD_OUTRAS*100,14) //.............15..
??pb_zer(GDFBASE->BD_MODO,       1) //.............16..(CIF=1     FOB=2)
??BD_SITUA //......................................17..Situação Nota Fiscal
TIPO[7]++ // ..........................................SOMA TIPO DE REGISTRO 70
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R71()		//	FRETE-Detalhe
*----------------------------------------------------------------------------*
? '71' //.............................................1.....Tipo Registro
??padl(trim(GDFBASE->BD_CGC),14,'0') //...............2..
??padr(strtran(GDFBASE->BD_INSCR,'.',''),14) //.......3..
??dtos(GDFBASE->BD_DATA) //...........................4..
??padr(GDFBASE->BD_UF,2) //...........................5..
??GDFBASE->BD_MODELO //...............................6..
??padr(GDFBASE->BD_SERIE,        1) //................7..
??padr(GDFBASE->BD_SUBSERI,      2) //................8..
??pb_zer(GDFBASE->BD_NRNF,       6) //................9..
??padr(GDFBASE->BD_UFT,          2) //...............10..
??padl(trim(GDFBASE->BD_CGCT),14,'0') //.............11..
??padr(strtran(GDFBASE->BD_INSCRT,'.',''),14) //.....12..
??dtos(GDFBASE->BD_DATA) //..........................13..
??VerSerie(GDFBASE->BD_SERIECF,GDFBASE->BD_NRNFCF)//.14..Modelo da NF que foi transportada
??padr(GDFBASE->BD_SERIECF,      1) //...............15..
??'  ' //............................................16..Sub-Serie da NF que foi transportada
??pb_zer(GDFBASE->BD_NRNFCF,     6) //...............17..
??pb_zer(GDFBASE->BD_VLRCF*100, 14) //...............18..
??space(                        12) //...............19..
TIPO[8]++ // ..........................................SOMA TIPO DE REGISTRO 71
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R75()	// PRODUTO
*----------------------------------------------------------------------------*
? '75' //...........................................1....Tipo Registro
??dtos(DATA[1]) //..................................2..
??dtos(DATA[2]) //..................................3..
??pb_zer(GDFBASE->BD_CODPROD,   14) //..............4..
??space(                        08) //..............5..Código NCM
??padr(GDFBASE->BD_DESPROD,     53) //..............6..
??padr(GDFBASE->BD_UNIMED,      06) //..............7..Unidade 
//??padr(GDFBASE->BD_SITTRIB,     03) //..............8..SitTrib
??pb_zer(GDFBASE->BD_VLRIPI*100,05) //..............8..Aliq Ipi
??pb_zer(GDFBASE->BD_AICMS*100, 04) //..............9..Aliq Icms Aplicavel
??pb_zer(GDFBASE->BD_VICMS*100, 05) //.............10.. % Reducao
??pb_zer(0,                     13) //.............11..Base Calculo ICMS Subst 0u Zero
TIPO[9]++ //.......................................... SOMA TIPO DE REGISTRO 75
return NIL

*----------------------------------------------------------------------------*
  static function GRAVA_R90()
*----------------------------------------------------------------------------*
local VM:='90'
local X :=0
local Y :=0
TIPO[10]++ // SOMA 1 ao TIPO DE REGISTRO 90
VM+=padl(SONUMEROS(PARAMETRO->PA_CGC),14,   '0')
VM+=padr(SONUMEROS(PARAMETRO->PA_INSCR),     14)
for X:=3 to len(TIPO)-1
	if TIPO[X]>0
		VM+=pb_zer(TIPX[X],2) 	// codigo do registro
		VM+=pb_zer(TIPO[X],8)	// número de registros
	end
next
for X:=1 to len(TIPO)
	Y+=TIPO[X]//Some Total Geral
next
VM+=pb_zer(99,2) // Total Geral
VM+=pb_zer(Y,8)
VM:=padr(VM,125)+'1'
?VM
return NIL
//----------------------------------------------------------------------------EOF
