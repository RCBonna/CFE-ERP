*-----------------------------------------------------------------------------*
static aVariav := {{},{},.F.}
//..................1.2..3..4..5..6..7..8..9.10.11.12.13.14 15 16 17,18,19,20,21
*-----------------------------------------------------------------------------*
#xtranslate aDetNF			=> aVariav\[  1 \]
#xtranslate aResumoImp		=> aVariav\[  2 \]
#xtranslate lProcSAG			=> aVariav\[  3 \]

*-----------------------------------------------------------------------------*
function LivrosG()	//	Livros Fiscais = Geracao
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local X      :=18
local Periodo:=Left(dtos(date()),6)
private DATA :={bom(date()),eom(date())}

pb_lin4(_MSG_,ProcName())
if !abre({		'R->PARAMETRO',;
					'R->CLIENTE',;
					'R->PROD',;
					'R->UNIDADE',;
					'R->NATOP',;
					'R->CTRNF',;
					'R->FISACOF',;
					'C->ENTCAB',;
					'C->ENTDET',;
					'C->PEDCAB',;
					'C->PEDDET',;
					'E->LIVROPA',;
					'E->LIVRO';
					})
	return NIL
end
lProcSAG:=.F.
if PARAMETRO->PA_CGC=='75815456000290'	// É Filial - SAG
	if file('..\SAG\SAGANFC.DBF').and.;	// Valida se os arquivos estão no diretório
		file('..\SAG\SAGANFD.DBF').and.;
		file('..\SAG\SAGANFC'+OrdBagExt()).and.;
		file('..\SAG\SAGANFD'+OrdBagExt())
		if !abre({	'E->NFC',;
						'E->NFD'})
			return NIL
		end
		lProcSAG:=.T.
	else
		alert('Processando arquivos da FILIAL;Arquivos faltantes;Entrar/Sair do SAG para recriar arquivos.')
		dbcloseall()
		return NIL
	end
end

select LIVROPA
if val(right(PL_PERIO,2))<12
	Periodo:=str(val(PL_PERIO)+1,6)
else
	Periodo:=str(val(PL_PERIO)+89,6)
end

pb_box(X++,30,,,,'Gerar Livros Fiscais')
 X++
@X++,32 say "Informe Periodo :" get Periodo pict mPER
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	DATA[1]:=ctod("01/"+right(Periodo,2)+"/"+left(Periodo,4))
	DATA[2]:=eom(DATA[1])
	select LIVRO
	ORDEM ID
	ZAP
	Pack
	LF_EntradasCFE(DATA) // Gera Dados Livros CFE - Entradas
	LF_SaidasCFE(DATA)	// Gera Dados Livros CFE - Saidas
	if lProcSAG
		LF_EntSaiSAG(DATA)// Gera Dados Livros SAG - (Entrada e Saida)
	end
	select LIVROPA
	replace  PL_PERIO with Periodo,;	// Ultimo periodo fechado
				PL_DATA  with	date()	// Data ultima geracado
end
dbcloseall()
return NIL

*-------------------------------------------------------------
	static function LF_EntradasCFE(DATA)
*-------------------------------------------------------------
local Linha
pb_msg('Gerando Informacoes de Entrada-CFE...')
select ENTCAB
ORDEM DTEDOC
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.dtos(ENTCAB->EC_DTEMI)<=dtos(DATA[2])
	@24,65 say ENTCAB->EC_DTEMI
	if NATOP->(dbseek(str(ENTCAB->EC_CODOP,7))).and.NATOP->NO_ILIVRO // CONSIDERAR NO LIVRO
		CLIENTE->(dbseek(str(ENTCAB->EC_CODFO,5)))
		aDetNF    :=RtEntrada() //.............Busca entradas -> spedc00f.prg
		aResumoImp:=ResumoImp(aDetNF)	//.......Resumir imposto para LF
		if len(aResumoImp)==0
			aadd(aResumoImp,{			NATOP->NO_CDVLFI,;//.................1-Tipo Operação Livro (1,2,3)
							left(str(	ENTCAB->EC_CODOP,7),5),;//...........2-Natureza só com 5 digitos -> Caractere
											ENTCAB->EC_ICMSP,;//.................3-% Icms
											ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS,;//.4-Vlr Contabil/Fiscal (2014)
											ENTCAB->EC_ICMSV,;//.................5-Vlr Icms
											ENTCAB->EC_ICMSB,;//.................6-Base Icms
											0,;//................................7-Isentas
											0;//.................................8-Outras
											})
		end
		for nX:=1 to len(aResumoImp)
			aadd_livro({'E',;					// 01-Tipo <E>ntrada> <S>aida>
							ENTCAB->EC_DTENT,;// 02-Dt Processamento do Documento
							ENTCAB->EC_TPDOC,;// 03-Especie
							ENTCAB->EC_SERIE,;// 04-Serie
							ENTCAB->EC_DOCTO,;// 05-Numero Docto
							ENTCAB->EC_DTEMI,;// 06-Dt Emissao do documento
							ENTCAB->EC_CODFO,;// 07-Emitente = Fornecedor
							CLIENTE->CL_UF,;//...08-UF-Emitente
							aResumoImp[nX,1],;// 09-Cod Contabil (LF=1,2,3,4)
							aResumoImp[nX,4],;// 10-Vlr Contabil/Fiscal
							aResumoImp[nX,2],;// 11-CFOP-Nat Operaçao = Caractere
							aResumoImp[nX,6],;// 12-ICMS=Base
							aResumoImp[nX,3],;// 13-ICMS=%
							aResumoImp[nX,5],;// 14-ICMS=Vlr
							aResumoImp[nX,7],;// 15-Vlr Isentas
							aResumoImp[nX,8],;// 16-Vlr Outras
							0,;					// 17-Vlr Outras-Ajustes (TP=AJU)
							0,;					// 17-IPI=Base
							0,;					// 18-IPI=%
							0,;					// 19-IPI=Vlr
							''})					// 20-Observacao
		next
	else
		Alert('CFOP '+str(ENTCAB->EC_CODOP,7)+' Nao cadastrado;Verifique NF:'+str(ENTCAB->EC_DOCTO,9)+'/'+ENTCAB->EC_SERIE)	
	end
	pb_brake()
