//-----------------------------------------------------------------------------*
  static aVariav := {0,0,'',0,{},{},{},'',{},'','', 0}
//...................1.2..3.4.5..6..7...8..9.10.11.12
//-----------------------------------------------------------------------------*
#xtranslate nTotLeite	=> aVariav\[  1 \]
#xtranslate nCodMun		=> aVariav\[  2 \]
#xtranslate cGerArq		=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate aResumo		=> aVariav\[  5 \]
#xtranslate dLctos		=> aVariav\[  6 \]
#xtranslate aSoma			=> aVariav\[  7 \]
#xtranslate cArq			=> aVariav\[  8 \]
#xtranslate aProd			=> aVariav\[  9 \]
#xtranslate nSistema		=> aVariav\[ 10 \]
#xtranslate CodMun		=> aVariav\[ 11 \]
#xtranslate VM_PAG		=> aVariav\[ 12 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function LEITEP08() // Gera Arquivo de Exportação-Aurora
*-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())

nSistema	:=Alert(ProcName()+';Selecione Sistema Leite',{'Atual','Novo'})
if nSistema==0
	dbcloseall() // Sair se não foi selecionado opcao
end

if !abre({	'R->PARAMETRO'	,;
				'R->CODTR'		,;
				'C->CLIOBS'		,;
				'C->GRUPOS'		,;
				'C->MOVEST'		,;
				'C->FISACOF'	,;
				'C->SALDOS'		,;
				'C->UNIDADE'	,;
				'C->VENDEDOR'	,;
				'C->CLIENTE'	,;
				'R->LEIMUNAU'	,;
				'R->LEIPARAM'	,;		// Criado arquivo no LEITEP00.PRG
				'R->LEIDADOS'	,;		// Criado arquivo no LEITEP00.PRG
				'C->PROD';
			})
	return NIL
end
if LEIPARAM->LP_PROD>0 // Código Leite
	CodPr  	:=LEIPARAM->LP_PROD // Código Leite - dos parâmetros
else 
	alert('Cadastro de Codigo do Leite deve ser alerado;ir no cadastro de Leite')
	dbcloseall()
	return NIL
end

ORDEM CODIGO
dbseek(Str(CodPr,L_P))

select LEIMUNAU
ORDEM ALFA

nX			:=MaxRow()-9
aProd		:={0,99999}
dLctos	:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA),'S'}
cGerArq	:=padr('C:\TEMP\ARQ-LEITE-AUTORA.TXT',40)

