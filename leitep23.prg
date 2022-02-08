//-----------------------------------------------------------------------------*
  static aVariav := {'',0,.T.,'',{},'',.T.,'',{},'', 0,'', 0, 0, 0, 0,''}
//....................1.2..3...4..5..6..7...8..9.10.11.12.13.14.15.16.17
//-----------------------------------------------------------------------------*
#xtranslate cElimina		=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate lErroReg		=> aVariav\[  3 \]
#xtranslate cLogErros	=> aVariav\[  4 \]
#xtranslate cArqExp		=> aVariav\[  5 \]
#xtranslate VM_PERIODO	=> aVariav\[  6 \]
#xtranslate RT				=> aVariav\[  7 \]
#xtranslate cArquivo		=> aVariav\[  8 \]
#xtranslate aImport		=> aVariav\[  9 \]
#xtranslate cMostraErro	=> aVariav\[ 10 \]
#xtranslate nRegAnt		=> aVariav\[ 11 \]
#xtranslate cLog			=> aVariav\[ 12 \]
#xtranslate nY				=> aVariav\[ 13 \]
#xtranslate cTexto		=> aVariav\[ 14 \]
#xtranslate nFileHandle	=> aVariav\[ 15 \]
#xtranslate nTotal		=> aVariav\[ 16 \]
#xtranslate cValidRota	=> aVariav\[ 17 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
	function LeiteP23()	//	Calculo de Valores de Qualidade do Leite
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'C->LEIPARAM'		,;		// Parametros do Leite (LEITEP00.PRG)
				'R->LEILABOR'		,;		// Dados de Analise Leite Laboratório (LEITEP00.PRG)
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIGORD'		,;		// Faixa de Gordura (LEITEP12.PRG)
				'R->LEIPROT'		,;		// Faixa de Proteina (LEITEP13.PRG)
				'R->LEIESD'			,;		// Faixa de ESD (LEITEP14.PRG)
				'R->LEICCS'			,;		// Faixa de CCS (LEITEP15.PRG)
				'R->LEICPP'			,;		// Faixa de CPP=CCB (LEITEP16.PRG)
				'R->LEIDADOS'		,;		// Dados dos Cliente (LEITEP00.PRG)
				'C->LEIBON'			;		// Calculo Valores Qualidade Leite (LEITEP00.PRG)
			})
	return NIL
end
select LEIPARAM
if !empty(LP_ERRANAL)
	if Alert('Foi detectado erro em processo anterior ou atual:;;'+;
				Trim(LEIPARAM->LP_ERRANAL),{'Continuar','Sair'}) # 1
		dbcloseall()
		return NIL
	end
end
VM_PERIODO	:=LEIPARAM->LP_PERIODO
nX				:=14
cElimina		:='S'
cValidRota	:='S'
cMostraErro :='S'
cArquivo		:='C:\TEMP\ERRO_CALC_LEITE_'

pb_box(nX++,0,,,,'LEITE-Calcular Valores da Qualidade do Leite')
 nX++
@nX++,01 say 'Ultimo Erro do Processo...: '+LEIPARAM->LP_ERRANAL
@nX++,01 say 'Periodo de Calculo........:' get VM_PERIODO	pict mPER when pb_msg('Periodo de calculo da Qualidade de Leite')
@nX++,01 say 'Eliminar Calculo Anterior.:' get cElimina		pict mUUU when pb_msg('Eliminar os Dados ja Calculados do Periodo')
@nX++,01 say 'Validar Qualidade x Rota..:' get cValidRota	pict mUUU when pb_msg('Validar os Codigos de Rota/Cliente com Analise de Valor')
@nX++,01 say 'Mostrar Erro em Tela......:' get cMostraErro	pict mUUU when pb_msg('Mostrar erro das faixas nao encontrada em tela')
 nX++
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cArquivo	+=VM_PERIODO+'.LOG'
	cLogErros:=padc('Log de Erros no Calculo de Valores da Qualidade de Leite',78)+CRLF+CRLF
	cLogErros+=padr('Periodo de Calculo.......:'+transform(VM_PERIODO,mPER),78)	+CRLF
	cLogErros+=padr('Eliminar Calculo Anterior:'+cElimina,78)							+CRLF
	cLogErros+=padr('Validar Qualidade x Rota.:'+cValidRota,78)							+CRLF
	cLogErros+=padl('Importado em '+DtoC(Date())+' as '+Time(),78)						+CRLF
	
	if cElimina=='S'
		EliminarCalculo()
	end
	cLogErros+=	CRLF+CRLF+;
					padr(	'Valiacao=1 Cliente com dados de Qualidade no Cadastro de Produtores x Rotas',78)+;
					CRLF+CRLF
	cLogErros+=replicate('-',78)+CRLF
	select LEILABOR // Dados de Analise de Leite
	ORDEM DTCLI
	DbSeek(VM_PERIODO,.T.) // Próximo
	while !eof().and.VM_PERIODO==Left(DtoS(LEILABOR->LA_DTCOLE),6) // Ler Dados Importado
		pb_msg('Calculo Valores de Qualidade. Cliente:'+Str(LEILABOR->LA_CDCLI,5))
		EfetuarCalculo()
		DbSkip()
	end
	cLogErros+=replicate('-',78)+CRLF
	//---------------------------------------------------------------------------------------------
	if cValidRota=='S' // Validar se Cliente na Analise está no cadastro de Produtores x Rota VV
		ValidaQualiRota()
	end
	
	select LEIPARAM
	if RecLock()
		Replace LP_ERRANAL with if(lErroReg,'Erro: Calculo de Valores de Qualidade','')
	end
	DbUnlockAll()
	
	pb_box(05,00,22,79,'B/W')
	Alert('Gerado Arquivo de LOG;'+cArquivo)
	MemoWrit(cArquivo,cLogErros) // Gravar Arquivo de Erros
	set key K_ALT_P to Log_Print(cLogErros)
	SetCursor(1)
	MemoEdit(cLogErros,06,01,21,78,.F.)
	SetCursor(0)
	set key K_ALT_P to
	setcolor(VM_CORPAD)
