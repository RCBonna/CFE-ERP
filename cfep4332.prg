*-----------------------------------------------------------------------------*
 static aVariav := {  1 , .F., 'Q', '', '','','','',{},{},{0,0},'S', 0,''}
*.....................1.., 2 ,  3 ,  4,  5, 6 ,7, 8, 9,10,  11, 12, 13,14
*-----------------------------------------------------------------------------*
#xtranslate nQtdade			=> aVariav\[  1 \]
#xtranslate lNrImpar			=> aVariav\[  2 \]
#xtranslate cQtdEtiq			=> aVariav\[  3 \]
#xtranslate TXT				=> aVariav\[  4 \]
#xtranslate cNomeImp			=> aVariav\[  5 \]
#xtranslate CR					=> aVariav\[  6 \]
#xtranslate STX				=> aVariav\[  7 \]
#xtranslate cSelecao			=> aVariav\[  8 \]
#xtranslate dData				=> aVariav\[  9 \]
#xtranslate nDocto			=> aVariav\[ 10 \]
#xtranslate nLimites			=> aVariav\[ 11 \]
#xtranslate cSoComQtdade	=> aVariav\[ 12 \]
#xtranslate nBProduto		=> aVariav\[ 13 \]
#xtranslate dBData			=> aVariav\[ 14 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
function CFEP4332()	//	Emissao Etiquetas - MENU
*-----------------------------------------------------------------------------*
//.............................pb_tela()
private VM_PINI,VM_PFIM
private VM_GINI

pb_lin4(_MSG_,ProcName())
if !abre({	'R->GRUPOS',;
				'R->PARAMETRO',;
				'R->MOVEST',;
				'R->PROD'})
	return NIL
end
select PROD
ORDEM CODIGO
go top
VM_PINI:=PR_CODPR
go bottom
VM_PFIM:=PR_CODPR

dData 		:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)	}
nDocto		:={							0,						999999	}
nLimites		:={							0,								0	}
cSelecao		:='P' // P=Por Produto  G=Por Grupo  E=Entrada
cSoComQtdade:='S' // Só produtos com quantidade

alert('S¢ sera impresso etiqueta o Produto que tem;campo <Imp.Etiqueta=S> no Cadastro.')

pb_box(08,0,,,,'Op‡äes de Etiqueta-Barras com Argox')
@10,02 say 	'Selecione Tipo Impressao:'				get cSelecao pict mUUU valid cSelecao$'PGE';
				when pb_msg('P=Por Produto  G=Por Grupo Produtos   E=Data de Entrada')

@11,02 say 'Informe Produto Inicial..:' 				get VM_PINI 		pict masc(21)	valid fn_codpr(@VM_PINI,77).and.fn_rtunid(VM_PINI) 							when cSelecao$'PE'
@13,18 say                 'Final....:'				get VM_PFIM 		pict masc(21)	valid fn_codpr(@VM_PFIM,77).and.fn_rtunid(VM_PFIM).and.VM_PFIM>=VM_PINI	when cSelecao$'PE'

@15,02 say 'Informe Grupo Estoque....:'				get VM_GINI			pict masc(13)	valid VM_GINI%10000#0.and.fn_codigo(@VM_GINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GINI,6)))},,{2,1}}) 	when pb_msg('Informe o Grupo de Estoque a ser Impresso').and.cSelecao$'G'

@17,02 say 'Movimento de Data inicial:'				get dData[1]		pict mDT 																										when pb_msg('Informe data inicia e final de entrada de produtos do mes').and.cSelecao$'E'
@18,18 say 'Final....:'										get dData[2]		pict mDT			valid dData[2]>=dData[1]																when cSelecao$'E'
@17,50 say 'Docto.Ini:'										get nDocto[1]		pict mI6			valid nDocto[1]>=0																		when cSelecao$'E'
@18,50 say 'Docto.Fin:'										get nDocto[2]		pict mI6			valid nDocto[2]>=nDocto[1]																when cSelecao$'E'

@19,02 say 'N§ Etiquetas por Produto.:'				get nLimites[1]	pict mI4			valid nLimites[1]>=0																		when pb_msg('Nr Etiquetas Fixas Por Produto ou <Zero> sera o Nr Etiquetas do Cadastro ou Movimento').and.cSelecao$'P'
@19,50 say '<=Qt Maxima do Produto/Movto>' 			color 'R/G'
@20,02 say 'Limite Etiq  por Produto.:'				get nLimites[2]	pict mI4			valid nLimites[2]>=0 																	when pb_msg('Vc pode Limitar Qtdade a um determinado Nr.Etiquetas <Zero> sem Limites').and.nLimites[1]==0

