*-----------------------------------------------------------------------------*
 static aVariav := {'N','',.T.,0,''}
 //.................1....2..3..4..5
*-----------------------------------------------------------------------------*
#xtranslate lNFS    => aVariav\[  1 \]
#xtranslate cArq    => aVariav\[  2 \]
#xtranslate lRT     => aVariav\[  3 \]
#xtranslate nX      => aVariav\[  4 \]
#xtranslate cRT     => aVariav\[  5 \]

*----------------------------------------------------------------------------
  function GDFPPREP(pGDF)	// GERAR DADOS PARA SECRET FAZENDA
*----------------------------------------------------------------------------
#include 'RCB.CH'
*-------------------------------------------------------------------- Movimento
local   ArqParam :='GDF_PARA.ARR'
private CGC  :=''
private CHAVE:='421?'
private ARQS :='GDFXXLIB.RCB'

pb_lin4(_MSG_,ProcName())
if pGDF#NIL.and.pGDF=='SAG'
	alert('Nao executar geracao de dados via SAG;Execute via CFE')
end
gdfpinic()
if !abre({	'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PROD',;
				'R->NATOP',;
				'C->CTRNF',;
				'E->GDFBASE';
			})				
	return NIL
end
if file(ArqParam)
//		ALERT('ARQUIVO RESTAURADO = '+ArqParam)
	V_GDF:=RestArray(ArqParam)
else
	V_GDF:={	padr(VM_EMPR,35),;
				space(28),;
				BOM(BOM(PARAMETRO->PA_DATA)-1),;
				BOM(PARAMETRO->PA_DATA)-1;
				}
end

	VM_NOMEE:=V_GDF[1]
	CONTATO :=V_GDF[2]
	DATA    :={V_GDF[3],V_GDF[4]}

CGC  :=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),15)
CHAVE+=CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE+CHAVE

pb_box(16,18,,,,'Processar-GDF-Periodo')
@17,20 say 'Empresa.............:' get VM_NOMEE pict mUUU
@19,20 say 'Processar NFServicos?' get lNFS     pict mUUU valid lNFS$'SN' when pb_msg('<S>im ou <N>ao -> Incluir NF de Servicos')
@20,20 say 'Data INICIAL........:' get Data[1]  pict mDT
@21,20 say 'Data FINAL..........:' get Data[2]  pict mDT valid Data[2]>Data[1]
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	if !abre({	;
					'R->CFEACFC',;
					'R->CFEACFD',;
					'R->PEDCAB',;
					'R->PEDDET',;
					'R->ENTCAB',;
					'R->ENTDET';
				})
		dbcloseall()
		return NIL
	else
		V_GDF[1]:=VM_NOMEE
		V_GDF[3]:=DATA[1]
		V_GDF[4]:=DATA[2]

		SaveArray(V_GDF,ArqParam)

		select PROD
		ORDEM CODIGO

		GDFPCFEE(lNFS,1)	// PROCESSAR NF-ENTRADA CFE NORMAL
		GDFPCFES(lNFS,1)	// PROCESSAR NF-SAIDA CFE NORMAL
		GDFPCFRE(lNFS,1)	// Processar NF-Frete
		
		select PEDCAB
		close
		select PEDDET
		close
		select ENTCAB
		close
		select ENTDET
		close
		select CFEACFC
		close
		select CFEACFD
		close
		
	end
	if file('..\SAG\SAGANFC.DBF').and.;
		file('..\SAG\SAGANFD.DBF')
		if file('..\SAG\SAGANFC.NSX').and.;
			file('..\SAG\SAGANFD.NSX')
			if !abre({	;
							'R->NFD',;
							'R->NFC';
							})
				dbcloseall()
				return NIL
			else
				select NFD
				ORDEM CODIGO
				select PROD
				ORDEM CODIGO
				GDFPSAG(lNFS)	// Processar - SAG
			end
		else
			alert('SAG;Nao encontrado arquivos de indices;deve-se entrar no sag para regerar')
		end
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
  function GRAVADVS(P1)	// INTEGRA SAIDAS - REF/CFE
*-----------------------------------------------------------------------------*
salvabd(SALVA)
select('GDFBASE')
AddRec()
for nX:=1 to len(P1)
	GDFBASE->(fieldput(nX,P1[nX]))
next nX
salvabd(RESTAURA)
return NIL

*-----------------------------------------------------------------------------*
  static function GDFPINIC()
