//-----------------------------------------------------------------------------*
  static aVariav := { 0,0,0, 0,{},'',.T.,{},{},{},{},'', 0, 0, 0, 0,''}
//....................1.2.3..4..5..6..7...8..9.10.11.12.13.14.15.16.17
//-----------------------------------------------------------------------------*
#xtranslate nCli			=> aVariav\[  1 \]
#xtranslate nX				=> aVariav\[  2 \]
#xtranslate nTarro		=> aVariav\[  3 \]
#xtranslate nRota			=> aVariav\[  4 \]
#xtranslate cArqExp		=> aVariav\[  5 \]
#xtranslate VM_DIRIMPO	=> aVariav\[  6 \]
#xtranslate RT				=> aVariav\[  7 \]
#xtranslate aArquivos	=> aVariav\[  8 \]
#xtranslate aImport		=> aVariav\[  9 \]
#xtranslate aReg			=> aVariav\[ 10 \]
#xtranslate aLayOut		=> aVariav\[ 11 \]
#xtranslate cLog			=> aVariav\[ 12 \]
#xtranslate nY				=> aVariav\[ 13 \]
#xtranslate nCont			=> aVariav\[ 14 \]
#xtranslate nFileHandle	=> aVariav\[ 15 \]
#xtranslate nTotal		=> aVariav\[ 16 \]
#xtranslate cNomeArq		=> aVariav\[ 17 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function LeiteP07()	//	Importação de Dados do Leite
//-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO'		,;
				'R->LEIPARAM'		,;		// Parametros do Leite
				'R->PROD'			,;
				'R->CLIENTE'		,;
				'R->LEITRANS'		,;
				'R->LEIMOTIV'		,;
				'R->LEIVEIC'		,;
				'R->LEIROTA'		,;		// criado arquivo no LEITEP00.PRG
				'R->LEICPROD'		,;		// Criado arquivo no LEITEP00.PRG
				'C->LEIDADOS'		;		// Criado arquivo no LEITEP00.PRG
			})
	return NIL
end
private nX1
nX			:=16
cArqExp	:={	padr('04082015-MLH3578-1.TXT'	,50),;	//....1
					padr('ROTA_TRANSPORTADOR.TXT'	,50),;	//....2
					padr('MOTIVO_REJEICAO.TXT'		,50),;	//....3
					padr('TRANSPORTADOR_PLACA.TXT',50);		//....4
				}

SetLayout() // Setar valores iniciais
				
pb_box(nX++,0,,,,'LEITE-Importar Dados de Arquivos de Coleta')
 nX++

select LEIPARAM
VM_DIRIMPO:=LEIPARAM->LP_DIRIMPO

