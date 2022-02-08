*-----------------------------------------------------------------------------*
 static aVariav := {{} ,'',  0, 0,'',0,{},0,0, 0, 0, 0, 0, 0}
*....................1 , 2  ,3 ,4 ,5,6 ,7,8,9,10,11 12 13 14
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
#xtranslate nVlrUnit			=> aVariav\[ 10 \]
#xtranslate nVlrDesc			=> aVariav\[ 11 \]
#xtranslate vBasePis			=> aVariav\[ 12 \]
#xtranslate PercIBTP			=> aVariav\[ 13 \]
#xtranslate VImpostoIBPT	=> aVariav\[ 14 \]

*-----------------------------------------------------------------------------*
  function CFEPPNFE() // Prepara para Gera��o NFE-SAIDA Normal
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

//P[1,X] = Dados do Cabe�alho
//P[2,X] = Dados dos Itens da NF
//P[3,X] = Dados do Faturamento
//P[4,X] = Dados do Transporte
//P[5,X] = Dados dos Impostos/Total
//default VM_OBSD to '' // USADO PARA IMPRESS�O DE NFE DE LEITE - OBERVA��O SOBRE OS VALORES A SEREM CONSIDERADOS NO VALOR UNIT�RIO DO LEITE.
if PEDCAB->PC_VEND>0
	VM_OBSP+=' - Vendedor:'+pb_zer(PEDCAB->PC_VEND,3)+'-'+trim(PR('VENDEDOR',str(VM_VEND,3),2,.F.))
end
finNFE:='1' // Finalidade 1=Normal
if NATOP->NO_DEVOL=='S'
	finNFE:='4' // 4=Devolu��o NFE
end

