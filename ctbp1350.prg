//-----------------------------------------------------------------------------*
  static aVariav := {'',0,0,{},0}
//....................1..2.3.4.5
//-----------------------------------------------------------------------------*
#xtranslate cArquivo			=> aVariav\[ 1 \]
#xtranslate X					=> aVariav\[ 2 \]
#xtranslate nLote				=> aVariav\[ 3 \]
#xtranslate aData				=> aVariav\[ 4 \]
#xtranslate nContrap			=> aVariav\[ 5 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function CTBP1350()	//	Listagem do diario geral									*
*-----------------------------------------------------------------------------*

pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'	,;
				'C->PARAMCTB'	,;
				'R->CTADET'		,;
				'R->RAZAO'		,;
				'R->CTATIT'		})
	return NIL
end
select('CTADET')
ORDEM CONTAN
select('RAZAO')
ORDEM DTLOTE

set relation to RZ_CONTA into CTADET

aData		:={bom(date()),eom(date())}
cArquivo	:='C:\TEMP\EXP_LACAMENTOS_'+DtoS(Date())+'.TXT'
X        :=16
pb_box(X++,20,,,,'Selecione-Exportacao Lancamentos')
	X++
	@X++,21 say 'Dt Inicio:' get aData[1] valid year(aData[1])==PARAMCTB->PA_ANO when pb_msg('Ano Contabil:'+str(PARAMCTB->PA_ANO,4))
	@X++,21 say 'Dt Fim...:' get aData[2] valid 		 aData[1]<=aData[2]
	X++
	@X++,21 say 'Arquivo..:' get cArquivo
	read
setcolor(VM_CORPAD)
if lastkey()#27
	if pb_ligaimp(,cArquivo)
		CTBP1351()
		pb_deslimp(,,.F.)
		Alert('Arquivo de Exportacao Gerado;'+cArquivo)
	end
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  static function CTBP1351(P1)
//-----------------------------------------------------------------------------*
// RZ_VALOR < 0 = Crédito
// RZ_VALOR > 0 = Dedito

dbseek(DtoS(aData[1]),.T.)
while !eof().and.RZ_DATA>=aData[1].and.RZ_DATA<=aData[2]
	nLote 	:= RZ_NRLOTE // iniciar controle de lote
	nContrap	:= 0
	FLAG		:=.T.
	while !eof().and.RZ_DATA>=aData[1].and.RZ_DATA<=aData[2].and.nLote == RZ_NRLOTE
		??StrTran(DtoC(RZ_DATA),'/','')	//......................01-Data Lancamento
		??if(RZ_VALOR>0,pb_zer(CTADET->CD_CTA,8),pb_zer(0,8)) //.02-Conta Débito
		??if(RZ_VALOR<0,pb_zer(CTADET->CD_CTA,8),pb_zer(0,8)) //.03-Conta Crédito
		??pb_zer(abs(RZ_VALOR),17,02)	//.........................04-Valor
		??pb_zer(0,8)	//........................................05-Histórico
		??padr(RZ_HISTOR,64)	//..................................06-Hist.Complemento
		??pb_zer(0,3)	//........................................07-Débito-Estabelecimento
		??pb_zer(0,3)	//........................................08-Crédito-Estabelecimento
		??pb_zer(0,3)	//........................................09-Débito-Centro de Custos
		??pb_zer(0,3)	//........................................10-Crédito-Centro de Custos
		??pb_zer(nContrap,8)	//..................................11-Contrapartida (1a do Lote = Zero)
		??pb_zer(nLote,6) //.....................................12-Conjunto de Lancamentos
		??space(40)	//...........................................13-Nome Conta Débito
		??space(20)	//...........................................14-Identificador Conta Débito
		??'0'	//.................................................15-Tp da Conta Débito
		??'0'	//.................................................16-Tp Identificador Conta Débito
		??space(40)	//...........................................17-Nome Conta Crédito
		??space(20)	//...........................................18-Identificador Conta Crédito
		??'0'	//.................................................19-Tp da Conta Crédito
		??'0'	//.................................................20-Tp Identificador Conta Crédito
		??space(40)	//...........................................21-Nome Conta Contrapartida
		??space(20)	//...........................................22-Identificador C.Contrapartida
		??'0'	//.................................................23-Tp da Conta Crédito
		??'0'	//.................................................24-Tp Identificador Conta Crédito
		??space(12)	//...........................................25-Arquivamento
		??pb_zer(0,5)	//........................................26-Débito-Centro de Custos
		??pb_zer(0,5)	//........................................27-Crédito-Centro de Custos
		??space(51)	//...........................................28-Reservado
		?
//		??CRLF	//..............................................29-Chr(13)+Chr(10)
		if FLAG
			nContrap	:= CTADET->CD_CTA
			FLAG		:=.F.
		end
		DbSkip()
	end
end
return NIL

//----------------------------------------------EOF--------------------------
