static aVariav := {.F.,0,0,'','','MP-4200 TH',0,0,0}
 //.................1..2.3.4..5............6..7.8.9
*---------------------------------------------------------------------------------------*
#xtranslate aPrinter 	=> aVariav\[  1 \]
#xtranslate nOpPrint 	=> aVariav\[  2 \]
#xtranslate nLinha   	=> aVariav\[  3 \]
#xtranslate cLinha   	=> aVariav\[  4 \]
#xtranslate cArqPrint   => aVariav\[  5 \]
#xtranslate cNomeBemat  => aVariav\[  6 \]
#xtranslate nPos	 	 	=> aVariav\[  7 \]
#xtranslate nX		 	 	=> aVariav\[  8 \]
#xtranslate nY		 	 	=> aVariav\[  9 \]
*-----------------------------------------------------------------------------*
* P1=COD CLIENTE
* P2=NOME CLIENTE
* P3=DUPLS
* P4=DATA EMISSAO
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

*------------------------------------------------------------------------------------*
function FN_IMPCARNE(P1,P2,P3,P4)
*------------------------------------------------------------------------------------*

if PARAMETRO->PA_TIPOCAR # 2 // não é Bematech
	if pb_ligaimp(RST+C15CPP,,'Carnes de Pagamento')
		if PARAMETRO->PA_TIPOCAR==0
			fn_carne0(P1,P2,P3,P4)
		elseif PARAMETRO->PA_TIPOCAR==1
			fn_carne1(P1,P2,P3,P4)
		else
			Alert('Tipo de Carne '+str(PARAMETRO->PA_TIPOCAR,1) +' nao disponivel use 0 ou 1')
		end
		pb_deslimp()
	end
else
	if pb_sn('Venda Balcao;Imprimir o Carne Bematech ?')
		aPrinter := GetPrinters()
		if !empty(aPrinter)
			nOpPrint		:=Ascan(aPrinter,cNomeBemat)
			pb_msg('Imprimindo Carne de '+P2)
	//		nLinha:=MaxRow()-len(aPrinter)-4
	//		pb_box(nLinha,40,nLinha+len(aPrinter)+1,76,'G/W*','Selecione Impressora Bematech')
	//		nOpPrint:=Achoice(nLinha+1,41,nLinha+len(aPrinter),75,aPrinter)
			if nOpPrint>0
				cLinha:={}
				ImprimeCarneBematech(P1,P2,P3,P4) // preencher TXT
				if Len(cLinha) > 0
					for nX:=1 to Len(cLinha)
						cArqPrint:= ArqTemp(,'CARN','.TXT')	// Gera Arquivo Temporário
//						ALERT('Arq:'+cArqPrint)
						SET PRINTER TO ( aPrinter[nOpPrint] ) // Impressora Bematech
						MemoWrit(cArqPrint,cLinha[nX])	// Gravar Arquivo
						PrintFileRaw( aPrinter[nOpPrint],cArqPrint,'Carne:'+AllTrim(P2)+' '+str(nX,2)+'/'+str(len(cLinha),2))
						SET PRINTER TO
						inkey(1)
						FileDelete(cArqPrint) // Eliminar arquivo temporário
					next
				end
			else
				Alert('Nao encontrado a impressora '+cNomeBemat+'; cadastrada no Windows.')
			end
		else
			Alert('Nao encontrado impressoras instalada no Windows.')
		end
	end
end
return NIL

*------------------------------------------------------------------------------------*
	static function FN_CARNE0(P1,P2,P3,P4)
