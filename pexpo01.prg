*----------------------------------------------------------------------------------------*
static aVariav:= { 0,0,1,2003,'','',0,'','','', 0,.F.,'', 0, 0,'','','',{},'','','','', 0}
 //................1.2.3....4..5..6.7..8..9.10.11, 12.13.14.15.16.17.18.19.20.21.22.23,24
*----------------------------------------------------------------------------------------*
#xtranslate nX       	=> aVariav\[  1 \]
#xtranslate nY       	=> aVariav\[  2 \]
#xtranslate nMES     	=> aVariav\[  3 \]
#xtranslate nANO     	=> aVariav\[  4 \]
#xtranslate cArqE    	=> aVariav\[  5 \]
#xtranslate cArqS    	=> aVariav\[  6 \]
#xtranslate nNrReg   	=> aVariav\[  7 \]
#xtranslate dInic    	=> aVariav\[  8 \]
#xtranslate dFinal   	=> aVariav\[  9 \]
#xtranslate cTipoCli 	=> aVariav\[ 10 \]
#xtranslate nCGC     	=> aVariav\[ 11 \]
#xtranslate lProcSAG 	=> aVariav\[ 12 \]
#xtranslate cEnquadr 	=> aVariav\[ 13 \]
#xtranslate nVlrNFE		=> aVariav\[ 14 \]
#xtranslate nVlrNFS		=> aVariav\[ 15 \]
#xtranslate cTabPISC		=> aVariav\[ 16 \]
#xtranslate cItTabPISC	=> aVariav\[ 17 \]
#xtranslate cGInvent		=> aVariav\[ 18 \]
#xtranslate aCodEst		=> aVariav\[ 19 \]
#xtranslate cTpItem		=> aVariav\[ 20 \]
#xtranslate cCST			=> aVariav\[ 21 \]
#xtranslate dInven		=> aVariav\[ 22 \]
#xtranslate cCodSVC		=> aVariav\[ 23 \]
#xtranslate cPICMS		=> aVariav\[ 24 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function PEXPO01()	// Exportacao de Dados
*-----------------------------------------------------------------------------*
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CODTR',;
				'R->CTRNF',;
				'R->NATOP',;
				'R->ALIQUOTAS',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->PEDSVC',;
				'R->SALDOS',;
				'R->CLIENTE',;
				'R->ATIVIDAD',;
				'R->GRUPOS',;
				'R->FISACOF',;
				'R->UNIDADE',;
				'R->PEDPARC',;
				'R->PROD'})
	return NIL
end
*--------------------------------------------------------VERIFICAR ARQUIVOS DO SAG (SISTEMA ARMAZENAMENTO DE GRAOS)
lProcSAG:=.F.
if file('..\SAG\SAGANFC.DBF').and.;
	file('..\SAG\SAGANFD.DBF')
	if file('..\SAG\SAGANFC.CDX').and.;
		file('..\SAG\SAGANFD.CDX')
		if !abre({	;
						'R->NFD',;
						'R->NFC';
						})
			alert('SAG;Arquivos do SAG en uso; nao puderam ser abertos.')
			dbcloseall()
			return NIL
		else
			select NFD
			ORDEM CODIGO // MANTER ESTE INDICE SELECIONADO PARA DETALHES DA NF SAG
			lProcSAG:=.T.
		end
	else
		alert('SAG;Nao encontrado arquivos de indices;deve-se entrar no sag para regerar')
		dbcloseall()
		return NIL
	end
end
*--------------------------------------------------------------------------------------------------------------------
select('PROD')
ORDEM CODIGO
DbGoTop()
aData   :={bom(PARAMETRO->PA_DATA),bom(PARAMETRO->PA_DATA)}
nMES    := month(bom(PARAMETRO->PA_DATA)-1)
nANO    :=  year(bom(PARAMETRO->PA_DATA)-1)
cGInvent:='N'
pb_box(14,19,,,,'Exportar Dados Fiscais (Entrada/Saida) - PH-v:8.53')
@15,21 say 'Mes.................:' get nMES     pict mI2  valid nMES > 0    .and. nMES < 13
@16,21 say 'Ano.................:' get nANO     pict mI4  valid nANO > 1990 .and. nANO <= year(PARAMETRO->PA_DATA)
@17,21 say 'Gerar Reg Inventario?' get cGInvent pict mUUU valid cGInvent$'SN' when pb_msg('Gerado Reg. Inventario 75, 76 e 77 de 31/12 do ano anterior ao definido acima')
read
if lastkey()#27.and.pb_sn('CONFIRME;Exportar dados de Entrada e Saida')
	
	cArqE :='C:\TEMP\PH_E'+right(pb_zer(nANO,4),2)+pb_zer(nMES,2)+'.TXT'
	cArqS :='C:\TEMP\PH_S'+right(pb_zer(nANO,4),2)+pb_zer(nMES,2)+'.TXT'
	@19,21 say 'Arq.Entrada: '+cArqE
	@20,21 say 'Arq.Saida..: '+cArqS
	aCodEst:=RestArray('ESTOQUE.ARR') // Carregar itens
	dInic  :=ctod('01/'+pb_zer(nMES,2)+'/'+pb_zer(nANO,4))
	dFinal :=eom(dInic)
	dInven :=boy(dFinal)-1 // fim do ano anterior
	@17,50 say 'Ref:'+DtoC(dInven) color 'Gr+/G'
	*-------------------------------------------------------------* ENTRADAS
	pb_msg('Exportanto NF Entradas...')
	set print to (cArqE)
	set print on
	set console off
	nNrReg:=0
	GravaTXT(10,;
				padr(SONUMEROS(PARAMETRO->PA_CGC),  14)+;
				padr(SONUMEROS(PARAMETRO->PA_INSCR),15)+;
				pb_zer(nMES,                         2)+;
				pb_zer(nANO,                         4);
				)
	
	ProEntrCFE({dInic,dFinal}) // PEXPO01E.PRG
	
	if lProcSAG
		ProEntrSAG({dInic,dFinal}) // PEXPO02E.PRG
	end
		
	GravaTXT(90,;
				pb_zer(nNrReg+1,5);
				)
	set console ON
	set print OFF
	set print to
	
	*-------------------------------------------------------------* SAIDAS
	pb_msg('Exportanto NF Saidas...')
	set print to (cArqS)
	set print on
	set console off
	nNrReg:=0
	GravaTXT(10,;
				padr(SONUMEROS(PARAMETRO->PA_CGC),14)+;
				padr(SONUMEROS(PARAMETRO->PA_INSCR),15)+;
				pb_zer(nMES,2)+;
				pb_zer(nANO,4);
				)
	
	ProSaidCFE({dInic,dFinal})	//.......PEXPO01S.PRG
	
	if lProcSAG
		ProSaidSAG({dInic,dFinal})	//...PEXPO02S.PRG
	end

	if cGInvent=='S'
		pb_msg('Exportanto Saldo de Estoque...')
		Gera75() // Registros de Inventário (75,76,77)
	end

	GravaTXT(90,;
				pb_zer(nNrReg+1,5);
				)
	set console ON
	set print OFF
	set print to
	alert('Arquivos Gerados..')
