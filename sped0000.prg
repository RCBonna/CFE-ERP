static aVariav := {'',{},.T.,0,'','','0',{},{},{},'','',.F.}
//..................1..2..3..4..5..6..7..8...9.10.11.12..13
*-----------------------------------------------------------------------------*
#xtranslate nCGC			=> aVariav\[  1 \]
#xtranslate aNFE			=> aVariav\[  2 \]
#xtranslate lRT			=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate cRT			=> aVariav\[  5 \]
#xtranslate cVerLay		=> aVariav\[  6 \]
#xtranslate cTPEnv		=> aVariav\[  7 \]
#xtranslate aCodEst		=> aVariav\[  8 \]
#xtranslate nY				=> aVariav\[  9 \]
#xtranslate Data			=> aVariav\[ 10 \]
#xtranslate REGISTRO		=> aVariav\[ 11 \]
#xtranslate cConteudo	=> aVariav\[ 12 \]
#xtranslate lProcSAG		=> aVariav\[ 13 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------*
function SPED0000()
*-----------------------------------------------------------------------*
SPEDINIC()
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->CFEACFC',;
				'R->CFEACFD',;
				'R->PEDCAB',;
				'R->PEDDET',;
				'R->ENTCAB',;
				'R->ENTDET',;
				'R->PROD',;
				'R->UNIDADE',;
				'R->FISACOF',;
				'R->NATOP',;
				'R->MOVCLIX',;
				'C->CTRNF',;
				'E->SPEDAICM',;
				'E->SPEDBAS';
			})				
	return NIL
end
lProcSAG:=.F.
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
			ORDEM CODIGO // MANTER ESTE INDICE SELECIONADO PARA DETALHES DA NF SAG
			lProcSAG:=.T.
		end
	else
		alert('SAG;Nao encontrado arquivos de indices;deve-se entrar no sag para regerar')
	end
end

public aNrReg  :={0,0,0,0,0,0,0,0}
//................0.C.D.E.G.H.1.9.........TOTAIS POR BLOCO (Zero + "C"
//................1.2.3.4.5.6.7.8.........TOTAIS POR BLOCO (Zero + "C"

CGC     :=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)
cVerLay :='003'//.....Codigo da Versão do Lay-Out
cTPEnv  :='0'//.......Codigo envio
VM_CTABI:=329//.......Ademir
Data    :={BOM(BOM(PARAMETRO->PA_DATA)-1),BOM(PARAMETRO->PA_DATA)-1}

