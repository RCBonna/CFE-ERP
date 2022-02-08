*-----------------------------------------------------------------------------*
 static aVariav := {0, 0,  0,  '', 0,'MP-4200 TH','',0}
 //.................1..2...3...4...5...........6...7.8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate ORD        => aVariav\[  2 \]
#xtranslate LAR        => aVariav\[  3 \]
#xtranslate cPAR       => aVariav\[  4 \]
#xtranslate nTotVlr    => aVariav\[  5 \]
#xtranslate cNomeBemat => aVariav\[  6 \]
#xtranslate cLinha	  => aVariav\[  7 \]
#xtranslate nTotQtd    => aVariav\[  8 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------
	function CFEPVEBC(PARC) // Imprime pedidos venda Balcão
*-----------------------------------------------------------------------------
if PARAMETRO->PA_TIPPD#3 // Tipo de Pedido = Não é Bematech
	ImprPedidoNornal(PARC)
else
	ImprPedidoBematech(PARC)
end
return NIL

*-------------------------------------------------------------------------------------------*
static function ImprPedidoNornal(PARC) // imprime pedidos venda Balcão
*-------------------------------------------------------------------------------------------*
if pb_sn('Venda Balcao;Imprimir o pedido ?')
	if pb_ligaimp(C15CPP+I33LPP)
		VENDEDOR->(dbseek(str(PEDCAB->PC_VEND,3)))
		nTotQtd:= 0
		for nX    := 1 to PARAMETRO->PA_VZIPD
			LAR    :=80
			nTotVlr:= 0
			nTotQtd:= 0
			?I5CPP+VM_EMPR+C5CPP+'  -Fone:'+trim(PARAMETRO->PA_FONE)
			?
			?'Dt Emissao:'+dtoc(PC_DTEMI)+space(32)+'Pedido Nr: '+pb_zer(PEDCAB->PC_PEDID,6)
			?padc('Venda a '+if(PC_FATUR>0,'Prazo','Vista'),LAR,'-')
			?
			? padr('Cliente' ,15,'.')+': '+pb_zer(PEDCAB->PC_CODCL,6)+'-'+CLIENTE->CL_RAZAO
			? replicate('-',LAR)
			? I15CPP+space(8)
			??'Unid. Quantidad '+padc('Codigo',L_P)
			??' Descricao Produto'+space(25)+'CT '
			??padl('Valor Unitario',16)
			??padc('Valor Total',16)+C15CPP
			? replicate('-',LAR)+I15CPP
			for ORD:=1 to len(VM_DET)
				if VM_DET[ORD,2]>0
					? space(8)
					??VM_DET[ORD,10]+space(1) //.................................Unidade
					??transform(VM_DET[ORD,4],masc(6))+space(1) //...............Qtdade
					??pb_zer(VM_DET[ORD,2],L_P)+space(1) //......................CodProduto
					??VM_DET[ORD,03]+space(2) //.................................Descricao
					??pb_zer(VM_DET[ORD,8],2) //.................................Cod Tributario
					??transform(VM_DET[ORD,5],masc(2))+space(1) //...............Vlr Unitario
					??transform(round(VM_DET[ORD,5]*VM_DET[ORD,4],2),masc(2)) //.Vlr Venda
					nTotVlr+=      round(VM_DET[ORD,5]*VM_DET[ORD,4],2)
				end
			next
			?
			if str(PC_TOTAL,15,2)>str(nTotVlr,15,2)
				?padr('Financeira',92,'.')+transform(PC_TOTAL-nTotVlr,masc(2)) // EM R$
			end
			?padr('Total das Mercadorias',92,'.')+transform(PC_TOTAL,masc(2)) // EM R$
			if PC_DESC>0
				? padr('(-)Desconto',92,'.')+transform(PC_DESC,masc(2))
				? padr('Valor Liquido',92,'.')+transform(PC_TOTAL-PC_DESC,masc(2)) // EM R$
			end
			if PC_VLRENT>0
				? padr('(-)Valor da Entrada',92,'.')+transform(PC_VLRENT,masc(2)) // EM R$
				? padr('Valor a ser parcelado em '+str(len(PARC),2)+' parcelas',92,'.')
				??transform(PC_TOTAL-PC_DESC-PC_VLRENT,masc(2)) // EM R$
			end
			?
			if !empty(PC_OBSER)
				? PC_OBSER
			end
			? C15CPP
			//-----------------------------------PARCELAMENTO--------------------------------------
			if len(PARC)>0
				?padc('CODICOES',LAR,'-')
				cPAR:="   Data           Valor"
				?space(15)+cPAR+space(10)+cPAR
				for ORD:=1 to len(PARC)
					? space(15)+dtoc(PARC[ORD,2])
					??space(01)+transform(PARC[ORD,3],mD82)
					ORD++
					if ORD<=len(PARC)
						??space(10)+dtoc(PARC[ORD,2])
						??space(01)+transform(PARC[ORD,3],mD82)
					end
				next
			end	
			?
			?replicate('-',40)+space(10)+replicate('-',30)
			?padc(str(PEDCAB->PC_VEND,3)+'-'+VENDEDOR->VE_NOME,40)
			??space(10)
			??padc('Comprador',30)
			eject
		next
		pb_deslimp(I66LPP+C15CPP)
	end
