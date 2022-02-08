*-----------------------------------------------------------------------------*
*
*-----------------------------------------------------------------------------*
function CVCIF(P1)
clear
if valtype(P1)#'C'
	pb_msg('Informe o diretorio dos arquivos anteriores. CVCIF C:\...\...\',10,.F.)
	quit
end
OPC:=0
arquivo('OF3AGR.DBF')
use OF3AGR new alias NOVO
zap

arquivo(P1+'\ESTAGR.DBF')
use (P1+'\ESTAGR.DBF') new alias VELHO
while !eof()
	@23,10 say 'Processando..GRUPOS.'
	select('NOVO')
	dbappend(.T.)
	fieldput(1,VELHO->GR_GRUPO)
	fieldput(2,VELHO->GR_DESCR)
	select('VELHO')
	dbskip()
end
dbcloseall()

arquivo('OF3AIT.DBF')
use OF3AIT new alias NOVO
zap
arquivo(P1+'\ESTAIT.DBF')
use (P1+'\ESTAIT.DBF') new alias VELHO
while !eof()
	@23,10 say 'Processando..ITENS.'
	select('NOVO')
	dbappend(.T.)
	fieldput(01,left(VELHO->IT_CODIT,4))
	fieldput(02,val(right(VELHO->IT_CODIT,5)))
	fieldput(03,VELHO->IT_DESCR)
	fieldput(04,'')
	fieldput(05,VELHO->IT_LOCAL)
	fieldput(06,VELHO->IT_QTATU)
	fieldput(07,VELHO->IT_VLRTO)
	fieldput(08,VELHO->IT_DTCOM)
	fieldput(09,VELHO->IT_VLCOM)
	fieldput(10,VELHO->IT_DTSAI)
	fieldput(11,VELHO->IT_PCVEN)
	fieldput(12,VELHO->IT_PERCT)
	fieldput(13,VELHO->IT_UNIDA)
	fieldput(14,VELHO->IT_QTANT)
	fieldput(15,VELHO->IT_VLANT)
	fieldput(16,VELHO->IT_ETMIN)
	fieldput(17,VELHO->IT_VLCUS)
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