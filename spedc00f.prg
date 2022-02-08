static aVariav := {'',0,.T.,0,'','','0',0,{},0,'','','', 0, 0, 0, 0,{},'','', 0,  0}
 //.................1.2..3..4..5..6..7..8..9.10.11.12.13.14 15 16 17,18,19,20,21,22
*----------------------------------------------------------------------------------*
#xtranslate nCGC			=> aVariav\[  1 \]
#xtranslate cValor		=> aVariav\[  2 \]
#xtranslate lRT			=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate cRT			=> aVariav\[  5 \]
#xtranslate cKey			=> aVariav\[  6 \]
#xtranslate nKey			=> aVariav\[  7 \]
#xtranslate nVlrAcess	=> aVariav\[  8 \]
#xtranslate aNF			=> aVariav\[  9 \]
#xtranslate nZ				=> aVariav\[ 10 \]
#xtranslate REGISTRO		=> aVariav\[ 11 \]
#xtranslate cConteudo	=> aVariav\[ 12 \]
#xtranslate cUnd			=> aVariav\[ 13 \]
#xtranslate nDescD		=> aVariav\[ 14 \]
#xtranslate nBASICMS		=> aVariav\[ 15 \]
#xtranslate nPERICMS		=> aVariav\[ 16 \]
#xtranslate nVLRICMS		=> aVariav\[ 17 \]
#xtranslate aCodEst  	=> aVariav\[ 18 \]
#xtranslate cTpItem  	=> aVariav\[ 19 \]
#xtranslate cSerie 	 	=> aVariav\[ 20 \]
#xtranslate cCSTPISCOF 	=> aVariav\[ 21 \]
#xtranslate vUniPr 		=> aVariav\[ 22 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------*
function RtEntrada() // processa uma NF de Entrada
*-----------------------------------------------------------------------*
cRT:={'1',;//..............................1-Emissão de Terceiros
		'01',;//.............................2-Modelo do documento conforme 4.1.1 (ato cotep)
		'08',;//.............................3-Situação Trib PIS
		0.00,;//.............................4-Aliq PIS
		'08',;//.............................5-Situação Trib COFINS
		0.00}//..............................6-Aliq COFINS

aCodEst:=restarray('ESTOQUE.ARR') // Carregar itens

if right(str(ENTCAB->EC_CODOP,8),1) == '9' // Tipo impressão da NF de entrada
	cRT[1]:='0'//..............................0=Emissão de Própria
	//alert('NAT.OP='+str(ENTCAB->EC_CODOP,8)+'; NF='+str(ENTCAB->EC_DOCTO,9))
end
	cRT[2]:=VERSERIE(ENTCAB->EC_SERIE,ENTCAB->EC_DOCTO)

cSerie:=substr(ENTCAB->EC_SERIE,1,1)
if cSerie>='0'.and.cSerie<'9'
	cSerie+='  '
elseif ENTCAB->EC_SERIE=='NPS'
	cSerie:='1  '
end

nVlrAcess:=if(str(ENTCAB->EC_ACFRET+ENTCAB->EC_ACSEGU+EC_ACOUTR,15,2)>str(0,15,2),ENTCAB->EC_ACOUTR,ENTCAB->EC_ACESS)

aNF:={'E',;//...............................01-Tipo Nota Fiscal (E=Entrada / S=Saida)
		cRT[1],;//............................02-Tipo NF (1=Terceiro/0=Proprio)
		ENTCAB->EC_CODFO,;//..................03-Codigo Emitente
		ENTCAB->EC_DOCTO,;//..................04-Nr Documento
		ENTCAB->EC_SERIE,;//..................05-Serie do Documento
		cRT[2],;//............................06-Modelo do documento conforme 4.1.1 (ato cotep)
		if(ENTCAB->EC_NFCAN,'02','00'),;//....07-Tabela Situação do Documento 4.1.2 (ato cotep)
		ENTCAB->EC_DTEMI,;//..................08-DT Emissão
		ENTCAB->EC_DTENT,;//..................09-DT Entrada/Saida
		ENTCAB->EC_TOTAL,;//..................10-Valor Total do documento fiscal
		if(ENTCAB->EC_FATUR>0,1,0),;//........11-Parcelamento (0=Vista,1=Parcelado)
		ENTCAB->EC_DESC,;//...................12-Valor Total do Desconto
		0.00,;//..............................13-Abatimento não Tributado
		ENTCAB->EC_TOTAL-ENTCAB->EC_DESC,;//..14-Valor das mercadorias constantes no documento fiscal
		ENTCAB->TR_TIPO,;//...................15-Tipo Frete (1=Emitente 2=Destinatário) há outros (ato cotep)
		ENTCAB->EC_ACFRET,;//.................16-Valor do Frete indicado no documento fiscal
		ENTCAB->EC_ACSEGU,;//.................17-Valor do Seguro Indicado no documento fiscal
		nVlrAcess,;//.........................18-Valor Despesas Assesórias-Outros (todos)
		0.00,;//..............................19-Valor da Base de cálculo do ICMS----------->(Somar dos itens)
		0.00,;//..............................20-Valor do ICMS------------------------------>(Somar dos itens)
		ENTCAB->EC_ICMSTB,;//.................21-Valor da Base de cálculo do ICMS ST
		ENTCAB->EC_ICMSTV,;//.................22-Valor do ICMS ST
		0.00,;//..............................23-Valor total do IPI (====>ENTCAB->EC_IPI)
		0.00,;//..............................24-Valor total do PIS
		0.00,;//..............................25-Valor total da COFINS
		0.00,;//..............................26-Valor total do PIS retido por substituição tributária
		0.00,;//..............................27-Valor total da COFINS retido por substituição tributária
		ENTCAB->EC_NFEKEY,;//.................28-Chave NFE
		'C',;//...............................29-Tipo de sistema (C=CFE S=SAG)
		ENTCAB->EC_DOCTO,;//..................30-Numero Interno
		ENTCAB->EC_TPDOC,;//..................31-Tipo de Documento (CT, NF,...)
		ENTCAB->EC_NFCAN,;//..................32-NF Cancelada?
		trim(ENTCAB->EC_OBSNFE)+' '+trim(ENTCAB->EC_PARCE),;//...33-OBS NF Entrada
		ENTCAB->EC_CODOP,;//..................34-Natureza Operação Digitada
		0.00,;//..............................35-nill
		0.00,;//..............................36-nill
		0.00,;//..............................37-nill
		0.00,;//..............................38-nill
		0.00,;//..............................39-nill
		{},;//................................40-Frete
		{},;//................................41-Parcelamento
		{},;//................................42-Produtos da NF
		{},;//................................43-Resumo Fiscal
		}
		
		aNF[40]:={	ENTCAB->TR_CODTRA,;//.....01-Codigo Transportador
						ENTCAB->TR_NOME,;//.......02-Nome do Transportador
						ENTCAB->TR_ENDE,;//.......03-
						ENTCAB->TR_MUNI,;//.......04-
						ENTCAB->TR_UFT,;//........05-
						ENTCAB->TR_TIPO,;//.......06-
						ENTCAB->TR_PLACA,;//......07-
						ENTCAB->TR_UFV,;//........08-
						ENTCAB->TR_CGC,;//........09-
						ENTCAB->TR_INCR,;//.......10-
						'',;//....................11-
						'',;//....................12-
						'',;//....................13-
						'',;//....................14-
						ENTCAB->TR_QTDEM,;//......15-Qtda Volumes
						ENTCAB->TR_ESPE,;//.......16-Especie Volume
						ENTCAB->TR_PBRU,;//.......17-Peso Bruto
						ENTCAB->TR_PLIQ,;//.......18-Peso Liquido
						ENTCAB->TR_TIPO,;//.......19-Tipo Frete
						ENTCAB->TR_PLACA,;//......20-Identificação veiulo
						ENTCAB->TR_UFT,;//........21-UF da Placa do Transportador
					}