end
return NIL

*-------------------------------------------------------------------------------------------*
static function ImprPedidoBematech(PARC) // imprime pedidos venda Balcão - Bematech
*-------------------------------------------------------------------------------------------*
if pb_sn('Venda Balcao;Imprimir o pedido na Bematech ?')
	aPrinter := GetPrinters()
	if !empty(aPrinter)
//		cNomeBemat:='Lexmark X464'
		nOpPrint:=Ascan(aPrinter,cNomeBemat)
		if nOpPrint>0
			cLinha:=''
			GeraPedidoBematech(PARC)
			if !empty(cLinha)
				cArqPrint:= ArqTemp(,,'.TXT')	// Gera Arquivo Temporário
				SET PRINTER TO ( aPrinter[nOpPrint] ) // Impressora Bematech
					MemoWrit(cArqPrint,cLinha)	// Gravar Arquivo
					PrintFileRaw( aPrinter[nOpPrint] ,cArqPrint) 				
				SET PRINTER TO
				FileDelete(cArqPrint) // Eliminar arquivo temporário
			end
		else
			Alert('Não encontrado impressora '+cNomeBemat+'; cadastrada no Windows.')
		end
	else
		Alert('Não encontrado impressora cadastrada no Windows.')		
	end
end
return NIL

*-------------------------------------------------------------------------------------------*
	static function GeraPedidoBematech(PARC) // imprime pedidos venda Balcão - Bematech
