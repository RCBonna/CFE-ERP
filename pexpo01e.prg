*-------------------------------------------------------------------------------------------*
static aVariav:= { 0,0,1,2002,'','',0,'','', 0,{},.F.,0, 0,'','','',{},'',{},'', 0, 0,'',''}
 //................1.2.3....4..5..6.7..8..9.10,11.12.13.14.15,16,17,18,19,20.21.22.23,24,25
*-------------------------------------------------------------------------------------------*
#xtranslate nX        => aVariav\[  1 \]
#xtranslate nY        => aVariav\[  2 \]
#xtranslate nMES      => aVariav\[  3 \]
#xtranslate nANO      => aVariav\[  4 \]
#xtranslate cArqE     => aVariav\[  5 \]
#xtranslate cArqS     => aVariav\[  6 \]
#xtranslate nNrReg    => aVariav\[  7 \]
#xtranslate dInic     => aVariav\[  8 \]
#xtranslate dFinal    => aVariav\[  9 \]
#xtranslate nVlrCtb   => aVariav\[ 10 \]
#xtranslate vIcms     => aVariav\[ 11 \]
#xtranslate lFlag     => aVariav\[ 12 \]
#xtranslate nModFrete => aVariav\[ 13 \]
#xtranslate VlFrete   => aVariav\[ 14 \]
#xtranslate cNFEKey   => aVariav\[ 15 \]
#xtranslate cModDNF 	 => aVariav\[ 16 \]
#xtranslate cNFProp 	 => aVariav\[ 17 \]
#xtranslate aNFEnt 	 => aVariav\[ 18 \]
#xtranslate cSerie 	 => aVariav\[ 19 \]
#xtranslate vIPI      => aVariav\[ 20 \]
#xtranslate vCodNF    => aVariav\[ 21 \]
#xtranslate nCodlNF   => aVariav\[ 22 \]
#xtranslate cNomeCli	 => aVariav\[ 24 \]
#xtranslate cCodInt	 => aVariav\[ 25 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function ProEntrCFE(dPeriodo)
*-----------------------------------------------------------------------------*
private pModXNF:='' // só para parametro em RtModelo

