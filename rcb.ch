/*
*--------------------------------------*
*	NOVO INCLUDE PARA xHarbour
*--------------------------------------*
*/
#include "COMMON.CH"
#include 'STD.CH'
#include "INKEY.CH"
#include "..\FUN\IMPR.CH"

#define NOMESIS "C.F.E."
#define REPRES "Inffhox Desenvolvimentos"
#define KB_LIVRE 3024000
#define SCOLD "FF1"
#define SERIE_CUPOM "FIS"

#define SALVA .T.	//
#define RESTAURA  .F.	//
#define CRLF chr(13)+chr(10)

#define DEB +1
#define CRE -1

#define SHARED .T.
#define LOCK .T.

#define PULA_PAGINA .T.

#define USOMODULO chr(255)+chr(25)

#define  SALVACOR salvacor(.T.)
#define  RESTAURACOR salvacor(.F.)

#command ORDEM <(cTag)> => OrdSetFocus( <(cTag)> )

#define  SONUMEROS(PARAMETRO1)  (charonly('0123456789',PARAMETRO1))

#define  SALVABANCO	salvabd(.T.)
#define  RESTAURABANCO salvabd(.F.)

#define mUUU  masc(01)
#define mXXX  masc(23)

#define mI1   masc(28) // Valores Inteiros
#define mI2   masc(11)
#define mI3   masc(12)
#define mI4   masc(03)
#define mI5   masc(04)
#define mI6   masc(19)
#define mI7   masc(35)
#define mI8   masc(09)
#define mI9   masc(46)
#define mI10  masc(08)

#define mD10  masc(37)
#define mD12  masc(60)	// uma inteira e 2 decimais
#define mD70  masc(54)
#define mD42  masc(40)
#define mD52  masc(44)
#define mD72  masc(56) // Valores Menores
#define mD82  masc(25) // Valores Menores
#define mD83  masc(29)
#define mD102 masc(50)
#define mD112 masc(05)
#define mD132 masc(02) // DISPLAY NUMEROS 13,2
#define mD133 masc(27)

#define mI85  masc(39)

#define mI61  masc(31)	// Mascara    4 Int 1 Decimal
#define mI62  masc(20)	// Percentual 3 Int 2 Decimais
#define mI63  masc(26)	// Percentual 2 Int 3 Decimais
#define mI52  masc(14)	// Percentual 2 Int 2 Decimais
#define mI53  masc(52)	// Mascara    1 Int 3 Decimais
#define mI64  masc(57)	// Mascara    1 Int 4 Decimais
#define mI74  masc(62)	// Mascara    2 Int 4 Decimais
#define mI92  masc(06)
#define mI102 masc(32)	// Mascara    7 int 2 Decimais
#define mI113 masc(42)	// Mascara    7 int 3 Decimais
#define mI112 masc(48)	// Mascara   10 int 2 Decimais
#define mI123 masc(45)
#define mI122 masc(05)
#define mI135 masc(43)	// Mascara     7 int 5 Decimais
#define mI132 masc(47)	// Mascara    10 int 2 Decimais
#define mI144 masc(53)	// Mascara    09 int 4 Decimais
#define mI156 masc(51)

#define mDT   masc(07)	// DATA
#define mHR   masc(61)	// Hora
#define mDT2  masc(34)
#define mCEP  masc(10)	// CEP
#define mGRU  masc(13)	// Grupo Estoque
#define mCPF  masc(17)	// mCPF
#define mCGC  masc(18)	// CNPJ
#define mDPL  masc(16)
#define mDPLN masc(55)	// Mascara da duplicata - novo modelo
#define mNAT  masc(24)	// Natureza Operação = CFOP
#define mPER  masc(30)	// Período
#define mCTB  masc(30)	// Contabilidade
#define mPLACA masc(41)	// Placa de Carro
#define mROTA masc(58)	// Rota-Leite
#define mI16  masc(49)
#define mCHNFE  masc(59) // Chave NFE
