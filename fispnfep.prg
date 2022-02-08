*-----------------------------------------------------------------------------*
 static aVariav := {{}, 0,  0, 0,'',0,{},0,0, 0, 0,  0, 0, 0, 0}
 *...................1..2...3..4..5.6..7.8.9,10,11, 12,13,14,15
*-----------------------------------------------------------------------------*
#xtranslate PNFE				=> aVariav\[  1 \]
#xtranslate rDT				=> aVariav\[  2 \]
#xtranslate nContaD			=> aVariav\[  3 \]
#xtranslate nContaC			=> aVariav\[  4 \]
#xtranslate nId				=> aVariav\[  5 \]
#xtranslate VLRTOTIT			=> aVariav\[  6 \]
#xtranslate TOTIMP			=> aVariav\[  7 \]
#xtranslate nX					=> aVariav\[  8 \]
#xtranslate nY					=> aVariav\[  9 \]
#xtranslate VLRUNIT			=> aVariav\[ 10 \]
#xtranslate nSoma				=> aVariav\[ 11 \]
#xtranslate PercIBTP			=> aVariav\[ 13 \]
#xtranslate VImpostoIBPT	=> aVariav\[ 14 \]
#xtranslate nCodIBGE			=> aVariav\[ 15 \]

#include 'RCB.CH'
#include 'ENTRADA.CH'

*-----------------------------------------------------------------------------*
  function FISPNFEP() // Prepara para Geração NFE-ENTRADA Normal
*-----------------------------------------------------------------------------*
//P[1,X]   = Dados do Cabeçalho
//P[2,X]   = Dados dos Itens da NF
//P[3,X]   = Dados do Faturamento
//P[4,X]   = Dados do Transporte
//P[5,X]   = Dados dos Impostos/Total
//			  = left(pb_zer(PARAMETRO->PA_CDIBGE,7),2),;// 001-Codigo Estado Emitente
// VM_OBSD = USADO PARA IMPRESSÃO DE NFE DE LEITE - OBERVAÇÃO SOBRE OS VALORES A SEREM CONSIDERADOS NO VALOR UNITÁRIO DO LEITE.
PNFE:=array(5)

	finNFE:='1' // Finalidade 1=Normal
if NATOP->NO_DEVOL=='S'
	finNFE:='4' // 4=Devolução NFE
end