select ENTCAB
ORDEM DTEDOC
DbGoTop()
dbseek(dtos(dPeriodo[1]),.T.)
while !eof().and.ENTCAB->EC_DTENT<=dPeriodo[2]

	aNFEnt	:=RtEntrada() // busca entradas -> SPEDC00F.prg
	CLIENTE->(	dbseek(str(ENTCAB->EC_CODFO,5)))
	cNomeCli	:=CLIENTE->CL_RAZAO
	NATOP->(		dbseek(str(ENTCAB->EC_CODOP,7)))
	
	cCodInt:=if(CLIENTE->CL_ATIVID==1, NATOP->NO_CODINA,NATOP->NO_CODIN)

	//	if len(aNFEnt[42])>0 // tem item na NF
	cModDNF:=RtModelo('E',ENTCAB->EC_SERIE,@pModXNF) // Tabela D e pMod=Modelo tabela interna do governo
	cNFProp:=if(right( pb_zer(ENTCAB->EC_CODOP,7),1)=='9','S','N') // Impressa na empresa (NF Própria?)
	cSerie :=substr(ENTCAB->EC_SERIE,1,1)
	if cSerie>='0'.and.cSerie<'9'
		cSerie+=''
	elseif ENTCAB->EC_SERIE=='NPS'
		cSerie:='1'
	elseif ENTCAB->EC_SERIE=='NFE'
		cSerie:='1'
	end
	//-----------------------------------------------------------------------------------------------NRO NFE
	cNFEKey:=ENTCAB->EC_NFEKEY
	if val(left(ENTCAB->EC_NFEKEY,6)) < 1 // não tem número da chave
		if pModXNF=='55' // é nota fiscal NF-e
			if cNFProp=='S' // NF-e Próprias
				cNFEKey:='42'//.........................................................Codigo Estado(01-02)
				cNFEKey+=pb_zer(year(	ENTCAB->EC_DTENT)-2000,2)+;//...................AA           (03-04)
							pb_zer(month(	ENTCAB->EC_DTENT),2)//..........................MM           (05-06)
				cNFEKey+=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)//.................CNPJ         (07-20)
				cNFEKey+=PARAMETRO->PA_MODNFE//.........................................Modelo NFE=55(21-22)
				cNFEKey+='001'//........................................................Serie        (23-25)
				cNFEKey+=pb_zer(ENTCAB->EC_DOCTO,9)//...................................Nr Documento (26-34)
				cNFEKey+=pb_zer(ENTCAB->EC_DOCTO,8)//...................................Controle parte 1
				cNFEKey+=str(pb_chkdgt(pb_zer(ENTCAB->EC_DOCTO,8),3),1)//...............Controle parte 2
				cNFEKey+=CalcDg(cNFEKey)//..............................................Novo Digito Verificador
			end
		end
	end
	nCodlNF:=substr(cNFEKey,26,09) // novo número documento
	
	@24,59 say dtoc(ENTCAB->EC_DTENT)+'>'+str(ENTCAB->EC_DOCTO,9)
	nModFrete:=max(ENTCAB->TR_TIPO,1) //.........................Tipo de frete  <1>CIF   <2>FOB   <3>Outros
	nVlrCtb  :=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+aNFEnt[22]+aNFEnt[16]
	vCodNF   :=if(ENTCAB->EC_NFCAN,'1','0')
	VlFrete  :=0	// Sem Valor Frete
	if ENTCAB->EC_TPDOC=='CT ' // não fazer notas de frete, deve constar na
		nModFrete:=2 // FOB
		VlFrete  :=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC // ???????????????????????
		vCodNF   :='6'
	else
		VlFrete  :=aNFEnt[16]
	end
	if cModDNF$'35' .or. nModFrete == 3 .or. nModFrete == 9 // NF Telecom e Energia ou informado sem Frete
		nModFrete:=0 // Sem frete
	end
	GravaTXT(20,;//........................................1 DADOS DO DOCUMENTO
				pb_zer(day(    ENTCAB->EC_DTENT),2)		+;	//..2 Data Entrada
				SONUMEROS(dtoc(ENTCAB->EC_DTEMI))		+;	//..3 Data Documento
				padr(          ENTCAB->EC_TPDOC,		5)	+;	//..4 Especie (NFF,CF,..)
				padr(          cSerie,					5)	+;	//..5 Serie
				right(pb_zer  (ENTCAB->EC_DOCTO,8),	6) +;	//..6 Nr Docto
				left (pb_zer  (ENTCAB->EC_CODOP,7),	4) +;	//..7-NATUREZA OPERACAO - 4=char Primeiros Digitos
				padr(cCodInt,								4)	+;	//..8-Historico Identificador EFPH
				padr(ENTCAB->EC_OBSLIV,				  25)	+;	//..9-OBS Livros Fiscais
				cModDNF											+;	//.10-Código do modelo (Tabela D)
				str(nModFrete,1)								+;	//.11-Tipo de Frete   0-Sem Frete  2-FOB   3-OUTROS
				vCodNF											+;	//.12-0=Normal 1=Cancelado 2=Extemp Norm 3=Extemp Canc 4=Uso Denegado 5=Uso Inutil 6=Compl(Sem item)
				'00'												+;	//.13-Dois digitos da NATUREZA do meio
				cNFProp											+;	//.14-NF Entrada Impressa na Empresa ?
				' '												+;	//.15-<S>Svc executado fora municipio <N>Svc Exec no Munic
				' '												+;	//.16-<S>Svc Exec em Bens de terceitos <N> SVC Não exec em..
				space(10)										+;	//.17-Codigo Serviço/Atividade
				'0'												+;	//.18-Situação NF Serviço (0=Nenhuma-1=Normal...)
				if(pModXNF$'5557','S','N')					+;	//.19-É documento Eletronico?
				cNFEKey											+;	//.20-Chave Eletrônica
				padr(ENTCAB->EC_OBSNFE			 ,75)		+;	//.21-Complemento OBS NF <entrada>
				space(04)										+;	//.22-CFOP do Documento <Igual a item 7>
				if(     ENTCAB->EC_FATUR>0,'2','1')		+;	//.23-1=Vista   2=Prazo   3=Sem pagamento
				space(04)										+;	//.24-Complemento do campo 17
				nCodlNF											+;	//.25-Novo Número do Documento (9 digitos)
				'')