end
dbcloseall()
Return NIL

*-----------------------------------------------------------------------------*
	function Gera22(pCodCli) // Tanto para Entrada quanto para Saida - EMITENTE
*-----------------------------------------------------------------------------*
CLIENTE->(dbseek(str(pCodCli,5)))

cTipoCli    := '1'//.................................> Tipo de Cliente/Fornec = Juridico
if CLIENTE->CL_UF=='EX'
	cTipoCli := '0' //................................> Cliente/Fornec Exterior
elseif CLIENTE->CL_TIPOFJ=='F'
	cTipoCli := '2'//.................................> Tipo de Cliente/Fornec = Fisica
end
GravaTXT(22,;//.......................................1
			padr(CLIENTE->CL_RAZAO,40)					+;//..2
			padr(SONUMEROS(CLIENTE->CL_CGC),18)		+;//..3
			cTipoCli											+;//..4 Tipo de Cliente 0,1,2
			if(cTipoCli=='1',padr(SONUMEROS(CLIENTE->CL_INSCR),14),space(14))+;//..5
			padr(trim(CLIENTE->CL_ENDER)+','+trim(CLIENTE->CL_ENDNRO), 40)					+;//..6
			padr(CLIENTE->CL_BAIRRO          ,14)	+;//..........7
			padr(CLIENTE->CL_CEP              ,9)	+;//..........8
			padr(CLIENTE->CL_UF               ,2)	+;//.........09
			padr(pb_zer(CLIENTE->CL_CDIBGE,7),25)	+;//.........10
			pb_zer(0                          ,8)	+;//.........11-Cod contabil para EFPH
			pb_zer(0                         ,12)	+;//.........12-CEI/NIT
			padr(CLIENTE->CL_INSMUN          ,14)	+;//.........13-Inscr Municip
			padr(SONUMEROS(CLIENTE->CL_FONE) ,11)	+;//.........14-Fone
			padr(CLIENTE->CL_NFANTA          ,40)	+;//.........15-Nome Fantasia
			pb_zer(CLIENTE->CL_CDPAIS         ,4)	+;//.........16-Codigo Pais
			'')
return NIL

*------------------------------------------------------------------------------------------
	function Gera30(pModeloNF,pFaturam,pCodEmitente) // Tanto para Entrada quanto para Saida
*-------------------------------------------------------------------------------------------
nCGC:=SONUMEROS(TR_CGC)
if pModeloNF=='2' .and. TR_TIPO <> 3 .and. pCodEmitente <> 34929 // É NF modelo 01 (Tabela D-Entrada Tabela A-Saida) não é CONAB
	cTipoCli:=if(len(alltrim(nCGC))<=11,'2','1') //..> Tipo de Cliente/Fornec = Juridico
	GravaTXT(30,; 											//..1.Informações Reg Mag SRF
				padr(TR_NOME		,35)+;				//..2.Nome Transportador
				padl(nCGC			,14,'0')+;			//..3.CGC Transp
				cTipoCli					 +;				//..4.Tipo 1=CGC.......2=CPF......0=Não
				if(cTipoCli=='2',space(14),padr(SONUMEROS(TR_INCR),14))+;//..5.Incr Estad
				padr(TR_ENDE      ,32)+;				//..6.Endereço Transp
				space(             14)+;				//..7.Bairro
				pb_zer(0           ,8)+;				//..8.CEP
				padr(TR_UFT        ,2)+;				//..9.UF
				padr(TR_MUNI      ,20)+;				//.10.Cidade
				padr('Rodoviario' ,13)+;				//.11.Via Transp
				pb_zer(TR_QTDEM    ,7)+;				//.12.Quantidade Volumes
				padr(TR_ESPE       ,8)+;				//.13.Especie
				pb_zer(TR_PBRU*1000,9)+;				//.14.Peso Bruto
				pb_zer(TR_PLIQ*1000,9)+;				//.15.Peso Liquid
				str(max(TR_TIPO,1), 1)+;				//.16.1-CIF     2-FOB
				padr(TR_PLACA     ,12)+;				//.17.Placa
				if(pFaturam>0,'2','1')+;				//.18.1=Vista   2-Prazo
				space(             14)+;				//.19.Inscr Estad do Substituto Trib
				space(             40)+;				//.20.OBS
				'')