*-------------------------------------------------------------------------------------------*
VENDEDOR->(dbseek(str(PEDCAB->PC_VEND,3)))
if PARAMETRO->PA_PEDCAB=='S' // Imprimir nome da empresa no cabeçalho do pedido?
	cLinha+=CHR(27) + "!" + Chr(32)
	cLinha+=padc(trim(VM_EMPR),20)
	cLinha+=CHR(27) + "!" + Chr(00)+CRLF
	cLinha+=padc(' CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18)),42)					+CRLF
	cLinha+=padc(' Fone: '+trim(PARAMETRO->PA_FONE),42)									+CRLF
	cLinha+=replicate('Ä',42)																		+CRLF
end
if PARAMETRO->PA_VZIPD<1
	Alert('Numero de vezes para imprimir o pedido;nao configurado;ajuste em paramentros.')
	cLinha:=''
end	
for nX:=1 to PARAMETRO->PA_VZIPD // Número de vezes para imprimir o Pedido
	nTotQtd:= 0
	nTotVlr:= 0
	cLinha+='Emissao:'+dtoc(PEDCAB->PC_DTEMI)+'   Pedido Nr:'+pb_zer(PEDCAB->PC_PEDID,6)+CRLF
	cLinha+=' '																									+CRLF
	cLinha+=padr('Cliente:'+pb_zer(PEDCAB->PC_CODCL,6)+'-'+CLIENTE->CL_RAZAO,42)			+CRLF
	cLinha+=padr('Vend.'+pb_zer(PEDCAB->PC_VEND,3)+'-'+VENDEDOR->VE_NOME,42)				+CRLF
	cLinha+=replicate('Ä',42)																				+CRLF
	cLinha+=chr(27) + "!" + CHR(01) // compacta
	cLinha+='Qtd Cod.Prd Descricao                     Vl Un  Vl Tot'							+CRLF
	for ORD:=1 to len(VM_DET)
		if VM_DET[ORD,2]>0
			cLinha +=transform(VM_DET[ORD,4],mI3)	+space(1)	//....................Qtdade
			cLinha +=pb_zer(VM_DET[ORD,2],L_P)		+space(1)	//....................CodProduto
			cLinha +=padr(VM_DET[ORD,03],26)			+space(1)	//....................Descricao
			cLinha +=transform(VM_DET[ORD,5],mD52)	+space(1)		//....................Vlr Unitario
			cLinha +=transform(round(VM_DET[ORD,5]*VM_DET[ORD,4],2),mD52)+CRLF //..Vlr Venda
			nTotVlr+=          round(VM_DET[ORD,5]*VM_DET[ORD,4],2)
			nTotQtd+=                              VM_DET[ORD,4]
		end
	next
	cLinha+=chr(27) + "!" + CHR(00)+replicate('Ä',42)																				+CRLF
	if PEDCAB->PC_DESC>0 .or. PEDCAB->PC_VLRENT>0
		cLinha+=padl('SubTotal'   ,30)+transform(nTotVlr,mD82)									+CRLF		
	end
	if PEDCAB->PC_DESC>0
		cLinha+=padl('Desconto(-)',30)+transform(PEDCAB->PC_DESC,mD82)							+CRLF
	end
	if PEDCAB->PC_VLRENT>0
		cLinha+=padl('Vlr Entrada(-)',30)+transform(PEDCAB->PC_VLRENT,mD82)					+CRLF
	end
	if len(PARC)>0
		cLinha+=padl('SALDO (=)',30)+transform(PEDCAB->PC_TOTAL-PEDCAB->PC_VLRENT,mD82)	+CRLF // EM R$
		cLinha+=' '																								+CRLF
	else
//		cLinha+=padc('Sem valor parcelado',42)															+CRLF
		cLinha+=padl('Pagamento a Vista(=)',30)+transform(PEDCAB->PC_TOTAL,mD82)			+CRLF // EM R$
		cLinha+=' '																								+CRLF
	end
	cLinha+='Qd Pecas:'+transform(nTotQtd,mI4)														+CRLF
	cLinha+=replicate('Ä',42)																				+CRLF

	if !empty(PEDCAB->PC_OBSER)
		cLinha+=trim(PEDCAB->PC_OBSER)																	+CRLF
	end
	//-----------------------------------PARCELAMENTO
	cLinha+='Venda a '+if(PEDCAB->PC_FATUR>0,'Prazo','Vista')									+CRLF
	if len(PARC)>0  // Tem parcelamento
		cLinha+=padc('CODICOES',42,'Ä')																	+CRLF
		cLinha+='Parc      Data           Valor'														+CRLF
		cLinha+=replicate('Ä',42)																			+CRLF
		for ORD:=1 to len(PARC)
			cLinha+=space(2)+pb_zer(ORD,2)+space(2)
			cLinha+=dtoc(PARC[ORD,2])+space(2)
			cLinha+=transform(PARC[ORD,3],mD82)															+CRLF
		next
		cLinha+=replicate('Ä',42)																			+CRLF
	end
	cLinha+=' '																									+CRLF
	cLinha+=' '																									+CRLF
	cLinha+=' '																									+CRLF
	cLinha+=' '																									+CRLF
	cLinha+=' '																									+CRLF
	cLinha+=chr(27)+chr(109)
next
return NIL
//------------------------------EOF-----------------------------------------