*-----------------------------------------------------------------------------*
lRT :=.T.
cARQ:='GDFBAS'
ferase(cARQ+'.DBF')
ferase(cARQ+ordbagext())
if dbatual(cARQ,{;
						{'BD_EMPRESA'	,'N', 3, 0},;	//01-Código da Empresa
						{'BD_TIPO'		,'N', 2, 0},; // 02-Tipo Registro 50/54/61/70/71
						{'BD_DATA'		,'D', 8, 0},; // 03-DT Emissao 50/54/61/70/71
						{'BD_CGC'		,'C',14, 0},; // 04-50/54/70
						{'BD_INSCR'		,'C',14, 0},; // 05-50/54/70
						{'BD_UF'			,'C', 2, 0},; // 06-50/54/70
						{'BD_MODELO'	,'C', 2, 0},; // 07-50/54/61/70
						{'BD_SERIE'		,'C', 3, 0},; // 08-050/54/61/70
						{'BD_SUBSERI'	,'C', 2, 0},; // 09-50/54/61/70
						{'BD_NRNF'		,'N', 6, 0},; // 10-50/54/61/70
						{'BD_CFOP'		,'N', 4, 0},; // 11-50/70
						{'BD_VLRTOT'	,'N',13, 2},; // 12-50/61/70
						{'BD_BICMS'		,'N',13, 2},; // 13-50/70
						{'BD_VICMS'		,'N',13, 2},; // 14-50/70
						{'BD_ISENTR'	,'N',13, 2},; // 15-50/70 ISENTAS OU NAO TRIBUTADAS
						{'BD_OUTRAS'	,'N',13, 2},;	//	16-50/70 VLR NAO CONFIRA DEB/CRE ICMS
						{'BD_AICMS'		,'N', 6, 2},;	//	17-50/   VLR NAO CONFIRA DEB/CRE ICMS
						{'BD_SITUA'		,'C', 1, 0},;	//	18-50/70 SITUACAO CANCELADA S=SIM N=NAO
						{'BD_MODO'		,'N', 1, 0},;	//	19-70 1=CIF  2=FOB
						{'BD_ITEM'		,'N', 3, 0},;	//	20-54 seq na NF
						{'BD_CODPROD'	,'N',14, 0},;	//	21-54 cod produto
						{'BD_SITTRIB'	,'C', 3, 0},;	//	22-54 Sit Tributaria
						{'BD_UNIMED'	,'C', 6, 0},;	//	23-54 unidade
						{'BD_QTDADE'	,'N',13, 3},;	//	24-54 Qtdade
						{'BD_VLRIPI'	,'N',13, 2},;	//	25-54 Vlr IPI
						{'BD_STATU'		,'C', 1, 0},;	//	26-G=GERADO I=INCLUIDO A=ALTERADO
						{'BD_DESPROD'	,'C',53, 0},;	//	27-70/DESCRICAO DO PRODUTO
						{'BD_DESCONT'	,'N',13, 2},;	//	28-54/Vlr DESCONTO
						{'BD_TPEMIT'	,'C', 1, 0},;	//	29-50-TipoEmitente NF (Próprio/Terceiro)
						{'BD_CGCT'		,'C',14, 0},;	// 30-71-CGC-Tomador Do Conhecimento de Frete
						{'BD_INSCRT'	,'C',14, 0},;	// 31-71-IE-Tomador Do Conhecimento de Frete
						{'BD_UFT'		,'C', 2, 0},;	// 32-71-UF-Tomador Do Conhecimento de Frete
						{'BD_NRNFCF'	,'N', 6, 0},;	// 33-71-Número NF-Levada no conhecimento de Frete
						{'BD_SERIECF'	,'C', 3, 0},;	// 34-71-Série NF-Levada no conhecimento de Frete
						{'BD_VLRCF'		,'N',14, 2}},; // 35-71-Valor NF-Levada no conhecimento de Frete
						RDDSETDEFAULT())
end
pb_msg('Organizando BASE DE DADOS GDF',NIL,.F.)
if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
	PACK
	Index on str(BD_EMPRESA,3)+str(BD_TIPO,2)+dtos(BD_DATA)													tag GERAR to (cARQ)
	Index on str(BD_EMPRESA,3)+str(BD_TIPO,2)+dtos(BD_DATA)+BD_CGC+str(BD_NRNF,6)+str(BD_ITEM,2)	tag REG50 to (cARQ) FOR BD_TIPO==50
	Index on str(BD_EMPRESA,3)+str(BD_TIPO,2)+dtos(BD_DATA)+BD_CGC+str(BD_NRNF,6)+str(BD_ITEM,2)	tag REG54 to (cARQ) FOR BD_TIPO==54
	Index on str(BD_EMPRESA,3)+str(BD_TIPO,2)+dtos(BD_DATA)+str(BD_NRNF,6)+str(BD_ITEM,2)			tag REG61 to (cARQ) FOR BD_TIPO==61
	Index on str(BD_EMPRESA,3)+str(BD_TIPO,2)+dtos(BD_DATA)+str(BD_NRNF,6)+str(BD_ITEM,2)			tag REG70 to (cARQ) FOR BD_TIPO==70
	Index on str(BD_EMPRESA,3)+str(BD_TIPO,2)+dtos(BD_DATA)+str(BD_NRNF,6)+str(BD_ITEM,2)			tag REG71 to (cARQ) FOR BD_TIPO==71
	Index on str(BD_EMPRESA,3)+str(BD_CODPROD,14)																tag REG75 to (cARQ) FOR BD_TIPO==75