end
DbCloseAll()
return NIL

//------------------------------------------------------------------------------------------
	static function EfetuarCalculo() // Calculo dos Valores da Qualidade do Leite
//------------------------------------------------------------------------------------------
lErroReg:=.F. // Este Registro tem Erro de Faixa 
select LEIBON	// Calculo dos valores da Qualidade de Leite
// Alert('Gravacao:'+Str(LEILABOR->LA_CDCLI)+';Registro:'+Str(RecNo()))
if AddRec()
	replace ;
				CB_CDCLI		with 								LEILABOR->LA_CDCLI,;			// 01-Codigo Cliente
				CB_PERIOD	with Left(DtoS(				LEILABOR->LA_DTCOLE),6),;	// 02-Período (AAAAMM)
				CB_GORDUR	with 								LEILABOR->LA_GORDUR,;		// 03-PERC_GORDURA
				CB_PROTEI	with 								LEILABOR->LA_PROTEI,;		// 04-PROTEINA
				CB_LACTOS	with 								LEILABOR->LA_LACTOS,;		// 05-PERC_LACTOSE
				CB_ESD		with 								LEILABOR->LA_ESD,;			// 06-EDS-Extrato Seco Desengurdurado
				CB_PERSOL	with 								LEILABOR->LA_PERSOL,;		// 07-PERC_SOLIDOSTOTAL
				CB_NRCCS		with 								LEILABOR->LA_NRCCS,;			// 08-CCS_1000
				CB_NRCPP		with 								LEILABOR->LA_NRCBT,;			// 09-CPP=CBT
				CB_VLGORD	with BuscaValor('LEIGORD',	LEILABOR->LA_GORDUR),;		// 10-PERC_GORDURA
				CB_VLPROT	with BuscaValor('LEIPROT',	LEILABOR->LA_PROTEI),;		// 11-PERC_PROTEINA
				CB_VLESD		with BuscaValor('LEIESD' ,	LEILABOR->LA_ESD),;			// 12-EDS-Extrato Seco Desengurdurado
				CB_VLCCS		with BuscaValor('LEICCS' ,	LEILABOR->LA_NRCCS),;		// 13-CCS_1000
				CB_VLCPP		with BuscaValor('LEICPP' ,	LEILABOR->LA_NRCBT),;		// 14-CBT/CPP
				CB_ERFXCL	with if(lErroReg,'SIM','nao')+'|nao',;						// 15-Erro de Faixa no Reg
				CB_CDROTA	with 								LEILABOR->LA_CDROTA,;		// 16-Rota
				CB_TARRO		with 								LEILABOR->LA_TARRO			// 17-Nr Tarro
	DbUnlockAll()
end
select LEILABOR // Dados de Analise de Leite
return NIL

//------------------------------------------------------------------------------------------
	static function BuscaValor(pArq,pFaixa) // Buscar Faixa dos Valores das Qualidades
//------------------------------------------------------------------------------------------
RT		:=.T.
nTotal:=0
NrArea:=Select() // Número da Área Anterior
Select(pArq)
DbGoTop()
while !eof().and.RT
	if pFaixa>=FieldGet(1).and.pFaixa<=FieldGet(2) // Está nesta Faixa ?
		nTotal:=FieldGet(3)
		RT		:=.F.
	end
	DbSkip()
end
if RT
	cTexto	:=	'ERRO;Faixa Nao Encontrada'				+;
					';Cliente:'+Str(LEILABOR->LA_CDCLI,5)	+;
					';Tipo...:'+padl(pArq,8)					+;
					';Valor..:'+Str(pFaixa,FieldLen(3),FieldDeci(3))
	cLogErros+=padr(StrTran(cTexto,';','-'),78)+CRLF
	if cMostraErro=='S'
		Alert(cTexto)
	end
	lErroReg :=.T. // Exite Erro no registro
end
DbSelectArea(NrArea)
return (nTotal)

//------------------------------------------------------------------------------------------
	static function EliminarCalculo() // Eliminar Calculo Anterior do Período