end
return NIL

*-------------------------------------------------------------
	static function LF_SaidasCFE(DATA)
*-------------------------------------------------------------
local x1:=1,x2:=1,x3:=1,x4:=1,x5:=1
pb_msg('Gerando Informacoes de Saida-CFE...')
select PEDCAB
ORDEM DTENNF
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.dtos(PEDCAB->PC_DTEMI)<=dtos(DATA[2])
	@24,65 say dtos(PEDCAB->PC_DTEMI)
	if PEDCAB->PC_FLAG.and.!PEDCAB->PC_FLCAN //..................................NF liberada e não cancelada
		if NATOP->(dbseek(str(PEDCAB->PC_CODOP,7))).and.NATOP->NO_ILIVRO //.......CONSIDERAR NO LIVRO
			aDetNF    :=RtSaida() //...............................................Busca entradas -> spedc00f.prg
			aResumoImp:=ResumoImp(aDetNF)	//.......................................Resumir imposto para LF
			CLIENTE->(dbseek(str( PEDCAB->PC_CODCL,5)))
			if Len(aResumoImp)==0 //...............................................Sem itens da NF?
				aadd(aResumoImp,{	         NATOP->NO_CDVLFI,;//...........1-Tipo Operação Livro (1,2,3)
										Left(Str(PEDCAB->PC_CODOP,7),5),;//.....2-CFOP-Natureza só com 5 digitos -> Caractere
													PEDCAB->TR_PICMS,;//...........3-% Icms
										PEDCAB->PC_TOTAL-PEDCAB->PC_DESC,;//....4-Vlr Fiscal/Contabil
										PEDCAB->TR_VICMS,;//....................5-Vlr ICMS
										PEDCAB->TR_BICMS,;//....................6-Base ICMS Trib
										0,;//...................................7-Base ICMS Isentas
										0})//...................................8-Base ICMS Outras
			else
//				@24,75 say str(x5++,4)
			end
			for nX:=1 to len(aResumoImp)
				aadd_livro({'S',;					//.........................01-Tipo <E>ntrada> <S>aida>
								PEDCAB->PC_DTEMI,;//.........................02-Dt Processamento do Documento
								PEDCAB->PC_TPDOC,;//.........................03-Especie
								PEDCAB->PC_SERIE,;//.........................04-Serie
								PEDCAB->PC_NRNF,;	//.........................05-Numero Docto(NRNF)
								aDetNF[09],;//...............................06-Dt Saida do Material
								PEDCAB->PC_CODCL,;//.........................07-Emitente = Cliente
								CLIENTE->CL_UF,;	//.........................08-UF-Emitente
								aResumoImp[nX,1],;//.........................09-Cod Contabil (LF=1,2,3,4)
								aResumoImp[nX,4],;//.........................10-Vlr Contabil
								aResumoImp[nX,2],;//.........................11-CFOP-Nat Operaçao = Caractere
								aResumoImp[nX,6],;//.........................12-ICMS=Base
								aResumoImp[nX,3],;//.........................13-ICMS=%
								aResumoImp[nX,5],;//.........................14-ICMS=Vlr
								aResumoImp[nX,7],;//.........................15-Vlr Isentas
								aResumoImp[nX,8],;//.........................16-Vlr Outras
								0,;					//.........................17-Vlr Outras-Ajustes (TP=AJU)
								0,;					//.........................18-IPI=Base
								0,;					//.........................19-IPI=%
								0,;					//.........................20-IPI=Vlr
								''})					//.........................21-Observacao
			next
		else
			Alert('CFOP '+str(PEDCAB->PC_CODOP,7)+' Nao cadastrado;Verifique NF:'+str(PEDCAB->PC_NRNF,6)+'/'+PEDCAB->PC_SERIE)
		end
	end
	pb_brake()
end
return NIL

*-------------------------------------------------------------
  static function LF_EntSaiSAG(DATA)