/*
			TABELA D (Modelos de Documentos)
				0-Nota Fiscal de Serviços;
				1-Conhecimento de Transp.Rodov.Cargas-08;
				2-Nota Fiscal-01;
				3-Nota Fiscal/Conta Energia Elétrica-06;
				4-Nota Fiscal de Entrada-03;
				5-Nota Fiscal/Serviço Telecomunicações-22;
				7-Nota Fiscal de Serviços de Transporte-07;
				8-Conhecimento Transp.Ferrov.Cargas-11
				9-Conhecimento Transp.Aquav.Cargas-09
				A-Nota Fiscal/Serviço Comunicações-21+22
				B-Conhecimento Aéreo-10
				C-Conhecimento Transp.Multimodal Cargas-26
				L-Nota Fiscal/Conta Fornecimento de Gás-28
				M-Nota Fiscal/Conta Fornecimento de Água Canalizada-29
*/
	//---------------------------------------------------------------pagina 45 layout PH
	GravaTXT(21,;//..........................1
				pb_zer(nVlrCtb*100,12)+;//......2 vlr Contabil
				pb_zer(VlFrete*100,12)+;//......3 vlr FRETE --> ??? junto com a nf ? separado ?
				pb_zer(aNFEnt[17]*100,12)+;//...4 vlr Seguro
				pb_zer(Abs(aNFEnt[18]-aNFEnt[22])*100,12)+;//...5 vlr Despesas Acessórias
				pb_zer(0,12)+;//................6 vlr DESC GERAL = ENTCAB->EC_DESC
				pb_zer(ENTCAB->EC_FUNRU*100,12)+;//..7 vlr FUNRURAL
				pb_zer(aNFEnt[21]*100,12)+;//...8 vlr BASE ICMS SUBSTIT
				pb_zer(aNFEnt[22]*100,12)+;//...9 vlr ICMS SUBSTIT
				'0'+;//.....................10 Cod Antecip ICMS - Tab G
				'O'+; //....................11 Tipo Icms Sub <P>etróleo/derivados  <E>nerg.Eletrica  <O>utros
				pb_zer(0,12)+;//............12 vlr Contab 1 --> ??
				pb_zer(0,12)+;//............13 vlr Contab 2 --> ??
				pb_zer(0,12)+;//............14 vlr Contab 3 --> ??
				pb_zer(0,12)+;//............15 vlr Contab 4 --> ??
				pb_zer(0,12)+;//............16 vlr Contab 5 --> ??
				pb_zer(0,09)+;//............17 vlr PIS/COFINS
				pb_zer(0,09)+;//............18 vlr Aprop Cred Ativ Imob
				pb_zer(0,09)+;//............19 vlr Ressarc de Sub Trib
				pb_zer(0,09)+;//............20 vlr Transf Credito
				pb_zer(0,09)+;//............21 vlr Compl Vlr Fiscal/ICMS
				pb_zer(0,09)+;//............22 vlr Serv Nao Trib
				pb_zer(0,03)+;//............23 CCusto Debito
				pb_zer(0,03)+;//............24 CCusto Credito
				pb_zer(0,09)+;//............25 Abatimento não tributado
				'')
	*---------------------------------------------------------------pagina 10 layout PH
	Gera22(ENTCAB->EC_CODFO) // Tanto para Entrada quanto para Saida
	*---------------------------------------------------------------pagina 10 layout PH

	vIPI :=array(6,3)
	aeval(vIPI,{|DET|afill(DET,0)})
	vIcms:=array(6,3)
	aeval(vIcms,{|DET|afill(DET,0)})
	if EC_TPDOC=='CT '// Nota fiscal de frete não tem produtos lancados
		vIcms[01,01]:=ENTCAB->EC_ICMSB
		vIcms[01,02]:=ENTCAB->EC_ICMSP
		vIcms[01,03]:=ENTCAB->EC_ICMSV
	else
		BuscaIcmsE(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5))
	end
	GravaTXT(23,;//..................................1=Valores de ICMS
				pb_zer(vIcms[1,1]*100,12)+;//...........2.ICMS 1 - BASE
				pb_zer(vIcms[1,2]*100,04)+;//...........3.ICMS 1 - ALIQ
				pb_zer(vIcms[1,3]*100,12)+;//...........4.ICMS 1 - VALOR
				pb_zer(vIcms[2,1]*100,12)+;//...........5.ICMS 2 - BASE
				pb_zer(vIcms[2,2]*100,04)+;//...........6.ICMS 2 - ALIQ
				pb_zer(vIcms[2,3]*100,12)+;//...........7.ICMS 2 - VALOR
				pb_zer(vIcms[3,1]*100,12)+;//...........8.ICMS 3 - BASE
				pb_zer(vIcms[3,2]*100,04)+;//...........9.ICMS 3 - ALIQ
				pb_zer(vIcms[3,3]*100,12)+;//..........10.ICMS 3 - VALOR
				pb_zer(vIcms[4,1]*100,12)+;//..........11.ICMS 4 - BASE
				pb_zer(vIcms[4,2]*100,04)+;//..........12.ICMS 4 - ALIQ
				pb_zer(vIcms[4,3]*100,12)+;//..........13.ICMS 4 - VALOR
				pb_zer(vIcms[5,1]*100,12)+;//..........14.ICMS 5 - BASE
				pb_zer(vIcms[5,2]*100,04)+;//..........15.ICMS 5 - ALIQ
				pb_zer(vIcms[5,3]*100,12)+;//..........16.ICMS 5 - VALOR
				pb_zer(vIcms[6,1]*100,12)+;//..........17.ISENTAS
				pb_zer(vIcms[6,2]*100,12)+;//..........18.OUTRAS
				pb_zer(0             ,07)+;//..........19.BASE # ALIQ (AQUIS/IMOBILIZ)
				'')

		//----> 24 Cupom Fiscal (só saidas)
		//----> 25 IPI --> (Somente Para o Silo = Atualmente Isento)
		GravaTXT(25,;//..................................1=Valores de IPI
					pb_zer(vIPI[01,01]*100,12)+;//...........2.IPI - BASE
					pb_zer(vIPI[01,02]*100,05)+;//...........3.IPI - ALIQ
					pb_zer(0              ,12)+;//...........4.IPI - VALOR IPI DA ALIQUOTA (ENTRADA SO VALOR TOTAL)
					pb_zer(0              ,12)+;//...........5.IPI - ISENTAS (ENTRADA SO VALOR TOTAL)
					pb_zer(0              ,12)+;//...........6.IPI - OUTRAS (ENTRADA SO VALOR TOTAL)
					pb_zer(vIPI[01,03]*100,12)+;//...........7.VLR IPI TOTAL 
					'')
		//----> 26 ISS --> (Só Saidas)
		//----> 27 ICMS-SUBSTITUICAO - (Não Necessario)
		//----> 28 EXCLUSÃO DIEF - (Não Necessario)
		//----> 29 Gera29ItemE(str(ENTCAB->EC_DOCTO,8)+ENTCAB->EC_SERIE+str(ENTCAB->EC_CODFO,5)) //.. FORA
		
		//...............................................TEM QUE BUSCAR INFORMAÇÕES NA NF DE TRANSPORTE 
		Gera30(cModDNF,ENTCAB->EC_FATUR) // Entrada e saida (PAGINA 14) - Gerar quando Modelo For = 2 (Tabela D)
		//----> 31 Ajustes PIS/COFINS (É SOMENTE PARA REGISTROS DE SAIDAS)
		//----> 32 Detalhamento de Transporte de Carga
		//----> 33 Detalhamento de Serviço
		//----> 34 Detalhamento de Base CSLL
		//----> 35 Retenção
		if NATOP->NO_FLPISC=='S' // NATUREZA NAO DEVE CONSIDERAR PIS/COFINS
			Gera36('E',aNFEnt)	//----> 36 Valores de PIS/COFINS não cumulativos
		end
		//				Gerado no PEXPO01 (entrada a parte)
		//----> 37 Desmembramento de Valores do SIMPLES NACIONAL
		//...............................................FATURAMENTO
		//	Gera38(ENTCAB->EC_FATUR, ENTCAB->EC_PARCE) // Entrada e saida (PAGINA 14) - Faturamento (E/S)
		//	aFAT   :=fn_RetParc(PEDCAB->PC_PEDID,PEDCAB->PC_FATUR,PEDCAB->PC_PEDID)
		//	Gera38(ENTCAB->EC_FATUR, ENTCAB->EC_PARCE,aFAT) // Entrada e saida (PAGINA 14) - Faturamento (E/S)
		if cModDNF$'35'
			if len(aNFEnt[42])>0
				Gera45(	{	pb_zer(aNFEnt[42][01][43]    ,02),;
								pb_zer(aNFEnt[42][01][44]    ,01),;
								pb_zer(aNFEnt[42][01][45]    ,02),;
								pb_zer(aNFEnt[42][01][46]    ,02);
							}) // Energia/Comunicação/Tele/Agua/Gas Canalizado