else
	GravaTXT(30,;								  //.........1.Informações Reg Mag SRF
				space(				35)		+;//.........2.Nome Transportador
				space(				14)		+;//.........3.CGC Transp
				' '								+;//.........4.Tipo 1=CGC.......2=CPF......0=Não
				space(				14)		+;//.........5.Incr Estad
				space(				32)		+;//.........6.Endereço Transp
				space(				14)		+;//.........7.Bairro
				pb_zer(0				,8)		+;//.........8.CEP
				space(				02)		+;//.........9.UF
				space(				20)		+;//........10.Cidade
				space(				13)		+;//........11.Via Transp
				pb_zer(0				,7)		+;//........12.Quantidade Volumes
				space(				08)		+;//........13.Especie
				pb_zer(0				,9)		+;//........14.Peso Bruto
				pb_zer(0				,9)		+;//........15.Peso Liquido
				str(0					,1)		+;//........16.0=Sem Frete  1-CIF     2-FOB 
				space(				12)		+;//........17.Placa
				if(pFaturam>0,'2','1')		+;//........18.1=Vista   2-Prazo
				space(				14)		+;//........19.Inscr Estad
				space(				40)		+;//........20.OBS
				'')
end
return NIL

*---------------------------------------------------------------------
	function Gera31(pTipo,aNFEnt) // SPED - Saidas
*---------------------------------------------------------------------
if len(aNFEnt[42])>0 //.....................................NF TEM ITENS PARA SER REPORTADO
	nVlrNFE:=0
	nVlrNFS:=0
	for nX:=1 to len(aNFEnt[42]) // Itens
		cEnquadr  :='0000'
		cTabPISC  :='0'
		cItTabPISC:='000'
		if pTipo=='E'.and.NATOP->NO_FLPISC=='S' //..........................Entrada
			if aNFEnt[42][nX][41]=='50'// CST
				cEnquadr:='2020'
				nVlrNFE+=(aNFEnt[42][nX][06]-aNFEnt[42][nX][05])
			end
		elseif NATOP->NO_FLPISC=='S' //................................Saida
			if     aNFEnt[42][nX][41]=='04'// CST
				cTabPISC:='1'
			elseif aNFEnt[42][nX][41]=='05'// CST
				cTabPISC:='3'
			elseif aNFEnt[42][nX][41]=='06'// CST
				cTabPISC:='4'
			elseif aNFEnt[42][nX][41]=='07'// CST
				cTabPISC:='5'
			elseif aNFEnt[42][nX][41]=='08'// CST
				cTabPISC:='6'
			elseif aNFEnt[42][nX][41]=='09'// CST
				cTabPISC:='7'
			end
			if cTabPISC#'0'
				cItTabPISC:=aNFEnt[42][nX][48]
				cEnquadr  :='1329'
				nVlrNFS   +=(aNFEnt[42][nX][06]-aNFEnt[42][nX][05])
			end
		end
	next
	if nVlrNFS>0
		GravaTXT(31,; //.........................................01.Valores de PIS/COFINS Não-Cumulativos
					pb_zer(0,09)										+;//..02-Revenda Medic/Perf/Hig.
					pb_zer(0,09)										+;//..03-Revenda Combustíveis 
					pb_zer(0,09)										+;//..04-Revenda Veículos Subst.
					pb_zer(0,09)										+;//..05-Revenda Cigarros
					pb_zer(0,09)										+;//..06-Aliq.Difer.Base
					pb_zer(0,09)										+;//..07-Aliq.Difer.Devoluções
					pb_zer(0,09)										+;//..08-Aliq.Difer.Aquisições
					pb_zer(0,09)										+;//..09-Aliq.Difer.Outras Exclusões
					pb_zer(9,01)										+;//..10-Tipo do Produto
					pb_zer(0,09)										+;//..11-Revenda Veículos L10485
					pb_zer(0,09)										+;//..12-Rev.Pneus/Camâras L10485
					pb_zer(0,09)										+;//..13-Venda Anexos I/II L10485
					pb_zer(0,09)										+;//..14-Pneus Camâras Art 5.L10485
					pb_zer(0,09)										+;//..15-Devoluções Ref.Campo 13
					pb_zer(0,09)										+;//..16-Outras Deduções Campo 13
					pb_zer(0,09)										+;//..17-Veículos Art 1.L10485
					pb_zer(0,09)										+;//..18-Devoluções Ref.Campo 17
					pb_zer(0,09)										+;//..19-Outras Deduções Campo 17
					pb_zer(0,09)										+;//..20-Vendas c/Red.Art.1 L10485
					pb_zer(0,09)										+;//..21-Vendas c/Red.Art.1 L10485
					pb_zer(0,09)										+;//..22-Valor Pago Concessionários
					pb_zer(9,01)										+;//..23-Tipo do Produto
					pb_zer(0,08)										+;//..24-Revenda Bebidas
					pb_zer(0,08)										+;//..25-Rev.Mat.Prima Emb.Bebidas
					pb_zer(0,08)										+;//..26-Al.Dif.Venda Bebidas
					pb_zer(0,08)										+;//..27-Al.Dif.Devolução Bebidas
					pb_zer(0,08)										+;//..28-Al.Dif.Revenda Bebidas
					pb_zer(0,08)										+;//..29-Al.Dif.Bebidas/Embalagens
					pb_zer(0,08)										+;//..30-Al.Dif.Aquis.c/Crédito
					pb_zer(0,08)										+;//..31-ICMS/IPI Inclusos no Valor
					pb_zer(nVlrNFS*100,08)							+;//..32-Revenda Outros Produtos
					'')
	end