PNFE:=array(5)
*------------------------------------------------------------CABE�ALHO - NF SAIDAS
PNFE[1]:={	left(pb_zer(PARAMETRO->PA_CDIBGE,7),2),;// 001-Codigo Estado Emitente
				pb_zer(VM_ULTPD,7)+str(pb_chkdgt(pb_zer(VM_ULTPD,7),3),1),;//002-C�digo Numerico interno que compoe chave de acesso(8 d�gitos)
				trim(NATOP->NO_DESCR),;						// 003-Descr Natureza Opera��o
				if(PEDCAB->PC_FATUR>0,'1','0'),;			// 004-Ind de Forma de Pagamento 0=Vista 1=Prazo 2=Outro
				PARAMETRO->PA_MODNFE,;						// 005-Cod Modelo NF = 55
				'1',;												// 006-Informar Zero p/S�rie �nica
				str(VM_ULTNF,9),;								// 007-N�mero NF Fiscal (NFE)
				DTY4MD(PEDCAB->PC_DTEMI),;					// 008-Data de emiss�o param = 'TZ'=AAAA-MM-DDTHH:MM:SS-03:00
				DTY4MD(PEDCAB->PC_DTSAI),;					// 009-Data de Saida   AAAA-MM-DDTHH:MM:SS-03:00
				'1',;												// 010-Tipo 0=NF Entrada     1=NF de Saida
				pb_zer(PARAMETRO->PA_CDIBGE,7),;			// 011-Nr IBGE Munic�pio Gerador do ICMS 
				'1',;												// 012-Tipo Emiss�o Danfe (1-Retrato/2-Paisagem)
				'1',;												// 013-Forma de emiss�o (1-Normal, 2-Contingencia FS, 3-Contingencia SCAN,...
				PARAMETRO->PA_CGC,;							// 014-CNPJ Emitente da NFe (Respons�vel)
				PARAMETRO->PA_NFEAMB,;						// 015-Ambiente Trabalho (1-Produ��o  2-Homologa��o)
				finNFE,;											// 016-Finalidade NFE (1-Normal, 2-Complementar, 3-Ajuste, 4-Complementar)
				'0',;												// 017-Proc Emis (0=Do Contribuinte, 1=Avulso pelo Fisco, 2=Avulso pelo Contrib c/DertifDigital atrav�s do Fisco, 3-Fisco/Fisco)
				CFEVERSAO(),;									// 018-Vers�o Aplicativo emissor da NFe
				'J',;												// 019-Emitente - Tipo <F>isico    <J>uridico
				PARAMETRO->PA_CGC,;							// 020-CGC da empresa emitente
				VM_EMPR,;										// 021-Nome da empresa emitente
				'COOLACER',;									// 022-Nome fantasia
				trim(PARAMETRO->PA_ENDER),;				// 023-Logradouro
				trim(PARAMETRO->PA_ENDNRO),;				// 024-N�mero
				trim(PARAMETRO->PA_ENDCOMP),;				// 025-Complemento
				trim(PARAMETRO->PA_BAIRRO),;				// 026-Bairro
				pb_zer(PARAMETRO->PA_CDIBGE,7),;			// 027-Nr IBGE Munic�pio
				trim(PARAMETRO->PA_CIDAD),;				// 028-Nome Munic�pio
				PARAMETRO->PA_UF,;							// 029-UF - descricao
				trim(PARAMETRO->PA_CEP),;					// 030-CEP
				'1058',;											// 031-Nr Pa�s
				'BRASIL',;										// 032-Nome Pais
				trim(SONUMEROS(PARAMETRO->PA_FONE)),;	// 033-Fone
				trim(SONUMEROS(PARAMETRO->PA_INSCR)),;	// 034-Inscri��o Estadual
				pb_zer(CLIENTE->CL_CODCL,5),;				// 035-Destinatario - Codigo CLiente
				CLIENTE->CL_TIPOFJ,;							// 036-Destinatario - Tipo <F>isico    <J>uridico
				trim(CLIENTE->CL_CGC),;						// 037-Destinat�rio - CGC/CPF
				trim(CLIENTE->CL_RAZAO),;					// 038-Destinat�rio - Nome
				trim(CLIENTE->CL_ENDER),;					// 039-Destinat�rio - Endere�o
				trim(CLIENTE->CL_ENDNRO),;					// 040-
				trim(CLIENTE->CL_ENDCOMP),;				// 041-
				trim(CLIENTE->CL_BAIRRO),;					// 042-
				pb_zer(CLIENTE->CL_CDIBGE,7),;			// 043-
				trim(CLIENTE->CL_CIDAD),;					// 044-
				CLIENTE->CL_UF,;								// 045-
				CLIENTE->CL_CEP,;								// 046-
				'1058',;											// 047-Nr Pa�s --> buscar do cadastro de cliente
				'BRASIL',;										// 048-Nome Pa�s
				trim(SONUMEROS(CLIENTE->CL_FONE)),;		// 049-Fone
				trim(CLIENTE->CL_INSCR),;					// 050-Inscri��o Estadual "ISENTO", NR, Branco=PF
				trim(CLIENTE->CL_CDSUFRA),;				// 051-C�digo SUFRAMA
				alltrim(VM_OBS),;								// 052-Observa��o NF
				alltrim(VM_OBSP),;							// 053-Observa��o NF - VALORES LEITE
				alltrim(PARAMETRO->PA_CDMUNIC),;			// 054-Codigo Inscri��o Municipal
				alltrim(PARAMETRO->PA_CNAE),;				// 055-CNAE-
				alltrim(PEDCAB->PC_NFEDEV);				// 056-NFE-Devolu��o (chave)
			}
*------------------------------------------------------------PRODUTOS - SAIDA
TOTIMP:={0,0,0,0,0,0,0,0,0 ,0 ,0, 0, 0, 0}
//.......1,2,3,4,5,6,7,8,9,10,11,12,13,14
aProd:={}
VImpostoIBPT:=0
for nX:=1 to len(VM_DET)
	if VM_DET[nX,2]>0
		PROD->(dbseek(str(VM_DET[nX,2],L_P)))
		if NCM->(dbseek(PROD->PR_CODNCM))
			PercIBTP:=NCM->NCM_PERC1
		else
			PercIBTP:=0
		end
		VLRTOTIT:=Trunca( VM_DET[nX,4]*VM_DET[nX,5],2) // Valor dos Produtos
		PIS     :={0,0,'99'}
		COFINS  :={0,0,'99'}