//.................................................................Processa detalhes da NF (itens da NF)
select ENTDET
//if !dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE,.T.)
//	alert('ERRO na NF-Entrada;Nr:'+str(ENTCAB->EC_DOCTO,8)+' Serie:'+ENTCAB->EC_SERIE+';Fornecedor:'+str(ENTCAB->EC_CODFO,5)+';Nao tem Itens.')
//	@23,00 say '*ERRO na NF-Entrada* Nr:'+str(ENTCAB->EC_DOCTO,8)+' Serie:'+ENTCAB->EC_SERIE+'-Fornecedor:'+str(ENTCAB->EC_CODFO,5)+'-->Nao tem Itens.'
//	strFile(cConteudo,'C:\TEMP\SPEDERR.TXT',.T.)
//end
dbseek(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE,.T.)

nX:=0
while !eof().and.	ENTDET->ED_DOCTO==ENTCAB->EC_DOCTO.and.;
						ENTDET->ED_SERIE==ENTCAB->EC_SERIE
	if ENTDET->ED_CODFO==ENTCAB->EC_CODFO //---------------------------------Cod Fornecedor
		PROD-> (dbseek(str(ENTDET->ED_CODPR,L_P))) // Pegar Unidade.
		NATOP->(dbseek(str(ENTDET->ED_CODOP,7)))	// Buscar CFOP
		
		cRT[3]:='08'//.............................3-Situação Trib PIS
		cRT[4]:=0.00//.............................4-Aliq PIS
		cRT[5]:='08'//.............................5-Situação Trib COFINS
		cRT[6]:=0.00//.............................6-Aliq COFINS

		if FISACOF->(dbseek(ENTDET->ED_CODCOF+CLIENTE->CL_TIPOFJ,.T.))
			cRT[3]:=FISACOF->CO_TIPOIN
			cRT[4]:=FISACOF->CO_PERC1
			cRT[5]:=FISACOF->CO_TIPOIN
			cRT[6]:=FISACOF->CO_PERC2
		else
			if FISACOF->(dbseek(PROD->PR_CODCOE+CLIENTE->CL_TIPOFJ,.T.)) // PEGAR DO PRODUTO SE NÃO ACHAR NO ARQUIVO
				cRT[3]:=FISACOF->CO_TIPOIN
				cRT[4]:=FISACOF->CO_PERC1
				cRT[5]:=FISACOF->CO_TIPOIN
				cRT[6]:=FISACOF->CO_PERC2
			end
		end
		cUnd:=ED_UNIENTR
		if empty(cUnd)
			cUnd:=PROD->PR_UND
		end
		UNIDADE->(dbseek(cUnd)) // Buscar descr Unidade
		//...............................Ajustes no CTS -> ICMS
		vBASICMS:=ENTDET->ED_BICMS
		vPERICMS:=ENTDET->ED_PCICM
		vVLRICMS:=ENTDET->ED_VLICM
		if ENTDET->ED_CODTR+'#'$'030#040#041#050#060#'
			vBASICMS:=0
			vPERICMS:=0
			vVLRICMS:=0
		end
		if ENTDET->ED_CODTR+'#'$'000#010#020#070#'.and.str(vPERICMS,10,2)==str(0,10,2) // tem que ter % ICMS
			//???
		end
		//-------------------------------------------------------------Tipo item
		cTpItem:=ascan(aCodEst,{|DET|DET[1]==PROD->PR_CTB})
		if cTpItem > 0
			cTpItem:=pb_zer(aCodEst[cTpItem][3],2)//....................Tipo Item
			//
			//...REGISTRO 61 - TABELA PARA A EXPORTAÇÃO PARA O PH
			// 00-Mercadoria para Revenda;
			// 01-Matéria-Prima;
			// 02-Embalagem;
			// 03-Produto em Processo;
			// 04-Produto Acabado;
			// 05-Subproduto;
			// 06-Produto Intermediário;
			// 07-Material de Uso e Consumo;
			// 08-Ativo Imobilizado;
			// 09-Serviços;
			// 10-Outros insumos;
			// 99-Outras.
			//
		else
			cTpItem:=pb_zer(99,2) //....................................Tipo Item = Se não achar nenhum colocar 99
		end

		nDescD:=abs(round(pb_divzero(ENTCAB->EC_DESC,ENTCAB->EC_TOTAL)*ENTDET->ED_VALOR,2))
		cValor:=max(ENTDET->ED_VALOR,0.01) 										// Valor Total do item sem desconto
		vUniPr:=round(pb_divzero(ENTCAB->EC_TOTAL,ENTDET->ED_QTDE),5)	// Vlr Unit Prod
		aadd(aNF[42],;
						{ENTDET->ED_ORDEM,;//...................................01-Sequencia Prod
						 ENTDET->ED_CODPR,;//...................................02-Cod Produto
						 ENTDET->ED_QTDE,;//....................................03-Quantidade Entrada
						 cUnd,;//...............................................04-Unidade Entrada
						 nDescD,;//.............................................05-Vlr Desconto
						 cValor,;//.............................................06-Vlr Produto sem desconto
						 0,;//..................................................07-Movim Estoque(0=Sim/1=Sim)
						 ENTDET->ED_CODTR,;//...................................08-Situação Trib ICMS
						 ENTDET->ED_CODOP,;//...................................09-CFOP-Cod Operacao CFE/SAG
						 vBASICMS,;//...........................................10-Vlr Base ICMS
						 vPERICMS,;//...........................................11-Aliq ICMS
						 vVLRICMS,;//...........................................12-Vlr ICMS
						 0.00,;//...............................................13-ICMS Substituicao-Vlr Base 
						 0.00,;//...............................................14-ICMS Substituicao-Aliq
						 0.00,;//...............................................15-ICMS Substituicao-Vlr
						 0,;//..................................................16-IPI-Periodo Apuracao (IND_APUR)
						 '',;//.................................................17-IPI-Cód Sit Trib-Conforme a Tabela indicada no item 4.3.2.
						 '',;//.................................................18-IPI-Cód Enquadr Legal(Branco)
						 0.00,;//...............................................19-IPI-Vlr Base
						 ENTDET->ED_PIPI,;//....................................20-IPI-Aliq
						 ENTDET->ED_IPI,;//.....................................21-IPI-Vlr
						 cRT[3],;//.............................................22-PIS-CST-Situação Trib
						 pb_divzero(ENTDET->ED_FVLPIS,cRT[4]/100),;//...........23-PIS-Vlr Base
						 cRT[4],;//.............................................24-PIS-Aliq
						 0.00,;//...............................................25-PIS-Base Quantidade (Branco)
						 0.00,;//...............................................26-PIS-Aliq (Reais=Branco)
						 ENTDET->ED_FVLPIS,;//..................................27-PIS-Vlr
						 cRT[5],;//.............................................28-COFINS-CST-Situação Trib
						 pb_divzero(ENTDET->ED_VLCOFI,cRT[6]/100),;//...........29-COFINS-Vlr Base
						 cRT[6],;//.............................................30-COFINS-Aliq
						 0.00,;//...............................................31-COFINS-Base Quantidade (Branco)
						 0.00,;//...............................................32-COFINS-Aliq (Reais=Branco)
						 ENTDET->ED_VLCOFI,;//..................................33-COFINS-Vlr
						 '',;//.................................................34-Conta Contábil
						 upper(PROD->PR_DESCR),;//..............................35-Descricao Produto/Item
						 upper(UNIDADE->UN_DESCR),;//...........................36-Descricao da Unidade
						 cTpItem,;//............................................37-Tipo de Item (ESTOQUE.ARR)-Caractere
						 PROD->PR_CODGEN,;//....................................38-Cód.Genero Item NCM-EX
						 0,;//..................................................39-Cod.Produto=Serviço Lei Federal compl 116/03
						 PROD->PR_PICMS,;//.....................................40-ICMS Interna - operações estaduais
						 cRT[3],;//.............................................41-CST -> PIS/COFINS
						 upper(NATOP->NO_DESCR),;//.............................42-Descr Natureza Operacao
						 PROD->PR_CLCONS,;//....................................43-Energia-Classe Consumo   (REG=45 Campo=02 - PH)
						 PROD->PR_TPLIGA,;//....................................44-Energia-Cod Tipo Ligação (REG=45 Campo=25 - PH)
						 PROD->PR_GRTENS,;//....................................45-Energia-Grupo Tensão     (REG=45 Campo=26 - PH)
						 PROD->PR_TPASSI,;//....................................46-Energia-Tipo Assinant    (REG=45 Campo=27 - PH)
						 PROD->PR_CODNCM,;//....................................47-NCM-
						 PROD->PR_ITEMTAB,;//...................................48-Item-Tabela PIS/COFINS (4.3.10..4.3.16)
						 upper(PROD->PR_COMPL),;//..............................49-Descricao Complementa do produto
						 ENTDET->ED_ISENT,;//...................................50-ICMS-Vlr Isentas
						 ENTDET->ED_OUTRA,;//...................................51-ICMS-Vlr Outros
						 NATOP->NO_CDVLFI,;//...................................52-LIVRO-Tipo Operação (1,2,3..)
						 vUniPr,;//.............................................53-Valor Unit Produto
						 '';
						})
						
		//...........................................................................SOMA PARA REGISTROS C190
		//CalcResumoIMP(	ENTDET->ED_CODTR,;//..........01-Código Tributário
		//					ENTDET->ED_CODOP,;//..........02-Natureza Operacao
		//					vPERICMS,;//..................03-Perc ICMS
		//					vBASICMS,;//..................04-Valor Base ICMS
		//					vVLRICMS,;//..................05-Valor ICMS
		//					cValor)//.....................06-Valor Total Item
	end
	dbskip()
