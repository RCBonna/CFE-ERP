//-----------------------------------------------------------------------------*
  static aVariav := {{},0,.F.,'',0,0}
//...................1..2..3..4..5.6
//-----------------------------------------------------------------------------*
#xtranslate aProdDev	=> aVariav\[  1 \]
#xtranslate nX			=> aVariav\[  2 \]
#xtranslate lRT		=> aVariav\[  3 \]
#xtranslate cTELA		=> aVariav\[  4 \]
#xtranslate nQtdade	=> aVariav\[  5 \]
#xtranslate nPedido	=> aVariav\[  6 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function SetProdDevol(pTipo,pChave) // Produtos de NF de Devolução (E/S)
*-----------------------------------------------------------------------------*
aProdDev	:= {}	// Zerar array de Produtos
nQtdade	:= 0	// Setar qtdade Zero
nPedido	:= 0	// Setar Código do Pedido para Saidas
salvabd(SALVA)
if pTipo=='E'
	select('ENTDET')
	DbSeek(pChave,.T.)
	while !eof().and.;
			str(ENTDET->ED_DOCTO,8)+ENTDET->ED_SERIE+str(ENTDET->ED_CODFO,5)==pChave
			PROD-> (dbseek(str(ENTDET->ED_CODPR,L_P))) // Buscar Descrição Produto
		aadd(aProdDev,{ENTDET->ED_ORDEM,;//...................................01-Sequencia Prod
							ENTDET->ED_CODPR,;//...................................02-Cod Produto
							upper(PROD->PR_DESCR),;//..............................03-Descrição Produto
							ENTDET->ED_QTDE;//.....................................04-Quantidade Entrada
							})
		dbskip()
	end
elseif pTipo=='S'
	select('PEDCAB')
	Set Order to 5 // NF e Série
	if DbSeek(pChave)	// Procura a NF no Cabeçalho da NF de Saída
		nPedido:=PEDCAB->PC_PEDID // Nr Pedido (para buscar Produtos da NF Devolução)
		select('PEDDET')
		DbSeek(Str(nPedido,6),.T.)
		while !eof().and. PEDDET->PD_PEDID==nPedido
			PROD-> (dbseek(str(PEDDET->PD_CODPR,L_P))) // Buscar Descrição Produto
			aadd(aProdDev,{PEDDET->PD_ORDEM,;//...................................01-Sequencia Prod
								PEDDET->PD_CODPR,;//...................................02-Cod Produto
								upper(PROD->PR_DESCR),;//..............................03-Descrição Produto
								PEDDET->PD_QTDE;//.....................................04-Quantidade Entrada
								})
			dbskip()
		end
	end
end
salvabd(RESTAURA)
return .T.

*-----------------------------------------------------------------------------*
	function ChkProdNFDev(pProd) // Produtos de NF de Devolução (E/S)
*-----------------------------------------------------------------------------*
lRT		:=.F.
nQtdade	:= 0 // setar Qtdade Zero
for nX:=1 to len(aProdDev)
	if aProdDev[nX,2]==pProd // Produto Encontrado
		nQtdade	:=aProdDev[nX,4] // Setar Quantidade
		lRT		:=.T.
		nX			:=1000
	end
next
if len(aProdDev)>0
	if !lRT
		cTELA:=SaveScreen()
		pb_msg('Produto nao encontrado na NF-e de devolucao, Selecione!')
		salvacor(SALVA)
		setcolor('W+/RB')
		nX:=Abrowse(15,35,22,79,;
							aProdDev,;
						{    'Sq', 'Prod.','Descricao',    'Qtdade'},;
						{       2,     L_P,         20,          10},;
						{     mI2,masc(21),       mXXX, masc(6)+'9'},,;
						'Itens da NF-e Devolucao')
		salvacor(RESTAURA)
		RestScreen(,,,,cTELA)
		if nX>0
			pProd  :=aProdDev[nX,2]
			nQtdade:=aProdDev[nX,4] // Setar Quantidade
			pb_msg('Produto NF-e Devolucao com Quantidade='+str(nQtdade,12,3))
		end
	end
else
	lRT:=.T. // não tem itens - não deve ser devolucao
end
return lRT

*-----------------------------------------------------------------------------*
	function ChkQtdeNFDev(pQtde) // Produtos de NF de Devolução (E/S)
*-----------------------------------------------------------------------------*
lRT		:=.T.
if nQtdade>0 // se não é devolução deve ser zero
	if pQtde>nQtdade
		lRT		:=.F.
		pb_msg('Quantidade maior que a da NF-e Devolucao :'+str(nQtdade,12,3))
	end
end
return lRT


//--------------------------------eof---------------------------
