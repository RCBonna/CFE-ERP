*-----------------------------------------------------------------------------*
  static aVariav := {0,2000,{},{} ,0,{}, 1,'','',.F.,{},.F.,{}}
*...................1....2..3..4..5..6..7..8..9, 10,11, 12, 13,14,15
*-----------------------------------------------------------------------------*
#xtranslate nX         => aVariav\[  1 \]
#xtranslate nANO       => aVariav\[  2 \]
#xtranslate cARQ       => aVariav\[  3 \]
#xtranslate aGera      => aVariav\[  4 \]
#xtranslate nSaldo     => aVariav\[  5 \]
#xtranslate oNFE		  => aVariav\[  6 \]
#xtranslate CodEmpr	  => aVariav\[  7 \]
#xtranslate nRegistro  => aVariav\[  8 \]
#xtranslate cConteudo  => aVariav\[  9 \]
#xtranslate lGerarArq  => aVariav\[ 10 \]
#xtranslate aANO       => aVariav\[ 11 \]
#xtranslate lProcSAG   => aVariav\[ 12 \]
#xtranslate aPeriodo   => aVariav\[ 13 \]

#include 'RCB.CH'

//-----------------------------------------------------------------------------*
  function FISATO15()	//	Gerar Arquivo do Ato Declaratorio Executivo Nr.5
//-----------------------------------------------------------------------------*

pb_tela()
pb_lin4("Gerar Arq.Ato Declar.Nr.15",ProcName())
SPEDINIC()
if !abre({	'R->PARAMCTB'	,;
				'R->PARAMETRO'	,;
				'R->CTADET'		,;
				'R->RAZAO'		,;
				'R->DPFOR'		,;
				'R->HISFOR'		,;
				'R->DPCLI'		,;
				'R->HISCLI'		,;
				'R->CODTR'		,;
				'R->CTRNF'		,;
				'R->NATOP'		,;
				'R->ALIQUOTAS'	,;
				'R->ENTCAB'		,;
				'R->ENTDET'		,;
				'R->PEDCAB'		,;
				'R->PEDDET'		,;
				'R->PEDSVC'		,;
				'R->SALDOS'		,;
				'R->CLIENTE'	,;
				'R->ATIVIDAD'	,;
				'R->GRUPOS'		,;
				'R->FISACOF'	,;
				'R->UNIDADE'	,;
				'R->PEDPARC'	,;
				'E->SPEDBAS'	,;
				'R->PROD'})
	return NIL
end
CodEmpr	:=1 // MatriZ
lProcSAG:=.F.
if file('..\SAG\SAGANFC.DBF').and.;
	file('..\SAG\SAGANFD.DBF')
	if file('..\SAG\SAGANFC'+OrdBagExt()).and.;
		file('..\SAG\SAGANFD'+OrdBagExt())
		if !abre({	;
						'R->NFD',;
						'R->NFC';
						})
			alert('SAG;Arquivos do SAG em uso; nao puderam ser abertos.')
			dbcloseall()
			return NIL
		else
			select NFD
			ORDEM CODIGO // MANTER ESTE INDICE SELECIONADO PARA DETALHES DA NF SAG
			lProcSAG:=.T.
			CodEmpr	:=2 // Filial
		end
	else
		alert('SAG;Nao encontrado arquivos de indices;deve-se entrar no sag para regerar')
		dbcloseall()
		return NIL
	end
end

	SELECT PROD
	ORDEM CODIGO // MANTER ESTE INDICE SELECIONADO PARA DETALHES DA NF
	
	SELECT SPEDBAS
	GO TOP
	zap
	pack

nX			:=12
nANO		:=PARAMCTB->PA_ANO
aArq     :={'',''}
lGerarArq:=.F.
aGera:={'S','S','S','S','S','S'}
//.......1...2...3...4...5...6
aPeriodo:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
pb_box(nX++,01,21,78,,'Selecao')
 nX++
@nX++,22 say 'Data Inicial....:'                 get aPeriodo[1]     pict mDT when pb_msg('Deve ser dados do mesmo Mes/Ano')
@nX++,22 say 'Data Final......:'                 get aPeriodo[2]     pict mDT  valid year(aPeriodo[1])==year(aPeriodo[2]).and.month(aPeriodo[1])==month(aPeriodo[2])
@nX++,22 say 'Matriz/Filial..: '+if(CodEmpr==1,'Matriz','Filial')
 nX++