else
	lRT:=.F.
end
close
//--------------------------------------
cARQ:='GDF60S'
if dbatual(cARQ,{;
					 {'G6_EMPRESA'	,'N', 3, 0},;	//01-
					 {'G6_TIPO'		,'N', 2, 0},; // 02-60/M/A
					 {'G6_TIPOAM'	,'C', 1, 0},; // 03-M/A
					 {'G6_DATA'		,'D', 8, 0},; // 04-60-data emissao
					 {'G6_NRCXA'	,'N', 3, 0},; // 05-numero interno da máquina
					 {'G6_NRSERIE'	,'C',15, 0},; // 06-numero de série da máquina
					 {'G6_MODELO'	,'C', 2, 0},; // 07-Modelo 2D
					 {'G6_NRCUPIN'	,'N', 6, 0},; // 08-Numero inicial do cupon do dia
					 {'G6_NRCUPFI'	,'N', 6, 0},; // 09-Numero final   do cupon do dia
					 {'G6_CONTZ'	,'N', 6, 0},; // 10-Numero de contagens de redução Z
					 {'G6_VLRTOTI'	,'N',16, 2},; // 11-Total / grande total inicio dia
					 {'G6_VLRTOTF'	,'N',16, 2},; // 12-Total / grande total fim    dia
					 {'G6_VLRACMT'	,'N',16, 2},; // 13-Vlr Acumulado Totalizador PArcial
					 {'G6_SITRIB'	,'C', 4, 0}},;// 14-SITUACAO TRIBUTARIA 1700.../F/I/N/CANC/DESC/ISS
					 RDDSETDEFAULT())
	ferase(cARQ+ordbagext())
end
if !file(cARQ+ordbagext())
	pb_msg('Organizando GDF/CF/60',NIL,.F.)
	if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
		PACK
		Index on str(G6_EMPRESA,3)+str(G6_TIPO,2)+descend(G6_TIPOAM)+str(G6_NRCXA,3)+dtos(G6_DATA)	tag GERAR to (cARQ)
	else
		lRT:=.F.
	end
	close
end
return lRT

*----------------------------------------------------------
  static function GdfLibera(CGC)
*----------------------------------------------------------
lRT:=.F.
if !file(ARQS)
	alert('PARA LIBERACAO GDF;Solicite chave de parametros;Informando o CNPJ')
	lRT:=.F.
ELSE
	lRT:=.T.
END
return lRT

*-----------------------------------------------------------------------------------------------
  function VERSERIE(pCodSerie,pNrDoc) // Retorna Modelo de uma Série - relativo a um documento
*-----------------------------------------------------------------------------------------------
cRT:='00'
salvabd(SALVA)
select CTRNF
if dbseek(pCodSerie)
	cRT:=NF_MODELO
else
	alert('ATENCAO;Docto:'+str(pNrDoc,8)+' Serie ['+pCodSerie+'] nao encontrada;Feito Cadastro Provisorio')
	if AddRec()
		replace 	NF_TIPO   with pCodSerie,;
					NF_DESC   with 'REVER SERIE',;
					NF_MODELO with '00'
		cRT:=NF_MODELO
	end
end
salvabd(RESTAURA)
return cRT

*-----------------------------------------------------------------------------------------------
  function GRFPROD(vEMP)
*-----------------------------------------------------------------------------------------------
salvabd(SALVA)
select GDFBASE
nX:=indexord()
ORDEM REG75
if !dbseek(str(vEMP,3)+str(PROD->PR_CODPR,14))
	gravaDVS({vEMP,;				//  1-Empresa
				75,;					//  2-PRODUTO
				DATA[1],;			//  3-Data Emissao
				'',;					//  4-CGC Cliente
				'',;					//  5-INSCR Cliente
				'',;					//  6-UF DO Cliente
				'00',;				//  7-Modelo
				'',;					//  8-Serie NF
				'',;					//  9-Subserie
				0,;					// 10-NR NOTA FISCAL
				0,;					// 11-NAT OPERACAO
				0,;					// 12-TOTAL NF/ALIQUOTA
				0,;					//	13-BASE ICMS
				if(PROD->PR_PTRIB>0.00,100-PROD->PR_PTRIB,0),;// 14-VLR ICMS --> PERCENTUAL TRIBUTARIO
				0,;					// 15-VLR ISENTAS
				0,;					// 16-VLR OUTRAS
				PROD->PR_PICMS,;	// 17-% ICMS
				'',;					// 18-SITUACAO DA NF
				0,;					// 19-MODO CIF
				0,;					// 20-ITEM NF
				PROD->PR_CODPR,;	// 21-COD PROD
				PROD->PR_CODTR,;	// 22-SIT TRIB - Saida
				PROD->PR_UND,;		// 23-UNIDADE
				0,;					// 24-QTDADE
				PROD->PR_PIPI,;	// 25-VLR IPI
				'G',;					// 26-registro Gerado
				trim(PROD->PR_DESCR)+' '+PROD->PR_COMPL,; //..27-Descricao Produto
				0,;					// 28-Desconto
				''})					// 29-Tipo Emitente <T> ou <P>
