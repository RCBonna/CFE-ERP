static aVariav := {'',0,.T.,0,'','','0',{},{},0,'',''}
 //.................1.2..3..4..5..6..7..8..9.10.11.12
*-----------------------------------------------------------------------------*
#xtranslate nCGC			=> aVariav\[  1 \]
#xtranslate cValor		=> aVariav\[  2 \]
#xtranslate lRT			=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate cRT			=> aVariav\[  5 \]
#xtranslate cKey			=> aVariav\[  6 \]
#xtranslate nKey			=> aVariav\[  7 \]
#xtranslate oNF			=> aVariav\[  8 \]
#xtranslate aNF			=> aVariav\[  9 \]
#xtranslate nZ				=> aVariav\[ 10 \]
#xtranslate REGISTRO		=> aVariav\[ 11 \]
#xtranslate cConteudo	=> aVariav\[ 12 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------*
function SPEDC000(pEmpresa,pData,pCGC,pProcSAG)
*-----------------------------------------------------------------------*
REGISTRO:='C001'
cConteudo:='0'//....................................Bloco tem dados
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'-'+REGISTRO,;//........03-Chave Acesso
				cConteudo;//............................04-Conteúdo
				}))
aNrReg[2]++
SPEDENTRADA(pEmpresa,pData)
pb_msg('Finalizado processamento das entradas')
SPEDSAIDA(pEmpresa,pData)
pb_msg('Finalizado processamento das saidas')
if pProcSAG // tem dados do SAG
	SPEDSAG(pEmpresa,pData)
	pb_msg('Finalizado processamento das saidas')
end

//..................................................Encerramento Bloco C
REGISTRO:='C990'
aNrReg[2]++//.......................................somar antes de gera o registro
cConteudo:=AllTrim(str(aNrReg[2],10))//.............02-QTD_LIN_C (quandidade registros Bloco C)
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//...................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'-'+REGISTRO,;//........03-Chave Acesso
				cConteudo;//............................04-Conteúdo
				}))
return NIL

*-----------------------------------------------------------------------*
static function SPEDENTRADA(pEmpresa,pData,pCGC)
*-----------------------------------------------------------------------*
select ENTCAB
ORDEM DTEDOC
DbGoTop()
dbseek(dtos(pData[1]),.T.)
while !eof().and.ENTCAB->EC_DTENT<=pData[2]
	pb_msg('SPED: Entradas:'+dtoc(ENTCAB->EC_DTENT)+str(ENTCAB->EC_DOCTO,8)+'/'+ENTCAB->EC_SERIE)
	if !ENTCAB->EC_SERIE+'#'$'NPS#CF #' // Não é nf de serviços e nem CF
		CLIENTE->(DBSeek(str(ENTCAB->EC_CODFO,5)))
		oNF:=RtEntrada() // Busca a NF e seus detalhes
		if len(oNF[42])>0//...........................................................Não tem itens para esta NF
			SPEDC100(pEmpresa,oNF,;//..................................................Registro da NF
						'Entrada: NF:'+str(ENTCAB->EC_DOCTO,8)+' Serie:'+ENTCAB->EC_SERIE+' Cliente:'+str(ENTCAB->EC_CODFO,5),;
						pData)
		end
		select ENTCAB
//		INKEY(0)
	end
	if ENTCAB->EC_SERIE=='NPS' // É nf de serviços
		alert('SPED: Entradas/Servico:'+dtoc(ENTCAB->EC_DTENT)+str(ENTCAB->EC_DOCTO,8)+'/'+ENTCAB->EC_SERIE)
	end
	skip
end
return NIL

*-----------------------------------------------------------------------*
static function SPEDSAIDA(pEmpresa,pData,pCGC)
*-----------------------------------------------------------------------*
select PEDCAB
ORDEM DTEPED
DbGoTop()
dbseek(dtos(pData[1]),.T.)
while !eof().and.PEDCAB->PC_DTEMI<=pDATA[2]
	pb_msg('SPED: Saidas:'+dtoc(PEDCAB->PC_DTEMI)+'-'+str(PEDCAB->PC_PEDID,8))
	if PEDCAB->PC_FLAG.and.!PEDCAB->PC_SERIE=='NPS' // Não é nf de serviços e a nota foi processada
		CLIENTE->(dbseek(str(PEDCAB->PC_CODCL,5)))
		oNF:=RtSaida() // busca dados da NF e seus detalhes
		if len(oNF[42])>0//...........................................................Não tem itens para esta NF
			SPEDC100(pEmpresa,oNF,;//..................................................Registro da NF
						'Saidas: NF:'+str(PEDCAB->PC_PEDID,8)+' Serie:'+PEDCAB->PC_SERIE+' Cliente:'+str(PEDCAB->PC_CODCL,5),;
						pData) // Criar C100
		end
		select PEDCAB
	end
	skip
