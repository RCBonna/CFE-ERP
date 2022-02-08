*---------------------------------------------Grava Movimentacao no Estoque
#include 'RCB.CH'

 function GravMovEst(_PR)
*-----------------------------------------------------------------------------*
* _PR[1]=PRODUTO
* _PR[2]=DATA
* _PR[3]=DOCTO
* _PR[4]=QUANTIDADE
* _PR[5]=VALOR MEDIO
* _PR[6]=VALOR VENDA
* _PR[7]=TIPO MOV -> E,S,A...
* _PR[8]=SERIE
* _PR[9]=FORNECEDOR

	SALVABANCO
	select('MOVEST')
	while !AddRec(30);end
	replace	ME_CODPR with _PR[1],;
				ME_DATA  with _PR[2],;
				ME_DCTO  with _PR[3],;
				ME_QTD   with _PR[4],;
				ME_VLEST with _PR[5],; // Medio total-ICMS-IPI+FRETE+FUNRUR
				ME_VLVEN with _PR[6],;
				ME_TIPO  with _PR[7],;  // <E>ntradas  <S>aida ....
				ME_CTB   with PROD->PR_CTB,;
				ME_SERIE with _PR[8],;
				ME_CODFO with _PR[9]
	dbrunlock(recno())
	RESTAURABANCO
return NIL

*---------------------------------------------Grava Movimentacao no Estoque
 function GrMovEst(P1)
*-----------------------------------------------------------------------------*
salvabd(SALVA)
select('MOVEST')
while !AddRec(30);end
for X:=1 to fcount()
	fieldput(X,P1[X])
next
dbrunlock(recno())
RESTAURABANCO
return NIL