*-------------------------------------------------------------
pb_msg('Gerando Informacoes de Entrada+Saida-SAG...')
select NFD
ORDEM CODIGO
select NFC
ORDEM DATA
DbGoTop()
dbseek(dtos(DATA[1]),.T.)
while !eof().and.dtos(NFC->NF_DTEMI)<=dtos(DATA[2])
	@24,65 say dtos(NFC->NF_DTEMI)
	if !NFC->NF_FLCAN //......................................................NF Cancelada?
		if NATOP->(dbseek(str(NFC->NF_CODOP,7))).and.NATOP->NO_ILIVRO //.......CONSIDERAR NO LIVRO
			aDetNF    :=RtSag() //..............................................Busca entradas -> spedc00f.prg
//			alert('SAG.Itens='+str(len(aDetNF[42]),3))
			aResumoImp:=ResumoImp(aDetNF)	//....................................Resumir imposto para LF
//			alert('SAG.Resum='+str(len(aResumoImp),3))
			CLIENTE->(str(NFC->NF_EMIT,5))
			for nX:=1 to len(aResumoImp)
				aadd_livro({NFC->NF_TIPO,;//......01-Tipo <Entrada> <Saida>
								NFC->NF_DTPRO,;//.....02-Dt Processamento do Documento
								NFC->NF_TPDOC,;//.....03-Especie
								NFC->NF_SERIE,;//.....04-Serie
								NFC->NF_NRNF,;//......05-Numero Docto
								NFC->NF_DTEMI,;//.....06-Dt Emissao do documento
								NFC->NF_EMIT,;//......07-Emitente
								CLIENTE->CL_UF,;//....08-UF-Emitente
								aResumoImp[nX,1],;//..09-Cod Contabil (LF=1,2,3,4)
								aResumoImp[nX,4],;//..10-Vlr Contabil
								aResumoImp[nX,2],;//..11-CFOP-Nat Operaçao = Caractere
								aResumoImp[nX,6],;//..12-ICMS=Base
								aResumoImp[nX,3],;//..13-ICMS=%
								aResumoImp[nX,5],;//..14-ICMS=Vlr
								aResumoImp[nX,7],;//..15-Vlr Isentas
								aResumoImp[nX,8],;//..16-Vlr Outras
								0,;					//..17-Vlr Outras-Ajustes (TP=AJU)
								0,;					//..18-IPI=Base
								0,;					//..19-IPI=%
								0,;					//..20-IPI=Vlr
								''})					//..21-Observacao
			next
		else
			Alert('CFOP '+str(NFC->NF_CODOP,7)+' Nao cadastrado;Verifique NF:'+str(NFC->NF_NRNF,9)+'/'+NFC->NF_SERIE)
		end
	end
	pb_brake()
end
return NIL

*-------------------------------------------------------------
	static function ResumoImp (paNF)
*-------------------------------------------------------------
XX1:=1
aResumoImp:={}
for nZ:=1 TO len(paNF[42])
	@23,76 say str(XX1++,4)
	nY:=0
	for nX:=1 to Len(aResumoImp)
		if     aResumoImp[nX,1]      ==          paNF[42,nZ,52].and.;//........1-Tipo de Opoeração 1,2,3,4
			    aResumoImp[nX,2]      == Left(Str(paNF[42,nZ,09],7),5).and.;//..2-CFOP					
			Str(aResumoImp[nX,3],9,2) ==      Str(paNF[42,nZ,11],9,2)//.........3-% ICMS
			nY:=nX
			nX:=1000 // Sair do resumo
		end
	next nX
	if nY==0//.................................................Não encontrado - criar um novo
		aadd(aResumoImp,{	         paNF[42,nZ,52],;//.........1-Tipo Operação Livro (1,2,3,4)
								Left(str(paNF[42,nZ,09],7),5),;//...2-CFOP-Natureza só com 5 digitos -> Caractere
											paNF[42,nZ,11],;//.........3-% Icms
								0,;//...............................4-Vlr Fiscal/Contabil
								0,;//...............................5-Vlr ICMS
								0,;//...............................6-Base ICMS Trib
								0,;//...............................7-Base ICMS Isentas
								0})//...............................8-Base ICMS Outras
		nY:=len(aResumoImp)
	end
	aResumoImp[nY,4]+=paNF[42,nZ,06]//.......................4-Vlr Fiscal/Contabil
	aResumoImp[nY,5]+=paNF[42,nZ,12]//.......................5-Vlr ICMS
	aResumoImp[nY,6]+=paNF[42,nZ,10]//.......................6-Base ICMS Trib
	aResumoImp[nY,7]+=paNF[42,nZ,50]//.......................7-Base ICMS Isentas
	aResumoImp[nY,7]+=paNF[42,nZ,51]//.......................8-Base ICMS Outras
next nZ
return aResumoImp

*-------------------------------------------------------------
	static function Aadd_Livro(P1)
*-------------------------------------------------------------
SALVABANCO
select LIVRO
RT:=AddRec(,P1)
RESTAURABANCO
return RT
*------------------------------------EOF----------------------