end
select ENTCAB
return aNF

*-----------------------------------------------------------------------*
function RtSaida() // processa uma NF de Saida
*-----------------------------------------------------------------------*
cRT:={'0',;//..............................1-Emissão de Terceiros(1) Emissão Própria(0)
		'01',;//.............................2-Modelo do documento conforme 4.1.1 (ato cotep)
		'08',;//.............................3-Situação Trib PIS
		0.00,;//.............................4-Aliq PIS
		'08',;//.............................5-Situação Trib COFINS
		0.00}//..............................6-Aliq COFINS

	aCodEst:=restarray('ESTOQUE.ARR') // Carregar itens

	cRT[2]:=VERSERIE(PEDCAB->PC_SERIE,PEDCAB->PC_NRNF)
	dDTSAI:=if(Empty(PEDCAB->PC_DTSAI),PEDCAB->PC_DTEMI,PEDCAB->PC_DTSAI) // Campo colocado em 05/2012 - pode estar vazio antes disso
	
aNF:={'S',;//...............................01-Tipo Nota Fiscal (E=Entrada / S=Saida)
		cRT[1],;//............................02-Tipo NF (1=Terceiro/0=Proprio)
		PEDCAB->PC_CODCL,;//..................03-Codigo Emitente
		PEDCAB->PC_NRNF,;//...................04-Nr Documento
		PEDCAB->PC_SERIE,;//..................05-Serie do Documento
		cRT[2],;//............................06-Modelo do documento conforme 4.1.1 (ato cotep)
		if(PEDCAB->PC_FLCAN,'02','00'),;//....07-Tabela Situação do Documento 4.1.2 (ato cotep)
		PEDCAB->PC_DTEMI,;//..................08-DT Emissão
		dDTSAI,;//............................09-DT Entrada/Saida
		PEDCAB->PC_TOTAL+abs(PEDCAB->PC_DESC),;//..10-Valor total do documento fiscal
		if(PEDCAB->PC_FATUR>0,1,0),;//........11-Parcelamento (0=Vista,1=Parcelado)
		PEDCAB->PC_DESC,;//...................12-Valor Total do Desconto
		0.00,;//..............................13-Abatimento não Tributado
		PEDCAB->PC_TOTAL,;//..................14-Valor das mercadorias constantes no documento fiscal
		PEDCAB->TR_TIPO,;//...................15-Tipo Frete (1=Emitente 2=Destinatário 3-Sem) há outros (ato cotep)
		0.00,;//..............................16-Valor do frete indicado no documento fiscal
		0.00,;//..............................17-Valor do seguro indicado no documento fiscal
		0.00,;//..............................18-Valor Despesas Assesórias
		0.00,;//..............................19-Valor da Base de cálculo do ICMS-------------------->(Somar dos itens)
		0.00,;//..............................20-Valor do ICMS--------------------------------------->(Somar dos itens)
		0.00,;//..............................21-Valor da base de cálculo do ICMS substituição tributária
		0.00,;//..............................22-Valor do ICMS retido por substituição tributária
		0.00,;//..............................23-Valor total do IPI
		0.00,;//..............................24-Valor total do PIS
		0.00,;//..............................25-Valor total da COFINS
		0.00,;//..............................26-Valor total do PIS retido por substituição tributária
		0.00,;//..............................27-Valor total da COFINS retido por substituição tributária
		PEDCAB->PC_NFEKEY,;//.................28-Chave NFE
		'C',;//...............................29-Tipo de sistema (C=CFE S=SAG)
		PEDCAB->PC_PEDID,;//..................30-Contole Interno
		PEDCAB->PC_TPDOC,;//..................31-Tipo de Documento (CT, NF, ...)
		PEDCAB->PC_FLCAN,;//..................32-NF Cancelada?
		PEDCAB->PC_OBSER,;//..................33-OBS
		0.00,;//..............................34-nill
		0.00,;//..............................35-nill
		0.00,;//..............................36-nill
		0.00,;//..............................37-nill
		0.00,;//..............................38-nill
		0.00,;//..............................39-nill
		{},;//................................40-Frete
		{},;//................................41-Parcelamento
		{},;//................................42-Produtos da NF
		{},;//................................43-Resumo Fiscal
		}
		aNF[40]:={	PEDCAB->TR_CODTRA,;//.....01-Codigo Transportador
						PEDCAB->TR_NOME,;//.......02-Nome do Transportador
						'',;//....................03-
						'',;//....................04-
						'',;//....................05-
						'',;//....................06-
						'',;//....................07-
						'',;//....................08-
						'',;//....................09-
						'',;//....................10-
						'',;//....................11-
						'',;//....................12-
						'',;//....................13-
						'',;//....................14-
						PEDCAB->TR_QTDEM,;//......15-Qtda Volumes
						PEDCAB->TR_ESPE,;//.......16-Especie Volume
						PEDCAB->TR_PBRU,;//.......17-Peso Bruto
						PEDCAB->TR_PLIQ,;//.......18-Peso Liquido
						PEDCAB->TR_TIPO,;//.......19-Tipo Frete
						PEDCAB->TR_PLACA,;//......20-Identificação veiulo
						PEDCAB->TR_UFT,;//........21-UF da Placa do Transportador
					}
		