end
dbsetorder(nX)
salvabd(RESTAURA)
return NIL
*-----------------------------------------------------------------------------------------------EOF

/*
*-----------------------------------------------------------
 static function GdfLibera(CGC)
*-----------------------------------------------------------
local NRT:=GdfCripto({.F.,date(),date(),CGC})
local RT:=.F.
if NRT>=6
	alert('PARA LIBERACAO GDF;Solicite chave de parametros;Informando o CNPJ')
	if GDFLiberaIn(CGC)==0
		RT:=.T.
	end
elseif NRT#0 
	alert('CHAVE de liberacao nao reconhecida')
	ferase(ARQS)
elseif NRT==0 
	RT:=.T.
end
return RT

//----------------------------------------------------------
  static function GDFLIBERAIN(ARQ)
//----------------------------------------------------------
local RT     :=1
local TF     :=savescreen()
local AUTORIZ:=space(50)
local NHAND  :=0
pb_box(5,0,21,79)
@11,2 say 'Confira seu CNPJ: ' + CGC
@13,2 say 'Cod.Autorizacao.:' get AUTORIZ pict mXXX
read
if lastkey()#K_ESC
	ALERT('LEN='+STR(len(AllTrim(AUTORIZ))))
	if len(AllTrim(AUTORIZ))==40
		if (RT:=GDFChkString(AllTrim(AUTORIZ),CHAVE,CGC))==0
			NHAND:=FCREATE(ARQS)
			FWRITE(NHAND,AllTrim(AUTORIZ))
			FCLOSE(NHAND)
		end
	end
end
restscreen(5,0,21,79,TF)
return RT

static function GDFCripto(P1)
//-------------------------1=LOGICO
//-------------------------2=DT1
//-------------------------3=DT2
//-------------------------4=CGC
local X    :={0,0}
local P2K  :=''
local P2   :=''
local RT   :=1
if P1[1] // CRIPTOGRAFA
	P2:=dtos(P1[2])+'?'+dtos(P1[3])+'?'+P1[4]+'?'
// ..........8.......1.......8.......1..15.....1......6  = 32+6
// ..........8.......9......17......18..32....33
	for X[1]:=1 to len(P2)
		X[2]+=asc(substr(P2,X[1],1)) // SOMATORIO
	next
	P2 +=pb_zer(X[2],6)
	for X[1]:=1 to len(P2)
		P2K+=chr(asc(substr(P2,X[1],1))+asc(substr(CHAVE,X[1],1)))
	next
	NHAND:=FCREATE(ARQS)
	FWRITE(NHAND,P2K)
	FCLOSE(NHAND)
	RT:=0
else // LER E CONFERIR
	if file(ARQS)
		NHAND:=FOPEN(ARQS)
		if ferror()==0
			X[1]:=40
			P2:=space(X[1])
			if FREAD(NHAND,@P2,X[1]) == X[1]
				RT:=GDFChkString(P2,CHAVE)
			else
				Alert('Error(Read)')
				RT:=5
			end	
			FCLOSE(NHAND)
		else
			alert('Error(Open)')
			RT:=6
		end
	else
		alert('Error(Existar)')
		RT:=7
	end
end
return RT

*----------------------------------------------------------------------------
 static function GDFChkString(P2,CHAVE,CGC)
*----------------------------------------------------------------------------
local RT :=1
local X  :={0,0}
local P2K:=''
for X[1]:=1 to len(P2)
	P2K+=chr(asc(substr(P2,X[1],1))-asc(substr(CHAVE,X[1],1)))
	if X[1]<35
		X[2]+=asc(substr(P2K,X[1],1)) // SOMATORIO
	end
next
if pb_zer(X[2],6)==substr(P2K,35,6)
	//--------------------------------------->
	if CGC==substr(P2K,19,15)
		if 	dtos(date())>=substr(P2K,01,08).and.;
			dtos(date())<=substr(P2K,10,08)
			RT:=0
		else
			alert('Error(dt)')
			RT:=2
		end
	else
		Alert('Error(Cgc)')
		RT:=3
	end
else
	alert('Error(chksun)')
	RT:=4
end
return RT
*/