end
return NIL

*-----------------------------------------------------------------------*
 static function SPEDSAG(pEmpresa,pData,pCGC)
*-----------------------------------------------------------------------*
select NFC
ORDEM DATA
DbGoTop()
dbseek(dtos(pData[1]),.T.)
while !eof().and.NFC->NF_DTEMI<=pDATA[2]
	pb_msg('SPED: SAG:'+dtoc(NFC->NF_DTEMI)+'-'+NF_TIPO+'-'+NF_SERIE+'-'+str(NF_NRNF,6))
	if !NFC->NF_SERIE=='NPS' // Não é nf de serviços e a nota foi processada
		CLIENTE->(dbseek(str(NFC->NF_EMIT,5)))
		oNF:=RtSAG() // Busca dados da NF e seus detalhes
		if len(oNF[42])>0//...........................................................Não tem itens para esta NF
			SPEDC100(pEmpresa,oNF,;//..................................................Registro da NF
						'SAG - NF:'+dtoc(NFC->NF_DTEMI)+'-Tipo='+NFC->NF_TIPO+'- Serie='+NFC->NF_SERIE+'-NRNF='+str(NFC->NF_NRNF,6),;
						pData) // Criar C100
		end
		select NFC
	end
	skip
end
return NIL

*------------------------------------------------------------------------------------------*
	static function SPEDC100(pEmpresa,poNF,pOBS,pData) // Vendas ou Entradas (Cab+Detalhes)
*------------------------------------------------------------------------------------------*
SPED0150(pEmpresa,; //.......................................................................Criar Emitente se não existir
			poNF[3],;
			' Tipo:'+poNF[1]+' NF='+AllTrim(str(poNF[04],12))+' Serie='+poNF[7])

select SPEDBAS
REGISTRO:='C100'
cRT     :='01'
cNFE    :=''

cConteudo:=if(poNF[1]=='E','0','1')//.............02-Indicador do tipo de operação
cConteudo+='|'+poNF[2]//..........................03-Indicador do emitente do documento fiscal (0=Proprio 1=Terceiro)
cConteudo+='|'+pb_zer(poNF[3],5)//................04-Cod Participante
cConteudo+='|'+poNF[6]//..........................05-Modelo 4.1.1. Ato cotep
cConteudo+='|'+poNF[7]//..........................06-Situação 4.1.2. Ato cotep
if poNF[6]=='55' // é nota fiscal NF-e
	if poNF[2]=='0' // NF-e Próprias
		cRT :='01'
		cNFE:=poNF[28]
		if empty(cNFE)
	//		cNFE:=BuscaKeyNFE(poNF[4],poNF[29]) // ver no XML o código
			cNFE:='42'
			cNFE+=pb_zer(year(poNF[08])-2000,2)+pb_zer(month(poNF[08]),2)//..... AAMM
			cNFE+=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)//.................CNPJ
			cNFE+=PARAMETRO->PA_MODNFE//.........................................Modelo NFE=55
			cNFE+='0'+cRT//......................................................Serie
			cNFE+=pb_zer(poNF[04],9)//...........................................Nr Documento
			cNFE+=pb_zer(poNF[30],8)//...........................................Controle parte 1
			cNFE+=str(pb_chkdgt(pb_zer(poNF[30],8),3),1)//.......................Controle parte 2
			cNFE+=CalcDg(cNFE)//.................................................Novo Digito Verificador
		end
	end
else // outros numero de series
	cRT:=pb_zer(val(SONUMEROS(poNF[7])),2)
	if cRT=='00'
		cRT:='01'
	end