pb_box(nX++,14,,,,'Geracao Arquivo Leite-Informe Selecao')
@nX++,15 say 'Cod.Leite.........: '+Str(CODPR,L_P)+'-'+trim(PROD->PR_DESCR)
@nX++,15 say 'Data Inicial......:'  Get dLctos[1]	pict mDT												when pb_msg('Informe Data de Inicio para gerar Arquivo Leite')
@nX++,15 say 'Data Final........:'  Get dLctos[2]	pict mDT      valid dLctos[1]<=dLctos[2]	when pb_msg('Informe Data de Fim    para gerar Arquivo Leite')
@nX++,15 say 'Producao por Faixa:'  Get dLctos[3]	pict mUUU     valid dLctos[3]$'SN'			when pb_msg('Imprimir tambem - Relatorio de Producao por Faixa?')
@nX++,15 say 'Arquivos Gerado...:'  Get cGerArq 	pict mUUU
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if CriaTmpLeite()
		if nSistema==1
			CalculaLeiteAtual()	// --- Acumular Leite Para Gerar Arquivo AURORA
		else
			CalculaLeiteNovo()
		end
		// --------- Acumular Leite Para Gerar Arquivo AURORA	
		if pb_ligaimp(,alltrim(cGerArq))
			select LEIMUNAU
			ORDEM CODIGO

			select WORK
			OrdSetFocus('CODIGO_MUN')

			DbGoTop()
			while !eof()
				nTotProd:=0
				nTotQtde:=0
				nCodMun :=WK_CODMUN
				LEIMUNAU->(dbseek(str(nCodMun,5)))
				while !eof().and.nCodMun==WK_CODMUN
					nTotProd++ // Num Produtores
					nTotQtde+=WK_QTD
					skip
				end
				?? dtoc(dLctos[2])				+';'
				?? alltrim(str(nCodMun))		+';'
				?? alltrim(LEIMUNAU->MA_CIDAD)+';'
				?? alltrim(str(nTotProd))		+';'
				?? alltrim(str(nTotQtde,15,0))+';'
				?
			end
			pb_deslimp()
		end

		//---------------------------------------------------------
		if dLctos[3]=='S' //......................Relatório por Faixa
			CalculaLeiteFaixa() //...............Calcular Qtd por Faixa
			cGerArq1:='C:\TEMP\ARQ-LEITE-FAIXA.TXT'
			if pb_ligaimp(,cGerArq1,'Resumo por Faixa')
				aSoma :={0,0}
				VM_PAG:=0
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),'Resumo Leite por Faixa',VM_PAG,'LEITEP08C',80)
				for nX:=1 to len(aResumo)
					? transform(aResumo[nX,1],mD10) + ' a '
					??transform(aResumo[nX,2],mD10) + Space(10)
					??transform(aResumo[nX,3],mD10) + Space(10)
					??transform(aResumo[nX,4],mD10)
					aSoma[1]+=aResumo[nX,3]
					aSoma[2]+=aResumo[nX,4]
				next
				?replicate('-',80)
				?padl('Totalizacao',29)
				??transform(aSoma[1],mD10) + Space(10)
				??transform(aSoma[2],mD10)
				?replicate('-',80)
				pb_deslimp()
			end
		end
	end
end
dbcloseall()
if !empty(cArq)
	fileDelete (cArq + '.*')
end
return NIL

*-----------------------------------------------------------------------------*
	function LEITEP08C()
*-----------------------------------------------------------------------------*
?padc('Referente Periodo '+dtoc(dLctos[1])+' a '+dtoc(dLctos[2]),80)
?
?'Faixa de Classificao     N.Produtores  Volume Produzido'
?replicate('-',80)
return NIL

*-----------------------------------------------------------------------------*
	static function CodMunAurora(pCdCliente)
*-----------------------------------------------------------------------------*
SALVABANCO
nCodMun:=0
select LEIMUNAU
if dbseek(upper(CLIENTE->CL_UF+CLIENTE->CL_CIDAD))
	nCodMun:=LEIMUNAU->MA_CODMUN
else
	alert('Cliente:'+str(pCdCliente,5)+'-'+trim(CLIENTE->CL_RAZAO)+;
			';UF='+CLIENTE->CL_UF+' CIDADE='+CLIENTE->CL_CIDAD+;
			';Nao Cadastrado Tabela Aurora;Ajustar Tabela')
end
RESTAURABANCO
return nCodMun

*-----------------------------------------------------------------------------*
	static function CalculaLeiteAtual()
*-----------------------------------------------------------------------------*
SALVABANCO
select MOVEST
ORDEM DTPROE
DbGoTop()
dbseek(DtoS(dLctos[1]),.T.)
while !eof().and.MOVEST->ME_DATA<=(dLctos[2])
	pb_msg('Gerando Dados...'+dtoc(MOVEST->ME_DATA))
	if MOVEST->ME_CODPR== CODPR		.and.;
		MOVEST->ME_CODFO>= aProd[1]	.and.;
		MOVEST->ME_CODFO<= aProd[2]	.and.;
		MOVEST->ME_FORMA== 'L'
		if !WORK->(dbseek(str(MOVEST->ME_CODFO,5)))
			CLIENTE->(dbseek(str(MOVEST->ME_CODFO,5)))
			CodMun:=CodMunAurora(MOVEST->ME_CODFO)
			Grava_Work({	MOVEST->ME_CODFO,;// 1-Associado
								CodMun,;				// 2-Cod Municipio Aurora
								MOVEST->ME_QTD;	//	3-Quantidade Leite
							})
		else
			replace WORK->WK_QTD with WORK->WK_QTD + abs(MOVEST->ME_QTD)
		end
	end
	dbskip()