end
return NIL

*---------------------------------------------------------------------
	function Gera36(pTipo,aNFEnt) // SPED - Entradas
*---------------------------------------------------------------------
if len(aNFEnt[42])>0 //.....................................NF TEM ITENS PARA SER REPORTADO
	nVlrNFE:=0
	nVlrNFS:=0
	for nX:=1 to len(aNFEnt[42]) // Itens
		cEnquadr  :='0000'
		cTabPISC  :='0'
		cItTabPISC:='000'
		if pTipo=='E' //..........................Entrada
			if aNFEnt[42][nX][41]=='50'// CST
				cEnquadr:='2020'
				nVlrNFE+=(aNFEnt[42][nX][06]-aNFEnt[42][nX][05])
			end
		else //...................................Saida
			if     aNFEnt[42][nX][41]=='04'// CST
				cTabPISC:='1'
			elseif aNFEnt[42][nX][41]=='05'// CST
				cTabPISC:='3'
			elseif aNFEnt[42][nX][41]=='06'// CST
				cTabPISC:='4'
			elseif aNFEnt[42][nX][41]=='07'// CST
				cTabPISC:='5'
			elseif aNFEnt[42][nX][41]=='08'// CST
				cTabPISC:='6'
			elseif aNFEnt[42][nX][41]=='09'// CST
				cTabPISC:='7'
			end
			if cTabPISC#'0'
				cItTabPISC:=aNFEnt[42][nX][48]
				cEnquadr  :='1329'
				nVlrNFS   +=(aNFEnt[42][nX][06]-aNFEnt[42][nX][05])
			end
		end
	next
	if nVlrNFE>0
		GravaTXT(36,; //............................................01.Valores de PIS/COFINS Não-Cumulativos
					pb_zer(nVlrNFE*100,10)								+;//..02.Crédito Integral Total 
					pb_zer(0,10)											+;//..03.Créd. Integral Prop 
					pb_zer(0,10)											+;//..04-Créd.Pres.70%/80%-60% Ttal 
					pb_zer(0,10)											+;//..05-Cred.Pres.70%/80%-60% Prop 
					pb_zer(0,10)											+;//..06-Créd.Pres.35% Total
					pb_zer(0,10)											+;//..07-Cred.Pres.35% Prop.
					pb_zer(0,10)											+;//..08-Créd.Pres.40% Total
					pb_zer(0,10)											+;//..09-Cred.Pres.40% Prop.
					pb_zer(0,10)											+;//..10-Créd.Pres.50% Total
					pb_zer(0,10)											+;//..11-Cred.Pres.50% Prop.
					pb_zer(0,10)											+;//..12-Créd.Pres.12% Total
					pb_zer(0,10)											+;//..13-Cred.Pres.12% Prop.
					'')
	end
end
return NIL

*---------------------------------------------------------------------
	function Gera38(pNrParcelas, pFaturamento, pAFAT) // Fatruramento
*---------------------------------------------------------------------
if pNrParcelas>0
	if !empty(pFaturamento)
		for nX:=1 to pNrParcelas
			GravaTXT(38,; //............................................1.Informações Reg Mag SRF
						'00'														+;//..2.Tipo 00=Duplicata
						padr('Duplicata',10)									+;//..3.Descricao
						'00'+substr(pFaturamento,nX*29+00+00-28, 8)	+;//..4.Nr Identificador
						substr(pFaturamento,     nX*29+15+00-28, 2)	+;//..5.Data Vencimento dd
						substr(pFaturamento,     nX*29+12+00-28, 3)	+;//..6.Data Vencimento mm
						substr(pFaturamento,     nX*29+08+00-28, 4)	+;//..7.Data Vencimento aaaa
						pb_zer(SONUMEROS(;
						substr(pFaturamento,     nX*29+08+08-28,12)),10)+;//..8.Valor Duplicata
						'')
		next
	else
		for nX:=1 to pNrParcelas
			GravaTXT(38,; //............................................1.Informações Reg Mag SRF
						'00'														+;//..2.Tipo 00=Duplicata
						padr('Duplicata',10)									+;//..3.Descricao
						pb_zer(      pAFAT[pNrParcelas][1],10)			+;//..4.Nr Identificador
						pb_zer(day  (pAFAT[pNrParcelas][2]),2)			+;//..5.Data Vencimento dd
						pb_zer(month(pAFAT[pNrParcelas][2]),2)			+;//..5.Data Vencimento mm
						pb_zer(year (pAFAT[pNrParcelas][2]),4)			+;//..5.Data Vencimento aaaa
						pb_zer(      pAFAT[pNrParcelas][3]*100,10)	+;//..6.Valor Duplicata
						'')
		next
	end