@nX++,01 say 'Diretorio Importacao Arq.:' get VM_DIRIMPO	pict mUUU	valid IsDirectory(trim(VM_DIRIMPO)) when pb_msg('Diretorio onde esta o arquivo-avalie se exite caso nao consiga ir adiante.')
@nX++,01 say 'Arq.Dados Sincronizacao..:' get cArqExp[1]	pict mUUU+'S50';
														valid validaArqImp()
 nX++
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cLinha		:=''
	nTotal		:=0
	aImport		:={}
	aReg			:={}
	cNomeArq		:=trim(VM_DIRIMPO)+if(right(trim(VM_DIRIMPO),1)=="\", "","\") + trim(cArqExp[1])
	cLog			:='ERROS/ADVERTENCIAS NA IMPORTACAO DO ARQUIVO - '+cNomeArq+CRLF
	cLog			+='Importado em '+DtoC(date())+' as '+time()+CRLF+CRLF+CRLF
	LeitArquivo() // Leitura --> Preenche aImport com as Linhas lidas
	//.............................Separar Linhas
	for nX:=1 to len(aImport)
		nCont:=1
		aadd(aReg,Array(len(aLayOut))) // criar registro com campos seprados
		for nY:=1 to len(aLayOut)
			aReg[nX][nY]:=substr(aImport[nX],nCont,aLayOut[nY][2])
			//........................Inicio,Posição,Tamanho
			nCont+=aLayOut[nY][2]
		next
	next
	Alert('Nr Reg Separados:'+str(Len(aReg)))
	//................................................Variáveis do Arquivo
	select LEIDADOS
	DbGoBottom()
	skip //...........................................Registro em branco no final do arquivo
	for nX :=1 to FCount()
		nX1 :="VM"+substr(fieldname(nX),3)
		&nX1:=FieldGet(nX)
	next
	for nX:=1 to Len(aReg)
		//.....................................validar cliente/produtor
		RT				:=.T.
		VM_ALIZAR	:=		 aReg[nX][01]
		VM_ALTERAD	:=		 aReg[nX][02]
		VM_CDFILI	:=Val	(aReg[nX][03])
		VM_CDMOTIV	:=Val	(aReg[nX][04])
		VM_CDROTA	:=Val	(aReg[nX][05])
		VM_CPFCPPJ	:=		 aReg[nX][06]
		VM_DTCOLET	:=CtoD(aReg[nX][07])
		VM_DTEMISS	:=CtoD(aReg[nX][08])
		VM_HREMISS	:=		(aReg[nX][09])
		VM_CDCLI		:=Val	(aReg[nX][10])// Produtor
		VM_NOMEPRO	:=		 aReg[nX][11]
		VM_NRVIAG	:=Val	(aReg[nX][12])
		VM_PLACA		:=		 aReg[nX][13]
		VM_REENVIA	:=		 aReg[nX][14]
		VM_REJEITA	:=		 aReg[nX][15]
		VM_SEQUENC	:=Val	(aReg[nX][16])
		VM_TARRO		:=Val	(aReg[nX][17])
		VM_TEMPER	:=Val	(aReg[nX][18])/100
		VM_CDPROP	:=Val	(aReg[nX][19])
		VM_ESTABUL	:=Val	(aReg[nX][20])
		VM_VOLTAN1	:=Val	(aReg[nX][21])/100
		VM_VOLTAN2	:=Val	(aReg[nX][22])/100
		VM_VOLTAN3	:=Val	(aReg[nX][23])/100
		VM_VOLTAN4	:=Val	(aReg[nX][24])/100
		VM_VOLTAN5	:=Val	(aReg[nX][25])/100
		VM_VOLTANT	:=VM_VOLTAN1+VM_VOLTAN2+VM_VOLTAN3+VM_VOLTAN4+VM_VOLTAN5
		VM_DTIMPOR	:=date()
		
		select CLIENTE
		if VM_CDCLI>99999.or.!CLIENTE->(dbseek(str(VM_CDCLI,5)))
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Cliente ('+aReg[nX][10]+') importado nao encontrado no cadastro.'+CRLF
			RT		:=.F.
		end
		//......................................Placa Veículo
		select LEIVEIC
		ORDEM PLACA
		if !dbseek(VM_PLACA)
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Veiculo ('+aReg[nX][13]+') importado nao encontrado no cadastro.'+CRLF
			RT		:=.F.
		end
		//......................................Motivo Rejeição
		select LEIMOTIV
		if VM_CDMOTIV>0.and.!dbseek(str(VM_CDMOTIV,4))
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Motivo Rejeitado ('+aReg[nX][04]+') nao encontrado no cadastro.'+CRLF
			RT		:=.F.
		end
		//......................................Rota
		select LEIROTA
		if !dbseek(str(VM_CDROTA,6))
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Rota ('+aReg[nX][05]+') nao encontrado no cadastro.'+CRLF
			RT		:=.F.
		end
		//......................................Rota e Tarro
		select LEICPROD
		ORDEM OROTA
		if !dbseek(str(VM_CDROTA,6)+str(VM_TARRO,6))
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Rota ('+aReg[nX][05]+') e Tarro ('+aReg[nX][17]+') nao encontrado no cadastro.'+CRLF
			RT		:=.F.
		end
		ORDEM CODCLI
		if !dbseek(str(VM_CDCLI,5))
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Cliente ('+aReg[nX][10]+') nao encontrado no cadastro de leite.'+CRLF
			RT		:=.F.
		end
		
		select LEIDADOS
		ORDEM DTCOLETA
		if dbseek(DtoS(VM_DTCOLET)+str(VM_NRVIAG,4)+str(VM_CDROTA,6)+str(VM_TARRO,6)+str(VM_SEQUENC,4))
			cLog	+='Reg.'+Str(nX,4)+'-ADVERTENCIA: Data ('+DtoS(VM_DTCOLET)+') Nr.Viag ('+str(VM_NRVIAG,4)+;
					') Rota ('+str(VM_CDROTA,6)+') Tarro ('+str(VM_TARRO,6)+') Seq.Imp.('+str(VM_SEQUENC,4)+;
					') ja foi importado.'+CRLF
			RT		:=.F.
		end
		if VM_REJEITA=='S'
			cLog	+='Reg.'+Str(nX,4)+'-ERRO:Registro esta marcado como rejeitado e portanto nao sera importado.'+CRLF
			RT		:=.F.			
		end
		if LD_ALTERAD=='S'
			cLog	+='Reg.'+Str(nX,4)+'-ADVERTENCIA:Registro esta marcado como alterado apos a entrada.'+CRLF
		end
		if RT	// sem erros nas validações - gravar
			nTotal+=VM_VOLTAN1+VM_VOLTAN2+VM_VOLTAN3+VM_VOLTAN4+VM_VOLTAN5
			LCont	:=AddRec()
			if LCont
				for nY:=1 to FCount()
					nX1:="VM"+substr(fieldname(nY),3)
					replace &(fieldname(nY)) with &nX1
				next
				dbcommit()
			end
			DbrunLock(RecNo())
		end
	next
//-----------------------------------GRAVACAO-----------------------------------------------
	cLog	+=CRLF
	cLog	+=replicat('-',78)+CRLF
	cLog	+='Total de registros lidos do arquivo......:'+Str(Len(aReg))+CRLF
	cLog	+='Total Leite Coletado valido neste Arquivo:'+transform(nTotal,mD132)+CRLF+CRLF
	cLog	+='Legenda: ERRO-Registro nao importado'+CRLF
	cLog	+='         ADVERTENCIA-Mensagem informativa mas importado'+CRLF
	pb_msg('Erros/Adverencias encontradas na importacao. <ALT+P> Imprimir. <Esc=Sair>')
	MemoWrit(Right(cNomeArq,3)+'log',cLog)
	set key K_ALT_P to Log_Print(cLog)
	SetCursor(1)
	MemoEdit(cLog,06,01,21,78,.F.)
	SetCursor(0)
	set key K_ALT_P to
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
		AEval(aArquivos,{|DET|DET[2]:=if(DET[2]>0,DET[2],1)}) // Colocar 1 KB pelo menos
		_ARQ2:=SaveScreen()
		Pb_Msg('Selecione o arquivo a ser recuperado')
		salvacor(.T.)
		setcolor('R/W,W/R,,,W/R')
		nX:=ABROWSE(15,00,23,79, aArquivos,;
									{'Nome',  'Tamanho(KB)',      'Data','Hora'},;
									{   45 ,            11 ,          10,    8 },;
									{  '@!','@E 999999,999','99/99/9999',  '@X'},;
									NIL,;
									'Importacao de dados de Coleta em '+trim(VM_DIRIMPO))
		if nX>0.and.Upper(Right(AllTrim(aArquivos[nX,1]),4))=='.TXT'
			cArqExp[1]:=AllTrim(aArquivos[nX,1]) // Setar Nome do arquivo escolhido
		else
			if nX>0
				Alert('Selecione Arquivo correto para ser recuperado')
				cArqExp[1]:=padr('ARQ_IMPORTACAO_NAO_ENCONTRADO.TXT',50)
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
	pb_msg('Lendo Arquivo de coleta do leite:'+Str(nCont,4))
	if len(cLinha)#218
		if len(cLinha)>0
			cLog+='Reg.'+Str(nCont,4)+'-ERRO:Registro incompleto, diferente que 218 bytes ('+str(len(cLinha),4)+')- verificar'+CRLF
		end
	elseif len(cLinha)==218
		aadd( aImport, cLinha )
	end
	nCont++
end
//......................Pegar última Linha
if len(cLinha)#218
	if len(cLinha)>0
		cLog+='Reg.'+Str(nCont,4)+'-ERRO:Registro incompleto, diferente que 218 bytes ('+str(len(cLinha),4)+')- verificar'+CRLF
	end
elseif len(cLinha)==218
	aadd( aImport, cLinha )
end
alert('Registros Lidos:'+str(len(aImport)))
FClose( nFileHandle )
return NIL

//-----------------------------------------------------------------------------*
  static function SetLayout()	//	Valida Existência Arquivo de Importação
//-----------------------------------------------------------------------------*
aLayout:={;
				{'S',20,'Alizarol             '},;	// 1. 001-020
				{'S', 1,'Reg.Alterad Pos Colet'},;	// 2. 021-021
				{'I', 4,'Cod.da Filiada       '},;	// 3. 022-025
				{'I', 4,'Cod.Rejeicao         '},;	// 4. 026-029
				{'I', 6,'Cod.Rota             '},;	// 5. 030-035
				{'S',18,'CPF/CNPJ Produtor    '},;	// 6. 036-053
				{'S',10,'Data da Coleta       '},;	// 7. 054-063
				{'S',10,'Data de Emissao      '},;	// 8. 064-073
				{'S', 8,'Hora de Emissao      '},;	// 9. 073-081
				{'I', 6,'Cod. Produtor        '},;	//10. 082-087
				{'S',60,'Nome Produtor        '},;	//11. 088-147
				{'I', 4,'Nr da Viagem         '},;	//12. 148-151
				{'S', 7,'Placa Veiculo        '},;	//13. 152-158
				{'S', 1,'Reenviado            '},;	//14. 159-159
				{'S', 1,'Rejeitado(S/N)       '},;	//15. 160-160
				{'S', 4,'Sequencia            '},;	//16. 161-164
				{'I', 6,'Nr.Tarro Produtor    '},;	//17. 165-170
				{'F', 4,'Temperatura Coleta   '},;	//18. 171-174
				{'I', 2,'Nr. Propriedade      '},;	//19. 175-176
				{'I', 2,'Nr. Estabulo         '},;	//20. 177-178
				{'F', 8,'Volume Tanque 1      '},;	//21. 179-186
				{'F', 8,'Volume Tanque 2      '},;	//22. 186-194
				{'F', 8,'Volume Tanque 3      '},;	//23. 195-202
				{'F', 8,'Volume Tanque 4      '},;	//24. 203-210
				{'F', 8,'Volume Tanque 5      '},;	//25. 211-218
				{'I', 4,'Cod.Destino          '},;	//28. 219-222
				{'I', 4,'Cod.Motivo Troca     '};	//29. 222-225
			}
return NIL

//-----------------------------------------------------------------------------*
  function Log_Print(pTexto)	//	Valida Existência Arquivo de Importação
//-----------------------------------------------------------------------------*
if pb_ligaimp()
	?pTexto
	pb_deslimp(,,.F.)
	pb_msg('Impressao completada. <Esc> para sair.',1)
end
return NIL
//------------------------------------------EOF--------------------------