*------------------------------------------------------------DADOS BASICOS-NF ENTRADA
PNFE[1]:={	left(pb_zer(PARAMETRO->PA_CDIBGE,7),2),;// 001-Codigo Estado Emitente
				pb_zer(DADOC[NNF ],7)+str(pb_chkdgt(pb_zer(DADOC[NNF ],8),3),1),;//002-Cód.Numerico Interno (key)
				trim(NATOP->NO_DESCR),;						// 003-Descr Natureza Operação
				if(DADOC[NPARC]>0,'1','0'),;				// 004-Ind de Forma de Pagamento (0=Vista 1=Prazo)
				PARAMETRO->PA_MODNFE,;						// 005-Cod Modelo NF = 55
				'1',;												// 006-Informar Zero p/Série Única
				str(DADOC[NNF ],9),;							// 007-Número NF Fiscal (NFE)
				DTY4MD(DADOC[NDT]),;							// 008-Data de emissão AAAA-MM-DD
				DTY4MD(DADOC[NDT1]),;						// 009-Data de Saida   AAAA-MM-DD
				'0',;												// 010-Tipo 0=NF Entrada 1=NF de Saida
				pb_zer(PARAMETRO->PA_CDIBGE,7),;			// 011-Nr IBGE Município Gerador do ICMS 
				'1',;												// 012-Tp Emissão Damfe (1-Retrato/2-Paisagem)
				'1',;												// 013-Forma de emissão (1-Normal, 2-Contingencia FS, 3-Contingencia SCAN,...)
				PARAMETRO->PA_CGC,;							// 014-CNPJ Emitente da NFe (responsável)
				PARAMETRO->PA_NFEAMB,;						// 015-Ambiente Trabalho (1-Produção  2-Homologação)
				finNFE,;											// 016-Tipo NFE (1-Normal, 2-Complementar, 3-Ajuste,  4-Devolução)
				'0',;												// 017-Proc Emis (0=Do Contribuinte, 1=Avulso pelo Fisco, 2=Avulso pelo Contrib c/DertifDigital através do Fisco, 3-Fisco/Fisco)
				CFEVERSAO(),;									// 018-Versão Aplicativo emissor da NFe
				'J',;												// 019-Emitente - Tipo <F>isico    <J>uridico
				PARAMETRO->PA_CGC,;							// 020-CGC da empresa emitente
				VM_EMPR,;										// 021-Nome da empresa emitente
				'Coolacer',;									// 022-Nome fantasia
				trim(PARAMETRO->PA_ENDER),;				// 023-Logradouro
				trim(PARAMETRO->PA_ENDNRO),;				// 024-Número
				trim(PARAMETRO->PA_ENDCOMP),;				// 025-Complemento
				trim(PARAMETRO->PA_BAIRRO),;				// 026-Bairro
				pb_zer(PARAMETRO->PA_CDIBGE,7),;			// 027-Nr IBGE Município Emitente
				trim(PARAMETRO->PA_CIDAD),;				// 028-Nome Município
				PARAMETRO->PA_UF,;							// 029-UF - descricao
				trim(PARAMETRO->PA_CEP),;					// 030-CEP
				'1058',;											// 031-Nr País
				'BRASIL',;										// 032-Nome Pais
				trim(SONUMEROS(PARAMETRO->PA_FONE)),;	// 033-Fone
				trim(SONUMEROS(PARAMETRO->PA_INSCR)),;	// 034-Inscrição Estadual
				pb_zer(CLIENTE->CL_CODCL,5),;				// 035-Destinatario - Codigo CLiente
				CLIENTE->CL_TIPOFJ,;							// 036-Destinatario - Tipo <F>isico    <J>uridico
				trim(CLIENTE->CL_CGC),;						// 037-Destinatário - CGC/CPF
				trim(CLIENTE->CL_RAZAO),;					// 038-Destinatário - Nome
				trim(CLIENTE->CL_ENDER),;					// 039-Destinatário - Endereço
				trim(CLIENTE->CL_ENDNRO),;					// 040-Destinatário - Nro
				trim(CLIENTE->CL_ENDCOMP),;				// 041-Destinatário - Complemento
				trim(CLIENTE->CL_BAIRRO),;					// 042-Destinatário - Bairro
				pb_zer(CLIENTE->CL_CDIBGE,7),;			// 043-Destinatário - Cod.Estado+Cidade IBGE
				trim(CLIENTE->CL_CIDAD),;					// 044-Destinatário - Cidade
				CLIENTE->CL_UF,;								// 045-Destinatário - UF
				CLIENTE->CL_CEP,;								// 046-Destinatário - CEP
				'1058',;											// 047-Nr País --> buscar do cadastro de cliente
				'BRASIL',;										// 048-Nome País
				trim(SONUMEROS(CLIENTE->CL_FONE)),;		// 049-Destinatário - Fone
				trim(CLIENTE->CL_INSCR),;					// 050-Inscrição Estadual "ISENTO", NR, Branco=PF
				trim(CLIENTE->CL_CDSUFRA),;				// 051-Destinatário - Código SUFRAMA
				alltrim(VM_OBS),;								// 052-Observação NF
				alltrim(VM_OBSP),;							// 053-Observação NF - VALORES LEITE
				alltrim(PARAMETRO->PA_CDMUNIC),;			// 054-Codigo Inscrição Municipal Emitente
				alltrim(PARAMETRO->PA_CNAE),;				// 055-CNAE-Emitente
				alltrim(DADOC[NFEKEYDEV]);					// 056-Codigo Chave NFe Devolução-
			}

