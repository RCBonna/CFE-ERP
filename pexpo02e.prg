*-----------------------------------------------------------------------------------------*
static aVariav:= { 0,0,1,2002,'','',0,'','', 0,{},.F.,0, 0,'','','',{},'',{},'', 0,'',''}
 //................1.2.3....4..5..6.7..8..9.10,11.12.13.14.15,16,17,18,19,20.21 22,23,24
*-----------------------------------------------------------------------------------------*
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
#xtranslate NaoUsado  => aVariav\[ 23 \]
#xtranslate cCodInt	 => aVariav\[ 24 \]

#include 'RCB.CH'

*-----------------------------------------------------------------------------*
 function ProEntrSAG(dPeriodo)
*-----------------------------------------------------------------------------*
private pModXNF:='' // só para parametro em RtModelo
select NFC
ORDEM DATA
DbGoTop()
dbseek(dtos(dPeriodo[1]),.T.)
while !eof().and.NFC->NF_DTEMI<=dPeriodo[2]
	if NFC->NF_TIPO=='E' // somente entradas
		pb_msg('SAG-NF Entradas:'+dtoc(NFC->NF_DTEMI)+'-'+NFC->NF_TIPO+'-'+NFC->NF_SERIE+'-'+str(NFC->NF_NRNF,6))
		NATOP->(dbseek(str(NFC->NF_CODOP,7)))
		CLIENTE->(dbseek(str(NFC->NF_EMIT,5)))
		cCodInt  :=if(CLIENTE->CL_ATIVID==1, NATOP->NO_CODINA,NATOP->NO_CODIN)
		oNF		:=RtSAG() // Busca dados da NF e seus detalhes
		
		cModDNF :=RtModelo('E',NFC->NF_SERIE,@pModXNF) // Tabela D e pMod=Modelo tabela interna
		cNFProp:=if(right( pb_zer(NFC->NF_CODOP,7),1)=='9','S','N') // impressa na empresa (própria?)
		cSerie:=substr(NFC->NF_SERIE,1,1)
		if cSerie>='0'.and.cSerie<'9'
			cSerie+=''
		elseif ENTCAB->EC_SERIE=='NPS'
			cSerie:='1'
		elseif ENTCAB->EC_SERIE=='NFE'
			cSerie:='1'
		end
		//-----------------------------------------------------------------------------------------------NRO NFE
		cNFEKey:=NFC->NF_NFEKEY
		if empty(cNFEKey)
			if pModXNF=='55' // é nota fiscal NF-e
				if cNFProp$'SN' // NF-e Próprias
					cNFEKey:='42'
					cNFEKey+=pb_zer(year(NFC->NF_DTEMI)-2000,2)+;
								pb_zer(month(NFC->NF_DTEMI),2)//...............................AAMM
					cNFEKey+=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)//.................CNPJ
					cNFEKey+='55'//.........................................................Modelo NFE=55
					cNFEKey+='001'//........................................................Serie
					cNFEKey+=pb_zer(NFC->NF_NRNF,9)//.......................................Nr Documento
					cNFEKey+=pb_zer(NFC->NF_NRNF,8)//.......................................Controle parte 1
					cNFEKey+=str(pb_chkdgt(pb_zer(NFC->NF_NRNF,8),3),1)//...................Controle parte 2
					cNFEKey+=CalcDg(cNFEKey)//..............................................Novo Digito Verificador
				end
			end
		end
		nCodlNF:=substr(cNFEKey,26,09) // novo número documento
			
		nModFrete:=max(oNF[15],1) //..................................Tipo de frete  <1>CIF   <2>FOB   <3>Outros
		nVlrCtb  :=oNF[10]	//.......................................Valor Contábil
		VlFrete  :=0
		if oNF[31]=='CT ' // Tipo Documento - não fazer notas de frete, deve constar
			nModFrete:=2 // FOB
			VlFrete  :=oNF[10] // ???????????????????????
		end
		if nModFrete == 3 .or. nModFrete == 9  // se for sem frete colocar ZERO
			nModFrete:=0
		end
		vCodNF:=if(NFC->NF_FLCAN,'1','0') // nf Cancalada=1 não cancelada  2
		if len(oNF[42])>0 // tem itens ?
			if oNF[31]#'CT '	// não é conhecimento de frete.
				vCodNF:='6'
			end
		end
		GravaTXT(20,;//........................................1
					pb_zer(day(		oNF[08]),2)				+;	//..2 Data Entrada
					SONUMEROS(dtoc(oNF[08]))				+;	//..3 Data Documento
					padr(          oNF[31]	,5)			+;	//..4 Especie (NFF,CF,..)
					padr(          cSerie	,5)			+;	//..5 Serie
					right(pb_zer  (oNF[04],8),6)			+;	//..6 Nr Docto
					left (pb_zer  (NFC->NF_CODOP,7),	4)	+;	//..7-NATUREZA OPERACAO - 4=char Primeiros Digitos
					padr(cCodInt,							4)	+;	//..8-Historico identificador EFPH
					padr('',25)									+;	//..9-OBS Livros Fiscais
					cModDNF										+;	//.10-Código do modelo (Tabela D)
					str(nModFrete,1)							+;	//.11-Tipo de frete   0-Sem Frete  2-FOB   3-OUTROS
					vCodNF										+;	//.12-0=Normal 1=Cancelado 2=? 6=Complementar(Sem item)
					'00'											+;	//.13-Dois digitos da NATUREZA do meio
					cNFProp										+;	//.14-NF Entrada Impressa na Empresa ?
					' '											+;	//.15-<S>Svc executado fora municipio <N>Svc Exec no Munic
					' '											+;	//.16-<S>Svc Exec em Bens de terceitos <N> SVC Não exec em..
					space(10)									+;	//.17-Codigo Serviço/Atividade
					'0'											+;	//.18-Situação NF Serviço (0=Nenhuma-1=Normal...)
					if(pModXNF$'5557','S','N')				+;	//.19-É documento Eletronico?
					cNFEKey										+;	//.20-Chave Eletrônica
					padr(NFC->NF_OBS1					,75)	+;	//.21-Complemento OBS NF <entrada>
					space(04)									+;	//.22-CFOP do Documento <Igual a item 7???>
					if(	NFC->NF_FATUR>0,'2','1'		)	+;	//.23-1=Vista   2=Prazo   3=Sem pagamento
					space(04)									+;	//.24-Complemento do campo 17
					nCodlNF										+;	//.25-Novo Número do Documento (9 digitos)
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
				9-Conhecimento Transp.Aquav.Cargas-09
				A-Nota Fiscal/Serviço Comunicações-21
				B-Conhecimento Aéreo-10
				C-Conhecimento Transp.Multimodal Cargas-26
				L-Nota Fiscal/Conta Fornecimento de Gás-28
				M-Nota Fiscal/Conta Fornecimento de Água Canalizada-29
		*/
		//---------------------------------------------------------------pagina 45 layout PH
		GravaTXT(21,;//.......................1
					pb_zer(nVlrCtb*100,12)+;//...2 vlr Contabil
					pb_zer(VlFrete,12)+;//.......3 vlr FRETE --> ??? junto com a nf ? separado ?
					pb_zer(0,12)+;//.............4 vlr Seguro
					pb_zer(0,12)+;//.............5 vlr Despesas Acessórias
					pb_zer(0,12)+;//.............6 vlr DESC GERAL = ENTCAB->EC_DESC
					pb_zer(NFC->NF_VLRFUN*100,12)+;//..7 vlr FUNRURAL
					pb_zer(0,12)+;//.............8 vlr BASE ICMS SUBSTIT
					pb_zer(0,12)+;//.............9 vlr ICMS SUBSTIT
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
		Gera22(NFC->NF_EMIT) // Tanto para Entrada quanto para Saida - DADOS DO EMITENTE(CLIENTE)
		*---------------------------------------------------------------pagina 10 layout PH

		vIPI :=array(6,3)
		aeval(vIPI,{|DET|afill(DET,0)})
		vIcms:=array(6,3)
		aeval(vIcms,{|DET|afill(DET,0)})
		vIcms[6,1]:=NFC->NF_VLRTOT // SAG SÓ TEM PRODUTOS ISENTOS

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
		Gera30(cModDNF,NFC->NF_FATUR) // Entrada e saida (PAGINA 14) - Gerar quando Modelo For = 2 (Tabela D)
		//----> 31 Ajustes PIS/COFINS (SPED-SOMENTE PARA REGISTROS DE SAIDA)
		//----> 32 Detalhamento de Transporte de Carga
		//----> 33 Detalhamento de Serviço
		//----> 34 Detalhamento de Base CSLL
		//----> 35 Retenção
		if NATOP->NO_FLPISC=='S'
			Gera36('E',oNF)	//----> 36 Valores de PIS/COFINS não cumulativos
		end
		//----> 37 Desmembramento de Valores do SIMPLES NACIONAL

		//...............................................FATURAMENTO
		//	Gera38(ENTCAB->EC_FATUR, ENTCAB->EC_PARCE) // Entrada e saida (PAGINA 14) - Faturamento (E/S)
		//	aFAT   :=fn_RetParc(PEDCAB->PC_PEDID,PEDCAB->PC_FATUR,PEDCAB->PC_PEDID)
		//	Gera38(ENTCAB->EC_FATUR, ENTCAB->EC_PARCE,aFAT) // Entrada e saida (PAGINA 14) - Faturamento (E/S)
		if cModDNF=='3'
			if len(oNF[42])>0
				Gera45(	{	pb_zer(oNF[42][01][43]    ,04),;
								pb_zer(oNF[42][01][44]    ,01),;
								pb_zer(oNF[42][01][45]    ,02),;
								pb_zer(oNF[42][01][46]    ,02);
							}) // Energia/Comunicação/Tele/Agua/Gas Canalizado
				ALERT('ENERGIA;Classe Consumo:'+pb_zer(oNF[42][01][43]    ,04)+;
								 ';Cod.Tp Ligacao:'+pb_zer(oNF[42][01][44]    ,01)+;
								 ';Grupo Tensao  :'+pb_zer(oNF[42][01][45]    ,02)+;
								 ';Tipo Assinant :'+pb_zer(oNF[42][01][46]    ,02)	 )
			else
				alert('NOTA FISCAL DE ENERGIA;Docto:'+str(NFC->NF_NRNF,8)+;
						'/Serie:'+NFC->NF_SERIE+;
						';Sem registros detalhes-Incluir.')	
			end
		end
		//	aNFEnt:=RtEntrada()
		Gera60('E',oNF,cModDNF,nCodlNF)
		select NFC
	end
	skip
end
return NIL

*-----------------------------------------------------------------------------*
//.......................................END FILE
*-----------------------------------------------------------------------------*