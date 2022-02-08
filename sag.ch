#include "INKEY.CH"
#include "COMMON.CH"
#include "IMPR.CH"
#include 'STD.CH'
#include 'hbsix.ch'

#define SALVA .T.	//
#define RESTAURA  .F.	//

#define SE_EXISTE .F.	//
#define TRAZ_TXT  .T.	//

#define CRLF chr(13)+chr(10)

#define DEB +1
#define CRE -1

#define SHARED .T.
#define LOCK .T.

#define DOSFILES 120
#define KB_LIVRE 1024000
#define SCOLD "FF1"
#define SERIE_CUPOM "FIS"

#define REG_ENTR   "Registro de Entrada"
#define REG_SAID   "Registro de Saida"
#define REG_INVENT "Registro de Inventario"

#define USOMODULO chr(255)+chr(25)
#command ORDEM <(cTag)> => OrdSetFocus( <(cTag)> )

#define SALVABANCO salvabd(.t.)
#define RESTAURABANCO salvabd(.f.)
#define SALVACOR salvacor(.T.)
#define RESTAURACOR salvacor(.F.)
#define SONUMEROS(PARAMETRO1)  (charonly('0123456789',PARAMETRO1))

#define PRIMEIRO dbgotop()
#define ULTIMO   dbgobottom()
#define PROXIMO  pb_brake()

#define mD7   masc(35) // 999.999

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
#define mI10  masc(08)

#define mI61  masc(31)
#define mI62  masc(20)	// Percentual 2 casas decimais
#define mI63  masc(26)	// Percentual 3 casas decimais
#define mD42  masc(40)

#define mD82  masc(25)
#define mD83  masc(29)
#define mI85  masc(39)
#define mI92  masc(06)
#define mI102 masc(32)
#define mD112 masc(05)
#define mI122 masc(05)
#define mD132 masc(02) // DISPLAY NUMEROS 13,2
#define mD133 masc(27)

#define mDT   masc(07)
#define mDT2  masc(34)
#define mCEP  masc(10)
#define mGRU  masc(13)
#define mI52  masc(14) // Percentual com duas casas decimais
#define mCPF  masc(17)
#define mCGC  masc(18)
#define mDPL  masc(16)
#define mNAT  masc(24)
#define mPER  masc(30) // PERIODO 99/99
#define mCTB  masc(30)

#define mPLACA masc(41) // Placa de Carro