end
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
	static function CalculaLeiteNovo()
*-----------------------------------------------------------------------------*
SALVABANCO
select LEIDADOS
ORDEM DTCLI // Data + Cliente
DbGoTop()
dbseek(DtoS(dLctos[1]),.T.)
while !eof().and.LEIDADOS->LD_DTCOLET<=(dLctos[2]) // Validar Período
	pb_msg('Acumulando Qtd.Leite...'+dtoc(LEIDADOS->LD_DTCOLET))
	if LEIDADOS->LD_CDCLI>=aProd[1]	.and.; 	// Produtor Inicial
		LEIDADOS->LD_CDCLI<=aProd[2]				// Produtor Final
		CLIENTE->(dbseek(str(LEIDADOS->LD_CDCLI,5)))
		CodMun:=CodMunAurora(LEIDADOS->LD_CDCLI)
		select WORK
		if !WORK->(dbseek(str(LEIDADOS->LD_CDCLI,5)))
			Grava_Work({	LEIDADOS->LD_CDCLI,;		// 1-Associado
								CodMun,;						// 2-Cod Municipio Aurora
								LEIDADOS->LD_VOLTANT;	//	3-Quantidade Leite
							})
		else
			replace 	WORK->WK_QTD with WORK->WK_QTD + abs(LEIDADOS->LD_VOLTANT)
		end
		select LEIDADOS
	end
	dbskip()
end
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
	static function CalculaLeiteFaixa()
*-----------------------------------------------------------------------------*
SALVABANCO
aResumo:={	{00000,00100,0,0},;
				{00101,00250,0,0},;
				{00251,00500,0,0},;
				{00501,01000,0,0},;
				{01001,02000,0,0},;
				{02001,03000,0,0},;
				{03001,04000,0,0},;
				{04001,05000,0,0},;
				{05001,06000,0,0},;
				{06001,07000,0,0},;
				{07001,08000,0,0},;
				{08001,09000,0,0},;
				{09001,10000,0,0},;
				{10001,11000,0,0},;
				{11001,12000,0,0},;
				{12001,14000,0,0},;
				{14001,15000,0,0},;
				{15001,16000,0,0},;
				{16001,17000,0,0},;
				{17001,18000,0,0},;
				{18001,19000,0,0},;
				{19001,25000,0,0},;
				{25001,99999,0,0};
			}	//..........N Q

select WORK
OrdSetFocus('CODIGO_CLI')
DbGoTop()
while !eof()
	for nX:=1 to len(aResumo)
		if WK_QTD>=aResumo[nX,1].and.WK_QTD<=aResumo[nX,2]
			aResumo[nX,3]++
			aResumo[nX,4]+=WK_QTD
			nX:=100 // Sair
		end
	next
	skip
end
RESTAURABANCO
return NIL

*-----------------------------------------------------------------------------*
	static function CriaTmpLeite()
*-----------------------------------------------------------------------------*
SALVABANCO
LCont:=.T.
cArq  := ArqTemp(,,'')
dbcreate(cArq,{{'WK_CODCL',	'N', 5,0},;	//-1
					{'WK_CODMUN',	'N', 5,0},;	//-2
					{'WK_QTD',		'N',15,0};	//-3
					},;
					RDDSETDEFAULT())
if !net_use(cArq,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	dbcloseall()
	Alert('Erro na abertura do arquivo de trabalho:'+cArq+';Tente novamente')
	LCont:=.F.
else
	Index on str(WK_CODCL ,5)						tag CODIGO_CLI to (cArq)
	Index on str(WK_CODMUN,5)+str(WK_CODCL,5)	tag CODIGO_MUN to (cArq)
	OrdSetFocus('CODIGO_CLI')
end
RESTAURABANCO
return LCont

//--------------------------------------------------------------------EOF