@21,02 say 'Lista s¢ Produtos com Qtd:'				get cSoComQtdade	pict mUUU		valid cSoComQtdade$'SN'																	when pb_msg('Imprimir Etiquetas so para Produtos com saldo em Estoque?').and.cSelecao$'PG'
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn('Pronto para enviar para Impressora?'),.F.)
	if cSelecao=='P' // Imprimir a Quantidade por Produto
		select PROD
		dbseek(str(VM_PINI,L_P),.F.)
		while !eof().and.PROD->PR_CODPR<=VM_PFIM
			if cSoComQtdade=='S'
				if str(PROD->PR_QTATU,10,0)>str(0,10,0)
					ImprimeEtiq(PROD->PR_QTATU)
				end
			else
				ImprimeEtiq(PROD->PR_QTATU)				
			end
			pb_brake()
		end
	elseif cSelecao=='G' // Imprimir os Itens de um Grupo de Estoque
		select PROD
		ORDEM GRUPRO
		PROD->(dbseek(str(VM_GIMP,6)))
		while !eof().and.PROD->PR_CODGR<=VM_GIMP
			pb_msg('Imprimindo Etiqueta Produto :'+str(PROD->PR_CODPR,L_P))
			if cSoComQtdade=='S'
				if str(PROD->PR_QTATU,10,0)>str(0,10,0)
					ImprimeEtiq(PROD->PR_QTATU)
				end
			else
				ImprimeEtiq(PROD->PR_QTATU)
			end
			pb_brake()
		end
		ORDEM CODIGO
	elseif cSelecao=='E'
		select MOVEST
		ORDEM CODDT // Imprimir por <E>ntrada de Produto (Data e Documento)
		go top
		dbseek(str(VM_PINI,L_P),.T.) // Primeiro
		browse()
		while !eof().and.str(MOVEST->ME_CODPR,L_P)<=str(VM_PFIM,L_P) // verifica Movim de <E>ntrada de produtos
			nQtdade	:=0
			nBProduto:=MOVEST->ME_CODPR
			
			while !eof().and.MOVEST->ME_CODPR == nBProduto 
				if dtos(	MOVEST->ME_DATA)	>=dtos(dData[1])		.and.;
					dtos(	MOVEST->ME_DATA)	<=dtos(dData[2])		.and.;
					str(	MOVEST->ME_DCTO,6)>=str(nDocto[1],6)	.and.;
					str(	MOVEST->ME_DCTO,6)<=str(nDocto[2],6)	.and.;
							MOVEST->ME_TIPO	=='E'
					nQtdade+=MOVEST->ME_QTD
				end
				pb_brake()
			end
			if nQtdade>0
				PROD->(dbseek(str(nBProduto,L_P),.F.)) // Buscar Produto
				ImprimeEtiq(nQtdade) // Imprimir Quantidade
			end
		end
		select PROD
	end
end

DbCloseAll()
nLimites		:={0,0} // Zerar se imprimir em Entrada Simples

return NIL

//------------------------------------------------------------------------------
	function ImprimeEtiq(pQtdade) // Preparação para enviar para impressão
//------------------------------------------------------------------------------
pb_msg('Imprimindo Etiqueta Produto :'+str(PROD->PR_CODPR,L_P))
if PROD->PR_IMPET=='S'
	Qtdade:=Trunca(pQtdade,0) // Recebe como Parametro a Qtdade de Produtos
	if nLimites[1]>0 // Foi informado um determinado número de etiquetas
		Qtdade:=nLimites[1]
	elseif nLimites[2]>0
		if nLimites[2]<Qtdade // Foi informado um limite de etiquetas
			Qtdade:=nLimites[2]
		end
	end
	ImprimeEtiqArgox(VM_EMPR,PROD->PR_CODPR,PROD->PR_DESCR,PROD->PR_VLVEN,Qtdade)
end
return NIL

//------------------------------------------------------------------------------
	static function ImprimeEtiqArgox(pEmpresa,pCodProd,pDescProd,pValor,pQtdade)
//------------------------------------------------------------------------------
cNomeImp	:='Argox OS-214 plus series PPLA'
nQtdEtiq2:=Trunca(pQtdade/2,0) // Dividir por 2 pois são 2 etiquetas por "folha"
lNrImpar :=.F. // não é Impar
STX		:= chr( 02 )
CR			:= chr( 13 )

if pQtdade%2 > 0
	lNrImpar:=.T. // é Impar - tem que acrescentar uma etiqueta a mais no total
end
cQtdEtiq:='Q'+pb_zer(nQtdEtiq2+if(lNrImpar,1,0),4) // Quantidade de etiquetas (metada pq tem 2 colunas)

TXT:=STX+'e'+CR		// e=Gap entre etiquetas
TXT+=STX+'m'+CR		// m=Medidas em centimetro
TXT+=STX+'M0800'+CR	// M=Largura da Etiqueta - 8 cm (2 x 4cm)
TXT+=STX+'L'+CR		// L=Tipo Etiqueta
TXT+='H12'+CR			// H=Temperatura cabeça de impressão (01..20)
TXT+='D11'+CR			// D=Tamanho do Pixel
//...........X...Y...
TXT+='1A5200000100020'+pb_zer(pCodProd,L_P)+CR
TXT+='1A5200000100440'+pb_zer(pCodProd,L_P)+CR
TXT+='111200001400020'+left(pDescProd,30)+CR
TXT+='111200001400440'+left(pDescProd,30)+CR
TXT+='121100001900020'+'R$ '+alltrim(transform(pValor,mD132))+CR
TXT+='121100001900440'+'R$ '+alltrim(transform(pValor,mD132))+CR
TXT+='131100002400020'+Upper(Left(pEmpresa,18))+CR // Fonte 3 h1.v1
TXT+='131100002400440'+Upper(Left(pEmpresa,18))+CR // Fonte 3 h1.v1
TXT+=cQtdEtiq+CR	// Número de etiquetas
TXT+='E'+CR // E=Volta Normal

aPrinter := GetPrinters()
if !empty(aPrinter)
	nOpPrint:=Ascan(aPrinter,cNomeImp)
	if nOpPrint>0
		if !empty(TXT)
			cArqPrint:=ArqTemp(,,'.TXT')	// Gera Arquivo Temporário
			SET PRINTER TO ( aPrinter[nOpPrint] ) // Impressora Argox
				MemoWrit(cArqPrint,TXT)	// Gravar Arquivo
				PrintFileRaw( aPrinter[nOpPrint] ,cArqPrint) 				
			SET PRINTER TO
			FileDelete(cArqPrint) // Eliminar arquivo temporário
		end
	else
		Alert('Não encontrado impressora '+cNomeImp+'; cadastrada no Windows.')
	end
else
	Alert('Não encontrado impressoras cadastrada no Windows.')
end

return NIL
//-----------------------------------------EOF--------------------------------------
