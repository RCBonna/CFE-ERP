//-----------------------------------------------------------------------------*
  static aVariav := {'',0,0, 0,{},'',.T.,{},{},{}, 0,'', 0, 0, 0, 0,'', 0, 0}
//....................1.2.3..4..5..6..7...8..9.10.11.12.13.14.15.16.17.18.19
//-----------------------------------------------------------------------------*
#xtranslate cSub			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate nTarro		=> aVariav\[  3 \]
#xtranslate nRota			=> aVariav\[  4 \]
#xtranslate cArqExp		=> aVariav\[  5 \]
#xtranslate VM_DIRIMPO	=> aVariav\[  6 \]
#xtranslate RT				=> aVariav\[  7 \]
#xtranslate aArquivos	=> aVariav\[  8 \]
#xtranslate aImport		=> aVariav\[  9 \]
#xtranslate aReg			=> aVariav\[ 10 \]
#xtranslate nRegAnt		=> aVariav\[ 11 \]
#xtranslate cLog			=> aVariav\[ 12 \]
#xtranslate nY				=> aVariav\[ 13 \]
#xtranslate nCont			=> aVariav\[ 14 \]
#xtranslate nFileHandle	=> aVariav\[ 15 \]
#xtranslate nTotal		=> aVariav\[ 16 \]
#xtranslate cNomeArq		=> aVariav\[ 17 \]
#xtranslate nRegErro		=> aVariav\[ 18 \]
#xtranslate nRegAdvert	=> aVariav\[ 19 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function LeiteP17()	//	Importação de Dados do Leite
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'C->LEIPARAM'		,;		// Parametros do Leite
				'C->LEILABOR'		,;		// Dados de Analise Leite Laboratório
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'C->LEIDADOS'		;		// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
private nX1
cArqExp	:={	padr('NOME_ARQUIVO_ANALISE.TXT'	,50),;	//....1
					padr('ROTA_TRANSPORTADOR.TXT'		,50),;	//....2
					padr('MOTIVO_REJEICAO.TXT'			,50),;	//....3
					padr('TRANSPORTADOR_PLACA.TXT'	,50);		//....4
				}

//SetLayout() // Setar valores iniciais
nX				:=15
pb_box(nX++,0,,,,'LEITE-Importar Dados de Analise de Leite')
 nX++
select LEIPARAM
VM_DIRIMPO	:=LEIPARAM->LP_DIRIMPL
cSub			:='S'
@nX++,01 say 'Periodo...: '+Transform(LEIPARAM->LP_PERIODO,mPER) color 'GR+/G,GR+/B'
@nX++,01 say 'Diretorio.:' get VM_DIRIMPO	pict mUUU	valid IsDirectory(trim(VM_DIRIMPO)) when pb_msg('Diretorio onde esta o arquivo-avalie se exite caso nao consiga ir adiante.')
@nX++,01 say 'Arquivo...:' get cArqExp[1]	pict mUUU+'S60';
														valid validaArqImp()
 nX++
