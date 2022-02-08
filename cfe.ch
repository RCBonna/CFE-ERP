/*
*	NOVO INCLUDE PARA xHarbour
*/

#include "COMMON.CH"
#include "STD.CH"

#define NOMESIS "C.F.E."

#define SALVA .T.	//
#define RESTAURA  .F.	//
#define CRLF chr(13)+chr(10)

#define DEB +1
#define CRE -1

#define SHARED .T.
#define LOCK .T.

#define PULA_PAGINA .T.

#define REPRES "Inffhox Desenvolvimentos"

#define USOMODULO chr(255)+chr(25)

#define  SALVACOR salvacor(.T.)
#define  RESTAURACOR salvacor(.F.)

#define  SALVABANCO	salvabd(.T.)
#define  RESTAURABANCO salvabd(.F.)

#define KB_LIVRE 3024000

#define mUUU  masc(01)
#define mXXX  masc(23)

#define mI1   masc(28) // valores inteiros
#define mI2   masc(11)
#define mI3   masc(12)
#define mI4   masc(03)
#define mI5   masc(04)
#define mI6   masc(19)
#define mI7   masc(35)
#define mI8   masc(09)
#define mI9   masc(46)
#define mI10  masc(08)

#define mD42  masc(40)
#define mD52  masc(44)
#define mD82  masc(25)	// Valores 99 até milhoes
#define mD83  masc(29)
#define mD112 masc(05)
#define mD132 masc(02) // DISPLAY NUMEROS 13,2
#define mD133 masc(27)

#define mI85  masc(39)

#define mI61  masc(31)
#define mI62  masc(20)	// Percentual 2 casas decimais
#define mI63  masc(26)	// Percentual 3 casas decimais
#define mI53  masc(52)	// uma casa iteira e 3 casas decimais
#define mI92  masc(06)
#define mI102 masc(32)
#define mI113 masc(42)
#define mI112 masc(48)
#define mI123 masc(45)
#define mI122 masc(05)
#define mI135 masc(43)
#define mI132 masc(47)
#define mI156 masc(51)

#define mDT   masc(07) // DATA
#define mDT2  masc(34)
#define mCEP  masc(10) // CEP
#define mGRU  masc(13)
#define mI52  masc(14) // Percentual com duas casas decimais
#define mCPF  masc(17)
#define mCGC  masc(18)
#define mDPL  masc(16)
#define mNAT  masc(24)
#define mPER  masc(30)
#define mCTB  masc(30)
#define mPLACA masc(41) // Placa de Carro
#define mI16  masc(49)