*------------------------------------------------------------PRODUTOS - ENTRADA
TOTIMP		:={0,0,0,0,0,0,0,0,0 ,0 ,0 ,0, 0, 0}
//.............1,2,3,4,5,6,7,8,9,10,11,12,13,14
aProd			:={}
VImpostoIBPT:=0
for nX:=1 to len(PRODUTOS)-1
	if PRODUTOS[nX,2]>=1
		PROD->(dbseek(str(PRODUTOS[nX,2],L_P)))
		if NCM->(dbseek(PROD->PR_CODNCM))
			PercIBTP:=NCM->NCM_PERC1
		else
			PercIBTP:=0
		end
		VLRTOTIT:=Trunca(PRODUTOS[nX,05],2)
		VImpostoIBPT+=VLRTOTIT*PercIBTP/100 // Imposto IBPT deste Item
		VLRUNIT :=Trunca(pb_divzero(PRODUTOS[nX,05],PRODUTOS[nX,04]),08) // somente para NFE
		PIS     :={0,0,'99'}
		COFINS  :={0,0,'99'}
		NATOP->(dbseek(str(DADOC[NNAT],7)))

		if NATOP->NO_FLPISC=='S' // Tem PIS x Cofins
			if FISACOF->(dbseek(PROD->PR_CODCOS+'J')) // A COOLACER é que é a Pessoa destinatário
				PIS   :={FISACOF->CO_PERC1,trunca(VLRTOTIT*FISACOF->CO_PERC1/100,2),FISACOF->CO_TIPOIN}	// % e Vlr Pis
				COFINS:={FISACOF->CO_PERC2,trunca(VLRTOTIT*FISACOF->CO_PERC2/100,2),FISACOF->CO_TIPOIN}	// % e Vlr Cofins
			else
				alert('PRODUTO='+pb_zer(PRODUTOS[nX,2],L_P)+';CDPISCF='+PROD->PR_CODCOS+';CLI-TIP=J;Erro PIS/COFINS na NF-Entrada')
			end
		end
		AAdd(aProd,		{	pb_zer(PRODUTOS[nX,2],L_P),;				// 01-Código Produto
								'',;												// 02-EAN=GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 (antigos códigos EAN, UPC e DUN-14)
								trim(PROD->PR_DESCR),;						// 03-Descr Produto
								trim(PROD->PR_CODNCM),;						// 04-Código = Nomenclatura NCM
								alltrim(str(PROD->PR_TIPI,2)),;			// 05-TIPI -> Zero não fazer
								trim(PROD->PR_CODGEN),;						// 06-Genero = Nomenclatura NCM
								left(str(DADOC[NNAT],7),4),;				// 07-Nat-Operacao
								trim(PROD->PR_UND),;							// 08-Unidade de Comercialização
								alltrim(str(PRODUTOS[nX,04],12,4)),;	// 09-Quantidade Comercialização
								alltrim(str(VLRUNIT,22        ,8)),;	// 10-Valor Unitário Comercialização
								alltrim(str(VLRTOTIT,15,2)),;	 			// 11-Valor Total
								trim(PROD->PR_UNDTRIB),;					// 12-Unidade de Tributação
								alltrim(str(PRODUTOS[nX,04],12,4)),;	// 13-Quantidade Tributável
								alltrim(str(VLRUNIT,22        ,8)),;	// 14-Valor Unitário
								str(PROD->PR_ORIGEM,1),;					// 15-Origem 0=Nacional, 1=Importação Direta 2=Importação Adq Merc Nacional
								{;													// 16-ICMS
									Right(PRODUTOS[nX,14],2),;					// 16;1-Cod Trib 00, 10, 20, 30 ...(só dois números)
									'0',;		//16;2-Modalidade de determinação da BC do ICMS (0=Margem Valor Agregado (%)// 1=Pauta (Valor)/  2=Preço Tabelado Máx. (valor)// 3=Valor da operação.
									alltrim(str(PRODUTOS[nX,19],15,2)),;	// 16;3-Base Cálculo ICMS
									alltrim(str(PRODUTOS[nX,09],05,2)),;	// 16;4-Alíquota
									alltrim(str(PRODUTOS[nX,10],15,2)),;	// 16;5-Valor Cálculo ICMS
									alltrim(str(100-PROD->PR_PTRIB),7,2);	// 16;6-% Redução da Base ICMS (100-% de Tributação)
								},;
								{;												// 17-IPI
									'02',;									// 17;1-CTS 02=ENTRADA ISETA 52=SAIDA ISENTO
									pb_zer(PROD->PR_TIPI,2),;			// 17;2-Tabela IPI
									PROD->PR_CODCOE,;						// 17;3-Código IPI Entrada
									PROD->PR_CODCOS,;						// 17;4-Código IPI Saída
									alltrim(PROD->PR_CFISIPI),;		// 17;5-Classificação Fiscal IPI
									alltrim(str(PROD->PR_PIPI),7,2),;// 17;6-% Tributação IPI
									'0.00',;									// 17;7-Valor Base de tributação do IPI
									'0.00';									// 17;8-Valor do IPI
								},;
								{;												// 18-PIS
									PIS[3],;									// 18;1-CTib PIS-interno (converter para CTS RECEITA==REVISAR ACIMA)
									alltrim(str(VLRTOTIT,15,2)),;		// 18;2-Vlr Base PIS
									alltrim(str(PIS[1],7,2)),;			// 18;3-% Tributação PIS
									alltrim(str(PIS[2],15,2));			// 18;4-Vlr PIS
								},;
								{;												// 19-COFINS
									COFINS[3],;								// 19;1-CTib COFINS-interno (converter para CTS RECEITA==REVISAR ACIMA)
									alltrim(str(VLRTOTIT, 15,2)),;	// 19;2-Vlr Base COFINS
									alltrim(str(COFINS[1], 7,2)),;	// 19;3-% Tributação COFINS
									alltrim(str(COFINS[2],15,2));		// 19;4-Vlr COFINS
								},;
								alltrim(str(PRODUTOS[nX,12],15,2)),;// 20 Desconto do Item
								alltrim(str(0,15,2));					// 21 Desconto do Geral (Proporcional) - Verificar
							})
		TOTIMP[01]+=PRODUTOS[nX,19]	// 1-Base de Calculo ICMS
		TOTIMP[02]+=PRODUTOS[nX,10]	// 2-Valor ICMS
		TOTIMP[03]+=0						// 3-Base de Calculo ICMS-Substituição
		TOTIMP[04]+=0						// 4-Vlr ICMS-Substituição
		TOTIMP[05]+=VLRTOTIT				// 5-Vlr total Produtos
		TOTIMP[06]+=0						// 6-Vlr IPI
		TOTIMP[07]+=PIS[2]				// 7-Vlr PIS
		TOTIMP[08]+=COFINS[2]			// 8-Vlr COFINS
		TOTIMP[09]+=0						// 9-Vlr II
		TOTIMP[12]+=PRODUTOS[nX,12]	// 12-Vlr Desconto
	end