end
return NIL

*---------------------------------------------------------------------
	function Gera45(pADados) // Energia/Agua/Comunic
*---------------------------------------------------------------------
GravaTXT(45,; //............................................1.Informações Reg Mag SRF
			pADados[1]	+;//..2.Código Classe de Consumo
			space(245-2-2)	+;//..3-24 - Brancos
			pADados[2]	+;//..25.Código Tipo de Ligação
			pADados[3]	+;//..26.Código Grupo de Tensão
			pADados[4]	+;//..27.Código Tipo Assinante
			'')
return NIL

*-----------------------------------------------------------------------------------------------------
	function Gera60(pTipo,aNFEnt,pTipoDoc,pNrNF,pNomeCli) // Itens da NF (60, 61, 62, 31, 36)
*-----------------------------------------------------------------------------------------------------
//------------------------------1+3 e 5 <Não>....................................1+A e G <Não>.......
if (pTipo=='E'.and.pTipoDoc$'2346789ABCDEFGHIJKLM').or.;
	(pTipo=='S'.and.pTipoDoc$'23456789BCDEFHIJKLM')
	if len(aNFEnt[42])>0 //..................................NF TEM ITENS PARA SER REPORTADO
		//GravaTXT(60,; //....................................1.Informações para SPED - Gerar em Branco
		//				'')
		if pTipo=='S'.and.pTipoDoc$'23456789BCDEFHIJKLM'
			GravaTXT(60,; //......................................1.Informações para SPED - Gerar em Branco
							'') // para Saidas = Branco