@nX++,22 say 'Gerar Arquivo ATO DECLARATORIO 25..:' get aGera[1] pict mUUU valid aGera[1]$'SN'
READ
if iif(lastkey()#K_ESC,pb_sn(),.F.)
	if aGera[1]=='S' // NF Entradas Saidas (Emitidas)
		lGerarArq:=NF431(CodEmpr) // NF Ent/Sai => Emitidas
	end
end
	DirMake('C:\TEMP\ATO15')
	aArq[1]:='C:\TEMP\ATO15\'+str(nANO,4)+if(CodEmpr==1,'M','F')
	DirMake(aArq[1])
	pb_msg('Gerando arquivos ATO DECARATORIO 25')

	SELECT SPEDBAS
	GO TOP
	nRegistro:=''
	aArq[2]  :=''
	while !eof()
		if nRegistro<>left(SC_CHAVE,4)
			nRegistro:=left(SC_CHAVE,4)
			aArq[2]:=aArq[1] + '\' + nRegistro +'_'+pb_zer(month(aPeriodo[1]),2) + '.TXT'
			if !pb_ligaimp(,aArq[2],'Geracao ATO DECARATORIO '+aArq[2])
				DbGoBottom()
				DbSkip()
			end
		end
		while !eof().and.left(SC_CHAVE,4)==nRegistro
			if nRegistro=='431X'
				nTam=427+13
			elseif nRegistro=='432X'
				nTam=302
			elseif nRegistro=='433X'
				nTam=317+13
			elseif nRegistro=='434X'
				nTam=315
			elseif nRegistro=='491X'
				nTam=257+7
			elseif nRegistro=='494X'
				nTam=15+44
			elseif nRegistro=='495X'
				nTam=29+44
			elseif nRegistro=='4A1X'
				nTam=116+7
			elseif nRegistro=='4A2X'
				nTam=114+7
			elseif nRegistro=='4A4X'
				nTam=218+7
			elseif nRegistro=='4A5X'
				nTam=232+7
			elseif nRegistro=='4A6X'
				nTam=230+7
			end
			??padr(SC_CONTEUD,nTam)
			?
			DbSkip()
		end	
		pb_deslimp(,,.F.)
	end
	dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
static function NF431(pEmpresa)
*-----------------------------------------------------------------------------*
*==============================ENTRADA=ENTRADA=ENTRADA=ENTRADA=ENTRADA=ENTRADA
select ENTCAB
ORDEM DTEDOC
DbGoTop()
dbseek(dtos(aPeriodo[1]),.T.)
nX:=1
while !eof().and.dtos(ENTCAB->EC_DTENT)<=dtos(aPeriodo[2])
	pb_msg('REG431/NF-Entrada/CFE: '+dtoc(ENTCAB->EC_DTENT)+ ' Doc:'+str(ENTCAB->EC_DOCTO,9))
	CLIENTE->(	dbseek(str(ENTCAB->EC_CODFO,5)))
	NATOP->(		dbseek(str(ENTCAB->EC_CODOP,7)))
	oNFE:=RtEntrada() 									// Montar objeto NF Entradas
	NF431G(pEmpresa,'E')	// PROCESSAR AS DUAS ENTRADAS (PROPRIAS E DE TERCEIROS)
	skip
end

if lProcSAG // É filial = SAG = ENTRADA=ENTRADA=ENTRADA
	select NFC
	ORDEM DATA
	DbGoTop()
	dbseek(dtos(aPeriodo[1]),.T.)
	while !eof().and.dtos(NFC->NF_DTEMI)<=dtos(aPeriodo[2])
		if NFC->NF_TIPO=='E' // somente entradas
			pb_msg('REG431/NF-Entradas/SAG: '+dtoc(NFC->NF_DTEMI)+' DOC: '+NFC->NF_TIPO+'-'+NFC->NF_SERIE+'-'+str(NFC->NF_NRNF,6))
			NATOP->(dbseek(str(NFC->NF_CODOP,7)))
			CLIENTE->(dbseek(str(NFC->NF_EMIT,5)))
			oNFE:=RtSAG() // Busca dados da NF e seus detalhes	NO SAG
			NF431G(pEmpresa,'E')
			DbUnlockAll()
		end
		skip
	end
end

*==============================SAIDA=SAIDA=SAIDA=SAIDA=SAIDA=SAIDA=SAIDA=SAIDA
select CLIENTE
ORDEM CODIGO
select PEDCAB
ORDEM DTENNF
DbGoTop()
dbseek(dtos(aPeriodo[1]),.T.)
while !eof().and.dtos(PC_DTEMI)<=dtos(aPeriodo[2])
	if PEDCAB->PC_FLAG //..................................nf impressa ?
		pb_msg('REG431/NF SAIDA/CFE: '+dtoc(PEDCAB->PC_DTEMI)+' NF '+str(PEDCAB->PC_NRNF,6))
		CLIENTE->(	dbseek(str(PEDCAB->PC_CODCL,5)))
		NATOP->(		dbseek(str(PEDCAB->PC_CODOP,7)))
		oNFE:=RtSaida() // Busca dados da NF e seus detalhes	NO CFE
		NF431G(pEmpresa,'S')
		DbUnlockAll()
	end
	skip
end

if lProcSAG // É filial = SAG = ENTRADA=ENTRADA=ENTRADA
	select NFC
	ORDEM DATA
	DbGoTop()
	dbseek(dtos(aPeriodo[1]),.T.)
	while !eof().and.dtos(NFC->NF_DTEMI)<=dtos(aPeriodo[2])
		if NFC->NF_TIPO=='S' // somente entradas
			pb_msg('REG431/NF-Saida/SAG: '+dtoc(NFC->NF_DTEMI)+' DOC: '+NFC->NF_TIPO+'-'+NFC->NF_SERIE+'-'+str(NFC->NF_NRNF,6))
			NATOP->(dbseek(str(NFC->NF_CODOP,7)))
			CLIENTE->(dbseek(str(NFC->NF_EMIT,5)))
			oNFE:=RtSAG() // Busca dados da NF e seus detalhes	NO SAG
			NF431G(pEmpresa,'S')
			DbUnlockAll()
		end
		skip
	end
end
return .T.

*------------------------------------------------------------------------------------------------------------*
static function NF431G(pEmpresa,pTipoMov) // GERAR REGISTRO ENTRADA CONFORME LAYOUT (NF TERCEIROS OU PRÓPRIAS)
*-------------------------------------------------------------------------------------------------------------*
if oNFE[02]=='0'//.................................1-NOTA DE ENTRADA/SAIDA EMISSAO PRÓPRIA
	cRegistro:='431X'	//...................1-NOTA DE ENTRADA/SAIDA EMISSAO PRÓPRIA - (+pTipoMov)
	cConteudo:=pTipoMov									//...................01-Tipo <E>ntrada/<S>aida
	cConteudo+=					  oNFE[06]				//...................02-Tipo Documento
	cConteudo+=padr          (oNFE[05],5)			//...................03-Serie + Subserie
	cConteudo+=pb_zer        (oNFE[04],9)			//...................04-NR+NF
	cConteudo+=SONUMEROS(dtoc(oNFE[08]))			//...................05-DT Emissao
	cConteudo+=pb_zer        (oNFE[03],14)			//...................06-Cod Participante
	cConteudo+=SONUMEROS(dtoc(oNFE[09]))			//...................07-DT Entrada
	cConteudo+=pb_zer        (oNFE[14]*100,17)	//...................08-Vlr Mercadorias
	cConteudo+=pb_zer        (oNFE[12]*100,17)	//...................09-Vlr Desconto
	cConteudo+=pb_zer        (oNFE[16]*100,17)	//...................10-Vlr Frete
	cConteudo+=pb_zer        (oNFE[17]*100,17)	//...................11-Vlr Seguro
	cConteudo+=pb_zer        (oNFE[18]*100,17)	//...................12-Outras Despesas/Acessórias
	cConteudo+=pb_zer        (oNFE[23]*100,17)	//...................13-VLR IPI
	cConteudo+=pb_zer        (oNFE[22]*100,17)	//...................14-VLR ICMS Substituição Tributária
	cConteudo+=pb_zer        (oNFE[10]*100,17)	//...................15-VLR nf Total
	cConteudo+=space(14)									//...................16-Inscrição Estadual do Substituto Tributário
	cConteudo+=padr('Rodoviario',15)					//...................17-Via de Transporte
	cConteudo+=space(14)									//...................18-Cod Transportador
	cConteudo+=pb_zer        (oNFE[40][15],17)	//...................19-Quantidade Embalagens (inteiro)
	cConteudo+=padr          (oNFE[40][16],10)	//...................20-Especie
	cConteudo+=pb_zer        (oNFE[40][17]*1000,17)//.................21-Peso Bruto 3 Casas Decimais
	cConteudo+=pb_zer        (oNFE[40][18]*1000,17)//.................22-Peso Liq   3 Casas Decimais
	cConteudo+=if(oNFE[40,19]==1,'CIF','FOB')		//...................23-Tipo Frete CIF/FOB
	cConteudo+=padr          (oNFE[40][20],15)	//...................24-Identificação Veiculo
	cConteudo+=if(oNFE[32],'S','N')					//...................25-
	cConteudo+=if(oNFE[11]>0,'2','1')				//...................26-1-Vista 2-Prazo
	cConteudo+=padr          (oNFE[33],45)			//...................27-Observação
	cConteudo+=space(50)									//..28-Ato Declaratório
	cConteudo+=space(02)									//...................29-Modelo do Documento Referenciado
	cConteudo+=space(05)									//...................30-Série/Subsérie do Documento Referenciado
	cConteudo+=pb_zer(0,9)								//...................31-Número do Documento Referenciado
	cConteudo+=pb_zer(0,8)								//...................32-Data de Emissão do Documento Referenciado
	cConteudo+=space(14)									//...................33-Código do Participante do Documento Referenciado

else //.........................................1-NF ENTRADA EMITIDA POR TERCEIROS
	cRegistro:='433X' //.................1-NF ENTRADA/SAIDA EMITIDA POR TERCEIROS (+pTipoMov)
	cConteudo:=					  oNFE[06]				//...................01-Modelo do Documento
	cConteudo+=padr          (oNFE[05],5)			//...................02-Serie + Subserie
	cConteudo+=pb_zer        (oNFE[04],9)			//...................03-NR NF
	cConteudo+=SONUMEROS(dtoc(oNFE[08]))			//...................04-DT Emissao
	cConteudo+=pb_zer        (oNFE[03],14)			//...................05-Cod Participante
	cConteudo+=SONUMEROS(dtoc(oNFE[09]))			//...................06-DT Entrada
	cConteudo+=pb_zer        (oNFE[14]*100,17)	//...................07-Vlr Mercadorias
	cConteudo+=pb_zer        (oNFE[12]*100,17)	//...................08-Vlr Desconto
	cConteudo+=pb_zer        (oNFE[16]*100,17)	//...................09-Vlr Frete
	cConteudo+=pb_zer        (oNFE[17]*100,17)	//...................10-Vlr Seguro
	cConteudo+=pb_zer        (oNFE[18]*100,17)	//...................11-Outras Despesas/Acessórias
	cConteudo+=pb_zer        (oNFE[23]*100,17)	//...................12-VLR TOTAL DO IPI
	cConteudo+=pb_zer        (oNFE[22]*100,17)	//...................13-VLR ICMS Substituição Tributária
	cConteudo+=pb_zer        (oNFE[10]*100,17)	//...................14-VLR nf Total
	cConteudo+=space(14)									//...................15-Inscrição Estadual do Substituto Tributário
	cConteudo+=pb_zer        (oNFE[11]+1,01)		//...................16-1-Vlr Vista 2-Parcelado
	cConteudo+=padr          (oNFE[33],45)			//...................17-Observação
	cConteudo+=space(50)									//..18-Ato Declaratório-VERIRICAR
	cConteudo+=space(02)									//...................19-Modelo do Documento Referenciado
	cConteudo+=space(05)									//...................20-Série/Subsérie do Documento Referenciado
	cConteudo+=pb_zer(0,9)								//...................21-Número do Documento Referenciado
	cConteudo+=pb_zer(0,8)								//...................22-Data de Emissão do Documento Referenciado
	cConteudo+=space(14)									//...................23-Código do Participante do Documento Referenciado
end

SPEDBAS->(	AddRec(30,;
				{pEmpresa,;//.............................................01-Codigo.Empresa
				cRegistro,;//.............................................02-Codigo.Registro
				cRegistro+dtos(  oNFE[09]   )+;//............................Regristor+DT Entrada
							 pb_zer(oNFE[04], 9)+;//............................NF Entrada
							 padr  (oNFE[05], 5)+;//............................Serie
							 pb_zer(oNFE[03], 6),;//.........................03-Emitente ==> Chave Acesso
				cConteudo;//..............................................04-Conteúdo
				}))

NF432E(pEmpresa,pTipoMov,oNFE[02])//...............1-Itens da NF de Entrada NF Própia+Terceiros
NF491(pEmpresa)	// Cadastro de Clientes/Fornecedores/Transportadores/Participante

DbUnlockAll()

return .T.

*----------------------------------------------------------------------------------------------*
static function NF432E(pEmpresa,pTipoMov,pRegistro) // Itens da Nota Fiscal
*----------------------------------------------------------------------------------------------*
if pRegistro=='0'//........................................ITENS DAS NFs Entrada Emissão PRÓPRIA
	for nX:=1 to Len(oNFE[42])
		PROD->(DbSeek(Str(oNFE[42][nX][02],L_P)))
		cConteudo:=pTipoMov												//...................01-Tipo <E>ntrada <S>aida
		cConteudo+=					  	oNFE[06]							//...................02-Tipo Documento
		cConteudo+=padr          (	oNFE[05],5)						//...................03-Serie + Subserie
		cConteudo+=pb_zer        (	oNFE[04],9)						//...................04-NR+NF
		cConteudo+=SONUMEROS(dtoc(	oNFE[08]))						//...................05-DT Emissao
		cConteudo+=pb_zer        (	oNFE[42][nX][01],3)			//...................06-Sequencia
		cConteudo+=padr(pb_zer   (	oNFE[42][nX][02],L_P),20)	//...................07-Codigo Produto
		cConteudo+=padr(PROD->PR_DESCR,45)							//...................08-Descr.Complementar
		cConteudo+=left(pb_zer	 (	oNFE[42][nX][09],7),4)		//...................09-CFOP (Natureza operacao)
		cConteudo+=left(pb_zer	 (	oNFE[42][nX][09],7),4)		//...................10-Natureza operacao(CFOP)
		cConteudo+=right(pb_zer	 (	oNFE[42][nX][09],7),2)		//...................10-Natureza operacao(CFOP) da Empresa 1/2
		cConteudo+=padl(				oNFE[42][nX][47],8)			//...................11-Codigo Nomenclatura Mercosul
		cConteudo+=pb_zer(			oNFE[42][nX][03]*1000,17)	//...................12-Quantidade (3 decimais)
		cConteudo+=padr(				oNFE[42][nX][04],3)			//...................13-Unidade
		cConteudo+=pb_zer(pb_divzero(oNFE[42][nX][06],oNFE[42][nX][03])*10000,17)//.14-Vlr Unitário (4 decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][06]*100,17)	//...................15-Vlr Total Item (2 decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][05]*100,17)	//...................16-Vlr Desconto Item (2 decimais)
		if pTipoMov=='E'
			cConteudo+='3'//........................................................17-3-IPI = Outras (Indicador de Tributação do IPI)
		else
			cConteudo+='3'//........................................................17-3-IPI = Outras	(Indicador de Tributação do IPI)
		end
		cConteudo+=pb_zer(			oNFE[42][nX][20]*100,05)	//...................18-% IPI (2 Decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][19]*100,17)	//...................19-Vlr Base IPI (2 Decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][21]*100,17)	//...................20-Vlr IPI (2 Decimais)
		cConteudo+=space(3)	//....................................................21-Preencher Cfe Convênio SINIEF s/nº, de 15 de dezembro de 1970.
		if oNFE[42][nX][08]+'#'$'000#010#020#'
			cConteudo+='1'	//.......................................................22-ICMS = Tributado
		elseif oNFE[42][nX][08]+'#'$'030#040#041#050#051#060#070#'
			cConteudo+='2'	//.......................................................22-ICMS = Isento ou Não Tributado
		else
			cConteudo+='3'	//.......................................................22-ICMS = Outros
		end
		cConteudo+=pb_zer(			oNFE[42][nX][11]*100,05)	//...................23-ICMS = Aliquota
		cConteudo+=pb_zer(			oNFE[42][nX][10]*100,17)	//...................24-ICMS = Base
		cConteudo+=pb_zer(			oNFE[42][nX][12]*100,17)	//...................25-ICMS = Valor
		cConteudo+=pb_zer(			oNFE[42][nX][13]*100,17)	//...................26-ICMS = Base Substituição
		cConteudo+=pb_zer(			oNFE[42][nX][14]*100,17)	//...................27-ICMS = Valor Substituição
		cConteudo+=if(oNFE[42][nX][07]==0,'S','N')				//...................28-Indicador Movimentacao Fisica do Produtos
		if pTipoMov=='E'
			cConteudo+='03'	//....................................................29-Código Situação Tributária do IPI (ENTRADA)
			cRegistro:='432X'	//ENTRADA PROPRIA
		else
			cConteudo+='53'	//....................................................29-Código Situação Tributária do IPI (SAIDA)
			cRegistro:='432X'	//SAIDA PROPRIA
		end
		//432C-ENTRADA PROPRIA
		//432E-ENTRADA TERCEIROS
		//432R-SAIDA PROPRIA
		//432S-SAIDA TERCEIROS
		SPEDBAS->(	AddRec(30,;
						{pEmpresa,;//.............................................01-Codigo.Empresa
						cRegistro,;//.............................................02-Codigo.Registro
						cRegistro+dtos(	oNFE[09])+;//..............................DT Entrada
									 pb_zer(	oNFE[04], 9)+;//...........................NF
									 padr(	oNFE[05], 5)+;//...........................Serie
									 pb_zer(	oNFE[03], 6)+;//...........................Emitente
									 pb_zer(	oNFE[42][nX][01],3),;//.................03-Ordem Numerica => Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
		if pTipoMov=='E'
			NF4A4(pEmpresa) // Arquivo Complemento PIS/COFINS para NF Entrada Próprias
		end
		NF495(pEmpresa,oNFE[42][nX][02])	// Cadastro de Produtos
		NF494(pEmpresa,oNFE[42][nX][09])	// Cadastro de CFOP - Natureza Operação
	next nX

else//.....................................................ITENS DA NFs DE ENTRADA/SAIDA - TERCEIROS
	for nX:=1 to Len(oNFE[42])
		PROD->(DbSeek(Str(oNFE[42][nX][02],L_P)))
		cConteudo:=					 	 	oNFE[06]							//...................01-Modelo Documento
		cConteudo+=padr				(	oNFE[05],5)						//...................02-Serie + Subserie
		cConteudo+=pb_zer				(	oNFE[04],9)						//...................03-NR+NF
		cConteudo+=SONUMEROS(dtoc	(	oNFE[08]))						//...................04-DT Emissao
		cConteudo+=pb_zer     		(	oNFE[03],14)					//...................05-Cod Participante
		cConteudo+=pb_zer 			(	oNFE[42][nX][01],3)			//...................06-Ordem na NF
		cConteudo+=padr(pb_zer   (	oNFE[42][nX][02],L_P),20)		//...................07-Codigo Produto
		cConteudo+=padr(PROD->PR_DESCR,45)								//...................08-Descr.Complementar
		cConteudo+=left(pb_zer	 (	oNFE[42][nX][09],7),4)			//...................09-CFOP
		cConteudo+=left(pb_zer	 (	oNFE[42][nX][09],7),4)			//...................10-CFOP (Natureza operacao)
		cConteudo+=right(pb_zer	 (	oNFE[42][nX][09],7),2)			//...................10-CFOP (Natureza operacao) da Empresa 
		cConteudo+=padl(				oNFE[42][nX][47],8)				//...................11-Codigo Nomenclatura Mercosul
		cConteudo+=pb_zer(			oNFE[42][nX][03]*1000,17)		//...................12-Quantidade (3 decimais)
		cConteudo+=padr(				oNFE[42][nX][04],3)				//...................13-Unidade
		cConteudo+=pb_zer(pb_divzero(oNFE[42][nX][06],oNFE[42][nX][03])*10000,17)	//.14-Vlr Unitário (4 decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][06]*100,17)		//...................15-Vlr Total Item (2 decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][05]*100,17)		//...................16-Vlr Desconto Item (2 decimais)
		if pTipoMov=='E'
			cConteudo+='3'//...........................................................17-3-IPI = Outras
		else
			cConteudo+='3'//...........................................................17-3-IPI = Outras	
		end
		cConteudo+=pb_zer(			oNFE[42][nX][20]*100,05)	//......................18-% IPI (2 Decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][19]*100,17)	//......................19-Vlr Base IPI (2 Decimais)
		cConteudo+=pb_zer(			oNFE[42][nX][21]*100,17)	//......................20-Vlr IPI (2 Decimais)
		cConteudo+=space(3)	//.......................................................21-Preencher Cfe Convênio SINIEF s/nº, de 15 de dezembro de 1970.
		if oNFE[42][nX][08]+'#'$'000#010#020#'
			cConteudo+='1'	//..........................................................22-ICMS = Tributado
		elseif oNFE[42][nX][08]+'#'$'030#040#041#050#051#060#070#'
			cConteudo+='2'	//..........................................................22-ICMS = Isento ou Não Tributado
		else
			cConteudo+='3'	//..........................................................22-ICMS = Outros
		end
		cConteudo+=pb_zer(			oNFE[42][nX][11]*100,05)	//......................23-ICMS = Aliquota
		cConteudo+=pb_zer(			oNFE[42][nX][10]*100,17)	//......................24-ICMS = Base
		cConteudo+=pb_zer(			oNFE[42][nX][12]*100,17)	//......................25-ICMS = Valor
		cConteudo+=pb_zer(			oNFE[42][nX][13]*100,17)	//......................26-ICMS = Base Substituição
		cConteudo+=pb_zer(			oNFE[42][nX][14]*100,17)	//......................27-ICMS = Valor Substituição
		cConteudo+=if(oNFE[42][nX][07]==0,'S','N')	//...............................28-Movimentacao Produtos?
		if pTipoMov=='E'
			cConteudo+='03'//..........................................................29-Código Situação Tributária do IPI (ENTRADA)
			cRegistro:='434X'	//ENTRADA TERCEIROS
		else
			cConteudo+='53'//..........................................................29-Código Situação Tributária do IPI (SAIDA)
			cRegistro:='434X'	// SAIDA TERCEIROS
		end
		//433C-ENTRADA PROPRIA
		//433E-ENTRADA TERCEIROS
		//433R-SAIDA PROPRIA
		//433S-SAIDA TERCEIROS
		SPEDBAS->(	AddRec(30,;
						{pEmpresa,;//.............................................01-Codigo.Empresa
						cRegistro,;//.............................................02-Codigo.Registro
						cRegistro+dtos(	oNFE[09])+;//..............................DT Entrada
									 pb_zer(	oNFE[04], 9)+;//...........................NF
									 padr(	oNFE[05], 5)+;//...........................Serie
									 pb_zer(	oNFE[03], 6)+;//...........................Emitente
									 pb_zer(	oNFE[42][nX][01],3),;//.................03-Ordem Numerica => Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
		
		if pTipoMov=='S'
			NF4A1(pEmpresa) // Arquivo Complemento PIS/COFINS - Itens NF Saida Terceiros
		else
			NF4A5(pEmpresa) // Arquivo Complemento PIS/COFINS - Itens NF Entrada Terceiros
		end
		NF495(pEmpresa,oNFE[42][nX][02])	// Cadastro de Produtos
		NF494(pEmpresa,oNFE[42][nX][09])	// Cadastro de CFOP - Natureza Operação
	next nX
end
return .T.

*------------------------------------------------------------------------------------*
static function NF4A1(pEmpresa) // Arquivo Complemento PIS/COFINS NF SAIDA PROPRIA
*------------------------------------------------------------------------------------*
cRegistro:='4A1X'
cConteudo:=					 	 	oNFE[06]							//...................01-Modelo Documento
cConteudo+=padr				(	oNFE[05],5)						//...................02-Serie + Subserie
cConteudo+=pb_zer				(	oNFE[04],9)						//...................03-NR+NF
cConteudo+=SONUMEROS(dtoc	(	oNFE[08]))						//...................04-DT Emissao
cConteudo+=pb_zer 			(	oNFE[42][nX][01],3)			//...................05-Ordem na NF
cConteudo+=padl				(	oNFE[42][nX][22],2)			//...................06-PIS = CST
cConteudo+=pb_zer				(	oNFE[42][nX][24]*10000,08)	//...................07-PIS = Aliquota (4 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][23]*1000, 17)	//...................08-PIS = Base (3 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][27]*100,  17)	//...................09-PIS = Valor (2 Decimais)
cConteudo+=padl				(	oNFE[42][nX][28],2)			//...................10-COFINS = CST
cConteudo+=pb_zer				(	oNFE[42][nX][30]*10000,08)	//...................11-COFINS = Aliquota (4 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][29]*1000, 17)	//...................12-COFINS = Base (3 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][33]*100,  17)	//...................13-COFINS = Valor (2 Decimais)
cConteudo+=SONUMEROS(dtoc	(	eom(oNFE[08])))				//...................14-DT Apropriação das contribuições
		
		SPEDBAS->(	AddRec(30,;
						{pEmpresa,;//.............................................01-Codigo.Empresa
						cRegistro,;//.............................................02-Codigo.Registro
						cRegistro+dtos(	oNFE[09])+;//..............................DT Entrada
									 pb_zer(	oNFE[04], 9)+;//...........................NF
									 padr(	oNFE[05], 5)+;//...........................Serie
									 pb_zer(	oNFE[03], 6)+;//...........................Emitente
									 pb_zer(	oNFE[42][nX][01],3),;//.................03-Ordem Numerica => Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
return .T.

*-------------------------------------------------------------------------------------------*
static function NF4A4(pEmpresa) // Arquivo Complemento PIS/COFINS - Itens NF Entrada Própria
*--------------------------------------------------------------------------------------------*
cRegistro:='4A4X'
cConteudo:=					 	 	oNFE[06]							//...................01-Modelo Documento
cConteudo+=padr				(	oNFE[05],5)						//...................02-Serie + Subserie
cConteudo+=pb_zer				(	oNFE[04],9)						//...................03-NR+NF
cConteudo+=SONUMEROS(dtoc	(	oNFE[08]))						//...................04-DT Emissao
cConteudo+=pb_zer 			(	oNFE[42][nX][01],3)			//...................05-Ordem na NF
cConteudo+=padl				(	oNFE[42][nX][22],2)			//...................06-PIS = CST
cConteudo+=pb_zer				(	oNFE[42][nX][24]*10000,08)	//...................07-PIS = Aliquota (4 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][23]*1000, 17)	//...................08-PIS = Base (3 Decimais)
cConteudo+=pb_zer				(	0,	17)							//...................09-PIS = Valor Crédito vinculado à receita de exportação
cConteudo+=pb_zer				(	0,	17)							//...................10-PIS = Valor Crédito vinculado à receita tributada no mercado interno
cConteudo+=pb_zer				(	0,	17)							//...................11-PIS = Valor Crédito vinculado à receita não-tributada do mercado interno
cConteudo+=pb_zer				(	oNFE[42][nX][27]*100,  17)	//...................12-PIS = Valor (2 Decimais)

cConteudo+=padl				(	oNFE[42][nX][28],2)			//...................13-COFINS = CST
cConteudo+=pb_zer				(	oNFE[42][nX][30]*10000,08)	//...................14-COFINS = Aliquota (4 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][29]*1000, 17)	//...................15-COFINS = Base (3 Decimais)
cConteudo+=pb_zer				(	0,	17)							//...................16-COFINS = Valor Crédito vinculado à receita de exportação
cConteudo+=pb_zer				(	0,	17)							//...................17-COFINS = Valor Crédito vinculado à receita tributada no mercado interno
cConteudo+=pb_zer				(	0,	17)							//...................18-COFINS = Valor Crédito vinculado à receita não-tributada do mercado interno
cConteudo+=pb_zer				(	oNFE[42][nX][33]*100,  17)	//...................19-COFINS = Valor (2 Decimais)
cConteudo+=SONUMEROS(dtoc	(	eom(oNFE[08])))				//...................20-DT Apropriação das contribuições (Apuração)
		
		SPEDBAS->(	AddRec(30,;
						{pEmpresa,;//.............................................01-Codigo.Empresa
						cRegistro,;//.............................................02-Codigo.Registro
						cRegistro+dtos(	oNFE[09])+;//..............................DT Entrada
									 pb_zer(	oNFE[04], 9)+;//...........................NF
									 padr(	oNFE[05], 5)+;//...........................Serie
									 pb_zer(	oNFE[03], 6)+;//...........................Emitente
									 pb_zer(	oNFE[42][nX][01],3),;//.................03-Ordem Numerica => Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
return .T.

*-----------------------------------------------------------------------------------------------*
static function NF4A5(pEmpresa) // Arquivo Complemento PIS/COFINS - Itens NF Entrada Terceiros
*-----------------------------------------------------------------------------------------------*
cRegistro:='4A5X'
cConteudo:=					 	 	oNFE[06]							//...................01-Modelo Documento
cConteudo+=padr				(	oNFE[05],5)						//...................02-Serie + Subserie
cConteudo+=pb_zer				(	oNFE[04],9)						//...................03-NR+NF
cConteudo+=SONUMEROS(dtoc	(	oNFE[08]))						//...................04-DT Emissao
cConteudo+=pb_zer     		(	oNFE[03],14)					//...................05-Cod Participante
cConteudo+=pb_zer 			(	oNFE[42][nX][01],3)			//...................06-Ordem na NF
cConteudo+=padl				(	oNFE[42][nX][22],2)			//...................07-PIS = CST
cConteudo+=pb_zer				(	oNFE[42][nX][24]*10000,08)	//...................08-PIS = Aliquota (4 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][23]*1000, 17)	//...................09-PIS = Base (3 Decimais)
cConteudo+=pb_zer				(	0,	17)							//...................10-PIS = Valor Crédito vinculado à receita de exportação
cConteudo+=pb_zer				(	0,	17)							//...................11-PIS = Valor Crédito vinculado à receita tributada no mercado interno
cConteudo+=pb_zer				(	0,	17)							//...................12-PIS = Valor Crédito vinculado à receita não-tributada do mercado interno
cConteudo+=pb_zer				(	oNFE[42][nX][27]*100,  17)	//...................13-PIS = Valor (2 Decimais)
cConteudo+=padl				(	oNFE[42][nX][28],2)			//...................14-COFINS = CST
cConteudo+=pb_zer				(	oNFE[42][nX][30]*10000,08)	//...................15-COFINS = Aliquota (4 Decimais)
cConteudo+=pb_zer				(	oNFE[42][nX][29]*1000, 17)	//...................16-COFINS = Base (3 Decimais)
cConteudo+=pb_zer				(	0,	17)							//...................17-COFINS = Valor Crédito vinculado à receita de exportação
cConteudo+=pb_zer				(	0,	17)							//...................18-COFINS = Valor Crédito vinculado à receita tributada no mercado interno
cConteudo+=pb_zer				(	0,	17)							//...................18-COFINS = Valor Crédito vinculado à receita não-tributada do mercado interno
cConteudo+=pb_zer				(	oNFE[42][nX][33]*100,  17)	//...................20-COFINS = Valor (2 Decimais)
cConteudo+=SONUMEROS(dtoc	(	eom(oNFE[08])))				//...................21-DT Apropriação das contribuições (Apuração)
		
		SPEDBAS->(	AddRec(30,;
						{pEmpresa,;//.............................................01-Codigo.Empresa
						cRegistro,;//.............................................02-Codigo.Registro
						cRegistro+dtos(	oNFE[09])+;//..............................DT Entrada
									 pb_zer(	oNFE[04], 9)+;//...........................NF
									 padr(	oNFE[05], 5)+;//...........................Serie
									 pb_zer(	oNFE[03], 6)+;//...........................Emitente
									 pb_zer(	oNFE[42][nX][01],3),;//.................03-Ordem Numerica => Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
return .T.

*------------------------------------------------------------------------------------*
static function NF491(pEmpresa) // Cadastro de Clientes/Fornecedores/Transportadores
*------------------------------------------------------------------------------------*
cRegistro:='491X'

if !SPEDBAS->(dbseek(padr(cRegistro+pb_zer   (oNFE[03],6),40),.F.))
	if empty(CLIENTE->CL_DTCAD)
		cConteudo:=SONUMEROS(DToC(aPeriodo[1]))					//-01-Data alteração Emitente
	else
		cConteudo:=SONUMEROS(DToC(CLIENTE->CL_DTCAD))			//-01-Data alteração Emitente
	end
	cConteudo+=pb_zer   (oNFE[03],14) 								//-02-Codigo
	cConteudo+=padr(SONUMEROS(CLIENTE->CL_CGC)			,14)	//-03-CNPJ+CPF
	if CLIENTE->CL_TIPOFJ=='J'
		cConteudo+=padr(SONUMEROS(CLIENTE->CL_INSCR)		,14)	//-04-Inscr Estadual
	else
		cConteudo+=space(14)												//-04-Inscr Estadual
	end
	cConteudo+=padr(CLIENTE->CL_INSMUN						,14)	//-05-Inscr Municipal
	cConteudo+=padr(CLIENTE->CL_RAZAO 						,70)	//-06-Nome / Razão Social
	cConteudo+=padr(trim(CLIENTE->CL_ENDER)+' '+;
						 trim(CLIENTE->CL_ENDNRO)+' '+;
						 trim(CLIENTE->CL_ENDCOMP)				,60)	//-07-Nome / Razão Social
	cConteudo+=padr(CLIENTE->CL_BAIRRO 						,20)	//-08-Bairro
	cConteudo+=padr(CLIENTE->CL_CIDAD 						,20)	//-09-Municipio
	cConteudo+=padr(CLIENTE->CL_UF	 						, 2)	//-10-UF
	cConteudo+=space(20)													//-11-Pais
	cConteudo+=padr(CLIENTE->CL_CEP 							, 8)	//-12-CEP
	SPEDBAS->(	AddRec(30,;
					{pEmpresa,;//.............................................01-Codigo.Empresa
					cRegistro,;//.............................................02-Codigo.Registro
					cRegistro+pb_zer(oNFE[03],6),;//.........................03-Registro+Codigo => Chave Acesso
					cConteudo;//..............................................04-Conteúdo
					}))
end
return .T.

*------------------------------------------------------------------------------------*
static function NF494(pEmpresa,pCFOP) // Cadastro de Natureza de Operação
*------------------------------------------------------------------------------------*
cRegistro:='494X'
if !SPEDBAS->(dbseek(padr(cRegistro+pb_zer(pCFOP,7),40),.F.))
	if empty(NATOP->NO_DTALT)
		cConteudo:=SONUMEROS(DToC(aPeriodo[1]))				//-01-Data alteração Natureza
	else
		cConteudo:=SONUMEROS(DToC(NATOP->NO_DTALT))			//-01-Data alteração Natureza
	end
	cConteudo+=left (pb_zer	 (	pCFOP,7),4)						//-02-CFOP (Natureza Operacao)
	cConteudo+=right(pb_zer	 (	pCFOP,7),2)						//-02-CFOP Final - da Empresa
	cConteudo+=padr(NATOP->NO_DESCR,45)							//-03-Descricao CFOP
	SPEDBAS->(	AddRec(30,;
					{pEmpresa,;//.............................................01-Codigo.Empresa
					cRegistro,;//.............................................02-Codigo.Registro
					cRegistro+pb_zer(pCFOP,7),;//.......................................03-Chave Acesso
					cConteudo;//..............................................04-Conteúdo
					}))
end
return .T.

*------------------------------------------------------------------------------------*
static function NF495(pEmpresa,pProduto) // Cadastro Produtos
*------------------------------------------------------------------------------------*
cRegistro:='495X'
if empty(PROD->PR_DTCAD)
	cConteudo:=SONUMEROS(DToC(aPeriodo[1]))		//.......01-Data alteração Emitente
else
	cConteudo:=SONUMEROS(DToC(PROD->PR_DTCAD))		//.......01-Data alteração Emitente
end
cConteudo+=padr(pb_zer(pProduto,L_P),20)			//.......02-Codigo Produto
cConteudo+=padr(PROD->PR_DESCR		,45)			//.......03-Descricao Produto
if !SPEDBAS->(dbseek(padr(cRegistro+padr(pb_zer(pProduto,L_P),20),40),.F.))
	SPEDBAS->(	AddRec(30,;
					{pEmpresa,;//.............................................01-Codigo.Empresa
					cRegistro,;//.............................................02-Codigo.Registro
					cRegistro+padr(pb_zer(pProduto,L_P),20),;//...........................03-Chave Acesso
					cConteudo;//..............................................04-Conteúdo
					}))
end
return .T.

*-----------------------------------------------------------------------------*
static function GLancCont()
*-----------------------------------------------------------------------------*
aArq[2]:=aArq[1]+'\LContab.TXT'
set printer to (aArq[2])
set print ON
set console OFF
select RAZAO
ordem CONTADT
pb_msg('Gerando '+aArq[2])
while !eof()
	@24,55 say RZ_CONTA+'/'+DtoC(RZ_DATA)
	if year(RZ_DATA)==nANO
		??SONUMEROS(DtoC(RZ_DATA))			//......1-Data Movimento
		??padr(SONUMEROS(RZ_CONTA),28)	//......2-Codigo da conta contabil
		??Space(28)								//......3-Centro de Custo / Despesa
		??Space(28)								//......4-Codigo Contrapartatida
		??pb_zer(abs(RZ_VALOR*100),17,0)	//......5-Valor movimento
		??iif(RZ_VALOR>0,'D','C')			//......6-D/C
		??     substr(RZ_DOCTO, 1,12)		//......7-Nro documento (rastreabilidade)
		??padr(substr(RZ_DOCTO,13,12),12)//......8-Identifica
		??padr(RZ_HISTOR,   150)
		?
	end
	skip
end
set console ON
set print OFF
set printer to
return NIL

//-----------------------------------------------------------------------------*
  static function GSldMensal()	// Saldo
//-----------------------------------------------------------------------------*
local CCampoD
local CCampoC
nSaldo :={0,0}
aArq[3]:=aArq[1]+'\SlMensal.TXT'
set printer to (aArq[3])
set print ON
set console OFF
select CTADET
ORDEM CONTAN
for nX:=1 to 12
	pb_msg('Gerando '+aArq[3]+str(nX,3)+'/12')
	DbGoTop()
	while !eof()
		@24,65 say CD_CONTA
		nSaldo[1]:=CD_SLD_IN
		if nX>1
			nSaldo[1]:=fn_SaldoConta(nX-1)
		end
		nSaldo[2]:=fn_SaldoConta(nX)
		CCampoD:='CD_DEB_'+pb_zer(nX,2)
		CCampoC:='CD_CRE_'+pb_zer(nX,2)
		if str(nSaldo[1]+&CCampoD+&CCampoC,15,2)#str(0,15,2) // Tem Saldo
			??SONUMEROS(DtoC(CtoD('01/'+pb_zer(nX,2)+'/'+str(nAno,4))))
			??padr(SONUMEROS(CD_CONTA),28)
			??pb_zer(abs(nSaldo[1]*100),17,0)
			??iif(nSaldo[1]>0,'D','C')
			??pb_zer(abs(&CCampoD *100),17,0)
			??pb_zer(abs(&CCampoC *100),17,0)
			??pb_zer(abs(nSaldo[2]*100),17,0)
			??iif(nSaldo[2]>0,'D','C')
			?
		end
		skip
	end
next
set console ON
set print OFF
set printer to
return NIL

//-----------------------------------------------------------------------------*
  static function GMovFornec()
//-----------------------------------------------------------------------------*
local CCampoD
local CCampoC
      fn_lecc('S',X,0, 0)
nSaldo :={0,0}
aArq[4]:=aArq[1]+'\MovForne.TXT'
aArq[5]:=ArqTemp(,,'') // Arquivo Temporário
SALVABANCO
dbcreate(ARQ,{ {'WK_CODCC', 'C', 25,0},;//1
					{'WK_CODCL', 'N',  5,0},;//2
					{'WK_NRDOC', 'N',  9,0},;//3
					{'WK_DTEMI', 'D',  8,0},;//4
					{'WK_DTVEN', 'D',  8,0},;//5
					{'WK_DTMOV', 'D',  8,0},;//6
					{'WK_VLORIG','N', 15,2},;//7
					{'WK_VLMOV', 'C', 15,2},;//8
					{'WK_DESCR', 'C', 50,0}; //9
					})
if !net_use(ARQ,.T., ,'WORK', ,.F.,RDDSETDEFAULT())
	RT:=.F.
else
	Index on WK_CODCC+str(WK_CODCL,5)+str(WK_NRDOC,9)+dtos(WK_DTEMI)+dtos(WK_DTMOV) tag CODIGO to (ARQ)
	OrdSetFocus('CODIGO')
end
RESTAURABANCO
set printer to (aArq[4])
set print ON
set console OFF
select DPFOR
while !eof()
	ContaC:=Busca
	AddRec(	{;
					})
	skip
end
set console ON
set print OFF
set printer to
return NIL
//------------------------------------------------EOF-----------------