function imp_csv(pFile)
//Local cArquivoCSV := "IBPTax.CSV" // coloque aqui o seu arquivo .CSV
//Local cArquivoDBF := "IBPTax.DBF" // coloque aqui o seu arquivo .DBF

local nPointer := 0
local nEol, cConteudo, cLinha
local nRegistro, cBuffer, nLenArq, nLido
local cEol := Chr( 13 ) + Chr( 10 )
local nHandle := FOpen( pFile, 2 )

private cCampo

nRegistro := 0
cBuffer := Space( 1200 )         // se houver linha maior aumente o 1200
nLenArq := FSeek( nHandle, nPointer, 2 ) // pega tamanho arquivo
FSeek( nHandle, nPointer, 0 )      // posiciona o pointer noinicio

nLido := FRead( nHandle , @cBuffer, 1200 )
nEol := AT( cEol, cBuffer )
nPointer += nEol + 1     // vamos ignorar a linha de nomes de campo
FSeek( nHandle, nPointer, 0 ) // posiciona o pointer na segunda linha

while nEol > 0
	nLido := FRead( nHandle , @cBuffer, 1200 )
	nEol := AT( cEol, cBuffer )

	if nEol > 0
		cLinha := Left( cBuffer, nEol - 1 )
		Append Blank // cria o registro vazio no dbf
		for X:=1 To FCount()
			cConteudo:=SubSt( cLinha, 0, At( ";", cLinha ) )
			cLinha:= StrTran( cLinha, cConteudo, Nil, 1, 1 ) // remove apenas esta sequencia
			cConteudo:=Left( cConteudo, Len( cConteudo ) - 1 ) // tira o ";" do final
			cCampo := Field( X )
			if ValType( &cCampo. ) = "N"
				cConteudo := Val( cConteudo )
			end
			replace &cCampo. with cConteudo // salva o campo
		next
	end
	nPointer += nEol + 1      // incrementa o pointer
	if nPointer >= nLenArq     // se fim de arquivo,
		exit             // fim...
	else              // se nao,
		FSeek( nHandle, nPointer, 0 ) // posiciona o pointer
	end
end
go top
while !eof()
	if NCM_TABELA=="0" // NCM
		cConteudo := val( NCM_CODNCM )
		replace NCM_CODNCM with pb_zer(cConteudo,8) // salva o campo -> 8 Caracteres Zeros a esquerda
	end
	SKIP
end
go top
return nil