//			GravaTXT(	60,;
//							if(pTipoDoc=='3','02','  ')+;	// 02=Tipo NF=Consumidor
//							'00'+;								// 03=Regular
//							pb_zer(pNrNF,09)+;				// 04=Nr Documento
//							SONUMEROS(dtoc(aNFEnt[08]))+;	//	05=Data Emissão
//							pb_zer(aNFEnt[14]*100,12,0)+;	// 06=Valor
//							substr(aNFEnt[28],07,14)+;		//	07=CPF/CNPJ
//							padr(pNomeCli,70)+;	//..........08=Nome
//							'')	//............................Branco
		else
			GravaTXT(60,; //......................................1.Informações para SPED - Gerar em Branco
							'') // para entrada = branco
		end
		nVlrNFE:=0
		nVlrNFS:=0
		for nX:=1 to len(aNFEnt[42]) // Itens
			cEnquadr  	:='0000'
			cTabPISC  	:='0'
			cItTabPISC	:='000'
			cCodSVC		:=if(aNFEnt[42][nX][39]>0,pb_zer(aNFEnt[42][nX][39],4),space(4))
			cPICMS		:=if(aNFEnt[42][nX][40]>0,pb_zer(aNFEnt[42][nX][40],4),space(4))
			if pTipo=='E'.and.NATOP->NO_FLPISC=='S' //..........................Entrada e CFOP não Gera PIS/COFINS
				if aNFEnt[42][nX][41]=='50'// CST
					cEnquadr:='2020'
					nVlrNFE+=(aNFEnt[42][nX][06]-aNFEnt[42][nX][05])
				end
			elseif NATOP->NO_FLPISC=='S' //.....................................Saida
				if     aNFEnt[42][nX][41]=='04'// CST
					cTabPISC:='1'
				elseif aNFEnt[42][nX][41]=='05'// CST
					cTabPISC:='3'
				elseif aNFEnt[42][nX][41]=='06'// CST
					cTabPISC:='4'
				elseif aNFEnt[42][nX][41]=='07'// CST
					cTabPISC:='5'
				elseif aNFEnt[42][nX][41]=='08'// CST
					cTabPISC:='6'
				elseif aNFEnt[42][nX][41]=='09'// CST
					cTabPISC:='7'
				end
				if cTabPISC#'0'.and.NATOP->NO_FLPISC=='S'//........................SAIDA e CFOP não Gera PIS/COFINS
					cItTabPISC:=aNFEnt[42][nX][48]
					cEnquadr  :='1329'
					nVlrNFS   +=(aNFEnt[42][nX][06]-aNFEnt[42][nX][05])
				end
			end
			GravaTXT(61,; //............................................01.Informações Reg Mag SRF
						pb_zer(aNFEnt[42][nX][02],14)						+;//..02.Cod Produto
						space(14)												+;//..03.Alteração Código Item
						padr(alltrim(aNFEnt[42][nX][47])+'000',11)	+;//..04.NCM+Ex=0
						padr(aNFEnt[42][nX][35],  50)						+;//..05.Descricao Produto
						padr(aNFEnt[42][nX][49],  30)						+;//..06.Complemento da Descricao Produto
						padr(aNFEnt[42][nX][04],  10)						+;//..07.Unid Med Produto no Documento
						padr(aNFEnt[42][nX][36],  20)						+;//..08.Descr Unid Med Produto no Documento
						padr(aNFEnt[42][nX][04],  10)						+;//..09.X-Unid Med Produto no Estoque
						padr(aNFEnt[42][nX][36],  20)						+;//..10.X-Descr Unid Med Produto no Documento
						space(15)												+;//..11.Fator Conversão (branco se for igual)
						'P'														+;//..12.<P>roduto ou <S>erviço
						space(09)												+;//..13.Cód Produto Tabela ANP
						space(14)												+;//..14.Cód Barras do Produto
						aNFEnt[42][nX][37]									+;//..15.Tipo Item (2 bytes)
						aNFEnt[42][nX][38]									+;//..16.Genero do Item
						cCodSVC													+;//..17.Codigo Servico Lei Federal 116/03
						cPICMS													+;//..18.Aliq. ICMS Interno (branco se Zero)
						aNFEnt[42][nX][41]									+;//..19.CST PIS/COFINS
						cTabPISC													+;//..20.Tabela PIS/COFINS (4.3.10 até 4.3.16)
						cItTabPISC												+;//..21.Item Tabela PIS/COFINS
						'')

			GravaTXT(62,; //............................................01.Complemento Itens
						pb_zer(aNFEnt[42][nX][03]*100000,13)			+;//..02.QTDE Produto
						space(13)												+;//..03.QTDE Cancelada de Produto //pb_zer(0,13)
						pb_zer(aNFEnt[42][nX][06]*100,12)				+;//..04.Valor Total do Item
						pb_zer(aNFEnt[42][nX][05]*100,12)				+;//..05.Valor Desconto do Item
						if(    aNFEnt[42][nX][07]==0,'S','N')			+;//..06.Movimentação Fisica?
								 aNFEnt[42][nX][08]							+;//..07.CST ICMS
						left(pb_zer(aNFEnt[42][nX][09],7)  ,4)			+;//..08.CFOP DO ITEM
						padr(       aNFEnt[42][nX][42]	 ,25)			+;//..09.Descr CFOP (Natureza Operação)
						pb_zer(		aNFEnt[42][nX][10]*100,12)			+;//..10.Base Calculo ICMS
						pb_zer(		aNFEnt[42][nX][11]*100,04)			+;//..11.Aliquota ICMS
						pb_zer(		aNFEnt[42][nX][12]*100,12)			+;//..12.Valor ICMS
						pb_zer(		aNFEnt[42][nX][13]*100,12)			+;//..13.Base Calculo ICMS-ST
						pb_zer(		aNFEnt[42][nX][14]*100,04)			+;//..14.Aliquota ICMS-ST
						pb_zer(		aNFEnt[42][nX][15]*100,12)			+;//..15.Valor ICMS-ST
						pb_zer(		aNFEnt[42][nX][16]    ,01)			+;//..16.Período Apuração IPI (0=Mensal / 1=Decencial)
						padr(			aNFEnt[42][nX][17]    ,02)			+;//..17.CST-IPI
						padr(			aNFEnt[42][nX][18]    ,03)			+;//..18.Código Enquadramento IPI
						pb_zer(		aNFEnt[42][nX][19]    ,12)			+;//..19.Base de Cálculo do IPI
						pb_zer(		aNFEnt[42][nX][20]*100,05)			+;//..20.Aliquota IPI
						space(06)												+;//..21.Código Selo Controle IPI
						pb_zer(0,09)											+;//..22.Quantidade de selos
						pb_zer(0,05)											+;//..23.Classe Enquadramento IPI
						pb_zer(0,08)											+;//..24.Valor por unidade padrão
						pb_zer(0,08)											+;//..25.Quantidade total produtos
						pb_zer(		aNFEnt[42][nX][21]*100,12)			+;//..26.Valor IPI = IPI do Documento
						cEnquadr													+;//..27.Enquadramento PIS
						cEnquadr													+;//..28.Enquadramento COFINS
						pb_zer(0,07)											+;//..29.Desmembramento Contábil
						space(04)												+;//..30.Código Classif.Energia // pb_zer(0,04)
						space(01)												+;//..31.Tipo Receita Energia/Telec // pb_zer(0,01)
						space(01)												+;//..32.CNPJ Participante // pb_zer(0,14)
						space(10)												+;//..33.Comunicação Telecomun
						'')
		next
	else // sem itens na NF-Entrada ou Saída
		GravaTXT(60,; //............................................1.Informações para SPED - Gerar em Branco
						'')
		GravaTXT(61,; //............................................01.Informações Reg Mag SRF
						'')
		GravaTXT(62,; //............................................01.Informações Reg Mag SRF
						space(139)+'1')
	end
end
return NIL

*---------------------------------------------------------------------
	function Gera75() // Inventário
