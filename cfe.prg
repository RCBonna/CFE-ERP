//-----------------------------------------------------------------------------*
	static aVariavM := { 0, 0, '', 0, {}, '', '' }
//......................1..2...3..4...5...6...7
//-----------------------------------------------------------------------------*
#xtranslate nSemCount	=> aVariavM\[  1 \]
#xtranslate nNRNF			=> aVariavM\[  2 \]
#xtranslate cTexto		=> aVariavM\[  3 \]
#xtranslate nX				=> aVariavM\[  4 \]
#xtranslate nTotReg		=> aVariavM\[  5 \]
#xtranslate cArqLog		=> aVariavM\[  6 \]
#xtranslate cKeyNFe		=> aVariavM\[  7 \]

#include "RCB.CH"
*-----------------------------------------------------------------------------*
* CFE - Sistema Integrado 																		*
*-----------------------------------------------------------------------------*
*------------------------------------------------------- VLR <0 CR
*------------------------------------------------------- VLR >0 DB
*-----------------------------------------------------------------------------*
static CF_Conv:=.F.

#define VERSAO '2018I2' // Data Modificação 22/08/17
//.........................
// 1-2-3-4-5-6-7-8-9-0-1-2-
// A-B-C-D-E-F-G-H-I-J-K-L-
*-----------------------------------------------------------------------------*
	function Main()
*-----------------------------------------------------------------------------*
local  X
local  aMenu
local  Tecla
local  dHoraInic:=Time()

public VM_EMPR   :='Demonstracao'
public USACAIXA  :=.F.
public VM_SISTEMA:=NOMESIS
public L_P       :=7
public NUM_CXA   :=2
public ARQ_CXA   :=''
public MPROD
public VM_MASTAM
public VM_LENMAS
public VM_MUSCC  :=''
public MASC_CTB  :='9-99-999'+space(12)	// 4 - Padrao inicial
public MESCTBFECHADO:=0

request	HELP
request	EDITAMENU
request	COPIAR
request	ERRORSYS
request	LIBACESSO
request	NAO
request	EDITADBF
request	DBFCDX
request	DBFFPT
request	HB_LANG_PT
request	HB_CODEPAGE_PT850
request	HB_NOMOUSE

clear

HB_LangSelect("PT")
//HB_SetCodePage("PT850")

SET AUTOPEN			OFF
SET SCOREBOARD		OFF
SET DELETED			ON
SET CONFIRM			ON
SET OPTIMIZE		ON		// otimização de filtros (SET FILTER TO)
SET CENTURY			ON		// Data com ano 4 digitos
SET CURSOR			OFF
SET DATE 			BRITISH
SET MESSAGE 		TO LastRec() CENTER
SET EPOCH 			TO 1980
SET TIME FORMAT 	TO "hh:mm"
SET COLOR 			TO 'W+/B'
SET HARDCOMMIT		ON

SetMouse(.F.)
MSetCursor(.F.)
MSetBounds(3,2,3,2)
SetMode(25,80)
SetBlink(.F.)
SetNetDelay(60) // setar tempo de espera em 60 segundos em rede

MakeDir('ERROS')
SET ERRORLOG TO ('ERROS\_Error.log') ADDITIVE

ANNOUNCE FPTCDX
RDDSETDEFAULT('DBFCDX')
RDDREGISTER(  'DBFCDX', 1 ) // RDT_FULL

*........ SET CFE=//CAIXA:1 //DNFE:1 //SERIE:NFE

*---------------------------------CONTROLAR CAIXAS
	NUM_CXA:=val(RtVarAmb('CFE','CAIXA:'))
if NUM_CXA<1
	NUM_CXA:=2
end
_ARQ_CXA:='CXA'+pb_zer(NUM_CXA,2)+'VLR.ARR'
*-------------------------------------------------------------*
pb_x('CFE',@VM_EMPR)
Cria_PA()//.............................em CFEPCRIA.PRG
Cria_PA_CTB() //........................em CTBPCRIA.PRG
Masc_Din()
ImprSet()

// @19,12 say 'SO='+aeval(OS_VersionInfo(),{|x|qqout(x)})
if !ACESSO_I('CFE',VM_SISTEMA+' / '+VERSAO)
	setcolor('')
	clear
	quit
end

X    :=.F.
TECLA:='C'
if !file('CFEAPA.DBF')
	X :=.T.
else
	dbUseArea(.T.,,'CFEAPA','PARAMETRO',!SHARED)
	if !NetErr()
		X:=.T. // tem alguem usando.
	end
	dbcloseall()