@nX++,01 say 'Substituir Reg Duplicado:' get cSub	pict mUUU valid cSub $ 'SN'
 nX++
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cErroGeral	:=.F.
	cLinha		:=''
	nTotal		:=0
	aImport		:={}
	aReg			:={}
	nRegErro		:=0
	nRegAdvert	:=0
	cNomeArq		:=AllTrim(VM_DIRIMPO)+if(right(trim(VM_DIRIMPO),1)=="\", "","\") + trim(cArqExp[1])
	cLog			:=Padc('ERROS/ADVERTENCIAS NA IMPORTACAO',78)					+CRLF+CRLF
	cLog			+='Arquivo Importado: '+cNomeArq										+CRLF+CRLF
	cLog			+='Periodo..........: '+Transform(LEIPARAM->LP_PERIODO,mPER)+Space(15)
	cLog			+='Importado em '+DtoC(date())+' as '+Time()						+CRLF+CRLF
	cLog			+=Replicate('-',78)+CRLF
	LeitArquivo() // Leitura --> Preenche aImport com as Linhas lidas
	//.............................Separar Linhas
	//	alert('Token incial;'+token(aImport[1],';',13))
	for nX:=1 to len(aImport)
		pb_msg('Separando Registros '+str(nX,4))
		aImport[nX]:=strtran(aImport[nX],',','.') // Mudar , para .
		aadd(aReg,Array(13)) // Criar Registro Campos Seprados
		for nY:=1 to 13 		// Ler Linha
			aReg[nX][nY]:=Token(aImport[nX],';',nY) // Pegar 1 registro e separar em campos
		next
	next
	//................................................Variáveis do Arquivo
	select LEILABOR
	DbGoBottom()
	DbSkip() //.......................................Registro em branco no final do arquivo
	for nX :=1 to FCount()
		nX1 :="VM"+substr(FieldName(nX),3)
		&nX1:=FieldGet(nX)
	next
	for nX:=2 to Len(aReg)	// Pular Reg = 1 = Cabeçalho Colunas Arquivo
		//.....................................validar cliente/produtor
		pb_msg('Gravando Registros '+str(nX,4))
		RT				:=.T. 					// Registro Sem Erros
		VM_NRREQU	:=Val (aReg[nX][01])	// 01-Nr Requisição Laboratório
		VM_ANOREQ	:=Val (aReg[nX][02])	// 02-Ano Requisição Laboratório
		VM_DTCOLE	:=CtoD(aReg[nX][03])	// 03-DATA_COLETA
		VM_TARRO		:=Val (aReg[nX][04])	// 04-Nr Tarro = IDENT_AMOSTRA
		VM_GORDUR	:=Val (aReg[nX][05])	// 05-PERC_GORDURA
		VM_PROTEI	:=Val (aReg[nX][06])	// 06-% PROTEINA
		VM_LACTOS	:=Val (aReg[nX][07])	// 07-PERC_LACTOSE
		VM_PERSOL	:=Val (aReg[nX][08])	// 08-PERC_SOLIDOSTOTAL
		VM_NRCCS		:=Val (aReg[nX][09])	// 09-CCS_1000
		VM_NRCBT		:=Val (aReg[nX][10])	// 10-CBT
		VM_DTANA		:=CtoD(aReg[nX][11])	// 11-DATA_ANALISE
		VM_CDROTA	:=Val (aReg[nX][12])	// 12-ROTA_LINHA
		VM_CDPROP	:=Val (aReg[nX][13])	// 13-UNIDADE_CLIENTE
		VM_ESD		:=VM_PERSOL-VM_GORDUR// 14-ESD-Extrado Seco Desengordurado
		VM_CDCLI		:=0						// 15-Codigo Cliente (Colocado na Importação)
		VM_DTIMP		:=Date()					// 16-Dt Importação
		VM_USUAR		:=RT_NOMEUSU()			// 17-Usuário importador

		select LEICPROD
		ORDEM OROTA
		if !dbseek(str(VM_CDROTA,6)+str(VM_TARRO,6))
			cLog			+=	'Reg.'			+Str (nX,4)		+;
								'-ERRO:Rota ('	+aReg[nX][12]	+;
								') e Tarro ('	+aReg[nX][04]	+;
								') nao encontrado no cadastro.'+CRLF
			RT				:=.F.	// Registro com Erro
			cErroGeral	:=.T.
			nRegErro++
		else
			VM_CDCLI:=LEICPROD->LC_CDCLI // Codigo do Cliente
		end

		select LEILABOR
		ORDEM DTROT 	// DtoS(LA_DTCOLE)+str(LA_TARRO,6)
		nRegAnt:=0
		if dbseek(DtoS(VM_DTCOLE)+str(VM_TARRO,6))
			cLog	+=	'Reg.'				+Str(nX,4)						+;
						'-ADVER: Data ('	+DtoS(VM_DTCOLE)				+;
						') Rota ('			+AllTrim(str(VM_CDROTA,6))	+;
						') Tarro ('			+AllTrim(str(VM_TARRO,6))	+;
						') ja importado'	+CRLF
			nRegAdvert++
			if cSub=='S'
				nRegAnt	:=RecNo()
			end
		end
		if RT	// Sem erros nas validações - gravar
			if nRegAnt==0	//......................Não Existe Registro Anterior
				LCont	:=AddRec()
			elseif cSub=='S'	//...................Existe Registro Anterior e Sobrepor
				LCont	:=RecLock()
			end
			if LCont
				for nY:=1 to FCount()
					nX1:="VM"+substr(fieldname(nY),3)
					replace &(fieldname(nY)) with &nX1
				next
				dbcommit()
			end
		end
	next
	//-----------------------------------GRAVACAO-----------------------------------------------
	select LEIPARAM
	if RecLock()
		Replace LP_ERRANAL with if(cErroGeral,'Erro: Importacao dos Dados de Analise','')
	end
	DbUnlockAll()
	cArqExp[2]:=StrTran(Upper(cNomeArq),'.TXT','.LOG')
	cLog	+=CRLF
	cLog	+=Replicate('-',78)																			+CRLF
	cLog	+='Total de registros lidos do arquivo..............:'+Str(Len(aReg)-1,4)	+CRLF
	cLog	+='Legenda: ERRO -Registros nao importado por falhas:'+Str(nRegErro,4)		+CRLF
	cLog	+='         ADVER-Mensagem Informativa mas importado:'+Str(nRegAdvert,4)	+CRLF
	cLog	+=Replicate('-',78)																			+CRLF
	cLog	+='Arquivo de LOG: '+cArqExp[2]
	pb_msg('Erros/Adverencias da importacao. <ALT+P>=Imprimir. <Esc>=Sair>')	

	pb_box(05,00,22,79,'B/W')
	MemoWrit(cArqExp[2],cLog)
	set key K_ALT_P to Log_Print(cLog)
	SetCursor(1)
	MemoEdit(cLog,06,01,21,78,.F.)
	SetCursor(0)
	set key K_ALT_P to
	setcolor(VM_CORPAD)
	//------------------------------------------------------------------------------------------
end
dbcloseall()
return NIL

//-----------------------------------------------------------------------------*
  static function ValidaArqImp()	//	Valida Existência Arquivo de Importação
//-----------------------------------------------------------------------------*
RT			:=.T.
cNomeArq	:=trim(VM_DIRIMPO)+if(right(trim(VM_DIRIMPO),1)=="\", "","\") + trim(cArqExp[1])
if file(cNomeArq)
	RT:=.T.
else
	RT:=.F.
	pb_msg('Arquivo nao encontrado no diretorio')
	aArquivos:=Directory( trim(VM_DIRIMPO)+'\*.TXT' )
	if len(aArquivos)>0
		ASort(aArquivos,,,{|x,y|x[1]>y[1]})
		AEval(aArquivos,{|DET|DET[2]:=int(DET[2]/1024)}) // Transformar em KB
		AEval(aArquivos,{|DET|DET[2]:=if (DET[2]>0,DET[2],1)}) // Colocar 1 KB pelo menos
		_ARQ2:=SaveScreen()
		pb_msg('Selecione o arquivo a ser recuperado')
		salvacor(.T.)
		setcolor('R/W,W/R,,,W/R')
		SET CENTURY	OFF		// Data com ano 2 digitos
		nX:=ABROWSE(15,00,23,79, aArquivos,;
									{'Nome',    'Tam(KB)',    'Data','Hora'},;
									{   52 ,           7 ,        8 ,    8 },;
									{  '@!', '@E 999,999','99/99/99',  '@X'},;
									nil,;
									'Importacao de dados de Analise em '+trim(VM_DIRIMPO))
		SET CENTURY	ON		// Data com ano 4 digitos

		if nX>0.and.Upper(Right(AllTrim(aArquivos[nX,1]),4))=='.TXT'
			cArqExp[1]:=AllTrim(aArquivos[nX,1]) // setar nome do arquivo escolhido
		else
			if nX>0
				Alert('Selecione Arquivo correto para ser recuperado')
				cArqExp[1]:=PadR('ARQ_IMPORTACAO_NAO_ENCONTRADO.TXT',50)
			end
		end
		RestScreen(,,,,_ARQ2)
		salvacor(.F.)
	else
		alert('Nao encontrado arquivos TXT no diretorio;'+trim(VM_DIRIMPO))
	end
end
return RT

//-----------------------------------------------------------------------------*
  static function LeitArquivo()	//	Valida Existência Arquivo de Importação
//-----------------------------------------------------------------------------*
nCont			:=1
nFileHandle :=FOpen( cNomeArq )
while HB_FReadLine( nFileHandle, @cLinha ) == 0
	pb_msg('Lendo Arquivo de Analise do leite:'+Str(nCont,4))
	if len(cLinha)>0
		aadd( aImport, cLinha )
	end
	nCont++
end
//......................Pegar última Linha
if len(cLinha)>0
	aadd( aImport, cLinha )
end
alert('Registros Lidos:'+str(len(aImport)-1))
FClose( nFileHandle )
return NIL

//------------------------------------------EOF--------------------------