*/
//.................................................................Processa detalhes da NF (itens da NF)
select PEDDET
//if !dbseek(str(PEDCAB->PC_PEDID,6),.T.)
//	alert('ERRO na NF-Saida;Nr:'+str(PEDCAB->PC_NRNF,8)+' Serie:'+PEDCAB->PC_SERIE+';Fornecedor:'+str(PEDCAB->PC_CODCL,5)+';Nao tem Itens.')
//	@23,00 say '*ERRO na NF-Saida* Nr:'+str(PEDCAB->PC_NRNF,8)+' Serie:'+PEDCAB->PC_SERIE+'-Fornecedor:'+str(PEDCAB->PC_CODCL,5)+'-Nao tem Itens.'
//	strFile(cConteudo,'C:\TEMP\SPEDERR.TXT',.T.)
//end
dbseek(str(PEDCAB->PC_PEDID,6),.T.)
while !eof().and.PEDDET->PD_PEDID==PEDCAB->PC_PEDID.and.!PEDCAB->PC_FLCAN // se NF for cancelada não listar itens
	if FISACOF->(dbseek(PEDDET->PD_CODCOF+CLIENTE->CL_TIPOFJ,.T.))
		cRT[3]:=FISACOF->CO_TIPOIN
		cRT[4]:=FISACOF->CO_PERC1
		cRT[5]:=FISACOF->CO_TIPOIN
		cRT[6]:=FISACOF->CO_PERC2
	end
	PROD-> (dbseek(str(PEDDET->PD_CODPR,L_P))) // Buscar Produto
	NATOP->(dbseek(str(PEDDET->PD_CODOP,7)))	// Buscar CFOP
	cUnd:=PROD->PR_UND
	if empty(cUnd)
		cUnd:='UN   '
	end
	UNIDADE->(dbseek(cUnd)) // Buscar descr Unidade

	//...............................Ajustes no CTS -> ICMS
	vBASICMS:=PEDDET->PD_BAICM
	vPERICMS:=PEDDET->PD_ICMSP
	vVLRICMS:=PEDDET->PD_VLICM
	if PEDDET->PD_CODTR+'#'$'030#040#041#050#060#'
		vBASICMS:=0
		vPERICMS:=0
		vVLRICMS:=0
	end
	*----------------------------------------------------Tipo item
	cTpItem:=ascan(aCodEst,{|DET|DET[1]==PROD->PR_CTB})
	if cTpItem > 0
		cTpItem:=pb_zer(aCodEst[cTpItem][3],2)//....................Tipo Item
	else
		cTpItem:=pb_zer(99,2) //....................................Tipo Item = Se não achar nenhum colocar 99
	end
	cValor:=max(trunca(PEDDET->PD_QTDE*PEDDET->PD_VALOR,2),0.01) // Valor do Produto
	aadd(aNF[42],;
						{PEDDET->PD_ORDEM,;//...................................01-Sequencia Prod.
						 PEDDET->PD_CODPR,;//...................................02-Cod Produto
						 PEDDET->PD_QTDE,;//....................................03-Quantidade Saida
						 cUnd,;//...............................................04-Unidade Saida
						 abs(PEDDET->PD_DESCV+PEDDET->PD_DESCG),;//.............05-Vlr Desconto Item
						 cValor,;//.............................................06-Vlr Produto
						 0,;//..................................................07-Movim Estoque(0=Sim/1=Sim)
						 PEDDET->PD_CODTR,;//...................................08-Situação Trib ICMS
						 PEDDET->PD_CODOP,;//...................................09-CFOP-Cod Operacao CFE/SAG
						 vBASICMS,;//...........................................10-Vlr Base ICMS
						 vPERICMS,;//...........................................11-Aliq ICMS
						 vVLRICMS,;//...........................................12-Vlr ICMS
						 0.00,;//...............................................13-ICMS Substituicao-Vlr Base 
						 0.00,;//...............................................14-ICMS Substituicao-Aliq
						 0.00,;//...............................................15-ICMS Substituicao-Vlr
						 0,;//..................................................16-Periodo Apuracao IPI (IND_APUR)
						 '',;//.................................................17-Cód Sit Trib ref IPI, conforme a Tabela indicada no item 4.3.2.
						 '',;//.................................................18-Cód Enquadr Legal do IPI(Branco)
						 0.00,;//...............................................19-Vlr Base IPI
						 0.00,;//...............................................20-Aliq IPI
						 0.00,;//...............................................21-Vlr IPI
						 cRT[3],;//.............................................22-Situação Trib PIS
						 pb_divzero(PEDDET->PD_VLPIS,cRT[4]/100),;//............23-Vlr Base PIS
						 cRT[4],;//.............................................24-Aliq PIS
						 0.00,;//...............................................25-Base Quantidade PIS (Branco)
						 0.00,;//...............................................26-Aliq PIS (Reais=Branco)
						 PD_VLPIS,;//...........................................27-Vlr PIS
						 cRT[5],;//.............................................28-Situação Trib COFINS
						 pb_divzero(PEDDET->PD_VLCOFI,cRT[6]/100),;//...........29-Vlr Base COFINS
						 cRT[6],;//.............................................30-Aliq COFINS
						 0.00,;//...............................................31-Base Quantidade COFINS (Branco)
						 0.00,;//...............................................32-Aliq COFINS (Reais=Branco)
						 PEDDET->PD_VLCOFI,;//..................................33-Vlr COFINS
						 '',;//.................................................34-Conta Contábil
						 upper(PROD->PR_DESCR),;//..............................35-Descricao Produto/Item
						 upper(UNIDADE->UN_DESCR),;//...........................36-Descricao da Unidade
						 cTpItem,;//............................................37-Tipo de Item (ESTOQUE.ARR)-Caractere
						 PROD->PR_CODGEN,;//....................................38-Cód.Genero Item
						 0,;//..................................................39-Cod.Produto=Serviço Lei Federal Compl 116/03
						 PROD->PR_PICMS,;//.....................................40-ICMS Interna - operações estaduais
						 cRT[3],;//.............................................41-CST -> PIS/COFINS
						 upper(NATOP->NO_DESCR),;//.............................42-Descr Natureza Operacao
						 PROD->PR_CLCONS,;//....................................43-Energia-Classe Consumo   (REG=45 Campo=02 - PH)
						 PROD->PR_TPLIGA,;//....................................44-Energia-Cod Tipo Ligação (REG=45 Campo=25 - PH)
						 PROD->PR_GRTENS,;//....................................45-Energia-Grupo Tensão     (REG=45 Campo=26 - PH)
						 PROD->PR_TPASSI,;//....................................46-Energia-Tipo Assinant    (REG=45 Campo=27 - PH)
						 PROD->PR_CODNCM,;//....................................47-Cod.NomenclaturaMercosul
						 PROD->PR_ITEMTAB,;//...................................48-Item-Tabela PIS/COFINS (4.3.10..4.3.16)
						 upper(PROD->PR_COMPL),;//..............................49-Descricao Complementa do produto
						 PEDDET->PD_VLRIS,;//...................................50-ICMS-Vlr Isentas
						 PEDDET->PD_VLROU,;//...................................51-ICMS-Vlr Outros
						 NATOP->NO_CDVLFI,;//...................................52-LIVRO-Tipo Operação (1,2,3..)
						 '';
						})
	//...........................................................................SOMA PARA REGISTROS C190
	//CalcResumoIMP(	PEDDET->PD_CODTR,;//..........01-Código Tributário
	//					PEDDET->PD_CODOP,;//..........02-Natureza Operacao
	//					vPERICMS,;//..................03-Perc ICMS
	//					vBASICMS,;//..................04-Valor Base ICMS
	//					vVLRICMS,;//..................05-Valor ICMS
	//					cValor)//.....................06-Valor Total Item 
	skip