*---------------------------------------------------------------------
select PROD
go top
while !eof()
	@24,65 say str(PROD->PR_CODPR,14)
	if SALDOS->(dbseek(str(1,2)+left(dtos(dInven),6)+str(PROD->PR_CODPR,L_P)))	// produto não esta na lista de saldos
		if str(SALDOS->SA_QTD+SALDOS->SA_VLR,18,4)#str(0.00,18,4) // saldo Zero
			nVlrNFE:=Trunca(pb_divzero(SALDOS->SA_VLR,SALDOS->SA_QTD),6)	// valor unitário
			nVlrNFS:=Round(nVlrNFE*SALDOS->SA_QTD,2)								// valor total (recomposto e arredondado)
			*----------------------------------------------------Tipo item
			UNIDADE->(dbseek(PROD->PR_UND)) // Buscar descr Unidade
			cTpItem:=ascan(aCodEst,{|DET|DET[1]==PROD->PR_CTB})
			if cTpItem > 0
				cTpItem:=pb_zer(aCodEst[cTpItem][3],2)//....................Tipo Item
			else
				cTpItem:=pb_zer(99,2) //....................................Tipo Item = Se não achar nenhum colocar 99
			end
			*-----------------------------------------------------CST PIS/Cofins
			cCST:='50'
			if FISACOF->(dbseek(PROD->PR_CODCOS+'J',.T.))
				cCST:=FISACOF->CO_TIPOIN
			end
			
			cEnquadr   :='0000'
			cTabPISC   :='0'
			cItTabPISC :='000'
			if     cCST=='04'// CST
				cTabPISC:='1'
			elseif cCST=='05'// CST
				cTabPISC:='3'
			elseif cCST=='06'// CST
				cTabPISC:='4'
			elseif cCST=='07'// CST
				cTabPISC:='5'
			elseif cCST=='08'// CST
				cTabPISC:='6'
			elseif cCST=='09'// CST
				cTabPISC:='7'
			end
			if cTabPISC#'0'//........................SAIDA e CFOP não Gera PIS/COFINS
				cEnquadr:='1329'
			end
			
			GravaTXT(75,; //............................................01.Informações Reg Mag SRF
						pb_zer(PROD->PR_CODPR,14)							+;//..02.Cod Produto
						space(14)												+;//..03.Alteração Código Item
						padr(alltrim(PROD->PR_CODNCM)+'000',11)		+;//..04.NCM-Ex=000
						padr(upper(PROD->PR_DESCR),	50)				+;//..05.Descricao Produto
						padr(upper(PROD->PR_COMPL),	30)				+;//..06.Complemento da Descricao Produto
						padr(upper(PROD->PR_UND),		10)				+;//..07.Unidade Medida Produto no Documento
						padr(upper(UNIDADE->UN_DESCR),20)				+;//..08.Descricao Unidade Medida Produto no Documento
						padr(upper(PROD->PR_UND),		10)				+;//..09.Unidade Medida Produto no Estoque
						padr(upper(UNIDADE->UN_DESCR),20)				+;//..10.Descricao Unidade Medida Produto no Documento
						pb_zer(0,15)											+;//..11.Fator de Conversão
						'P'														+;//..12.<P>roduto ou <S>erviço
						space(09)												+;//..13.Código Produto Tabela ANP
						space(14)												+;//..14.Código Barras do Produto
						cTpItem													+;//..15.Tipo Item (2 bytes)
						PROD->PR_CODGEN										+;//..16.Genero do Item-SPED-Fiscal (Tabela 4.2.1)
						pb_zer(0,4)												+;//..17.Codigo Servico Lei Federal 116/03
						pb_zer(PROD->PR_PICMS*100,4)						+;//..18.Aliq. ICMS Interno
						cCST														+;//..19.CST PIS/COFINS
						cTabPISC													+;//..20.Tabela PIS/COFINS (4.3.10 até 4.3.16)
						PROD->PR_ITEMTAB										+;//..21.Item Tabela PIS/COFINS
						'')

			*-----------------------------------------------------------------------Saldos
			GravaTXT(76,; //............................................01.Informações Reg Mag SRF
						SONUMEROS(dtoc(dInven))								+;//..02.Data Inventário
						pb_zer(max(SALDOS->SA_QTD	,0 )*1000   ,12)	+;//..03.Quantidade (3 casas Dec)
						pb_zer(max(nVlrNFE			,0 )*1000000,15)	+;//..04.Valor Unitário (6 casas Dec)
						pb_zer(max(nVlrNFS			,0 )*100		,15)	+;//..05.Valor Total (2 casas Dec)
						'0'														+;//..06.Própria e em seu poder (0) - pag 49 EFPH
						padr(upper(PROD->PR_COMPL),50)					+;//..07.Complemento
						space(15)												+;//..08.Conta Contábil (para SCPH)
						'1'														+;//..09.Tipo Inventário (1=Por determinaçao do Fisco)
						pb_zer(0,03)											+;//..10.CST ICMS 1
						space(12)												+;//..11.Base ICMS 1
						space(12)												+;//..12.Valor ICMS 1
						pb_zer(0,03)											+;//..13.CST ICMS 2
						space(12)												+;//..14.Base ICMS 2
						space(12)												+;//..15.Valor ICMS 2
						pb_zer(0,03)											+;//..16.CST ICMS 3
						space(12)												+;//..17.Base ICMS 3
						space(12)												+;//..18.Valor ICMS 3
						'')
		end
	end
	select PROD
	skip
end
return NIL

*-----------------------------------------------------------------------------*
	function RtModelo(pTipo,pSerie,pModelo)