end
cConteudo+='|'+cRT//.......................................07-Serie Numerica
cConteudo+='|'+AllTrim(str(poNF[04],12))//.................08-Numero Documento
cConteudo+='|'+cNFE//......................................09-Chave NFE
cConteudo+='|'+SONUMEROS(dtoc(poNF[08]))//.................10-DT Emissao
cConteudo+='|'+SONUMEROS(dtoc(poNF[09]))//.................11-DT Entrada/Saida
cConteudo+='|'+AllTrim(transform(poNF[10],mI132))//........12-Valor Total
cConteudo+='|'+str(poNF[11],1)//...........................13-Tipo Pagamento
cConteudo+='|'+AllTrim(transform(poNF[12],mI132))//........14-Vlr Desconto
cConteudo+='|'+AllTrim(transform(poNF[13],mI132))//........15-Vlr Abatimento Isento
cConteudo+='|'+AllTrim(transform(poNF[14],mI132))//........16-Vlr Mercadorias
cConteudo+='|'+str(poNF[15],1)//...........................17-Tipo Frete
cConteudo+='|'+AllTrim(transform(poNF[16],mI132))//........18-Vlr Frete
cConteudo+='|'+AllTrim(transform(poNF[17],mI132))//........19-Vlr Seguro
cConteudo+='|'+AllTrim(transform(poNF[18],mI132))//........20-Vlr Despesas Acessorias
cConteudo+='|'+AllTrim(transform(poNF[19],mI132))//........21-Vlr Base ICMS
cConteudo+='|'+AllTrim(transform(poNF[20],mI132))//........22-Vlr ICMS
cConteudo+='|'+AllTrim(transform(poNF[21],mI132))//........23-Vlr Base de cálculo do ICMS substituição trib
cConteudo+='|'+AllTrim(transform(poNF[22],mI132))//........24-Vlr ICMS retido por substituição trib
cConteudo+='|'+AllTrim(transform(poNF[23],mI132))//........25-Vlr total do IPI
cConteudo+='|'+AllTrim(transform(poNF[24],mI132))//........26-Vlr total do PIS
cConteudo+='|'+AllTrim(transform(poNF[25],mI132))//........27-Vlr total da COFINS
cConteudo+='|'+AllTrim(transform(poNF[26],mI132))//........28-Vlr total do PIS retido por substituição trib
cConteudo+='|'+AllTrim(transform(poNF[27],mI132))//........29-Vlr total do PIS retido por substituição trib
cConteudo+='|'//...........................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//................................................................01-Codigo.Empresa
							REGISTRO,;//................................................................02-Codigo.Registro
							str(pEmpresa,3)+'-C100-'+str(poNF[04],12)+cRT+pb_zer(poNF[3],5)+'-0000',;//.03-Chave Acesso
							cConteudo;//................................................................04-Conteúdo
							}))
aNrReg[2]++
if poNF[6]=='55'.and.poNF[2]=='0'
	poNF[42]:={} // não gerar C170 para NF-E própria
end

for nZ:=1 to len(poNF[42])//.....................Itens da nota fiscal
	SPED0200(pEmpresa,poNF[42][nZ][2],; //.........................................................Criar Produto (0200)
			' Tipo:'+poNF[1]+' NF='+AllTrim(str(poNF[04],12))+' Serie='+poNF[7]+' Seq:'+str(poNF[42][nZ][1]))

	SPED0400(pEmpresa,poNF[42][nZ][09],; //........................................................Criar Natureza Operacao
			' Nota Fiscal '+poNF[1]+' NF='+AllTrim(str(poNF[04],12))+' Serie='+poNF[7]+' Seq:'+str(poNF[42][nZ][1]))
			
	REGISTRO:='C170'
	cNFE    :=''
	cConteudo:=Alltrim(str(nZ,4))//.................................02-Sequencia
	cConteudo+='|'+pb_zer(poNF[42][nZ][2],L_P)//....................03-Cod Produto
	cConteudo+='|'//................................................04-Descr Complementar
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][03],mI113))//.....05-Quantidade
	cConteudo+='|'+AllTrim(          poNF[42][nZ][04])//............06-Unidade
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][06],mI132))//.....07-Vlr Total
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][05],mI132))//.....08-Vlr Desconto
	cConteudo+='|'+         str(     poNF[42][nZ][07],1)//..........09-Tipo Movimentacao (0=Sim 1=Não)
	cConteudo+='|'+                  poNF[42][nZ][08]//.............10-Situação Trib ICMS
	cConteudo+='|'+left(pb_zer(      poNF[42][nZ][09],7),4)//.......11-Cód Fiscal de Operação e Prestação(NAT.OP)
	cConteudo+='|'+      pb_zer(     poNF[42][nZ][09],7)//..........12-Cód Fiscal de Operação e Prestação(NAT.OP)
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][10],mI132))//.....13-Vlr Base ICMS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][11],mI132))//.....14-Alq ICMS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][12],mI132))//.....15-Vlr ICMS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][13],mI132))//.....16-Subs Trib Vlr Base ICMS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][14],mI132))//.....17-Subs Trib Aliq ICMS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][15],mI132))//.....18-Subs Trib Vlr ICMS
	cConteudo+='|'+        str(      poNF[42][nZ][16],1)//..........19-Periodo Apuração
	cConteudo+='|'+                  poNF[42][nZ][17]//.............20-Cod Sit Trib IPI (Branco=Nao Contr IPI)
	cConteudo+='|'+                  poNF[42][nZ][18]//.............21-Cod Enq Trib IPI (Branco=Nao Contr IPI)
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][19],mI132))//.....22-Vlr Base IPI
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][20],mI132))//.....23-Aliq IPI
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][21],mI132))//.....24-Vlr IPI
	cConteudo+='|'+                  poNF[42][nZ][22]//.............25-Sit Trib PIS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][23],mI132))//.....26-Vlr Base PIS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][24],mI132))//.....27-Aliq PIS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][25],mI132))//.....28-Base Quantidade PIS (Branco?)
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][26],mI132))//.....29-Aliq PIS (Reais=Branco?)
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][27],mI132))//.....30-Vlr PIS
	cConteudo+='|'+                  poNF[42][nZ][28]//.............25-Sit Trib COFINS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][29],mI132))//.....26-Vlr Base COFINS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][30],mI132))//.....27-Aliq COFINS
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][31],mI132))//.....28-Base Quantidade COFINS (Branco?)
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][32],mI132))//.....29-Aliq COFINS (Reais=Branco?)
	cConteudo+='|'+AllTrim(transform(poNF[42][nZ][33],mI132))//.....30-Vlr COFINS
	cConteudo+='|'+                  poNF[42][nZ][34]//.............31-Conta Contabil
	cConteudo+='|'//................................................Finaliza conteúdo
	*----------------------------------------------------------------------Gravar
	SPEDBAS->(AddRec(30,{pEmpresa,;//.........................................................................01-Codigo.Empresa
								REGISTRO,;//.........................................................................02-Codigo.Registro
								str(pEmpresa,3)+'-C100-'+str(poNF[04],12)+cRT+pb_zer(poNF[3],5)+'-'+pb_zer(nZ,4),;//.03-Chave Acesso
								cConteudo;//.........................................................................04-Conteúdo
								}))
	aNrReg[2]++