end
select PEDCAB
return aNF

*-----------------------------------------------------------------------*
function RtSAG() // processa uma NF de Saida/Entrada - SAG
*-----------------------------------------------------------------------*
cRT:={'0',;//..............................1-Emissão de Terceiros(1) Emissão Própria(0)
		'01',;//.............................2-Modelo do documento conforme 4.1.1 (ato cotep)
		'08',;//.............................3-Situação Trib PIS
		0.00,;//.............................4-Aliq PIS
		'08',;//.............................5-Situação Trib COFINS
		0.00}//..............................6-Aliq COFINS

		aCodEst:=restarray('ESTOQUE.ARR') // Carregar itens

		cRT[2]:=VERSERIE(NFC->NF_SERIE,NFC->NF_NRNF)
	
aNF:={NFC->NF_TIPO,;//..........................01-Tipo Nota Fiscal (E=Entrada / S=Saida)
		cRT[1],;//................................02-Tipo NF (1=Terceiro/0=Proprio)
		NFC->NF_EMIT,;//..........................03-Codigo Emitente
		NFC->NF_NRNF,;//..........................04-Nr Documento
		NFC->NF_SERIE,;//.........................05-Serie do Documento
		cRT[2],;//................................06-Modelo do documento conforme 4.1.1 (ato cotep)
		if(NFC->NF_FLCAN,'02','00'),;//...........07-Tabela Situação do Documento 4.1.2 (ato cotep)
		NFC->NF_DTEMI,;//.........................08-DT Emissão
		NFC->NF_DTEMI,;//.........................09-DT Entrada/Saida
		NFC->NF_VLRTOT,;//........................10-Valor total do documento fiscal -abs(NFC->NF_VLRDESG+NFC->NF_VLRDESI
		if(NFC->NF_FATUR>0,1,0),;//...............11-Parcelamento (0=Vista,1=Parcelado)
		0,;//.....................................12-Valor total do desconto NFC->NF_VLRDESG+NFC->NF_VLRDESI
		0.00,;//..................................13-Abatimento não tributado
		NFC->NF_VLRTOT,;//........................14-Valor das mercadorias constantes no documento fiscal -abs(NFC->NF_VLRDESG+NFC->NF_VLRDESI)
		NFC->TR_TIPO,;//..........................15-Tipo Frete (1=Emitente 2=Destinatário) há outros (ato cotep)
		0.00,;//..................................16-Valor do frete indicado no documento fiscal
		0.00,;//..................................17-Valor do seguro indicado no documento fiscal
		0.00,;//..................................18-Valor Despesas Assesórias
		0.00,;//..................................19-Valor da Base de cálculo do ICMS ------------------->(Somar dos itens)
		0.00,;//..................................20-Valor do ICMS -------------------------------------->(Somar dos itens)
		0.00,;//..................................21-Valor da base de cálculo do ICMS substituição tributária
		0.00,;//..................................22-Valor do ICMS retido por substituição tributária
		0.00,;//..................................23-Valor total do IPI
		0.00,;//..................................24-Valor total do PIS
		0.00,;//..................................25-Valor total da COFINS
		0.00,;//..................................26-Valor total do PIS retido por substituição tributária
		0.00,;//..................................27-Valor total da COFINS retido por substituição tributária
		NFC->NF_NFEKEY,;//........................28-Chave NFE
		'S',;//...................................29-Tipo de sistema (C=CFE S=SAG)
		NFC->NF_NRNF,;//..........................30-Codigo Interno
		NFC->NF_TPDOC,;//.........................31-Tipo de Documento (CT, NF, ...)
		NFC->NF_FLCAN,;//.........................32-NF Cancelada
		NFC->NF_OBS1,;//..........................33-OBS
		0.00,;//..................................34-nill
		0.00,;//..................................35-nill
		0.00,;//..................................36-nill
		0.00,;//..................................37-nill
		0.00,;//..................................38-nill
		0.00,;//..................................39-nill
		{},;//....................................40-Frete
		{},;//....................................41-Parcelamento
		{},;//....................................42-Produtos da NF
		{},;//....................................43-Resumo Fiscal
		}
		aNF[40]:={	NFC->TR_CODTRA,;//.....01-Codigo Transportador
						NFC->TR_NOME,;//.......02-Nome do Transportador
						'',;//....................03-
						'',;//....................04-
						'',;//....................05-
						'',;//....................06-
						'',;//....................07-
						'',;//....................08-
						'',;//....................09-
						'',;//....................10-
						'',;//....................11-
						'',;//....................12-
						'',;//....................13-
						'',;//....................14-
						NFC->TR_QTDEM,;//......15-Qtda Volumes
						NFC->TR_ESPE,;//.......16-Especie Volume
						NFC->TR_PBRU,;//.......17-Peso Bruto
						NFC->TR_PLIQ,;//.......18-Peso Liquido
						NFC->TR_TIPO,;//.......19-Tipo Frete
						NFC->TR_PLACA,;//......20-Identificação veiulo
						NFC->TR_UFT,;//........21-UF da Placa do Transportador
					}

