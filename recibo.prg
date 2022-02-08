*-----------------------------------------------------------------------------*
 static aVariav := {0, 0,  0,  '', 0,'MP-4200 TH','',.T.}
 //.................1..2...3...4...5...........6...7..8...9, 10, 11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate ORD        => aVariav\[  2 \]
#xtranslate LAR        => aVariav\[  3 \]
#xtranslate cPAR       => aVariav\[  4 \]
#xtranslate nTotVlr    => aVariav\[  5 \]
#xtranslate cNomeBemat => aVariav\[  6 \]
#xtranslate cLinha	  => aVariav\[  7 \]
#xtranslate lRepete    => aVariav\[  8 \]

#include "RCB.CH"

*-----------------------------------------------------------------------------*
function RECIBO(P1,P2,P3,P4,P5,P6)	//	Impressao de recibos
* 					 P1=TIPO(C=CLIENTE    F=FORNECEDOR
* 					 P2=NOME CLIENTE/FORNECEDOR
* 					 P3=LISTA DE DUPLICATAS/DESCRICAO
* 					 P4=DATA RECIBO
* 					 P5=VALOR TOTAL
*               P6=Tipo de recibo
*-----------------------------------------------------------------------------*
local X
local DET		:={if(P1=="C",P2,VM_EMPR),if(P1=="F",P2,VM_EMPR)}
private EXTENSO:='('+padr(pb_extenso(P5)+')',239,'*')

if P1=='C'.and.PARAMETRO->PA_RECICR=='3'
	ImprimeReciboBematech(P1,P2,P3,P4,P5,P6,DET)
else // impressão em impressora normal
	if pb_ligaimp(I33LPP,,"Impressao de Recibo")
		while .T.
			if PARAMETRO->PA_RECICR=='2'.or.PARAMETRO->PA_RECICP=='2' // supercomprimido?
				ReciboS(P1,P2,P3,P4,P5,P6,DET)
			else
				ReciboN(P1,P2,P3,P4,P5,P6,DET)
			end
			eject
			if pb_sn("<S> Sai   <N> Repete Impressao;Impressao OK ?")
				exit
			end
		end
		pb_deslimp(I66LPP)
	end
end
return NIL

//-----------------------------------------------------------------------------
static function RECIBON(P1,P2,P3,P4,P5,P6,DET)	//	Impressao de recibos NORMAL
//-----------------------------------------------------------------------------
	if P1=='C' // recibo para cliente
		?C15CPP
		??VM_EMPR
		? 'C.C.G. '+transform(PARAMETRO->PA_CGC,mCGC)
		??' I.E. ' +PARAMETRO->PA_INSCR
		? PARAMETRO->PA_ENDER+ '  Fone '+ PARAMETRO->PA_FONE
		? transform(PARAMETRO->PA_CEP,'@R 99.999-999') + '  -   '
		??PARAMETRO->PA_CIDAD + '   ' + PARAMETRO->PA_UF
	end
	?replicate("-",80)
	?padc("R E C I B O   R$ "+alltrim(transform(P5,mD132)),80)
	?replicate("-",80)
	set margin to 5
	?"Recebi(emos) de : "+DET[1]
	?"a quantia de R$ "+alltrim(transform(P5,mD132))+'.'
	?
	for X:=1 to 3
		??substr(EXTENSO,X*70-69,70)
		?
	next
	??I15CPP
	?"Referente pagamento de "+P3[1]
	for X:=2 to len(P3)
		?space(23)+P3[X]
	next
	set margin to 
	?C15CPP
	? space(15)
	??trim(PARAMETRO->PA_CIDAD)+" ("+PARAMETRO->PA_UF+"), "
	??pb_zer(day(P4),2)+" de "
	??pb_mesext(P4,"C")+" de "
	??pb_zer(year(P4),4)
	?
	?space(15)+replicate("-",53)
	?space(15)+DET[2]
return NIL

//-----------------------------------------------------------------------------------------
static function RECIBOS(P1,P2,P3,P4,P5,P6,DET)	//	Impressao de recibos Supercompactado
//-----------------------------------------------------------------------------------------
	??I20CPP
	if P1=='C' // recibo para cliente
		? padr(VM_EMPR,60)
		? padr('C.C.G. '+transform(PARAMETRO->PA_CGC,mCGC)+' I.E. ' +PARAMETRO->PA_INSCR,60)
		? padr(PARAMETRO->PA_ENDER,40)+padr(' F:'+ PARAMETRO->PA_FONE,20)
		? padr(transform(PARAMETRO->PA_CEP,mCEP)+' - '+alltrim(PARAMETRO->PA_CIDAD)+' '+PARAMETRO->PA_UF,60)
	end
	?replicate("-",60)
	?padc("R E C I B O   R$ "+alltrim(transform(P5,mD132)),60)
	?replicate("-",60)
	?padr("Recebi(emos) de :",60)
	?padr(DET[1],60)
	?"a quantia de R$ "+alltrim(transform(P5,mD132))+'.'
	?
	for X:=1 to 4
		??substr(EXTENSO,X*60-59,60)
		?
	next
	?
	?"Referente pagamento de "
	for X:=1 to len(P3)
		?P3[X]
	next
	?
	? space(10)
	??trim(PARAMETRO->PA_CIDAD)+" ("+PARAMETRO->PA_UF+"), "
	??pb_zer(day(P4),2)+" de "
	??pb_mesext(P4,"C")+" de "
	??pb_zer(year(P4),4)
	?
	?space(10)+replicate("-",50)
	?padr(space(10)+DET[2],60)
	??C20CPP
return NIL

//-------------------------------------------------------------------------------------------------
	static function ImprimeReciboBematech(P1,P2,P3,P4,P5,P6,DET)	//	Impressao de recibos Bematech
//-------------------------------------------------------------------------------------------------
if pb_sn('RECIBO;Imprimir recibo na Bematech ?')
	aPrinter := GetPrinters()
	if !empty(aPrinter)
		nOpPrint:=Ascan(aPrinter,cNomeBemat)
		if nOpPrint>0
			cLinha:=''
			GeraReciboBematech(P1,P2,P3,P4,P5,P6,DET)
			lRepete:=.T.
			while lRepete
				if !empty(cLinha)
					cArqPrint:= ArqTemp(,,'.TXT')	// Gera Arquivo Temporário
					SET PRINTER TO ( aPrinter[nOpPrint] ) // Impressora Bematech
						MemoWrit(cArqPrint,cLinha)	// Gravar Arquivo
						PrintFileRaw( aPrinter[nOpPrint] ,cArqPrint) 				
					SET PRINTER TO
					FileDelete(cArqPrint) // Eliminar arquivo temporário
				end
				lRepete:=!pb_sn("<S> Sai   <N> Repete Impressao;Impressao OK ?")
			end
		else
			Alert('Não encontrado impressora '+cNomeBemat+'; cadastrada no Windows.')
		end
	else
		Alert('Não encontrado impressora cadastrada no Windows.')		
	end
end
return NIL

//-----------------------------------------------------------------------------------------
	static function GeraReciboBematech(P1,P2,P3,P4,P5,P6,DET)	//	Impressao de recibos Supercompactado
//-----------------------------------------------------------------------------------------
cLinha+=chr(29)+chr(249)+chr(53)+chr(32)
cLinha+=chr(27)+'!'+chr(32)
cLinha+=padc(trim(VM_EMPR),20)
cLinha+=chr(27)+ '!'+chr(00)																	+CRLF
cLinha+=padc(' CNPJ: '+transform(PARAMETRO->PA_CGC,masc(18)),42)					+CRLF
cLinha+=padc(' Fone: '+trim(PARAMETRO->PA_FONE),42)									+CRLF
cLinha+=replicate('Ä',42)																		+CRLF
cLinha+=chr(27) + '!' + CHR(08)
cLinha+=padc('R E C I B O   R$ '+alltrim(transform(P5,mD132)),41)					+CRLF
cLinha+=chr(27) + '!' + CHR(00)+replicate('Ä',42)										+CRLF
cLinha+=padr('Recebemos de : '+right(DET[1],7),42)										+CRLF
cLinha+=padr(DET[1],42)																			+CRLF
cLinha+='a quantia de R$ '+alltrim(transform(P5,mD132))+'.'							+CRLF
for X:=1 to 4
	cLinha+=substr(EXTENSO,X*42-41,42)														+CRLF
next
cLinha+=' '																							+CRLF
cLinha+='Referente pagamento de '															+CRLF
cLinha+=chr(27) + '!' + CHR(01)
for nX:=1 to len(P3)
//	cLinha+=substr(P3[nX],1,len(P3[nX])-12)												+CRLF
	cLinha+=P3[nX]																					+CRLF
next
cLinha+=chr(27) + '!' + CHR(00)+replicate('Ä',42)										+CRLF
cLinha+=trim(PARAMETRO->PA_CIDAD)+' ('+PARAMETRO->PA_UF+'), '
cLinha+=pb_zer(day(P4),2)+' de '
cLinha+=pb_mesext(P4,'C')+' de '
cLinha+=pb_zer(year(P4),4)
cLinha+=' '																							+CRLF
cLinha+=' '																							+CRLF
cLinha+=replicate('Ä',20)																		+CRLF
cLinha+=trim(left(DET[2],42))																	+CRLF
cLinha+=' '																							+CRLF
cLinha+=' '																							+CRLF
cLinha+=' '																							+CRLF
cLinha+=' '																							+CRLF
cLinha+=chr(27)+chr(109)
return NIL

//---------------------------------------------EOF--------------------------------------

