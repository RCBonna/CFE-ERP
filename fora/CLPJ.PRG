*-----------------------------------------------------------------------------*
*
*-----------------------------------------------------------------------------*
function CFER(P1)
clear
if valtype(P1)#'C'
	pb_msg('Informe o diretorio dos arquivos anteriores. CLPJ C:\...\...\',10,.F.)
	quit
end
OPC:=0
while OPC=0
	OPC:=alert('Selecione Arquivo para conversao ',{'FIM','Fornecedores','Produtos'})
end
if OPC>1
	if OPC=2
		arquivo('CFEAFO.DBF')
		use CFEAFO new alias NOVO
		zap
		P1+='\FORNECE.DAT'
		arquivo(P1)
		use (P1) new alias VELHO
		while !eof()
			@23,10 say 'Processando..'+pb_zer(CODFORN,6)
			select('NOVO')
			dbappend(.T.)
			replace  FO_CODFO  with VELHO->CODFORN,;
						FO_RAZAO  with VELHO->NOMEFORN,;
						FO_ENDER  with VELHO->ENDERECO,;
						FO_CEP    with VELHO->CEP,;
						FO_CIDAD  with VELHO->CIDADE,;
						FO_UF     with VELHO->UF,;
						FO_FONE   with VELHO->FONE,;
						FO_FAX    with VELHO->FAX,;
						FO_CONTA  with VELHO->CONTATO,;
						FO_DTCOM  with VELHO->DATACAD,;
						FO_CGC    with strtran(strtran(strtran(VELHO->CGC,'/',''),'.',''),'-',''),;
						FO_INSCR  with VELHO->INCEST

			select('VELHO')
			dbskip()
		end
		dbcloseall()

	elseif OPC=3
		arquivo('CFEAPR.DBF')
		use CFEAPR new alias NOVO
		zap
		P1+='\ESTOQUE.DAT'
		arquivo(P1)
		use (P1) new alias VELHO
		while !eof()
			@23,10 say 'Processando..'+pb_zer(CODPROD,12)
			select('NOVO')
			dbappend(.T.)
			replace  PR_CODGR  with VELHO->CODGRUPO*100,; // GRUPO INICIAL
						PR_CODPR  with VELHO->CODPROD,;
						PR_DESCR  with VELHO->NOMEPROD,;
						PR_COMPL  with STR(VELHO->CODFABRI,5),;
						PR_UND    with VELHO->UNIDADE,;
						PR_ETMIN  with VELHO->QTMIN,;
						PR_LOCAL  with VELHO->LOCALIZA,;
						PR_ETMIN  with VELHO->QTMIN,;
						PR_PRVEN  with VELHO->COMISSAO,;
						PR_LUCRO  with VELHO->MARG_VENDA

			select('VELHO')
			dbskip()
		end
		dbcloseall()

	end
end
quit

*-----------------------------------------------------------------------------*
function ARQUIVO(P1)
if !file(P1)
	pb_msg('Arquivo : '+P1+' nao encontrado neste diretorio',10,.F.)
	quit
end
return NIL