*..........Processa detalhes da NF (itens da NF)
select NFD
//if !dbseek(NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6),.T.)
//	@23,00 say '*ERRO na NF-SAG* Nr:'+str(NFC->NF_NRNF,6)+' Serie:'+NFC->NF_SERIE+'-Fornecedor:'+str(NFC->NF_EMIT,5)+'-Nao tem Itens.'
//	strFile(cConteudo,'C:\TEMP\SPEDERR.TXT',.T.)
//end
dbseek(NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6),.T.)
//alert('SAG.NFC='+NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6))
//dbedit()
while !eof().and.	NFD->ND_TIPO+NFD->ND_SERIE+str(NFD->ND_NRNF,6)==NFC->NF_TIPO+NFC->NF_SERIE+str(NFC->NF_NRNF,6) .and.;
		!NFC->NF_FLCAN // Nfs canceladas não deve gerar os itens.
	if FISACOF->(dbseek(NFD->ND_CODCOF+CLIENTE->CL_TIPOFJ,.T.))
		cRT[3]:=FISACOF->CO_TIPOIN
		cRT[4]:=FISACOF->CO_PERC1
		cRT[5]:=FISACOF->CO_TIPOIN
		cRT[6]:=FISACOF->CO_PERC2
	end
	PROD-> (dbseek(str(NFD->ND_CODPR,L_P))) // Buscar Produto
	NATOP->(dbseek(str(NFD->ND_CODOP,7)))	// Buscar CFOP
	cUnd:=PROD->PR_UND
	if empty(cUnd)
		cUnd:='UN   '
	end
	UNIDADE->(dbseek(cUnd))
	
	//...............................Ajustes no CTS -> ICMS
	vBASICMS:=NFD->ND_BASICMS
	vPERICMS:=NFD->ND_PERICMS
	vVLRICMS:=NFD->ND_VLRICMS
	if NFD->ND_CODTR+'#'$'030#040#041#050#060#'
		vBASICMS:=0
		vPERICMS:=0
		vVLRICMS:=0
	end
	*----------------------------------------------------Tipo item
	cTpItem:=ascan(aCodEst,{|DET|DET[1]==PROD->PR_CTB})
	if cTpItem > 0
		cTpItem:=pb_zer(aCodEst[cTpItem][3],2)//....................Tipo Item
	else
		cTpItem:=pb_zer(99,2) //....................................Tipo Item = Se não achar nenhum colocar 99
	end

	aadd(aNF[42],;
						{NFD->ND_ORDEM,;//......................................01-Sequencia Prod
						 NFD->ND_CODPR,;//......................................02-Cod Produto
						 NFD->ND_QTDE,;//.......................................03-Quantidade Saida
						 cUnd,;//...............................................04-Unidade Saida
						 abs(NFD->ND_VLRDESP+NFD->ND_VLRDESI),;//...............05-Vlr Desconto
						 NFD->ND_VLRTOT,;//.....................................06-Vlr Produto
						 0,;//..................................................07-Movim Estoque(0=Sim/1=Sim)
						 NFD->ND_CODTR,;//......................................08-Situação Trib ICMS
						 NFD->ND_CODOP,;//......................................09-Cod Operacao CFE/SAG
						 vBASICMS,;//...........................................10-Vlr Base ICMS
						 vPERICMS,;//...........................................11-Aliq ICMS
						 vVLRICMS,;//...........................................12-Vlr ICMS
						 0.00,;//...............................................13-ICMS Substituicao-Vlr Base 
						 0.00,;//...............................................14-ICMS Substituicao-Aliq
						 0.00,;//...............................................15-ICMS Substituicao-Vlr
						 0,;//..................................................16-Periodo Apuracao IPI (IND_APUR)
						 '',;//.................................................17-Cód Sit Trib ref IPI, conforme a Tabela indicada no item 4.3.2.
						 '',;//.................................................18-Cód Enquadr Legal do IPI(Branco)
						 0.00,;//...............................................19-Vlr Base IPI
						 0.00,;//...............................................20-Aliq IPI
						 0.00,;//...............................................21-Vlr IPI
						 cRT[3],;//.............................................22-Situação Trib PIS
						 0.00,;//...............................................23-Vlr Base PIS
						 cRT[4],;//.............................................24-Aliq PIS
						 0.00,;//...............................................25-Base Quantidade PIS (Branco)
						 0.00,;//...............................................26-Aliq PIS (Reais=Branco)
						 0.00,;//...............................................27-Vlr PIS
						 cRT[5],;//.............................................28-Situação Trib COFINS
						 0.00,;//...............................................29-Vlr Base COFINS
						 cRT[6],;//.............................................30-Aliq COFINS
						 0.00,;//...............................................31-Base Quantidade COFINS (Branco)
						 0.00,;//...............................................32-Aliq COFINS (Reais=Branco)
						 0.00,;//...............................................33-Vlr COFINS
						 '',;//.................................................34-Conta Contábil
						 upper(PROD->PR_DESCR),;//..............................35-Descricao Produto/Item
						 upper(UNIDADE->UN_DESCR),;//...........................36-Descricao da Unidade
						 cTpItem,;//............................................37-Tipo de Item (ESTOQUE.ARR)-Caractere
						 PROD->PR_CODGEN,;//....................................38-Cód.Genero Item
						 0,;//..................................................39-Cod.Produto=Serviço Lei Federal compl 116/03
						 PROD->PR_PICMS,;//.....................................40-ICMS Interna - Operações Estaduais
						 cRT[3],;//.............................................41-CST -> PIS/COFINS
						 upper(NATOP->NO_DESCR),;//.............................42-Descr Natureza Operacao
						 PROD->PR_CLCONS,;//....................................43-Energia-Classe Consumo   (REG=45 Campo=02 - PH)
						 PROD->PR_TPLIGA,;//....................................44-Energia-Cod Tipo Ligação (REG=45 Campo=25 - PH)
						 PROD->PR_GRTENS,;//....................................45-Energia-Grupo Tensão     (REG=45 Campo=26 - PH)
						 PROD->PR_TPASSI,;//....................................46-Energia-Tipo Assinant    (REG=45 Campo=27 - PH)
						 PROD->PR_CODNCM,;//....................................47-Cod.NomenclaturaMercosul
						 PROD->PR_ITEMTAB,;//...................................48-Item-Tabela PIS/COFINS (4.3.10..4.3.16)
						 upper(PROD->PR_COMPL),;//..............................49-Descricao Complementa do produto
						 NFD->ND_ISEICMS,;//....................................50-ICMS-Vlr Isentas
						 NFD->ND_OUTICMS,;//....................................51-ICMS-Vlr Outros
						 NATOP->NO_CDVLFI,;//...................................52-LIVRO-Tipo Operação (1,2,3..)
						 '';
						})
	skip
