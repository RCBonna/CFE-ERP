//--------------------------------------------------------------------------------------------------------*
  static aVariav := {{},'',0,0,.F.,'',0,0,0,{},'',.F.}
//....................................................................1.......2.......3....4......5.........6.......7...8....9.....10.....11.....12
//-----------------------------------------------------------------------------*
#xtranslate aIPI			=> aVariav\[  1 \]
#xtranslate VM_REL		=> aVariav\[  2 \]
#xtranslate VM_PAG		=> aVariav\[  3 \]
#xtranslate LAR			=> aVariav\[  4 \]
#xtranslate FLAG			=> aVariav\[  5 \]
#xtranslate TIPO			=> aVariav\[  6 \]
#xtranslate TOTALNF		=> aVariav\[  7 \]
#xtranslate NNAT			=> aVariav\[  8 \]
#xtranslate nX				=> aVariav\[  9 \]
#xtranslate aVal			=> aVariav\[ 10 \]
#xtranslate nQuebra		=> aVariav\[ 11 \]
#xtranslate lSAG			=> aVariav\[ 12 \]

*-----------------------------------------------------------------------------*
	function CFEPLIPI()	//	Livro Fiscal do IPI										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
*-----------------------------------------------------------------------------*
VM_REL:='R E G I S T R O   D E   A P U R A C A O   D O   I P I'
pb_lin4(VM_REL,ProcName())

if !abre({	'C->PARAMETRO',;
				'R->NATOP',;
				'R->PARAMCTB',;
				'R->CLIENTE',;
				'R->PROD',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->ENTCAB',;
				'R->ENTDET'})
	return NIL
end
lSAG:=.F.
if file('..\SAG\SAGANFC.DBF').and.file('..\SAG\SAGANFD.DBF')//.and.!file('CFE.PRG')
	if !abre({	;
					'R->NFD',;
					'R->NFC';
					})
		alert('Problemas... Deve ser executado novamente....;Entrar antes em SAG')
		dbcloseall()
		return NIL
	else
		pb_msg('Encontrado arquivos do SAG',10)
		select NFD
		ORDEM CODIGO
		select NFC
		ORDEM DATA
		lSAG:=.T.
	end
else
	pb_msg('Nao encontrados arquivos do SAG',10)
end

aIPI:={}
ARQ :=ArqTemp(,,'')
dbcreate(ARQ,{ {'IP_TIPO', 'C',  1,0},;
					{'IP_CODOP','C',  4,0},;
					{'IP_DESCR','C', 30,0},;
					{'IP_VLCTB','N', 15,2},;
					{'IP_VLBAS','N', 15,2},;
					{'IP_VLIMP','N', 15,2},;
					{'IP_VLISE','N', 15,2},;
					{'IP_VLOUT','N', 15,2}})