next
*----------------------------------------------------------------------Gravar
REGISTRO:='C190'
for nZ:=1 to len(poNF[43])//..........................................Itens de Total da NF
	cConteudo:=poNF[43][nZ][1]//....................................02=CST_ICMS  03=CFOP  04=ALIQ_ICMS
	cConteudo+=    AllTrim(transform(poNF[43][nZ][02],mI132))//.....05-VL_OPR
	cConteudo+='|'+AllTrim(transform(poNF[43][nZ][03],mI132))//.....06-VL_BC_ICMS
	cConteudo+='|'+AllTrim(transform(poNF[43][nZ][04],mI132))//.....07-VL_ICMS
	cConteudo+='|'+AllTrim(transform(poNF[43][nZ][05],mI132))//.....08-VL_BC_ICMS_ST
	cConteudo+='|'+AllTrim(transform(poNF[43][nZ][06],mI132))//.....09-VL_ICMS_ST
	cConteudo+='|'+AllTrim(transform(poNF[43][nZ][07],mI132))//.....10-VL_RED_BC
	cConteudo+='|'+AllTrim(transform(poNF[43][nZ][08],mI132))//.....11-VL_IPI
	cConteudo+='|'+AllTrim(poNF[43][nZ][09])//......................12-COD_OBS
	cConteudo+='|'//...................................................Finaliza conteúdo
	*-----------------------------------------------------------------------------------------------Gravar
	SPEDBAS->(AddRec(30,{pEmpresa,;	//..............................................................01-Codigo.Empresa
								REGISTRO,;//................................................................02-Codigo.Registro
								str(pEmpresa,3)+'-C100-'+str(poNF[04],12)+cRT+pb_zer(poNF[3],5)+'-9999',;//.03-Chave Acesso
								cConteudo;//................................................................04-Conteúdo
								}))
	aNrReg[2]++
	select SPEDAICM
	//str(SC_EMPRESA,3)+SC_TIPO+SC_PERIODO
	if !dbseek(str(pEmpresa,3)+substr(poNF[43][nZ][1],5,4)+left(dtos(pData[1]),6))
		AddRec(30,{	pEmpresa,;
						substr(poNF[43][nZ][1],5,4),;
						left(dtos(pData[1]),6);
						})
	end
	replace ;
				SC_VLR_02 with SC_VLR_02 + poNF[43][nZ][03]//................04-E110=VL_TOT_DEBITOS
	
	if !dbseek(str(pEmpresa,3)+'E110'+left(dtos(pData[1]),6))
		AddRec(30,{	pEmpresa,;
						'E110',;
						left(dtos(pData[1]),6);
						})
	end
	if poNF[1]=='E'
		if (substr(poNF[43][nZ][1],5,1)$'123'.and.substr(poNF[43][nZ][1],5,4)#'1605').or.substr(poNF[43][nZ][1],5,4)=='5605'
			replace ;
						SC_VLR_02 with SC_VLR_02 + 0,;//................04-E110=VL_TOT_DEBITOS
						SC_VLR_03 with SC_VLR_03 + 0,;//................05-E110=VL_AJ_DEBITOS
						SC_VLR_04 with SC_VLR_04 + 0,;//................06-E110=VL_TOT_AJ_DEBITOS
						SC_VLR_05 with SC_VLR_05 + 0,;//................07-E110=VL_ESTORNOS_CRED
						SC_VLR_06 with SC_VLR_06 + poNF[43][nZ][04],;//.08-E110=VL_TOT_CREDITOS
						SC_VLR_07 with SC_VLR_07 + 0,;//................09-E110=VL_AJ_CREDITOS
						SC_VLR_08 with SC_VLR_08 + 0,;//................10-E110=VL_TOT_AJ_CREDITOS
						SC_VLR_09 with SC_VLR_09 + 0,;//................11-E110=VL_ESTORNOS_DEB
						SC_VLR_10 with SC_VLR_10 + 0,;//................12-E110=VL_SLD_CREDOR_ANT
						SC_VLR_11 with SC_VLR_11 + 0,;//................13-E110=VL_SLD_APURADO
						SC_VLR_12 with SC_VLR_12 + 0,;//................14-E110=VL_TOT_DED
						SC_VLR_13 with SC_VLR_13 + 0,;//................15-E110=VL_ICMS_RECOLHER
						SC_VLR_14 with SC_VLR_14 + 0,;//................16-E110=VL_SLD_CREDOR_TRANSPORTAR
						SC_VLR_15 with SC_VLR_15 + 0  //................17-E110=DEB_ESP
		end
	elseif poNF[1]=='S'
		if substr(poNF[43][nZ][1],5,1)$'567'.or.substr(poNF[43][nZ][1],5,4)=='1605'
			replace ;
						SC_VLR_02 with SC_VLR_02 + poNF[43][nZ][04],;//.04-E110=VL_TOT_DEBITOS
						SC_VLR_03 with SC_VLR_03 + 0,;//................05-E110=VL_AJ_DEBITOS
						SC_VLR_04 with SC_VLR_04 + 0,;//................06-E110=VL_TOT_AJ_DEBITOS
						SC_VLR_05 with SC_VLR_05 + 0,;//................07-E110=VL_ESTORNOS_CRED
						SC_VLR_06 with SC_VLR_06 + 0,;//................08-E110=VL_TOT_CREDITOS
						SC_VLR_07 with SC_VLR_07 + 0,;//................09-E110=VL_AJ_CREDITOS
						SC_VLR_08 with SC_VLR_08 + 0,;//................10-E110=VL_TOT_AJ_CREDITOS
						SC_VLR_09 with SC_VLR_09 + 0,;//................11-E110=VL_ESTORNOS_DEB
						SC_VLR_10 with SC_VLR_10 + 0,;//................12-E110=VL_SLD_CREDOR_ANT
						SC_VLR_11 with SC_VLR_11 + 0,;//................13-E110=VL_SLD_APURADO
						SC_VLR_12 with SC_VLR_12 + 0,;//................14-E110=VL_TOT_DED
						SC_VLR_13 with SC_VLR_13 + 0,;//................15-E110=VL_ICMS_RECOLHER
						SC_VLR_14 with SC_VLR_14 + 0,;//................16-E110=VL_SLD_CREDOR_TRANSPORTAR
						SC_VLR_15 with SC_VLR_15 + 0  //................17-E110=DEB_ESP
		end
	end	
	select SPEDBAS
next

return NIL


/* 4.1.2- Tabela Situação do Documento
Código Descrição
	00 Documento regular
	01 Documento regular extemporâneo
	02 Documento cancelado
	03 Documento cancelado extemporâneo
	04 NFe denegada
	05 NFe - Numeração inutilizada
	06 Documento Fiscal Complementar
	07 Documento Fiscal Complementar extemporâneo.
	08 Documento Fiscal emitido com base em Regime Especial ou Norma Específica
*/

/* 4.1.2- Tabela Situação do Documento
Código Descrição
	00	Documento regular
 	01 Documento regular extemporâneo
	02 Documento cancelado
	03	Documento cancelado extemporâneo
	04	NFe denegada
	05 NFe - Numeração inutilizada
	06 Documento Fiscal Complementar
	07 Documento Fiscal Complementar extemporâneo.
	08 Documento Fiscal emitido com base em Regime Especial ou Norma Específica
 */