end
select NFC
return aNF

*----------------------------------------------------------------------------------------------------------------*
	static function CalcResumoIMP(pCODTR,pCODOP,pPERICMS,pBASICMS,pVLRICMS,pVLRTOT) // Gera resumo para C0190
*----------------------------------------------------------------------------------------------------------------*
if pCODTR+'#'$'030#040#041#050#060#'
	pBASICMS:=0
	pPERICMS:=0
	pVLRICMS:=0
end
cKey:=pCODTR+'|'+left(pb_zer(pCODOP,7),4)+'|'+AllTrim(transform(pPERICMS,mI132))+'|'
if len(aNF[43])<1
	aadd(	aNF[43],;
			{cKey,;
				0,;//.......02-VL_OPR
				0,;//.......03-VL_BC_ICMS
				0,;//.......04-VL_ICMS
				0,;//.......05-VL_BC_ICMS_ST
				0,;//.......06-VL_ICMS_ST
				0,;//.......07-VL_RED_BC
				0,;//.......08-VL_IPI
				'';//.......09-COD_OBS
				})
end
nKey:=ASCAN(aNF[43],{|COD|COD[1]==cKey})
if nKey==0
	aadd(	aNF[43],;
			{cKey,;
				0,;//.......02-VL_OPR
				0,;//.......03-VL_BC_ICMS
				0,;//.......04-VL_ICMS
				0,;//.......05-VL_BC_ICMS_ST
				0,;//.......06-VL_ICMS_ST
				0,;//.......07-VL_RED_BC
				0,;//.......08-VL_IPI
				'';//.......09-COD_OBS
				})
	nKey:=len(aNF[43]) //....Ultimo registro Criado
end
aNF[43][nKey][02]+=pVLRTOT
aNF[43][nKey][03]+=pBASICMS
aNF[43][nKey][04]+=pVLRICMS
aNF[43][nKey][07]+=0
if pCODTR+'#'$'020#070#'
	aNF[43][nKey][07]+=max(pVLRTOT-pBASICMS,0)
end
aNF[19]+=pBASICMS	// Base ICMS
aNF[20]+=pVLRICMS	// Vlr ICMS

return NIL
//......................................................EOF..................................................