//				ALERT('ENERGIA;Classe Consumo:'+pb_zer(aNFEnt[42][01][43]    ,02)+;
	//							 ';Cod.Tp Ligacao:'+pb_zer(aNFEnt[42][01][44]    ,01)+;
		//						 ';Grupo Tensao  :'+pb_zer(aNFEnt[42][01][45]    ,02)+;
			//					 ';Tipo Assinant :'+pb_zer(aNFEnt[42][01][46]    ,02)	 )
			else
				alert('NOTA FISCAL DE ENERGIA;Docto:'+str(ENTCAB->EC_DOCTO,8)+'/Serie:'+ENTCAB->EC_SERIE+;
						'/Fornecedor:'+str(ENTCAB->EC_CODFO,5)+;
						';Sem registros detalhes-Incluir.')
			end
		end
		Gera60('E',aNFEnt,cModDNF,nCodlNF,cNomeCli)
	skip	//.................................................NOVO REGISTRO ENTRADA(CAB)
end
return NIL

*-----------------------------------------------------------------------------*
 static function BuscaIcmsE(pChave)
*-----------------------------------------------------------------------------*
aeval(vIcms,{|DET|afill(DET,0)})
SALVABANCO
SELECT ENTDET
dbseek(pChave,.T.)
while !eof().and.str(ED_DOCTO,8)+ED_SERIE+str(ED_CODFO,5)==pChave
	lFlag:=.T.
	nY:=0
	for nX:=1 to 5
		if vIcms[nX,2]==ED_PCICM.and.ED_PCICM>0
			vIcms[nX,1]+=ED_BICMS
			vIcms[nX,3]+=ED_VLICM
			lFlag:=.F.
		end
		if vIcms[nX,2]==0.and.nY==0.and.ED_PCICM>0
			nY:=nX
		end
	next
	if lFlag.and.str(ED_PCICM+ED_BICMS+ED_VLICM,15,2)>str(0,15,2).and.nY>0
		vIcms[nY,1]:=ED_BICMS
		vIcms[nY,2]:=ED_PCICM
		vIcms[nY,3]:=ED_VLICM
	end
	vIcms[06,01]+=ED_ISENT
	vIcms[06,02]+=ED_OUTRA
	//--------------------------Valor DO IPI
	vIPI [01,01]:=0
	vIPI [01,02]:=0
	vIPI [01,03]+=ED_IPI
	skip
end

//		if ENTDET->ED_CODTR+'#'$'030#040#041#050#060#'
//			vBASICMS:=0
//			vPERICMS:=0
//			vVLRICMS:=0
//		end

RESTAURABANCO
return NIL
*-----------------------------------------------------------------------------*
//.......................................END FILE
*-----------------------------------------------------------------------------*