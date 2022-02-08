function conv_sp()
#include "..\RCB.CH"

dbatual('SALPRD',{;
						{'GRPPRDCOD','N', 2,0},;
						{'SUBPRDCOD','N', 2,0},;
						{'PRDCOD'   ,'N', 3,0},;
						{'PRDSALANO','N', 2,0},;
						{'PRDSALMES','N', 2,0},;
						{'PRDSALQTD','N',13,3},;
						{'PRDSALCRS','N',13,2},;
						{'PRODUTO',  'N', 7,0}},;
						RDDSETDEFAULT())
if net_use("SALPRD",.T., ,"SALPRO", ,.F.,RDDSETDEFAULT())
	pb_msg('Ordenado SALPRD',.f.)
	index on str(PRODUTO,7)+str(PRDSALANO*100+PRDSALMES,4)   tag PRODUT to LIXO1
	index on str(GRPPRDCOD,2)+str(SUBPRDCOD,2)+str(PRDCOD,3) tag CODIGO to LIXO1
	dbgotop()
	pb_msg('Criando PRODUTO->SALPRD',.f.)
	dbeval({||SALPRO->PRODUTO:=GRPPRDCOD*100000+SUBPRDCOD*1000+PRDCOD},{||regi()})
else
	alert('Erro - SALPRD')
	quit
end
dbsetorder(1)

dbatual('PRODUT',{;
						{'GRPPRDCOD','N', 2,0},;
						{'SUBPRDCOD','N', 2,0},;
						{'PRDCOD'   ,'N', 3,0},;
						{'PRDNOM',   'C',35,0},;
						{'PRDUND',   'C', 3,0},;
						{'PRDLOCAL', 'C', 6,0},;
						{'PRDPRECO', 'N', 7,2},;
						{'PRDMARGEM','N', 6,2},;
						{'PRODUTO',  'N', 7,0}},;
						RDDSETDEFAULT())
if net_use("PRODUT",.T., ,"PROD", ,.F.,RDDSETDEFAULT())
	pb_msg('Ordenando PRODUT',.f.)
	index on str(PRODUTO,7)                                  tag PRODUT to LIXO2
	index on str(GRPPRDCOD,2)+str(SUBPRDCOD,2)+str(PRDCOD,3) tag CODIGO to LIXO2
	dbgotop()
	pb_msg('Criando PRODUTO->PRODUT',.f.)
	dbeval({||PROD->PRODUTO:=GRPPRDCOD*100000+SUBPRDCOD*1000+PRDCOD},{||regi()})
else
	alert('Erro - PRODUT')
	quit
end

net_use("CFEAGE",.T., ,"GRUPOA", ,.F.,RDDSETDEFAULT())
	
if net_use("GRPPRD",.T., ,"GRUPO", ,.F.,RDDSETDEFAULT())
	pb_msg('Copiando GRUPO',.f.)
	dbgotop()
	while !eof()
		select('GRUPOA')
		AddRec()
		replace 	GE_CODGR with GRUPO->GRPPRDCOD*10000,;
					GE_DESCR with GRUPO->GRPPRDNOM
		select('GRUPO')
		dbskip()
	end
else
	alert('Erro - GRPPRD')
	quit
end

if net_use("SUBPRD",.T., ,"SUBGRUPO", ,.F.,RDDSETDEFAULT())
	pb_msg('Copiando SUB-GRUPO',.f.)
	dbgotop()
	while !eof()
		select('GRUPOA')
		AddRec()
		replace 	GE_CODGR with SUBGRUPO->GRPPRDCOD*10000+SUBGRUPO->SUBPRDCOD*100,;
					GE_DESCR with SUBGRUPO->SUBPRDNOM
		select('SUBGRUPO')
		dbskip()
	end
else
	alert('Erro - SUBPRD')
	quit
end

if net_use("CFEAPR",.T., ,"PRODA", ,.F.,RDDSETDEFAULT())
	zap
	select('PROD')
	dbgotop()
	while !eof()
		pb_msg('Convertendo produto '+str(PRODUTO,7),.f.)
		SALDO:=fn_saldo(PROD->PRODUTO)

		select('PRODA')
		AddRec()
		replace 	PR_CODGR	with PROD->GRPPRDCOD*10000+PROD->SUBPRDCOD*100,; 
				   PR_CODPR	with PROD->PRODUTO,; 
				   PR_DESCR	with PROD->PRDNOM,; 
				   PR_UND	with PROD->PRDUND,;   
				   PR_LOCAL	with PROD->PRDLOCAL,; 
				 	PR_QTATU	with SALDO[1]
		replace 	PR_VLATU	with SALDO[2],;
				 	PR_VLVEN	with PROD->PRDPRECO,; 
				 	PR_CTB	with 4,;   
				 	PR_LUCRO	with PROD->PRDMARGEM,; 
				 	PR_CODTR	with '000' ,; 
				 	PR_CFTRIB with 'II',;
				 	PR_PICMS	with 17     ,; 
				 	PR_PTRIB	with 100
	
		select('PROD')
		dbskip()
	end
	select('PRODA')
//	dbsetorder(0)
//	dbeval({||PRODA->PR_CODPR:=recno()},{||regi()})
	
else
	alert('Erro - CFEAPR')
	quit
end
dbcloseall()
return NIL

function REGI()
@24,70 say recno()
return .T.

function FN_SALDO(P1)
local SALDO:={0,0}
salvabd(.t.)
select('SALPRO')
if dbseek(str(P1,7)+'9800')
	while !eof().and.P1==PRODUTO
		SALDO[1]+=PRDSALQTD
		SALDO[2]+=PRDSALCRS
		dbskip()
	end
end
salvabd(.f.)
return SALDO