end
if X
	*-----------------------------------------------> Contabilidade	
	if !abre({	'C->PARAMCTB',;
					'C->PARAMETRO'})
		pb_fim('CFE')
	end
	if abs(PARAMETRO->PA_DATA-date())>90
		pb_msg('Problemas com a data;do micro e do sistema;ATUALIZE (+90 dias)',5,.T.)
	end
	if PARAMETRO->PA_DATA < Date()
		TECLA:='S1'
	end
	CF_Conv:=PARAMETRO->PA_CONVCF
	if upper(trim(PARAMETRO->PA_VERSAO))>upper(trim(VERSAO))
		alert('*** ERRO ERRO ERRO ***;Foi executado uma copia do CFE mais atual;procure atualizar para cfe para versao '+upper(trim(PARAMETRO->PA_VERSAO)))
		dbcloseall()
		pb_fim('CFE')
	elseif trim(PARAMETRO->PA_VERSAO)<trim(VERSAO)
		@MaxRow()-2,0 say Padc('*** CFE/Instalado Nova Versao do SISTEMA - '+VERSAO,MaxCol()+1) color 'R+/W*'
		if reclock()
			replace PARAMETRO->PA_VERSAO with VERSAO
		end
		inkey(1)
	end
	dbcloseall()
	ARQ(.F., 'VER ARQUIVOS') // Só verifica arquivos
	INIT_ORD()
	ARQI(.F.,'VER INDICES') // Só verifica indices
	if !CF_Conv
		CLEAR
		alert('ESTA VERSAO SERVE SO PARA 2003;ESTE PROGRAMA NAO USA MAIS CADASTRO DE FORNECEORES;REQUER PROGRAMA UNIFICACAO DO CADASTRO DE CLIENTES E FORNECEDORES;VERSAO 2002L32')
		dbcloseall()
		return NIL
	end
end
USACAIXA  :=.F.
if abre({'R->CAIXAPA'})
	USACAIXA:=PA_MODCX
	dbcloseall()
end

MESCTBFECHADO  :=0
if abre({'R->PARAMCTB'})
	MESCTBFECHADO:=PA_MES // Mes Fechado
	dbcloseall()
end


set key K_ALT_F2 to DAJUDA()	// ALT+F2-Grava ajuda on line
setkey(K_F2,{||KEYXML()})		// F2-Consulta FORNECEDORES
setkey(K_F3,{||CFEPCONS()})	// F3-Consulta FORNECEDORES
setkey(K_F4,{||CFEPCONS()})	//	F4-Consulta CLIENTES
setkey(K_F5,{||CFEPCONS()})	//	F5-Consulta PRODUTOS
setkey(K_F6,{||CALC()})			// F6-Chama calculadora
setkey(K_F7,{||FN_CONSPAR()})	// F7-Consulta Valores
setkey(K_F9,{||IMPRSELE()})	// F9-Chama Selecao de Impressora
// setkey(K_F7,{||ORDPCLOR()})// F7-Consulta Cliente/Ordem
setkey(-40,{||CALEND()})		// F11-Calendario
setkey(-33,{||pb_fim('CFE')})	// ALT+F4 - Sair do Sistema
setkey(-30,{||TROCANIVEL()})	// ALT+F1 - Troca Nivel

setkey(300,{||Chk1NatOper()})	// ALT+Z - Atualizar Natureza operacao.

aMenu:=BuildMenu('CFE')
keyboard TECLA
while .T.
	pb_tela(VM_SISTEMA,VERSAO,VM_EMPR,REPRES)
	pb_lin4('M E N U',ProcName()+str(RT_NIVEL(),1))
	set confirm ON
	@maxrow()-11,01 say ' F1 =Ajuda '
	@maxrow()-10,01 say ' F3 =Cons.Fornecedores '
	@maxrow()-09,01 say ' F4 =Cons.Clientes '
	@maxrow()-08,01 say ' F5 =Cons.Produtos '
	@maxrow()-07,01 say ' F7 =Cons.Parcelamento '
	@maxrow()-06,01 say ' F6 =Calculadora '
	@maxrow()-05,01 say ' F9 =Sel Impressora '
	@maxrow()-04,01 say ' F11=Calendario '
	@maxrow()-04,60 say 'Mem¢ria: '+transform(Memory()/1024,mD70)+' MB'
	@maxrow()-03,60 say "Usuario:"+padr(RT_NOMEUSU(),11)
	@maxrow()-02,76 say "["+RT_NRUSU()+"]"
	FazMenu(aMenu)
	alert('Tempo Acesso:'+ElapTime(dHoraInic,Time()))
end

return NIL

