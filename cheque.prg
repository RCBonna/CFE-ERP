*-----------------------------------------------------------------------------------------------*
 static aVariav := {0, '', {'',''}, {}, '', .T., 0}
 //.................1...2.....3......4...5...6...7
*-----------------------------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate cExtenso   => aVariav\[  2 \]
#xtranslate aExtenso   => aVariav\[  3 \]
#xtranslate aLinha     => aVariav\[  4 \]
#xtranslate cCidade    => aVariav\[  5 \]
#xtranslate lFlag      => aVariav\[  6 \]
#xtranslate nLPP       => aVariav\[  7 \]

*-----------------------------------------------------------------------------------------------*
 function CHEQUE(BCO,VALOR,PORTADOR,DATA)	//	Impressao de cheque
*-----------------------------------------------------------------------------------------------*
#include "RCB.CH"

lFlag      :=.F.
cExtenso   :="("+padr(pb_extenso(VALOR)+")",119,"*")
aExtenso[1]:=left(cExtenso,60)
aExtenso[2]:=right(cExtenso,60)
aLinha     :=array(max(BANCO->BC_NRLIN,1))
cCidade    :=PARAMETRO->PA_CIDAD+'('+PARAMETRO->PA_UF+')'
nLPP       :=BANCO->BC_LPP

salvabd(SALVA)
select('LAYOUT')
for nX:=1 to len(aLinha)
	aLinha[nX]:=space(80)
next
dbseek(str(BANCO->BC_CODBC,2),.T.)
while !eof().and.BANCO->BC_CODBC == LAYOUT->LY_CODBC
	lFlag:=.T.
	if !empty(LAYOUT->LY_LINHA).and.!empty(LAYOUT->LY_COLUNA)
		if LY_SEQ==1
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],transform(VALOR,'@E ***,***,***.**'),LY_COLUNA)
		elseif LY_SEQ==2
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],aExtenso[1],                         LY_COLUNA)
		elseif LY_SEQ==3
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],aExtenso[2],                         LY_COLUNA)
		elseif LY_SEQ==4
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],PORTADOR,                            LY_COLUNA)
		elseif LY_SEQ==5
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],cCidade,                             LY_COLUNA)
		elseif LY_SEQ==6
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],pb_zer(day(DATA),2),                 LY_COLUNA)
		elseif LY_SEQ==7
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],pb_mesext(DATA,'C'),                 LY_COLUNA)
		elseif LY_SEQ==8
			aLinha[LY_LINHA]:=posrepl(aLinha[LY_LINHA],right(pb_zer(year(DATA),4),2),       LY_COLUNA)
		end
	end
	dbskip()
end
salvabd(RESTAURA)
if !lFlag.or.BANCO->BC_NRLIN<1
	alert('ERRO;Falta lay-out deste banco')
	return NIL
end
if pb_ligaimp(C15CPP+if(nLPP==1,I6LPP,I8LPP),'LPT'+pb_zer(BANCO->BC_PORCHE,1),"Impressao de Cheques")
	for nX:=1 to len(aLinha)
		??aLinha[nX]
		?
	next
	pb_deslimp(C15CPP+I6LPP)
end
return NIL
