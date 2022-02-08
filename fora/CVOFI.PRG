*-----------------------------------------------------------------------------*
*
*-----------------------------------------------------------------------------*
function CVOFI(P1)
clear
if valtype(P1)#'C'
	pb_msg('Informe o diretorio dos arquivos anteriores. CVCIF C:\...\...\',10,.F.)
	quit
end
OPC:=0
arquivo('CFEAGE.DBF')
use CFEAGE new alias NOVO
zap

arquivo(P1+'\OFIAGR.DBF')
use (P1+'\OFIAGR.DBF') new alias VELHO
while !eof()
	@23,10 say 'Processando..GRUPOS.'
	select('NOVO')
	dbappend(.T.)
	fieldput(1,val(VELHO->GR_GRUPO)*100)
	fieldput(2,VELHO->GR_DESCR)
	select('VELHO')
	dbskip()
end
dbcloseall()

arquivo('CFEAPR.DBF')
use CFEAPR new alias NOVO
zap

arquivo(P1+'\OFIAIT.DBF')
use (P1+'\OFIAIT.DBF') new alias VELHO
while !eof()
	@23,10 say 'Processando..ITENS.'
	select('NOVO')
	dbappend(.T.)
	fieldput(01,val(VELHO->IT_CODGR)*100)
	fieldput(02,VELHO->IT_CODIT)
	fieldput(03,VELHO->IT_DESCR)
	fieldput(04,VELHO->IT_REFER)
	fieldput(05,VELHO->IT_UNIDA)
	fieldput(06,VELHO->IT_LOCAL)
	fieldput(07,VELHO->IT_ETMIN)
	fieldput(08,VELHO->IT_QTATU)
	fieldput(09,VELHO->IT_VLRTO)
	fieldput(10,VELHO->IT_PCVEN)
	fieldput(11,VELHO->IT_DTSAI)
	fieldput(12,VELHO->IT_DTCOM)
	fieldput(13,VELHO->IT_VLCOM)
	fieldput(14,VELHO->IT_QTANT)
	fieldput(15,VELHO->IT_VLANT)
	fieldput(16,'A')
	fieldput(17,'A')
	select('VELHO')
	dbskip()
end
dbcloseall()
quit

*-----------------------------------------------------------------------------*
function ARQUIVO(P1)
if !file(P1)
	pb_msg('Arquivo : '+P1+' nao encontrado neste diretorio',10,.F.)
	quit
end
return NIL