pb_box(14,18,,,,'Processar-SPED-FISCAL-Periodo')
@ 15,20 say 'Empresa.............: '+VM_EMPR      pict mUUU
@ 16,20 say 'Contabilista........:' get VM_CTABI  pict mI5  valid fn_codigo(@VM_CTABI,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CTABI,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}) when pb_msg('O Contador deve ter registrado na referencia o codigo de CRC-Consenho Regional de Contabilidade')
@ 18,20 say 'Versao Lay-Out......: '+cVerLay
@ 19,20 say 'Tipo Envio..........:' get cTPEnv    pict mUUU valid cTPEnv$'01' when pb_msg('0-Remessa Original   1-Remessa Substituro')
@ 20,20 say 'Data INICIAL........:' get Data[1]   pict mDT
@ 21,20 say 'Data FINAL..........:' get Data[2]   pict mDT valid Data[2]>=Data[1]
@ 21,70 say 'SILO'
read
if if(lastkey()#K_ESC,pb_sn(),.F.)
	cConteudo:='Erros na geracao do SPED de '+DTOC(Data[1])+' a '+DTOC(Data[2])
//	strFile(cConteudo,'C:\TEMP\SPEDERR.TXT',.F.)
	CriaLog('C:\TEMP\SPEDERR.TXT',dtoc(date())+'-'+time(),.F.)
	SELECT PROD
	ORDEM CODIGO
	
	SELECT SPEDAICM
	ZAP // Eliminar registros SPEDAICM
	//Eliminar apenas os registros do PERIODO
	
	SELECT SPEDBAS
	ZAP // Eliminar registros SPEDBAS

	CodEmpresa:=1
	@00,30 say 'Bloco Zero'
	SPEDA000(CodEmpresa,VM_CTABI,'Registro Zero') // 
	@01,30 say 'Bloco C'
	SPEDC000(CodEmpresa,Data,CGC,lProcSAG) //........Montar o Bloco C-Documentos Fiscais I – Mercadorias (ICMS/IPI)
	@02,30 say 'Bloco D'
	SPEDD000(CodEmpresa,Data,CGC) //.................Montar o Bloco D-Documentos Fiscais II – Serviços (ICMS)
	//SPEDG000(CodEmpresa,Data,CGC) //...............Montar o Bloco G-Controle do Crédito de ICMS do Ativo Permanente – CIAP – modelos “C” e “D” (só 2011)
	SPEDE000(CodEmpresa,Data,CGC) //.................Montar o Bloco E-Apuração do ICMS e do IPI
	@03,30 say 'Bloco H'
	SPEDH000(CodEmpresa,Data,CGC) //.................Montar o Bloco H-Inventário Físico
	@04,30 say 'Bloco 0-Finalizar'
	SPED0990(CodEmpresa,Data,CGC) //.................Fechar o Bloco Zero
	@05,30 say 'Bloco 1'
	SPED1000(CodEmpresa,Data,CGC) //.................Montar o Bloco 1-Outras informações
	@06,30 say 'Bloco 9'
	SPED9000(CodEmpresa,Data,CGC) //.................Montar o Bloco 9-Controle e Encerramento
	SELECT SPEDBAS
	GO TOP
	cArqTemp:='C:\TEMP\SPED'+substr(dtos(Data[1]),3,4)+'.TXT'
	pb_msg('Gerando arquivo SPED '+cArqTemp)
	if pb_ligaimp(,cArqTemp,'Geracao SPED-FISCAL ')
		while !eof()
			??'|'+SC_TIPO+'|'
			??AllTrim(SC_CONTEUDO)
			?
			skip
		end
		pb_deslimp(,,.F.)
		Alert('Arquivo SPED-FISCAL Gerado '+cArqTemp)
	end
end
dbcloseall()
return NIL

*-------------------------------------------------------------------------------------*
	function SPEDA000(pEmpresa,pCodCTB,pOBS) // Abertura Bloco 0
*-------------------------------------------------------------------------------------*
*-------------------------------------------REGISTRO 0000-ABERTURA DO ARQUIVO DIGITAL E IDENTIFICAÇÃO DA ENTIDADE
	CGC     :=pb_zer(val(SONUMEROS(PARAMETRO->PA_CGC)),14)
	REGISTRO:='0000'
	cConteudo:=cVerLay//................................02-Codigo Versao Lay-out
	cConteudo+='|'+cTPEnv//.............................03-TIPO ENVIO
	cConteudo+='|'+SONUMEROS(dtoc(Data[1]))//...........04-DATA INICIAL
	cConteudo+='|'+SONUMEROS(dtoc(Data[2]))//...........05-DATA FINAL
	cConteudo+='|'+alltrim(VM_EMPR)//...................06-NOME EMPRESA
	cConteudo+='|'+alltrim(CGC)//.......................07-CNPJ
	cConteudo+='|'//....................................08-CPF
	cConteudo+='|'+PARAMETRO->PA_UF//...................09-UF
	cConteudo+='|'+SONUMEROS(PARAMETRO->PA_INSCR)//.....10-Inscr Estadual
	cConteudo+='|'+PB_ZER(PARAMETRO->PA_CDIBGE,7)//.....11-Código IBGE
	cConteudo+='|'+alltrim(PARAMETRO->PA_CDMUNIC)//.....12-Código Municipal
	if !empty(alltrim(PARAMETRO->PA_CDSUFRA))
		cConteudo+='|'+PB_ZER(PARAMETRO->PA_CDSUFRA,9)//.13-Código SUFRAMA
	else
		cConteudo+='|'//.................................13.Código SUFRAMA
	end
	cConteudo+='|B'//...................................14-Perfil
	cConteudo+='|1|'//..................................15-Tp Atividade
	*----------------------------------------------------------------------Gravar
	SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
					REGISTRO,;//............................02-Codigo.Registro
					str(pEmpresa,3)+'-0000',;//.............03-Chave Acesso
					cConteudo;//............................04-Conteúdo
					}))
	aNrReg[1]++

	*-------------------------------------------REGISTRO 0001-ABERTURA DO BLOCO 0
	REGISTRO:='0001'
	cConteudo:='0|'//...............................01-Abertura Bloco
	*----------------------------------------------------------------------Gravar
	SPEDBAS->(	AddRec(30,{pEmpresa,;//.............01-Codigo.Empresa
					REGISTRO,;//........................02-Codigo.Registro
					str(pEmpresa,3)+'-0001',;//.........03-Chave Acesso
					cConteudo;//........................04-Conteúdo
					}))
	aNrReg[1]++

	*-------------------------------------------REGISTRO 0005-DADOS COMPLEMENTARES DA ENTIDADE
	REGISTRO :='0005'
	cConteudo:='COOLACER'//..........................................02-Nome Fantasia
	cConteudo+='|'+pb_zer(val(SONUMEROS(PARAMETRO->PA_CEP)),8)//.....03-CEP
	cConteudo+='|'+Upper(AllTrim(PARAMETRO->PA_ENDER))//.............04-Endereco
	cConteudo+='|'+AllTrim(PARAMETRO->PA_ENDNRO)//...................05-Numero
	cConteudo+='|'+Upper(AllTrim(PARAMETRO->PA_ENDCOMP))//...........06-Complemento
	cConteudo+='|'+Upper(AllTrim(PARAMETRO->PA_BAIRRO))//............07-Bairro
	cConteudo+='|'+pb_zer(val(SONUMEROS(PARAMETRO->PA_FONE)),10)//...08-Fone
	cConteudo+='|'+pb_zer(val(SONUMEROS(PARAMETRO->PA_FAX)),10)//....09-Fax
	cConteudo+='|'+Alltrim(PARAMETRO->PA_EMAIL)//....................10-E-Mail
	cConteudo+='|'
	*----------------------------------------------------------------------Gravar
	SPEDBAS->(	AddRec(30,{pEmpresa,;//.............01-Codigo.Empresa
					REGISTRO,;//........................02-Codigo.Registro
					str(pEmpresa,3)+'-0005',;//.........03-Chave Acesso
					cConteudo;//........................04-Conteúdo
					}))
	aNrReg[1]++

	*-------------------------------------------REGISTRO 0015-DADOS DO CONTRIBUINTE SUBSTITUTO
	* 0015-Não Necessário *
	*-------------------------------------------REGISTRO 0100-DADOS DO CONTABILISTA
	REGISTRO:='0100'
	cConteudo:=''
	select CLIENTE
	if dbseek(str(pCodCTB,5))
		cConteudo:=upper(AllTrim(CLIENTE->CL_RAZAO))//...................02-Nome Contabilista
		cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_CGC)),11)//......03-CPF
		cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_REFER)),11)//....04-CRC-Conselho Regional Contabilidade
		cConteudo+='|'//.................................................05-CNPJ (não necessário)
		cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_CEP)),8)//.......06-CEP
		cConteudo+='|'+Upper(AllTrim(CLIENTE->CL_ENDER))//...............07-Endereco
		cConteudo+='|'+AllTrim(CLIENTE->CL_ENDNRO)//.....................08-Numero
		cConteudo+='|'+Upper(AllTrim(CLIENTE->CL_ENDCOMP))//.............09-Complemento
		cConteudo+='|'+Upper(AllTrim(CLIENTE->CL_BAIRRO))//..............10-Bairro
		cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_FONE)),10)//.....11-Fone
		cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_FAX)),10)//......12-Fax
		cConteudo+='|'+AllTrim(CLIENTE->CL_EMAIL)//......................13-E-Mail
		cConteudo+='|'+pb_zer(CLIENTE->CL_CDIBGE,7)//....................14-Código Municipio
		cConteudo+='|'
	else
			@23,00 say 'ERRO - Codigo CLIENTE Nao cadastrado '+pb_zer(pCodCTB,5)+'-'+pOBS
			CriaLog('C:\TEMP\SPEDERR.TXT','ERRO - Codigo CLIENTE Nao cadastrado '+pb_zer(pCodCTB,5)+'-'+pOBS,.T.)
	end
	if !empty(cConteudo)
		*----------------------------------------------------------------------Gravar
		SPEDBAS->(	AddRec(30,{pEmpresa,;//..............................01-Codigo.Empresa
						REGISTRO,;//.........................................02-Codigo.Registro
						str(pEmpresa,3)+'-0100',;//..........................03-Chave Acesso
						cConteudo;//.........................................04-Conteúdo
						}))
		aNrReg[1]++
	end
	select SPEDBAS