*-----------------------------------------------------------------------------*
RT     :='2'// VENDA NF NORMAL
pModelo:='01'
SALVABANCO
select('CTRNF')
if dbseek(pSerie)// <E>-Entrada   <S>-Saida
	if pTipo=='E'
		if     NF_MODELO=='08' ; RT:='1'//	Conhecimento de Carga
		elseif NF_MODELO=='57' ; RT:='1'//	Conhecimento de Frete Eletronico - deve ter "S" no campo 19 do reg 20
		elseif NF_MODELO=='01' ; RT:='2'//	Venda 
		elseif NF_MODELO=='06' ; RT:='3'//	Nota Fiscal/Conta Energia Elétrica
		elseif NF_MODELO=='03' ; RT:='4'//	Nota Fiscal de Entrada
		elseif NF_MODELO=='22' ; RT:='5'//	Nota Fiscal/Serviço Telecomunicações
		elseif NF_MODELO=='07' ; RT:='7'//	Nota Fiscal de Serviços de Transporte
		elseif NF_MODELO=='11' ; RT:='8'//	Conhecimento Transp.Ferrov.Cargas
		elseif NF_MODELO=='09' ; RT:='9'//	Conhecimento Transp.Aquav.Cargas
		elseif NF_MODELO=='21' ; RT:='A'//	Nota Fiscal/Serviço Comunicações
		elseif NF_MODELO=='10' ; RT:='B'//	Conhecimento Aéreo
		elseif NF_MODELO=='26' ; RT:='C'//	Conhecimento Transp.Multimodal Cargas
		elseif NF_MODELO=='28' ; RT:='L'//	Nota Fiscal/Conta Fornecimento de Gás
		elseif NF_MODELO=='29' ; RT:='M'//	Nota Fiscal/Conta Fornecimento de Água Canalizada
		elseif NF_MODELO=='55' ; RT:='2'//	NF-e
		end
	else // Saidas
		if     NF_MODELO=='08' ; RT:='1'//	Conhecimento de Carga
		elseif NF_MODELO=='01' ; RT:='2'//	Nota Fiscal
		elseif NF_MODELO=='02' ; RT:='3'//	Nota Fiscal Venda Consumidor
		elseif NF_MODELO=='13' ; RT:='4'//	Bilhete de Passagem Rodoviário
		elseif NF_MODELO=='PD' ; RT:='5'//	Cupom Fiscal PDV
		elseif NF_MODELO=='MR' ; RT:='6'//	Cupom Fiscal Máquina Registradora
		elseif NF_MODELO=='EC' ; RT:='7'//	Cupom Fiscal ECF
		elseif NF_MODELO=='07' ; RT:='9'//	Nota Fiscal de Serviço de Transporte
		elseif NF_MODELO=='22' ; RT:='A'//	Nota Fiscal Serviço Telecomunicações
		elseif NF_MODELO=='21' ; RT:='B'//	Nota Fiscal Serviço Comunicações
		elseif NF_MODELO=='10' ; RT:='C'//	Conhecimento de Tr.Aéreo de Cargas
		elseif NF_MODELO=='15' ; RT:='D'//	Bilhete de Passagem e Nota de Bagagem
		elseif NF_MODELO=='18' ; RT:='E'//	Resumo de Movimento Diário
		elseif NF_MODELO=='2E' ; RT:='F'//	Cupom Fiscal Bilhete de Passagem
		elseif NF_MODELO=='06' ; RT:='G'//	Nota Fiscal/Conta de Energia Elétrica
		elseif NF_MODELO=='09' ; RT:='H'//	Conhecimento de Transporte Aquaviário Cargas
		elseif NF_MODELO=='14' ; RT:='I'//	Bilhete de Passagem Aquaviário
		elseif NF_MODELO=='26' ; RT:='J'//	Conhecimento de Transporte Multimodal Cargas
		elseif NF_MODELO=='28' ; RT:='L'//	Nota Fiscal/Conta Fornecimento de Gás
		elseif NF_MODELO=='55' ; RT:='2'//	*NF-e
		end
	end
	pModelo:=NF_MODELO
end
RESTAURABANCO
return RT
/*-------------------TABELA D-ENTRADA-(Modelos de Documentos)------------------
0-Nota Fiscal de Serviços;
1-Conhecimento de Transp.Rodov.Cargas-08;
2-Nota Fiscal-01;
3-Nota Fiscal/Conta Energia Elétrica-06;
4-Nota Fiscal de Entrada-03;
5-Nota Fiscal/Serviço Telecomunicações-22;
7-Nota Fiscal de Serviços de Transporte-07;
8-Conhecimento Transp.Ferrov.Cargas-11
9-Conhecimento Transp.Aquav.Cargas-09
A-Nota Fiscal/Serviço Comunicações-21
B-Conhecimento Aéreo-10
C-Conhecimento Transp.Multimodal Cargas-26
L-Nota Fiscal/Conta Fornecimento de Gás-28
M-Nota Fiscal/Conta Fornecimento de Água Canalizada-29
*/
/*-------------------TABELA A-SAIDAS-(Modelos de Documentos)----------------
 0-Nota Fiscal de Serviços;
 1-Conhecimento de Transporte Rodoviário Cargas-08;
 2-Nota Fiscal-01;
 3-Nota Fiscal de Venda a Consumidor-02;
 4-Bilhete de Passagem Rodoviário-13;
 5-Cupom Fiscal PDV;
 6-Cupom Fiscal Máquina Registradora;
 7-Cupom Fiscal ECF;
 9-Nota Fiscal de Serviço de Transporte-07;
 A-Nota Fiscal Serviço Telecomunicações-22
 B-Nota Fiscal Serviço Comunicações-21
 C-Conhecimento de Tr.Aéreo de Cargas-10
 D-Bilhete de Passagem e Nota de Bagagem-15
 E-Resumo de Movimento Diário-18
 F-Cupom Fiscal Bilhete de Passagem-2E
 G-Nota Fiscal/Conta de Energia Elétrica-06
 H-Conhecimento de Transporte Aquaviário Cargas-09
 I-Bilhete de Passagem Aquaviário-14
 J-Conhecimento de Transporte Multimodal Cargas-26
 L-Nota Fiscal/Conta Fornecimento de Gás-28
*/



*-----------------------------------------------------------------------------*
	function GravaTXT(pReg,pDados)
*-----------------------------------------------------------------------------*
??padr(pb_zer(pReg,2)+pDados,256)
?
nNrReg++
return NIL

*-----------------------------------------EOF--------------------------------*