next
	TOTIMP[10]+=0					// 10-Vlr Frete
	TOTIMP[11]+=0					// 11-Vlr Seguro
	TOTIMP[13]+=0					// 13-Vlr Outro
	TOTIMP[14]:=TOTIMP[05]		// 14-Vlr NF

PNFE[2]:=aProd
PNFE[3]:={{'Fatura','NrFatura','Vlr Total','Desconto','Vlr Liquido'}}	// Totalizador
//...............1..........2...........3..........4.............5.......
nSoma  :=0
for nX:=1 to len(DADOPC)
	aadd(PNFE[3],{	strTran(Transform(DADOPC[nX,1],mDPL),' ','0'),;
						DTY4MD(           DADOPC[nX,2]),;
						alltrim(str(      DADOPC[nX,3],15,2))})
	nSoma+=DADOPC[nX,3]
next
if len(DADOPC)>0	//...........................................se tem dados... totalizar no array 1
	PNFE[3,1,2]:=strTran(Transform(DADOPC[1,1]-1,mDPL),' ','0')
	PNFE[3,1,3]:=alltrim(      str(nSoma,15,2))
	PNFE[3,1,4]:=alltrim(      str(    0,15,2))
	PNFE[3,1,5]:=alltrim(      str(nSoma,15,2))
end
PNFE[4]:=I_TRANS
				// PEDCAB->TR_NOME  with P1[01],;
				// PEDCAB->TR_ENDE  with P1[02],;
				// PEDCAB->TR_MUNI  with P1[03],;
				// PEDCAB->TR_UFT   with P1[04],;
				// PEDCAB->TR_TIPO  with P1[05],;
				// PEDCAB->TR_PLACA with P1[06],;
				// PEDCAB->TR_UFV   with P1[07],;
				// PEDCAB->TR_CGC   with P1[08],;
				// PEDCAB->TR_INCR  with P1[09],;
				// PEDCAB->TR_QTDEM with P1[10],;
				// PEDCAB->TR_ESPE  with P1[11],;
				// PEDCAB->TR_MARC  with P1[12],;
				// PEDCAB->TR_PBRU  with P1[13],;
				// PEDCAB->TR_PLIQ  with P1[14]

//aeval(TOTIMP,{|DET|DET:=alltrim(str(DET,15,2))})

if VImpostoIBPT>0
	PNFE[1][52]+=	" Val Aprox.dos Tributos R$ "+alltrim(Transform(VImpostoIBPT,mD112))+" ("+;
						alltrim(Transform(pb_divzero(VImpostoIBPT, TOTIMP[14])*100,mD112))+" %"+;
						") Fonte:IBPT"
end

for nX:=1 to len(TOTIMP)
	TOTIMP[nX]:=alltrim(str(TOTIMP[nX],15,2))
next

PNFE[5]:=TOTIMP
FISPNFEG(PNFE,'C') // com os dados prontos deve-se enviar os dados via parametros para geração da NF-e
return(.T.)

* TIPI = http://www.receita.fazenda.gov.br/aliquotas/DownloadArqTIPI.htm

*-------------------------------------------------------------------
  static function DTY4MD(pDT)
*-------------------------------------------------------------------
rDT:=dtos(pDT)
rDT:=Left(rDT,4)+'-'+Substr(rDT,5,2)+'-'+Right(rDT,2)
return (rDT)
*-------------------------------------------------------------EOF