*-----------------------------------------------------------------------------
 function LOGVER(P1)
*-----------------------------------------------------------------------------
if file(P1)
	alert('SET CFE='    +getenv('CFE'))
	alert('SET CLIPPER='+getenv('CLIPPER'))
	MemoEdit(memoread(P1),6,1,21,78,.F.)
else
	Alert('Arquivo de versoes nao encontrado')
end
return NIL

*-----------------------------------------------------------------------*
function ProgVersao()
return VERSAO
*-----------------------------------------------------------------------*

*-----------------------------------------------------------------------------
 function GDFPSAGE() //-NAO RETIRAR POR CAUSA DO SAG
*-----------------------------------------------------------------------------
return NIL
*-----------------------------------------------------------------------------
 function GDFPSAGS() //-NAO RETIRAR POR CAUSA DO SAG
*-----------------------------------------------------------------------------
return NIL

*----------------------------------------------VERIFICA NATUREZA OPERACAO 7 DIGITOS
  function Chk1NatOper()
*----------------------------------------------VERIFICA NATUREZA OPERACAO 7 DIGITOS
local ARQ
if pb_sn('Atualizar Codigo de;Natureza de Operacao; no sistema inteiro ?')
	ARQ:='CFEANO'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('NO_CODIG'),TrNatOper(NO_CODIG))})
		close
	end
	ARQ:='CFEAEC'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('EC_CODOP'),TrNatOper(EC_CODOP))})
		close
	end
	ARQ:='CFEAED'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('ED_CODOP'),TrNatOper(ED_CODOP))})
		close
	end
	ARQ:='CFEAPC'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('PC_CODOP'),TrNatOper(PC_CODOP))})
		close
	end
	ARQ:='CFEAPD'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('PD_CODOP'),TrNatOper(PD_CODOP))})
		close
	end
	ARQ:='CFEAPS'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('PS_CODOP'),TrNatOper(PS_CODOP))})
		close
	end

	ARQ:='FISARA'
	ferase(ARQ+OrdBagExt())
	if net_use(ARQ,.T.,20,ARQ,.T.,.F.,RDDSETDEFAULT())
		pb_msg('Modificando Natureza Operacao/'+ARQ)
		DbGoTop()
		dbeval({||fieldput(fieldpos('RA_CODOPE'),if(Len(Alltrim(RA_CODOPE))==3,Alltrim(RA_CODOPE)+'00',RA_CODOPE))})
		close
	end
	pb_msg('Encerrado conversao...')
	alert('Encerrado a conversao;Entre novamente no sistema')
	quit
end
return NIL
// TODO   Auto-generated method stub

*-----------------------------------------------------------------------*
function CFEVersao() //
*-----------------------------------------------------------------------*
Return VERSAO

*-----------------------------------------------------------------------*
static function Xchar_asc() //-NAO RETIRAR POR CAUSA DO SAG
*-----------------------------------------------------------------------*
local  X
local  N
clear
N:=CL_RAZAO
inkey(0)
for X:=1 to len(N)
	?? SPACE(3)+substr(N,X,1)
next 
?
for X:=1 to len(N)
	?? str(asc(substr(N,X,1)),4)
next 
inkey(0)
return NIL

function CFEPFAR1() // retirado de sistema
NAO(ProcName())
return NIL

function CFEPVECF() // retirado de sistema
NAO(ProcName())
return NIL

*-----------------------------------------------------------------------*
EXIT PROCEDURE MyExitCfe
sx_KillSem('CFE')
return NIL

*-----------------------------------------------------------------------*
/*
PROCEDURE ConfigurarAmbiente()

	HB_LangSelect( 'PT' )
	HB_SetCodePage( 'PT8501' )
	
	wvw_SetCodePage( 0, 255 )
	wvw_Size_Ready( .T. )
	wvw_EnableMaximize( 0, .T. )
	wvw_SetFont( 0 , "Consolas", 24, 11, 100, 4 )
	wvw_SetTitle( "CFE - Versão "+  VERSAO)
		
	SetMode( 20, 70 )
return
*/

*------------------------------------------------------------------------*
function NFEE() // calculo do digito verificador da NFE (43 digitos)
*------------------------------------------------------------------------*
nCont:=.T.
Alert('Calculo do digito verificador da NFE;Ajuste manual no XML em 2 pontos.')
while nCont
	pb_box(5,1,20,78)
	NFEE:='42MMAA7581545600010955001NNNNNNNNN188888888'
	@09,10 say                 '.......UFMMDD|-----CNPJ---|55serTnrnf.....Nr.Inter'
	@10,10 SAY 'NRNFE=' get NFEE PICT '9999999999999999999999999999999999999999999'
	READ
	IF LASTKEY()#K_ESC
		cDigId    :=CalcDg(NFEE)
		@12,10 SAY 'Digito='+cDigID
		INKEY(0)
	else
		nCont:=.F.
	END
