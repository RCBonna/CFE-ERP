*-----------------------------------------------------------------------------*
function FN_MSDPL(P1)
#include 'RCB.CH'
local OPC:=0
salvacor(SALVA)
setcolor('W+/W,W+/R')
OPC:=abrowse(11,0,22,79,P1,;
				{'NDuplicata','Dt Venct',  'TpM','Vlr Dpl/ R$','Vlr Pago', 'Juros','Desconto','Vlr Original','Reg','NrNr','Ser','DtEmiss'},;
				{          10,        10,      3,           12,        12,      12,        12,            12,   4 ,    6 ,   3 , 10      },;
				{        mDPL,       mDT,   mUUU,     masc(25),   masc(25),masc(25),   masc(25),    masc(25), mI4 ,  mI6 , mUUU, mDT     },,;
				'Duplicatas')
salvacor(RESTAURA)
return(OPC)