//		nVlrUnit:=VM_DET[nX,5] //..................................Precisa de mais casas para NFe.
//		nVlrUnit:=Trunca(pb_divzero(VLRTOTIT,VM_DET[nX,4]),12) //..Total
//		VLRTOTIT:=VLRTOTIT-VM_DET[nX,6]+VM_DET[nX,7] //............Retirar o desconto
		nVlrDesc:=VM_DET[nX,06]+VM_DET[nX,30] // Soma dos descontos gerais e Individuais
		vBasePis:=VLRTOTIT-nVlrDesc
		VImpostoIBPT+=(VLRTOTIT-nVlrDesc)*PercIBTP/100 // Imposto IBPT deste Item
		nVlrUnit:=Trunca(VM_DET[nX,5],08) //..Ajuste que me parece incorreto... (vlr unit iten sem desconto)
		
		if NATOP->NO_FLPISC=='S'// Natureza informa para n�o calcular PIS x Cofins
			if FISACOF->(dbseek(PROD->PR_CODCOS+CLIENTE->CL_TIPOFJ))
				PIS   :={FISACOF->CO_PERC1,VM_DET[nX,26],FISACOF->CO_TIPOIN}	// % e Vlr Pis    e Cod Trib
				COFINS:={FISACOF->CO_PERC2,VM_DET[nX,27],FISACOF->CO_TIPOIN}	// % e Vlr Cofins e Cod Trib
			else
				alert('PRODUTO='+pb_zer(VM_DET[nX,2],L_P)+';CDPISCF='+PROD->PR_CODCOS+';CLI-TIP='+CLIENTE->CL_TIPOFJ+';Erro PIS/COFINS na NF-Saida')
			end
		end
		aadd(aProd,		{	pb_zer(VM_DET[nX,2],L_P),;				// 01-C�digo Produto
								'',;											// 02-EAN=GTIN-8, GTIN-12, GTIN-13 ou GTIN-14 (antigos c�digos EAN, UPC e DUN-14)
								trim(VM_DET[nX,3]),;						// 03-Descricao Produto
								trim(PROD->PR_CODNCM),;					// 04-C�digo = Nomenclatura NCM
								alltrim(str(PROD->PR_TIPI,2)),;		// 05-TIPI -> Zero n�o fazer
								trim(PROD->PR_CODGEN),;					// 06-Genero = Nomenclatura NCM
								Left(str(VM_DET[nX,17],7),4),;		// 07-CFOP - Nat-Operacao
								trim(PROD->PR_UND),;						// 08-Unidade de Comercializa��o
								alltrim(str(VM_DET[nX,4],12,4)),; 	// 09-Quantidade Comercializa��o
								alltrim(str(nVlrUnit    ,22,8)),; 	// 10-Valor Unit�rio Comercializa��o
								alltrim(str(VLRTOTIT    ,15,2)),; 	// 11-Valor Total
								trim(PROD->PR_UNDTRIB),;			 	// 12-Unidade de Tributa��o
								alltrim(str(VM_DET[nX,4],12,4)),; 	// 13-Quantidade Tribut�vel
								alltrim(str(nVlrUnit,    22,8)),; 	// 14-Valor Unit�rio
								str(PROD->PR_ORIGEM        ,1),;  	// 15-Origem 0=Nacional, 1=Importa��o Direta 2=Importa��o Adq Merc Nacional
								{;												// 16-ICMS
									Right(VM_DET[nX,8],2),;						// 16;1-Cod Trib 00, 10, 20, 30 ...(s� dois n�meros)
									'0',;												// 16;2-Modalidade Determina��o da BC do ICMS (0=Margem Valor Agregado (%)// 1=Pauta (Valor)/  2=Pre�o Tabelado M�x. (valor)// 3=Valor da opera��o.
									alltrim(str(VM_DET[nX,16],15,2)),;		// 16;3-Base C�lculo ICMS
									alltrim(str(VM_DET[nX,09],05,2)),;		// 16;4-Al�quota
									alltrim(str(VM_DET[nX,15],15,2)),;		// 16;5-Valor C�lculo ICMS
									alltrim(str(100-VM_DET[nX,11],7,2));	// 16;6-% Redu��o da Base ICMS (100-% de Tributa��o)
								},;
								{;										// 17-IPI
									'52',;											// 17;1-CTS 02=ENTRADA ISETA 52=SAIDA ISENTO
									pb_zer(PROD->PR_TIPI,2),;					// 17;2-Tabela IPI
									PROD->PR_CODCOE,;								// 17;3-C�digo IPI Entrada
									PROD->PR_CODCOS,;								// 17;4-C�digo IPI Sa�da
									alltrim(PROD->PR_CFISIPI),;				// 17;5-Classifica��o Fiscal IPI
									alltrim(str(PROD->PR_PIPI,7,2)),;		// 17;6-% Tributa��o IPI
									'0',;												// 17;7-Valor Base de tributa��o do IPI
									'0';												// 17;8-Valor do IPI
								},;
								{;											// 18-PIS
									PIS[3],;											// 18;1-CTib PIS-interno (converter para CTS RECEITA==REVISAR ACIMA)
									alltrim(str(vBasePis,15,2)),;				// 18;2-Vlr Base PIS
									alltrim(str(PIS[1],   7,2)),;				// 18;3-% Tributa��o PIS
									alltrim(str(PIS[2],  15,2));				// 18;4-Vlr PIS
								},;
								{;											// 19-COFINS
									COFINS[3],;										// 19;1-CTib COFINS-interno (converter para CTS RECEITA==REVISAR ACIMA)
									alltrim(str(vBasePis, 15,2)),;			// 19;2-Vlr Base COFINS
									alltrim(str(COFINS[1], 7,2)),;			// 19;3-% Tributa��o COFINS
									alltrim(str(COFINS[2],15,2));				// 19;4-Vlr COFINS
								},;
								alltrim(str(nVlrDesc,15,2)),;		// 20 Desconto do Item
								alltrim(str(0,15,2));				// 21 Desconto do Geral (Proporcional) - Verificar
							})
		TOTIMP[01]+=VM_DET[nX,16]			// 01-Base de Calculo ICMS
		TOTIMP[02]+=VM_DET[nX,15]			// 02-Valor ICMS
		TOTIMP[03]+=0							// 03-Base de Calculo ICMS-Substitui��o
		TOTIMP[04]+=0							// 04-Vlr ICMS-Substitui��o
		TOTIMP[05]+=VLRTOTIT					// 05-Vlr Total Produtos
		TOTIMP[06]+=0							// 06-Vlr IPI
		TOTIMP[07]+=PIS[2]					// 07-Vlr PIS
		TOTIMP[08]+=COFINS[2]				// 08-Vlr COFINS
		TOTIMP[09]+=0							// 09-Vlr II
		TOTIMP[12]+=nVlrDesc					// 12-Vlr Desconto
	end