//------------------------------------------------------------------------------------------
nTotal:=0
pb_msg('Eliminar dados calculados do periodo: '+VM_PERIODO)
select LEIBON
ORDEM PERCLI
DbSeek(VM_PERIODO,.T.) // Próximo
while !eof().and.VM_PERIODO==LEIBON->CB_PERIOD
	if RecLock()
		pb_msg('Eliminando Registro do Periodo:'+VM_PERIODO+' - Cliente:'+str(LEIBON->CB_CDCLI,5))
		DbDelete()
		nTotal++
	end
	DbSkip()
end
DbUnlockAll()
cLogErros+=replicate('-',78)												+CRLF
cLogErros+=padr('Registros Eliminados.....:'+Str(nTotal,5),78)	+CRLF+CRLF
cLogErros+=replicate('-',78)												+CRLF
return NIL

//------------------------------------------------------------------------------------------
	static function ValidaQualiRota() // Validar todos os Prod. da Qualidade estão em Rota/VV 
//------------------------------------------------------------------------------------------
cLogErros+=	CRLF+;
				padr('Valiacao=2 Cliente com dados de Qualidade no Cadastro de Produtores x Rotas',78)+CRLF
cLogErros+=replicate('-',78)												+CRLF
lErroReg :=.F. // Exite Erro na validacao 
nTotal	:=0	// Número de Registro de Erros
select LEICPROD	// Dados dos Produtores e suas Rotas / Tarros
ORDEM CODCLI		// Ordem Cliente
select LEILABOR	// Dados de Analise de Leite
ORDEM DTCLI			// Ordem Data + Cliente
DbSeek(VM_PERIODO,.T.) // Próximo
while !eof().and.VM_PERIODO==Left(DtoS(LEILABOR->LA_DTCOLE),6) // Ler Dados Importado
	select LEICPROD	// Dados dos Produtores e suas Rotas / Tarros
	if !dbseek(str(LEILABOR->LA_CDCLI,5))
		cLogErros+=padr(	'Cliente: '+str(LEILABOR->LA_CDCLI,5)+;
								' nao encontrado no cadastro de Produtores x Rota',78)+CRLF
		lErroReg :=.T.
		nTotal	++
	end
	select LEILABOR	// Dados de Analise de Leite
	DbSkip()
end
if lErroReg
	cTexto:=padr(	'Validacao=2: Cliente com Analise de Leite sem estar em Produtores x Rotas - '+;
						Str(nTotal,5)+' Registros.',78)+CRLF
else
	cTexto:=padr('Validacao=2: Sem erros aparentes',78)+CRLF
end
cLogErros+=CRLF+cTexto			+CRLF
cLogErros+=replicate('-',78)	+CRLF+CRLF

//--------------------------------------------------------------------------------------------
cLogErros+=padr('Validacao=3 Rotas existente no Arquivo de Qualidade de Leite no Periodo',78)+CRLF
cLogErros+=replicate('-',78)	+CRLF
lErroReg :=.F. 		// Exite Erro na validacao
nTotal	:=0			// Número de Registro de Erros
select LEILABOR		// Dados de Analise de Leite
ORDEM ROTDT				// Tarro + Data Coleta
select LEICPROD		// Dados dos Produtores e suas Rotas / Tarros
ORDEM OROTA				// Ordem Rota + Tarro

while !eof() 			// Ler Dados dos Produtores (por Rota+Tarro)
	RT		:=.T. 		// Inicia como Falso - não encontrado
	select LEILABOR	// Dados dos Produtores e suas Rotas / Tarros
	dbseek(str(LEICPROD->LC_TARRO,6),.T.)
	while !eof().and.str(LEICPROD->LC_TARRO,6)==str(LEILABOR->LA_TARRO,6).and.RT // procurar mesmo Tarro
		if VM_PERIODO==Left(DtoS(LEILABOR->LA_DTCOLE),6)
			RT:=.F. 		// Não tem ERRO - Encontrado Análise do Leite - Sair
		end
		DbSkip()	// Proxima Análise
	end
	if RT
		cLogErros+=padr(	'ERRO: Tarro:'	+Str(LEICPROD->LC_TARRO,6)+;
								' Cliente:'		+Str(LEILABOR->LA_CDCLI,6)+;
								' nao tem Analise de Leite em '+transform(VM_PERIODO,mPER),78)+CRLF
		lErroReg :=.T.
		nTotal	++
	end
	select LEICPROD	// Dados dos Produtores e suas Rotas / Tarros
	DbSkip()	// Proximo Tarro
end
if lErroReg
	cTexto:=padr(	'Validacao=3: Tarro do Cadastro de Produtor nao tem Analise de Leite-'+;
						Str(nTotal,4)+' Reg.',78)+CRLF
else
	cTexto:=padr('Validacao=3: Sem erros aparentes',78)+CRLF	
end
cLogErros+=CRLF+cTexto+CRLF
cLogErros+=replicate('-',78)	+CRLF+CRLF

return NIL
//------------------------------------------EOF--------------------------------------------