if !net_use(ARQ,.T., ,'LIVOIPI', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	return NIL
end
Index on IP_TIPO+IP_CODOP            tag CODIGO to (ARQ)	//....1

select('PROD');dbsetorder(2)
select('PEDCAB');dbsetorder(6)	// Entrada Cabec, ORDEM DATA+NR NF

set relation to str(PC_CODCL,5) into CLIENTE,;
             to str(PC_CODOP,7) into NATOP

PERIODO:=left(dtos(bom(PARAMETRO->PA_DATA)-1),6)
	PAG :=PARAMETRO->PA_PAGIPI+1
	SEQ :=PARAMETRO->PA_SEQIPI+1
ATUALIZ:='N'

pb_box(16,30,,,,'Selecione')
@18,32 say 'Selecione Periodo.:' get PERIODO pict mPER valid fn_period(PERIODO)
@19,32 say 'Atualizar Folha   ?' get ATUALIZ pict mUUU valid ATUALIZ$'SN' when pb_msg('Atualiza Nr da Folha nos Parametros ?')
@20,32 say 'Folha Inicial.....:' get PAG     pict mI5  valid PAG>=0
//@21,32 say 'Sequencia Lctos...:' get SEQ     pict mI5  valid SEQ>=0
read
if lastkey()#K_ESC
		pb_msg('Gerando Entradas....')
		IPIGE()

		pb_msg('Gerando Saidas....')
		IPIGS()

		pb_msg('Gerando Entrada/Saidas-SAG....')
		IPIGSAG()

		pb_msg('Imprimindo....')
		select LIVOIPI
		CFEPIPIIMP()
end
dbcloseall()
FileDelete (Arq + '.*')
return NIL

//------------------------------------------------------------------------------------------------*
  static function IPIGE() // Processar CFE - Entradas
//------------------------------------------------------------------------------------------------*
select('ENTCAB')
ORDEM DTEDOC // Entrada Cabec, ORDEM DATA+DOCTO
set relation to str(ENTCAB->EC_CODOP,7) into NATOP
dbseek(PERIODO,.T.)
dbeval({||IPIGEA()},{||(NATOP->NO_ILIVRO.or.NATOP->NO_CODIG==0)},;
						  {||left(dtos(ENTCAB->EC_DTENT),6)==PERIODO.and.pb_brake(.T.)})

set relation to
return NIL

//-----------------------------------------------------------------------------*
  static function IPIGEA()
//-----------------------------------------------------------------------------*
TIPO   :='E'
TOTALNF:=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS
select LIVOIPI
if dbseek(TIPO+left(str(ENTCAB->EC_CODOP,7),4))
	replace 	IP_VLCTB with IP_VLCTB+TOTALNF,;
				IP_VLISE with IP_VLISE+TOTALNF

else
	AddRec(,{;
				TIPO,;
				left(str(ENTCAB->EC_CODOP,7),4),; // natureza operação
				NATOP->NO_DESCR,;
				TOTALNF,;	// Vlr Contábil
				0,;	// Vlr Base
				0,;	// Vlr IPI - Zero - Isento
				TOTALNF,;	// Vlr Base Isento
				0,;	// Vlr Base Outros
				})
end
select ENTCAB
return NIL

//------------------------------------------------------------------------------------------*
  static function IPIGS() // IPI Saidas - Geral
//-----------------------------------------------------------------------------------------*
select PEDCAB
dbsetorder(6)	// Entrada Cabec, ORDEM DATA+NR NF
set relation to str(PEDCAB->PC_CODOP,7) into NATOP
dbseek(PERIODO,.T.)
dbeval({||IPIGSA()},	{||(NATOP->NO_ILIVRO.or.NATOP->NO_CODIG==0).AND.PEDCAB->PC_FLAG.AND.!PEDCAB->PC_FLCAN},;
							{||left(dtos(PEDCAB->PC_DTEMI),6)==PERIODO.and.pb_brake(.T.)})

set relation to
return NIL

//---------------------------------------------------------------------------------------------------*
  static function IPIGSA() // IPI Saidas - Detalhe
//---------------------------------------------------------------------------------------------------*
local aVICMS:={}
TOTALNF:=0
select LIVOIPI
aVICMS:=fn_nfsoma(PEDCAB->PC_PEDID,{PEDCAB->PC_TOTAL,PEDCAB->PC_DESC,NATOP->NO_CDVLFI})
aeval(aVICMS,{|DET|TOTALNF+=DET[2]})
TIPO:='S'
select LIVOIPI
if dbseek(TIPO+left(str(PEDCAB->PC_CODOP,7),4))
	replace 	IP_VLCTB with IP_VLCTB+TOTALNF,;
				IP_VLISE with IP_VLISE+TOTALNF
else
	AddRec(,{;
				TIPO,;
				left(str(PEDCAB->PC_CODOP,7),4),; // natureza operação
				NATOP->NO_DESCR,;
				TOTALNF,;	// Vlr Contábil
				0,;			// Vlr Base
				0,;			// Vlr IPI - Zero - Isento
				TOTALNF,;	// Vlr Base Isento
				0,;			// Vlr Base Outros
				})
end
select PEDCAB
return NIL

//-----------------------------------------------------------------------------------------------------*
  static function IPIGSAG() // IPI Entrada/Saidas - SAG
//-----------------------------------------------------------------------------------------------------*
select NFC
ORDEM DATA
DbGoTop()
set relation to str(NFC->NF_CODOP,7) into NATOP
dbseek(PERIODO,.T.)
dbeval({||IPIGSAGA()},{||(NATOP->NO_ILIVRO.or.NATOP->NO_CODIG==0).AND.!NFC->NF_FLCAN},;
	                   {||left(dtos(NFC->NF_DTEMI),6)==PERIODO.and.pb_brake(.T.)})

set relation to
return NIL

//---------------------------------------------------------------------------------------------------*
  static function IPIGSAGA() // IPI SAG
//---------------------------------------------------------------------------------------------------*
TOTALNF:=NFC->NF_VLRTOT
TIPO   :=NFC->NF_TIPO
select LIVOIPI
if dbseek(TIPO+left(str(NFC->PC_CODOP,7),4))
	replace 	IP_VLCTB with IP_VLCTB+TOTALNF,;
				IP_VLISE with IP_VLISE+TOTALNF
else
	AddRec(,{;
				TIPO,;
				left(str(PEDCAB->PC_CODOP,7),4),; // natureza operação
				NATOP->NO_DESCR,;
				TOTALNF,;	// Vlr Contábil
				0,;			// Vlr Base
				0,;			// Vlr IPI - Zero - Isento
				TOTALNF,;	// Vlr Base Isento
				0,;			// Vlr Base Outros
				})
end
select NFC
return NIL

*-----------------------------------------------------------------------------*
  static function CFEPIPIIMP()
*-----------------------------------------------------------------------------*
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	LAR	:=132
	FLAG  :=.T.
	paginasIPI(VM_REL+" -  E N T R A D A S",@PAG)
	VM_TOTAL :={{"01 – POR ENTRADAS DO MERCADO NACIONAL ",0},;
					{"02 – POR ENTRADAS DO MERCADO EXTERNO  ",0},;
					{"03 – POR SAIDAS PARA O MERCADO EXTERNO",0},;
					{"04 – ESTORNO DE DEBITOS               ",0},;
					{"05 – OUTROS CREDITOS                  ",0},;
					{"06 – SUBTOTAL                         ",0},;
					{"07 – SALDO CREDOR DO PERIODO ANTERIOR ",0},;
					{"08 – T O T A L........................",0}}
	
	CFEPIPIPR("  -  E  N  T  R  A  D  A  S","E") // Imprime entrada

	?replicate('-',LAR)
	?padc('DEMONSTRATIVO DE CREDITOS',LAR/2,'-')
	for nX:=1 to len(VM_TOTAL)
		? "|"+space(2)+VM_TOTAL[nX,1]+space(7)+"|"
		??transform(VM_TOTAL[nX,2],masc(50))+"|"
	next
	?replicate('-',LAR)
	eject

	paginasIPI(VM_REL+" -  S A I D A S",@PAG)
	FLAG     :=.T.

	CFEPIPIPR("  -  S  A  I  D  A  S","S") // Imprime Saidas
	?replicate('-',LAR)

	VM_TOTAL :={{"09 – POR ENTRADAS DO MERCADO NACIONAL ",0},;
					{"10 – ESTORNO DE CREDITOS              ",0},;
					{"11 – RESSARCIMENTO DE CREDITOS        ",0},;
					{"12 – OUTROS DEBITOS                   ",0},;
					{"13 – T O T A L........................",0}}

	VM_TOTALA:={{"14 – DEBITO TODAL (=ITEM 13)..........",0},;
					{"15 – CREDITO TOTAL (=ITEM 08)         ",0},;
					{"16 – SALDO DEVEDOR (ITEM 14 - ITEM 15)",0},;
					{"17 – SALDO CREDOR (ITEM 15 - ITEM 14  ",0},;
					{"",0}}

	
	? padc('DEMONSTRATIVO DE DEBITOS',LAR/2,'-')
	??padc('APURAÇÃO DO SALDO',LAR/2,'-')
	for nX:=1 to len(VM_TOTAL)
		? "|"+space(2)+VM_TOTAL[nX,1]+space(7)+"|"
		??transform(VM_TOTAL[nX,2],masc(50))+"|"
		if !empty(VM_TOTALA[nX,1])
			??space(5)
			??"|"+VM_TOTALA[nX,1]+space(7)+"|"
			??transform(VM_TOTALA[nX,2],masc(50))+"|"
		end
	next
	?replicate('-',LAR)

	pb_deslimp(C15CPP)
	if ATUALIZ=='S'
		select('PARAMETRO')
		if reclock()
			replace 	PA_PAGSA with PAG-1,;
						PA_SEQSA with SEQ-1
			dbrunlock()
		end
	end
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  static function CFEPIPIPR(pTitulo,pTIPO)
//-----------------------------------------------------------------------------*
aVal   :={	{0,0,0,0,0},;
				{0,0,0,0,0} }
select LIVOIPI
dbseek(pTIPO,.T.)
cQuebra:=substr(IP_CODOP,1,1)
while !eof().and.IP_TIPO==pTIPO
	paginasIPI(VM_REL+pTitulo,@PAG)
	? "|"
	??space(8)
	??"| "
	??IP_CODOP+" | "
	??IP_DESCR+"|"
	??transform(IP_VLCTB,masc(50))+"|"
	??transform(IP_VLBAS,masc(50))+"|"+space(4)
	??transform(IP_VLIMP,masc(50))+"|"+space(8)
	??transform(IP_VLISE,masc(50))+"|"
	??transform(IP_VLOUT,masc(06))+"|"
	aVal[1,1]+=IP_VLCTB
	aVal[1,2]+=IP_VLBAS
	aVal[1,3]+=IP_VLIMP
	aVal[1,4]+=IP_VLISE
	aVal[1,5]+=IP_VLOUT
	pb_brake()
	if substr(IP_CODOP,1,1)#cQuebra
		Totalizar('SubTotais')
		cQuebra:=substr(IP_CODOP,1,1)
	end
end	

	?"|"+space(3)+padr("T O T A L",44)+"|"
	??transform(aVal[2,1],masc(50))+"|"
	??transform(aVal[2,2],masc(50))+"|"+space(4)
	??transform(aVal[2,3],masc(50))+"|"+space(8)
	??transform(aVal[2,4],masc(50))+"|"
	??transform(aVal[2,5],masc(06))+"|"

return NIL

//-----------------------------------------------------------------------------*
  static function PaginasIPI(P1,P2)
//-----------------------------------------------------------------------------*
if prow()>60.or.FLAG
	if prow()>60
		eject
	end
	? replicate('-'																,LAR)
	? padc(P1																		,LAR)
	? replicate('-'																,LAR)
	? padr('Empresa.......: '+VM_EMPR										, 78)
	??padr('Mes/Ano.: '+right(PERIODO,2)+'/'+left(PERIODO,4)			, 22)
	?? padl('Folha.: '+pb_zer(P2,3)											, 32)
	? padr('C.G.C.........: '+transform(PARAMETRO->PA_CGC,masc(18)), 61)
	? padr('Inscr Estadual: '+PARAMETRO->PA_INSCR						, 61)
	? replicate('-'																,LAR)
	
	?'|                                                              |              I P I   -   V A L O R E S   F I S C A I S          |'
	?replicate('-',LAR)
	?'|  CODIFICACAO  |                               |       VALORES|OPERACOES COM CREDITO DE IMPOSTO|OPERACOES SEM CREDITO DE IMPOSTO|'
	?replicate('-',LAR)
	?'|CONTABIL|FISCAL| NATUREZA                      |     CONTABEIS|  BASE CALCULO| IMPOSTO CREDITADO|ISENTAS NAO TRIBUTADAS|   OUTRAS|'
	?replicate('-',LAR)
	P2++
	FLAG:=.F.
end
return NIL

//-----------------------------------------------------------------------------*
  static function Totalizar(pTitulo)
//-----------------------------------------------------------------------------*
? "|"+space(3)+padr(pTitulo,44)+"|"
??transform(aVal[1,1],masc(50))+"|"
??transform(aVal[1,2],masc(50))+"|"+space(4)
??transform(aVal[1,3],masc(50))+"|"+space(8)
??transform(aVal[1,4],masc(50))+"|"
??transform(aVal[1,5],masc(06))+"|"

	aVal[2,1]+=aVal[1,1]
	aVal[2,2]+=aVal[1,2]
	aVal[2,3]+=aVal[1,3]
	aVal[2,4]+=aVal[1,4]
	aVal[2,5]+=aVal[1,5]
	aVal[1,1]:=0
	aVal[1,2]:=0
	aVal[1,3]:=0
	aVal[1,4]:=0
	aVal[1,5]:=0
return Nil


*------------------------------------------EOF-----------------------------------*

*-------------------------------------------------------------------------------------------------------------------------------
*|               |                            |              |              I P I   -   V A L O R E S   F I S C A I S          |
*-------------------------------------------------------------------------------------------------------------------------------
*|  CODIFICACAO  |                            |       VALORES|OPERACOES COM CREDITO DE IMPOSTO|OPERACOES SEM CREDITO DE IMPOSTO|
*-------------------------------------------------------------------------------------------------------------------------------
*|CONTABIL|FISCAL| NATUREZA                   |     CONTABEIS|  BASE CALCULO| IMPOSTO CREDITADO|ISENTAS NAO TRIBUTADAS|   OUTRAS|
*-------------------------------------------------------------------------------------------------------------------------------
*|        | 1.11 | XXXXXXXXX.XXXXXXX.XXXXXXXX.|999.999.999,99|999.999.999,99|    999.999.999,99|        999.999.999,99|999999,99|