*------------------------------------------------------------------------------------*
local X
for X:=1 to len(P3)
	? duplica('Ú'+replicate('Ä',37)+'¿ ')
	? duplica('³ '+I5CPP+padc(VM_EMPR,18)+C5CPP+'³ ')
	? duplica('³'+padc(' CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18)),37)+'³ ')
	? duplica('³'+padc(' Fone: '+trim(PARAMETRO->PA_FONE),37)+'³ ')
	? duplica('Ã'+replicate('Ä',37)+'´ ')
	? duplica('³'+padr(' Nome : '+left(P2,29),37)+'³ ')
	? duplica('³'+padr('        '+right(P2,16)+'     ('+pb_zer(P1,5)+')',37)+'³ ')
	? duplica('³'+replicate(' ',37)+'³ ')
	? duplica('³'+padr(' Documento.....: '+transform(P3[X,1],'@E 9999999,99'),37)+'³ ')
	? duplica('³'+padr(' Vencimento....: '+dtoc(P3[X,2]),37)+'³ ')
	? duplica('³'+padr(' Vlr Prestacao.: '+transform(P3[X,3],masc(2)),37)+'³ ')
	? duplica('³'+padr(' Vlr Juros.....: ________________',37)+'³ ')
	? duplica('³'+padr(' Vlr Total.....: ________________',37)+'³ ')
	? duplica('³'+replicate(' ',37)+'³ ')
	? duplica('Ã'+replicate('Ä',37)+'´ ')
	? duplica('³'+padc('MANTENHA EM DIA SEU PAGAMENTO',37)+'³ ')
	? duplica('À'+replicate('Ä',37)+'Ù ')
	?
	if X%3=0.00
		eject
	end
next
if (X-1)%3>0
	eject
end
return NIL

function DUPLICA(P1)
return (trim(' '+P1+P1))

*------------------------------------------------------------------------------------*
	static function FN_CARNE1(P1,P2,P3,P4)
*------------------------------------------------------------------------------------*
local SOMA:=0.00
for X:=1 to len(P3)
	SOMA+=P3[X,3]
next
	? I15CPP
	??'+'+replicate('-',70)+                                       '+'
	? '|'+padc(VM_EMPR,70)+                                        '|'
	? '|'+padc(' CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18)),70)+'|'
	? '|'+padc(' Fone: '+trim(PARAMETRO->PA_FONE),70)+             '|'
	? '+'+replicate('-',70)+                                       '+'
	? '|'+padr(' Cliente : '+P2+'('+pb_zer(P1,5)+')',70)+             '|'
	? '+'+replicate('-',70)+                                       '+'
	?
	?
	?padc('TERMO PARTICULAR DE CONFISSAO DE DIVIDA',70)
	?
	?
	?'O devedor reconhece e pagara a '+trim(VM_EMPR)
	?'os valores abaixo. Havendo mora, pagara os valores devidamente corrigidos,'
	?'acrescido  de  juros de mora,  de acordo  com  os  indices  aplicados pelo'
	?'mercado, acrescidos de multa de 2% (dois por cento) e 20% (vinte por cento'
	?'de honorarios de cobranca extrajudicial ou judicial,sendo tambem aplicaveis'
	?'todas estas disposicoes para eventual mora ou inadimplemento da credora.'
	?'Fica, desde ja, autorizada pelo devedor a abertura e a atualizacao das'
	?'informacoes, inclusive em caso de mora, de cadastro, ficha, registro e dados'
	?'pessoais e de consumo junto aos servicos de protecao ao credito ou entidades'
	?'similares, comprometendo-se tambem a comunicar expressamente a LOJA qualquer'
	?'alteracao de seu endereco e demais dados cadastrais.'
	?
	?
	?
	?'Data da Compra.:'+dtoc(P4)
	?'Valor da Compra:'+transform(SOMA,mD112)
	?
	?
	?
	?
	?space(20)+'-------------------------------------------'
	?space(20)+P2+'('+pb_zer(P1,5)+')'
	
	eject
	? '+'+replicate('-',70)+                                       '+'
	? '|'+padc(VM_EMPR,70)+                                        '|'
	? '|'+padc(' CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18)),70)+'|'
	? '|'+padc(' Fone: '+trim(PARAMETRO->PA_FONE),70)+             '|'
	? '+'+replicate('-',70)+                                       '+'
	? '|'+padr(' Cliente : '+P2+'('+pb_zer(P1,5)+')',70)+          '|'
	? '+'+replicate('-',70)+                                       '+'

	?padc('TERMO PARTICULAR DE CONFISSAO DE DIVIDA',70)
	?
	?'O devedor reconhece e pagara a '+trim(VM_EMPR)
	?'os valores abaixo. Havendo mora, pagara os valores devidamente corrigidos,'
	?'acrescido  de  juros de mora,  de acordo  com  os  indices  aplicados pelo'
	?'mercado, acrescidos de multa de 2% (dois por cento) e 20% (vinte por cento'
	?'de honorarios de cobranca extrajudicial ou judicial,sendo tambem aplicaveis'
	?'todas  estas  disposicoes  para eventual mora ou inadimplemento da credora.'
	?'Fica, desde ja, autorizada  pelo  devedor  a abertura e  a atualizacao  das'
	?'informacoes, inclusive em caso de mora, de cadastro,ficha, registro e dados'
	?'pessoais e de consumo junto aos servicos de protecao ao credito ou entidades'
	?'similares, comprometendo-se tambem a comunicar expressamente a LOJA qualquer'
	?'alteracao de seu endereco e demais dados cadastrais.'
	?
	?


for X:=1 to len(P3)
	? '+'+replicate('-',70)+'+'
	? '|'+padr(' Parcela:'    +transform(P3[X,1],'@E 9999999,99')+;
	           ' Vencimento: '+dtoc(P3[X,2])+;
	           ' Vlr Parcela:'+transform(P3[X,3],masc(2)),70)+'+'
	? '+'+replicate('-',70)+'+'
	?
next
?
?
?'ATENCAO: QUITACAO VALIDA APENAS COM CARIMBO E ASSINATURA DA LOJA'
?'         Os pagemento com cheque, somente apos a sua compensacao.'
?'         O presente carne, com a quitacao de todas as parcelas,'
?'         e o seu comprovante de pagamento.'
EJECT
return NIL

*------------------------------------------------------------------------------------*
	static function ImprimeCarneBematech(P1,P2,P3,P4)
*------------------------------------------------------------------------------------*
local X
local Y
nPos:=1
aadd(cLinha,'') // inicialmente cria 1 array
for X:=1 to len(P3)
	nPos:=len(cLinha)
	for Y:=1 to 2
		cLinha[nPos]+= 'Ú'+replicate('Ä',37)+'¿ '																+CRLF
		cLinha[nPos]+= '³ '+Chr(27) + "!" + Chr(32)+padc(VM_EMPR,18)+CHR(27) + "!" + Chr(00)	+CRLF
		cLinha[nPos]+= '³'+padc(' CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18)),37)+'³ '			+CRLF
		cLinha[nPos]+= '³'+padc(' Fone: '+trim(PARAMETRO->PA_FONE),37)+'³ '							+CRLF
		cLinha[nPos]+= 'Ã'+replicate('Ä',37)+'´ '																+CRLF
		cLinha[nPos]+= '³'+padr(' Nome : '+left(P2,29),37)+'³ '											+CRLF
		cLinha[nPos]+= '³'+padr('        '+right(P2,16)+'     ('+pb_zer(P1,5)+')',37)+'³ '		+CRLF
		cLinha[nPos]+= '³'+replicate(' ',37)+'³ '																+CRLF
		cLinha[nPos]+= '³'+padr(' Documento.....: '+transform(P3[X,1],'@E 9999999,99'),37)+'³ '+CRLF
		cLinha[nPos]+= '³'+padr(' Vencimento....: '+dtoc(P3[X,2]),37)+'³ '							+CRLF
		cLinha[nPos]+= '³'+padr(' Vlr Prestacao.: '+transform(P3[X,3],masc(2)),37)+'³ '			+CRLF
		cLinha[nPos]+= '³'+padr(' ',37)+'³ '																	+CRLF
		cLinha[nPos]+= '³'+padr(' Vlr Juros.....: ________________',37)+'³ '							+CRLF
		cLinha[nPos]+= '³'+padr(' ',37)+'³ '																	+CRLF
		cLinha[nPos]+= '³'+padr(' Vlr Total.....: ________________',37)+'³ '							+CRLF
		cLinha[nPos]+= '³'+replicate(' ',37)+'³ '																+CRLF
		cLinha[nPos]+= 'Ã'+replicate('Ä',37)+'´ '																+CRLF
		cLinha[nPos]+= '³'+padc('MANTENHA EM DIA SEU PAGAMENTO',37)+'³ '								+CRLF
		cLinha[nPos]+= 'À'+replicate('Ä',37)+'Ù '																+CRLF
		cLinha[nPos]+= ' '																							+CRLF
		cLinha[nPos]+= ' '																							+CRLF
		cLinha[nPos]+= ' '																							+CRLF
	next
	cLinha[nPos]+= ' '+chr(27)+'m'															 					+CRLF// Corte Parcial
	if X%4=0 .and. len(P3)#X // se é multiplo de 4 cria mais um arquivo para imprimir linha
		aadd(cLinha,'') // Cria um novo item no array
	end
next
cLinha[nPos]+=chr(27)+'i' // Corte Total
return NIL

//--------------------------------------EOF---------------------------------------------