return NIL

*--------------------------------------------------------------------------------------------*
	function SPED0150(pEmpresa,pCodigo,pOBS) // Código do participante - Cliente-0150+0175
*--------------------------------------------------------------------------------------------*
select SPEDBAS
if !dbseek(padr(str(pEmpresa,3)+'-0150-'+pb_zer(pCodigo,05)+'-00000',40)) // chave para cliente
	cConteudo:=''
	select CLIENTE
	if dbseek(str(pCodigo,5))
		*-------------------------------------------REGISTRO 0150-DADOS DO PARTICIPATE+CLIENTE+FORNECEDOR
		REGISTRO:='0150'
		cConteudo:=pb_zer(CLIENTE->CL_CODCL,5)//............................02-Cod Emitente
		cConteudo+='|'+upper(AllTrim(CLIENTE->CL_RAZAO))//..................03-Nome+Cliente+Fornecedor
		cConteudo+='|'+pb_zer(CLIENTE->CL_CDPAIS,5)//.......................04-Pais
		if CLIENTE->CL_TIPOFJ=='J'
			cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_CGC)),14)+'|'//..05-CNPJ+06-CPF	
			cConteudo+='|'+SONUMEROS(CLIENTE->CL_INSCR)//....................07-IE
		else
			cConteudo+='||'+pb_zer(val(SONUMEROS(CLIENTE->CL_CGC)),11)//.....05-CNPJ+06-CPF
			cConteudo+='|'//.................................................07-IE (Branco)
		end
		cConteudo+='|'+pb_zer(CLIENTE->CL_CDIBGE,7)//.......................08-Código Municipio
		cConteudo+='|'+pb_zer(val(SONUMEROS(CLIENTE->CL_CDSUFRA)),9)//......09-Código Suframa
		cConteudo+='|'+Upper(AllTrim(CLIENTE->CL_ENDER))//..................10-Endereco
		cConteudo+='|'+      AllTrim(CLIENTE->CL_ENDNRO)//..................11-Numero
		cConteudo+='|'+Upper(AllTrim(CLIENTE->CL_ENDCOMP))//................12-Complemento
		cConteudo+='|'+Upper(AllTrim(CLIENTE->CL_BAIRRO))//.................13-Bairro
		cConteudo+='|'
	else
		@23,00 say 'ERRO - CLIENTE Nao cadastrado '+pb_zer(pCodigo,5)+'-'+pOBS
		CriaLog('C:\TEMP\SPEDERR.TXT','ERRO - CLIENTE Nao cadastrado '+pb_zer(pCodigo,5)+'-'+pOBS,.T.)
	end
	if !empty(cConteudo)
		*----------------------------------------------------------------------Gravar
		SPEDBAS->(	AddRec(30,{pEmpresa,;//...................................01-Codigo.Empresa
						REGISTRO,;//..............................................02-Codigo.Registro
						str(pEmpresa,3)+'-0150-'+pb_zer(pCodigo,5)+'-00000',;//...03-Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
		aNrReg[1]++
	end
	*-------------------------------------------REGISTRO 0175-Alteração da Tabela de Cadastro de Participante
	REGISTRO:='0175'
	select MOVCLIX
	dbseek(str(pCodigo,5)+dtos(DATA[1]),.F.)
	while str(pCodigo,5)==str(CLX_CODCL,5)
		if dtos(CLX_DTALT)<=dtos(DATA[2])// houve alteração no período
			cConteudo:=SONUMEROS(dtoc(CLX_DTALT))
			if CLX_NROCPO==2 // Nome
				cConteudo+='|03|'+Upper(AllTrim(CLX_CONTANT))
			elseif CLX_NROCPO==55 // Código País
				cConteudo+='|04|'+pb_zer(val(CLX_CONTANT),5)
			elseif CLX_NROCPO==8 // Código CNPJ/CPF
				if CLIENTE->CL_TIPOFJ=='F'
					cConteudo+='|06|'+pb_zer(val(CLX_CONTANT),11) // CPF
				else
					cConteudo+='|05|'+pb_zer(val(CLX_CONTANT),14) // CNPJ
				end
			elseif CLX_NROCPO==9 // IE
				if CLIENTE->CL_TIPOFJ=='J'
					cConteudo+='|07|'+Upper(AllTrim(CLX_CONTANT)) // IE
				end
			elseif CLX_NROCPO==53 // Código do Município
				cConteudo+='|08|'+pb_zer(Val(AllTrim(CLX_CONTANT)),7) // Cd.Municipio
			elseif CLX_NROCPO==54 // Código Suframa
				cConteudo+='|09|'+pb_zer(Val(AllTrim(CLX_CONTANT)),9) // Cd.Suframa
			elseif CLX_NROCPO==3 // Endereço
				cConteudo+='|10|'+Upper(AllTrim(CLX_CONTANT)) // Endereço
			elseif CLX_NROCPO==56 // Nro Endereço
				cConteudo+='|11|'+Upper(AllTrim(CLX_CONTANT)) // Nro Endereço
			elseif CLX_NROCPO==57 // Complemento Endereço
				cConteudo+='|12|'+Upper(AllTrim(CLX_CONTANT)) // Complemento Endereço
			elseif CLX_NROCPO==4 // Bairo
				cConteudo+='|13|'+Upper(AllTrim(CLX_CONTANT)) // Bairo
			end
			cConteudo+='|'
			// tem que gravar como 150 e um conteúdo depois para ficar na ordem necessária no arquivo sped (cliente+alterações deste cliente)
			*----------------------------------------------------------------------Gravar
			SPEDBAS->(	AddRec(30,{pEmpresa,;//...........................................................01-Codigo.Empresa
							REGISTRO,;//......................................................................02-Codigo.Registro
							str(pEmpresa,3)+'-0150-'+pb_zer(pCodigo,05)+'-'+pb_zer(MOVCLIX->CLX_NROCPO,5),;//.03-Chave Acesso
							cConteudo;//......................................................................04-Conteúdo
							}))
			aNrReg[1]++
		end
		skip
	end
end // Cliente já cadatrado
select SPEDBAS
return NIL

*-------------------------------------------------------------------------------------*
  static function SPED0190(pEmpresa,pCodigo,pOBS) // Unidade de Medida + OBS
*-------------------------------------------------------------------------------------*
select SPEDBAS
if !dbseek(padr(str(pEmpresa,3)+'-0190-'+pCodigo,40)) // chave para Unidade de Medida
	select UNIDADE
	if dbseek(pCodigo)
		*-------------------------------------------REGISTRO 0190-Unidades de Medida
		REGISTRO:='0190'
		cConteudo:=Upper(AllTrim(pCodigo))//.............................02-Codigo UN
		cConteudo+='|'+Upper(AllTrim(UNIDADE->UN_DESCR))//..............03-Descricao Unidade
		cConteudo+='|'
		*----------------------------------------------------------------------Gravar
		SPEDBAS->(AddRec(30,{pEmpresa,;	//...............01-Codigo.Empresa
						REGISTRO,;//..........................02-Codigo.Registro
						str(pEmpresa,3)+'-0190-'+pCodigo,;//..03-Chave Acesso
						cConteudo;//..........................04-Conteúdo
						}))
		aNrReg[1]++
	else
		@23,00 say 'ERRO - UNIDADE Nao cadastrado '+pb_zer(pCodigo,5)+'-'+pOBS
		CriaLog('C:\TEMP\SPEDERR.TXT','ERRO - UNIDADE Nao cadastrado '+pb_zer(pCodigo,5)+'-'+pOBS,.T.)		
	end
end // Unidade já cadatrado
return NIL

*-------------------------------------------------------------------------------------*
	function SPED0200(pEmpresa,pCodigo,pOBS) // Produto + OBS
*-------------------------------------------------------------------------------------*
select SPEDBAS
if !dbseek(padr(str(pEmpresa,3)+'-0200-'+pb_zer(pCodigo,L_P)+'-00000',40)) // chave para Produto
	select PROD
	if dbseek(str(pCodigo,L_P))
		*-------------------------------------------REGISTRO 0200-Produto
		aCodEst:=restarray('ESTOQUE.ARR')
		REGISTRO:='0200'
		cConteudo:=pb_zer(pCodigo,L_P)//.....................................02-Codigo Produto
		cConteudo+='|'+Upper(AllTrim(PROD->PR_DESCR))//......................03-Descricao Produto
		cConteudo+='|'//.....................................................04-Codigo de Barras
		cConteudo+='|'//.....................................................05-Codigo Produto antes Mudança
		cConteudo+='|'+Upper(AllTrim(PROD->PR_UND))//........................06-Unidade
		cRT:=ascan(aCodEst,{|DET|DET[1]==PROD->PR_CTB})
		if cRT > 0
			cConteudo+='|'+pb_zer(aCodEst[cRT][3],2)//........................07-Tipo Item
		else
			cConteudo+='|'+pb_zer(99,2) //....................................07-Tipo Item = Se não achar nenhum colocar 99
		end
		cConteudo+='|'+pb_zer(Val(AllTrim(PROD->PR_CODNCM)),8)//.............08-Código NCM
		cConteudo+='|'+pb_zer(PROD->PR_TIPI,3)//.............................09-TIPI
		cConteudo+='|'+pb_zer(PROD->PR_CODGEN,2)//...........................10-NCM-Genero
		cConteudo+='|'//.....................................................11-Codigo de Serviço
		cConteudo+='|'+AllTrim(transform(PROD->PR_PICMS,mI132))//............12-ICMS operações internas
		cConteudo+='|'
		*----------------------------------------------------------------------Gravar
		SPEDBAS->(	AddRec(30,{pEmpresa,;//...................................01-Codigo.Empresa
						REGISTRO,;//..............................................02-Codigo.Registro
						str(pEmpresa,3)+'-0200-'+pb_zer(pCodigo,L_P)+'-00000',;//.03-Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						}))
		aNrReg[1]++

		*-------------------------------------------REGISTRO 0220-Unidade do Produto
		REGISTRO:='0220'
		cConteudo:=Upper(AllTrim(PROD->PR_UND))//....................02-Unidade
		cConteudo+='|1'//............................................03-Fator de Conversão na venda
		cConteudo+='|'
		*-------------------------------------------------------------------Gravar
		SPEDBAS->(	AddRec(30,{pEmpresa,;//...................................01-Codigo.Empresa
						REGISTRO,;//..............................................02-Codigo.Registro
						str(pEmpresa,3)+'-0200-'+pb_zer(pCodigo,L_P)+'-00001',;//.03-Chave Acesso
						cConteudo;//..............................................04-Conteúdo
						})) //............Manter Codigo = 200 para questões hierarquica/organação de geraçao
		aNrReg[1]++

		*--------------------------------------------Criar Registro de unidade para este item
		SPED0190(pEmpresa,PROD->PR_UND,pOBS+' Produto:'+pb_zer(pCodigo,L_P)) //criar unidade do item
		SPED0205(pEmpresa,PROD->PR_UND,pOBS+' Produto:'+pb_zer(pCodigo,L_P)) //criar modificações do item		
	else
		@23,00 say 'ERRO - Produto Nao cadastrado '+pb_zer(pCodigo,L_P)+'-'+pOBS
		CriaLog('C:\TEMP\SPEDERR.TXT','ERRO - Produto Nao cadastrado '+pb_zer(pCodigo,L_P)+'-'+pOBS,.T.)
	end
end // Produto já cadatrado
return NIL

*-------------------------------------------------------------------------------------*
  static function SPED0205(pEmpresa,pCodigo,pOBS) // Mudança em Produto + OBS
*-------------------------------------------------------------------------------------*
//--------------------------não será feito agora--------------------------------------
return NIL

*-------------------------------------------------------------------------------------*
	function SPED0400(pEmpresa,pCodigo,pOBS) // Natureza de Operação
*-------------------------------------------------------------------------------------*
select SPEDBAS
if !dbseek(padr(str(pEmpresa,3)+'-0400-'+pb_zer(pCodigo,7),40)) // chave Natureza de Operacoes
	select NATOP
	if dbseek(str(pCodigo,7))
		*-------------------------------------------REGISTRO 0400-Natureza de Operacao
		REGISTRO:='0400'
		cConteudo:=pb_zer(pCodigo,7)//...................................02-Codigo Nat Operacao
		cConteudo+='|'+Upper(AllTrim(NATOP->NO_DESCR))//.................03-Descr Natureza Operacao
		cConteudo+='|'
		*----------------------------------------------------------------------Gravar
		SPEDBAS->(	AddRec(30,{pEmpresa,;//..............................01-Codigo.Empresa
						REGISTRO,;//.........................................02-Codigo.Registro
						str(pEmpresa,3)+'-0400-'+pb_zer(pCodigo,7),;//.......03-Chave Acesso
						cConteudo;//.........................................04-Conteúdo
						}))
		aNrReg[1]++
	else
		@23,00 SAY 'ERRO - Natureza Operacao - Nao cadastrado '+pb_zer(pCodigo,7)+'-'+pOBS
		CriaLog('C:\TEMP\SPEDERR.TXT','ERRO - Natureza Operacao - Nao cadastrado '+pb_zer(pCodigo,7)+'-'+pOBS,.T.)
	end
end // Natureza Operacao Cadastrada
return NIL

*-------------------------------------------------------------------------------------*
  static function SPED0990(pEmpresa) // Totalizador Bloco Zero
*-------------------------------------------------------------------------------------*
*-------------------------------------------REGISTRO 0990-Totalizador Bloco Zero
REGISTRO :='0990'
aNrReg[1]++
cConteudo:=AllTrim(str(aNrReg[1],7))//..........................02-Total Bloco Zero
cConteudo+='|'
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//................................01-Codigo.Empresa
				REGISTRO,;//.........................................02-Codigo.Registro
				str(pEmpresa,3)+'-0990',;//...........................03-Chave Acesso
				cConteudo;//.........................................04-Conteúdo
				}))
return NIL

*-------------------------------------------------------------------------------------*
	function BuscaKeyNFE(pNrNf,pSist) // Busca NFE no XML - pSist ('C=CFE S=SAG')
*-------------------------------------------------------------------------------------*
aNFE:={	'',;//..............................................1-RETORNO DA CHAVE NFE
			'C:\NFE\SIGNED\'+pb_zer(pNrNf,7)+pSist+'.XML',;//...2-ARQUIVO
			0,;//...............................................3-HANDLE XML
			'',;//..............................................4-LEITURA ARQUIVO XML
			0,;//...............................................5-contar
			}
if file(aNFE[2])
	aNFE[3]:=fOpen(aNFE[2],0)
	if aNFE[3]<0
		alert('ERRO - Ocorreu erro na abertura do arquivo da NF Eletronica;na busca do numero da chave;NFE='+aNFE[2])
	else
		aNFE[4]:=fRead(aNFE[3],200) //..............Ler 200 bytes
		nX:=at('id="NFe',aNFE[4])
		if nX<1
			alert('ERRO - Esta NF Eletronica teve erro na leitura do ID;para buscar o codigo da chave;NFE='+aNFE[2])
		else
			aNFE[1]:=substr(aNFE[4],nX,44)
		end
	end
	fOpen(aNFE[2]) //..............................Fechar arquivo
else
	alert('ERRO - Esta NF Eletronica nao foi encontrada no diretorio;para buscar o codigo da chave;NFE='+aNFE[2])
end
return (aNFE[1])

*-----------------------------------------------------------------------------*
 function SPEDINIC()
*-----------------------------------------------------------------------------*
lRT :=.T.
cARQ:='SPEDBAS'
ferase(cARQ+'.DBF')
ferase(cARQ+ordbagext())
if dbatual(cARQ,{;
						{'SC_EMPRESA'	,'N',  3, 0},;//.......01-Código da Empresa
						{'SC_TIPO'		,'C',  4, 0},;//.......02-Tipo Registro 9999
						{'SC_CHAVE'		,'C', 40, 0},;//.......03-Chave do Registro
						{'SC_CONTEUD'	,'C',500, 0}},;//......04-Conteúdo
						RDDSETDEFAULT())
end
pb_msg('Organizando BASE DE DADOS SPED',NIL,.F.)
if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
	PACK
	Index on SC_CHAVE tag CHAVEPADRAO to (cARQ)
else
	lRT:=.F.
end
close

cARQ:='SPEDAICM'
ferase(cARQ+'.DBF')
ferase(cARQ+ordbagext())
if dbatual(cARQ,{;
						{'SC_EMPRESA'	,'N',  3, 0},;//.......01-Código da Empresa
						{'SC_TIPO'		,'C',  4, 0},;//.......02-Tipo Registro E110,
						{'SC_PERIODO'	,'C',  6, 0},;//.......03-Periodo (201004,201005)
						{'SC_VLR_02'	,'N', 15, 2},;//.......04-E110=VL_TOT_DEBITOS+Saidas e Debidos ICMS
						{'SC_VLR_03'	,'N', 15, 2},;//.......05-E110=VL_AJ_DEBITOS
						{'SC_VLR_04'	,'N', 15, 2},;//.......06-E110=VL_TOT_AJ_DEBITOS
						{'SC_VLR_05'	,'N', 15, 2},;//.......07-E110=VL_ESTORNOS_CRED
						{'SC_VLR_06'	,'N', 15, 2},;//.......08-E110=VL_TOT_CREDITOS+Entradas e Aquis com Credito
						{'SC_VLR_07'	,'N', 15, 2},;//.......09-E110=VL_AJ_CREDITOS
						{'SC_VLR_08'	,'N', 15, 2},;//.......10-E110=VL_TOT_AJ_CREDITOS
						{'SC_VLR_09'	,'N', 15, 2},;//.......11-E110=VL_ESTORNOS_DEB
						{'SC_VLR_10'	,'N', 15, 2},;//.......12-E110=VL_SLD_CREDOR_ANT
						{'SC_VLR_11'	,'N', 15, 2},;//.......13-E110=VL_SLD_APURADO
						{'SC_VLR_12'	,'N', 15, 2},;//.......14-E110=VL_TOT_DED
						{'SC_VLR_13'	,'N', 15, 2},;//.......15-E110=VL_ICMS_RECOLHER
						{'SC_VLR_14'	,'N', 15, 2},;//.......16-E110=VL_SLD_CREDOR_TRANSPORTAR
						{'SC_VLR_15'	,'N', 15, 2}},;//.......17-E110=DEB_ESP
						RDDSETDEFAULT())
end
pb_msg('Organizando BASE DE DADOS SPED-Apuracao',NIL,.F.)
if net_use(cARQ,.T.,20,cARQ,.T.,.F.,RDDSETDEFAULT())
	PACK
	Index on str(SC_EMPRESA,3)+SC_TIPO+SC_PERIODO tag CHAVEPADRAO to (cARQ)
else
	lRT:=.F.
end
close

return lRT

*---------------------------------------------------------------------------*
	function CriaLog(pFile,pTxt,pApp)
*---------------------------------------------------------------------------*
nHand:=0
TXT  :=time()+'-'+pTxt+chr(13)+chr(10)
if !file(pFile).or.!pApp
	FileDelete(pFile+'.*')
	nHand:=FCreate(pFile,0)
	fWrite(nHand,'Inffhox - Log'+chr(13)+chr(10))
	fClose(nHand)
end
nHand  :=fOpen(pFile,2)
nLenght:=fSeek(nHand,0,2) // ir para fim do arquivo
@12,00 say "Tamanho arquivo erros "+str(nLenght,6)
fWrite(nHand,@TXT)
fClose(nHand)
return nil
*-----------------------------------------------EOF-------------------------*
