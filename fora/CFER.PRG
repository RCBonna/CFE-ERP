*-----------------------------------------------------------------------------*
*
*-----------------------------------------------------------------------------*
function CFER(P1)
clear
if valtype(P1)#'C'
	pb_msg('Informe o diretorio dos arquivos anteriores. CFER C:\...\...\',10,.F.)
	quit
end
OPC:=0
while OPC=0
	OPC:=alert('Selecione Arquivo para conversao ',{'FIM','Clientes','Fornecedores','Produtos'})
end
if OPC>1
	if OPC=2
		arquivo('CFEACL.DBF')
		use CFEACL new alias NOVO
		zap
		P1+='\CLIENTES.DBF'
		arquivo(P1)
		use (P1) new alias VELHO
		while !eof()
			@23,10 say 'Processando..'+pb_zer(NUMERO,6)
			select('NOVO')
			dbappend(.T.)
			replace  CL_CODCL  with VELHO->NUMERO,;
						CL_RAZAO  with VELHO->NOME,;
						CL_ENDER  with VELHO->ENDE,;
						CL_BAIRRO with VELHO->BAIRRO,;
						CL_CIDAD  with VELHO->CIDADE,;
						CL_CEP    with pb_zer(VELHO->CEP,8),;
						CL_UF     with VELHO->UF,;
						CL_CGC    with strtran(strtran(strtran(VELHO->CGC,'/',''),'.',''),'-',''),;
						CL_INSCR  with VELHO->IEST,;
						CL_FONE   with VELHO->FONE,;
						CL_FAX    with VELHO->FAX,;
						CL_ATIVID with 1,;
						CL_VENDED with VELHO->VENDEDOR,;
						CL_OBS    with VELHO->COMPRADOR

			select('VELHO')
			dbskip()
		end
		dbcloseall()

	elseif OPC=3
		arquivo('CFEAFO.DBF')
		use CFEAFO new alias NOVO
		zap
		P1+='\FORNECE.DBF'
		arquivo(P1)
		use (P1) new alias VELHO
		while !eof()
			@23,10 say 'Processando..'+pb_zer(NUMERO,6)
			select('NOVO')
			dbappend(.T.)
			replace  CLIENTE->CL_CODCL  with VELHO->NUMERO,;
						CLIENTE->CL_RAZAO  with VELHO->NOME,;
						CLIENTE->CL_CIDAD  with VELHO->CIDADE,;
						CLIENTE->CL_UF     with VELHO->UF,;
						CLIENTE->CL_CGC    with strtran(strtran(strtran(VELHO->CGC,'/',''),'.',''),'-',''),;
						CLIENTE->CL_INSCR  with VELHO->IE

			select('VELHO')
			dbskip()
		end
		dbcloseall()

	elseif OPC=4
		arquivo('CFEAPR.DBF')
		use CFEAPR new alias NOVO
		zap
		P1+='\PRODUTOS.DBF'
		arquivo(P1)
		use (P1) new alias VELHO
		while !eof()
			@23,10 say 'Processando..'+pb_zer(CODIGO,6)
			select('NOVO')
			dbappend(.T.)
			replace  PR_CODGR  with 10100,; // GRUPO INICIAL
						PR_CODPR  with VELHO->CODIGO,;
						PR_DESCR  with VELHO->DESCRICAO,;
						PR_COMPL  with VELHO->LINHA,;
						PR_UND    with VELHO->UNIDADE,;
						PR_ETMIN  with VELHO->MINIMO,;
						PR_LUCRO  with VELHO->LUCRO

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