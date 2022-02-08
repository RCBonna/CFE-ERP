
function TESTE

use CFEAME new index CFEIME01 alias MOV

use CFEAPR new index CFEIPR02 alias PROD
dbeval({||TESTE1()})
// dbcommitall()
dbcloseall()
return NIL


function TESTE1()
?'PROCESSANDO....'+PB_ZER(PR_CODPR)
PRODUTO=PR_CODPR
QTD=PR_QTATU
VLR=PR_VLATU
select('MOV')
dbseek(str(PRODUTO,7),.T.)
while !eof().and.PRODUTO==ME_CODPR
	??'.'
	QTD+=(if(ME_TIPO='E',-ME_QTD,if(ME_TIPO='S',+ME_QTD,-ME_QTD)))
	VLR+=(if(ME_TIPO='E',-ME_VLEST,if(ME_TIPO='S',+ME_VLEST,-ME_VLEST)))
	dbskip()
end
select('PROD')
replace PR_SLDQT with QTD,;
			PR_SLDVL with VLR
return NIL