end
return nil

*--------------------------------------------------------------------*
function KEYXML()
*--------------------------------------------------------------------*
private XmlDoc := ''
private aOPC	:={'Matriz','Filial','Cancelar'}
private nOPC	:=0
nTotReg			:={0,0,0,0,0,0,0,0}
cTexto			:=''
if select()>0
	Alert('F2-Rotina que ajusta a Chave Interna do XML;So pode ser usada no menu principal.')
	return NIL
end
salvacor(SALVA)
if pb_msg('Ajustar a Chave interna NFE com XML-CFE+SAG')
	dbcloseall()
	nOPC:=Alert('Selecione ',aOPC)
	cTexto:=chr(15)+'LOG de importação de XML '+CRLF+'Importado em '+dtoc(date())+' as '+time()+CRLF+CRLF
	pb_box(10,10,20,70)
	if nOPC==1
		cDirOrig:=space(150)
		@12,12 say 'Opcao Selecionada: '+aOPC[nOPC] color 'R/G'
		@13,12 say 'Informe diretorio onde estao os XML com numeros corretos'
		@14,12 get cDirOrig pict '@xS58' valid isDirectory(alltrim(cDirOrig))
		read
		if iif(lastkey()#27,pb_sn('Processar XML do Diretorio;para '+aOPC[nOPC]+' ?'),.F.)
			if !abre({	'R->PARAMETRO',;
							'C->PEDCAB',;
							'C->ENTCAB'})
				alert('Impossivel abrir arquivos;Verifique - Saindo')
				return NIL
			end
			if PARAMETRO->PA_CGC#'75815456000109'
				Alert('Estes dados nao sao da MATRIZ;o acesso aos dados da '+aOPC[nOPC]+' CNPJ='+transform(PARAMENTRO->PA_CGC,mCGC))
			else
				XmlProcessa(aOPC[nOPC])
			end
		end
	elseif nOPC==2
		cDirOrig:=space(40)
		@12,12 say 'Opcao Selecionada: '+aOPC[nOPC] color 'R/G'
		@13,12 say 'Informe diretorio onde estao os XML com numeros corretos'
		@14,12 get cDirOrig pict '@x' valid isDirectory(alltrim(cDirOrig))
		read
		if iif(lastkey()#27,pb_sn('Processar XML do Diretorio;para '+aOPC[nOPC]+' ?'),.F.)
			if !abre({	'R->PARAMETRO',;
							'C->PEDCAB',;
							'C->ENTCAB',;
							'C->NFC'})
				alert('Impossivel abrir arquivos;Verifique - Saindo')
				return NIL
			end
			if PARAMETRO->PA_CGC#'75815456000290'
				Alert('Estes dados nao sao da FILIAL;o acesso aos dados da '+aOPC[nOPC]+' CNPJ='+transform(PARAMETRO->PA_CGC,mCGC))
			else
				XmlProcessa(aOPC[nOPC])
			end
		end		
	end
	dbcloseall()
	keyboard replicate(chr(K_ESC),4)
end
salvacor(RESTAURA)
return NIL 

*-------------------------------------------------------------------------------------*
static function XmlProcessa(pEmpresa)
*-------------------------------------------------------------------------------------*
select PEDCAB
ORDEM NNFSER // NRNF-DOC (6) Serie (3) 
select ENTCAB
ORDEM DOCSER // NRNF-DOC (8) Serie (3) Fornc(5)
cDirOrig:=alltrim(cDirOrig)
cTexto  +='Empresa selecionada='+aOPC[nOPC] +CRLF
cTexto  +='Diretorio de dados ='+cDirOrig   +CRLF+CRLF
cTexto  +='LISTA DE XML QUE NAO FORAM ENCONTRADAOS NO SITEMA (CFE ou SAG)'+CRLF
aFileDir:=Directory(cDirOrig+'\*.xml')
if len(aFileDir)>0
	cTexto+='Numero de Arquivos ='+str(len(aFileDir),4)+CRLF+CRLF
	for nX:=1 to len(aFileDir)
		pb_msg('Lendo Arquivo:'+aFileDir[nX,1])
		XmlDoc:=MemoRead(cDirOrig+'\'+aFileDir[nX,1])
		nPos:=at('<tpNF>',XmlDoc)
		if nPos>0
			nTipoNF:=substr(XmlDoc,nPos+6,1) // tipo de NF 0=Entrada 1=Saida
		end
		nPos   :=at('Id="NFe',XmlDoc)
		cKeyNFe:=substr(XmlDoc,nPos+7,44)
		nNRNF  :=val(substr(cKeyNFe,26,9))
		if nTipoNF=='1' // tipo NOTA FISCAL DE ENTRADA
			select PEDCAB
			if dbseek(str(nNRNF,6)+'NFE') // está no CFE com NF de Saida?
				if PEDCAB->PC_NFEKEY<>cKeyNFe	// Chave diferente?
					if RecLock()
						replace PEDCAB->PC_NFEKEY with cKeyNFe
						DbUnLock()
						DbCommit()
						nTotReg[2]++
					end
				else
					nTotReg[4]++
				end
			else
				if pEmpresa=='Filial'
					select NFC
					ORDEM SCODIGO // é Entrada
					if dbseek('S'+'NFE'+str(nNRNF,6)) // Esta existe na Saida ?
						if NFC->NF_NFEKEY<>cKeyNFe	// chave é diferente-> mudar
							if RecLock()
								replace NFC->NF_NFEKEY with cKeyNFe
								DbUnLock()
								DbCommit()
								nTotReg[6]++
							end
						else
							nTotReg[8]++
						end
					else
						cTexto+='XML '+aFileDir[nX,1]+' NF '+str(nNRNF,6)+' Saida-SAG'+CRLF
					end
				else
					cTexto+='XML '+aFileDir[nX,1]+' NF '+str(nNRNF,6)+' Saida-CFE'+CRLF
				end
			end
		else // é nota fiscal de entrada 'E'
			select ENTCAB
			if dbseek(str(nNRNF,8)+'NFE',.T.) // Tem NF e serie igual
				if str(ENTCAB->EC_DOCTO,8)==str(nNRNF,8).and.ENTCAB->EC_SERIE=='NFE'
					if ENTCAB->EC_NFEKEY<>cKeyNFe	// Chave é diferente - Mudar
						if RecLock()
							replace ENTCAB->EC_NFEKEY with cKeyNFe
							DbUnLock()
							DbCommit()
							nTotReg[1]++
						end
					else
						nTotReg[3]++
					end
				end
			else
				if pEmpresa=='Filial'
					select NFC
					ORDEM ECODIGO // é Entrada
					if dbseek('E'+'NFE'+str(nNRNF,6),.T.) // esta chava ainda tem Emitente
						if NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6)=='E'+'NFE'+str(nNRNF,6) // é esta NF
							if NFC->NF_NFEKEY<>cKeyNFe	// chave é diferente-> mudar
								if RecLock()
									replace NFC->NF_NFEKEY with cKeyNFe
									DbUnLock()
									DbCommit()
									nTotReg[5]++
								end
							else
								nTotReg[7]++
							end
						end
					else
						cTexto+='XML '+aFileDir[nX,1]+' NF '+str(nNRNF,6)+' Entrada-SAG'+CRLF
					end
				else
					cTexto+='XML '+aFileDir[nX,1]+' NF '+str(nNRNF,6)+' Entrada-CFE'+CRLF
				end
			end
		end
	next
	cTexto+=replicate('-',80)+CRLF
	cTexto+='Nr.Reg. Gravados em NF de Entrada  no CFE.:'+str(nTotReg[1])+CRLF
	cTexto+='                          Saida    no CFE.:'+str(nTotReg[2])+CRLF				
	cTexto+='                          Entrada  no SAG.:'+str(nTotReg[5])+CRLF				
	cTexto+='                          Saida    no SAG.:'+str(nTotReg[6])+CRLF				
	cTexto+='Nr.Reg. Chaves Corretas de Entrada no CFE.:'+str(nTotReg[3])+CRLF				
	cTexto+='                           Saidas  no CFE.:'+str(nTotReg[4])+CRLF				
	cTexto+='                           Entrada no SAG.:'+str(nTotReg[7])+CRLF				
	cTexto+='                           Saidas  no SAG.:'+str(nTotReg[8])+CRLF				
	cTexto+=replicate('-',80)+CRLF
	pb_msg('Finalizado...',2)

	cArqLog:='C:\TEMP\IMP_XML_'+SONUMEROS(TIME())+'.TXT'
	MemoWrit(cArqLog,cTexto)
	Alert('Gerado Arquivo de Log de erros;'+cArqLog)
else
	Alert('Diretorio informado nao contem XML;'+cDirOrig)
end
return NIL
*----------------------------------------------------------------------------------------*