next
	TOTIMP[10]+=0								// 10-Vlr Frete
	TOTIMP[11]+=0								// 11-Vlr Seguro
	TOTIMP[13]+=0								// 13-Vlr Outro
	TOTIMP[14]:=TOTIMP[05]-TOTIMP[12]	// 14-Valor NF (sem descontos)

PNFE[2]:=aProd
PNFE[3]:={{'Fatura','NrFatura','Vlr Total','Desconto','Vlr Liquido'}}	// Totalizador
//................1.........2...........3...........4...........5.......
nSoma  :=0
for nX:=1 to len(VM_FAT)
	aadd(PNFE[3],{	strTran(Transform(VM_FAT[nX,1],mDPL),' ','0'),;
						DTY4MD(           VM_FAT[nX,2]),;
						alltrim(str(      VM_FAT[nX,3],15,2))})
	nSoma+=VM_FAT[nX,3]
next
if len(VM_FAT)>0	//...........................................se tem dados... totalizar no array 1
	PNFE[3,1,2]:=strTran(Transform(VM_FAT[1,1]-1,mDPL),' ','0')
	PNFE[3,1,3]:=alltrim(      str(nSoma,15,2))
	PNFE[3,1,4]:=alltrim(      str(    0,15,2))
	PNFE[3,1,5]:=alltrim(      str(nSoma,15,2))
end
PNFE[4]:=I_TRANS
				// PEDCAB->TR_NOME  with P1[01],;
				// PEDCAB->TR_ENDE  with P1[02],;
				// PEDCAB->TR_MUNI  with P1[03],;
				// PEDCAB->TR_UFT   with P1[04],;
				// PEDCAB->TR_TIPO  with P1[05],; (1-  2-  3-)
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
FISPNFEG(PNFE,'C') // Com os dados prontos deve-se enviar os dados via parametros para gera��o da NF-e
return(.T.)

* TIPI = http://www.receita.fazenda.gov.br/aliquotas/DownloadArqTIPI.htm

*-------------------------------------------------------------------
  static function DTY4MD(pDT,pTP)
*-------------------------------------------------------------------
default pTP to '' // tipo se deve usar Time Zone e Horas
//rDT:=dtos(pDT)
//rDT:=Left(rDT,4)+'-'+Substr(rDT,5,2)+'-'+Right(rDT,2)
rDT:=pb_zer(year(pDT),4)+'-'+pb_zer(Month(pDT),2)+'-'+pb_zer(day(pDT),2)
if pTP=='TZ'
	rDT+='T'+time()+'-03:00'
end
return (rDT)
*--------------------------------------------------------EOF--------
