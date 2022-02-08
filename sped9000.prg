static aVariav := {'',0,.T.,0,'','','0',{},{},0,'',''}
 //.................1.2..3..4..5..6..7..8..9.10.11.12
*-----------------------------------------------------------------------------*
#xtranslate nCGC			=> aVariav\[  1 \]
#xtranslate cValor		=> aVariav\[  2 \]
#xtranslate lRT			=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate nR9900		=> aVariav\[  5 \]
#xtranslate nSoma			=> aVariav\[  6 \]
#xtranslate nSomaTot		=> aVariav\[  7 \]
#xtranslate oNF			=> aVariav\[  8 \]
#xtranslate cBloco		=> aVariav\[  9 \]
#xtranslate nZ				=> aVariav\[ 10 \]
#xtranslate REGISTRO		=> aVariav\[ 11 \]
#xtranslate cConteudo	=> aVariav\[ 12 \]

#include 'RCB.CH'
*-------------------------------------------------------------------------------------------*
function SPED9000(pEmpresa,pData)//BLOCO 9: CONTROLE E ENCERRAMENTO DO ARQUIVO DIGITAL
*-------------------------------------------------------------------------------------------*
//........0......C......D......E......G.......H......1......9
//........1......2......3......4......5.......6......7......8
nSomaTOT:=0 // SOMATÓRIO GERAL DE TODOS OS REGISTROS
//....................................................................APAGAR REGISTROS = SOMA
select SPEDAICM //str(SC_EMPRESA,3)+SC_TIPO+SC_PERIODO................SOMA REGISTROS
DbGoTop()
while !eof()
	if SC_TIPO=='SOMA'
		delete
	end
	skip
end

//....................................................................CONTAGEM
select SPEDBAS
DbGoTop()
nSoma :=0
cBloco:=''
while !eof()
	if cBloco#SPEDBAS->SC_TIPO
		if !Empty(cBloco).and.!Empty(nSoma)
			SPEDSOMA(pEmpresa,cBloco,nSoma)	//
		end
		nSoma :=0
		cBloco:=SPEDBAS->SC_TIPO // Novo registro
	end
	while !eof().and.SC_TIPO==cBloco
		nSoma++ //..................................soma Registro
		nSomaTOT++
		skip
	end
end
if !Empty(cBloco).and.!Empty(nSoma)
	SPEDSOMA(pEmpresa,cBloco,nSoma)	//
end

//.....................................................................INICIA BLOCO 9
select SPEDBAS
REGISTRO:='9001'
cConteudo:='0'//....................................Bloco tem dados
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'J'+REGISTRO,;//........03-Chave Acesso (Colocado J na frente da chave para ordenar a impressao)
				cConteudo;//............................04-Conteúdo
				}))
aNrReg[8]++
nSomaTOT++
SPEDSOMA(pEmpresa,'9001',1)//..........................Cria Registro para 9900

//.....................................................................GRAVAR 9900 NA CONTAGEM DOS REGISTROS
select SPEDAICM
nR9900  := 0
REGISTRO:='9900'
if dbseek(str(pEmpresa,3)+'SOMA'+'0000**')//.......................PRIMEIRO REGISTRO
	while !eof().and.SC_TIPO=='SOMA'
		cConteudo:=left(SC_PERIODO,4)//..............................02-Bloco a ser totalizado
		cConteudo+='|'+AllTrim(str(SC_VLR_02,10))//..................03-QTD_LIN_9 (quandidade registros Bloco 9)
		cConteudo+='|'//................................................Finalizar
		*----------------------------------------------------------------------Gravar
		SPEDBAS->(	AddRec(30,{pEmpresa,;//..........................01-Codigo.Empresa
						REGISTRO,;//.....................................02-Codigo.Registro
						str(pEmpresa,3)+'J'+REGISTRO,;//.................03-Chave Acesso
						cConteudo;//.....................................04-Conteúdo
						}))
		aNrReg[8]++
		nSomaTOT ++
		nR9900   ++ //.....................................................Soma Registros tipo 9900
		skip
	end
end

//....................................................................CRIA REGISTRO DE SOMA 9900
select SPEDBAS
REGISTRO :='9900'
cConteudo:=REGISTRO//...............................02-Bloco a ser Totalizado
cConteudo+='|'+AllTrim(str(nR9900+3,10))//...........03-QTD_LIN_9 (quandidade registros Bloco 9) + 3 (Este Registro)
cConteudo+='|'//.......................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'J'+REGISTRO,;//........03-Chave Acesso (Colocado J na frente da chave para ordenar a impressao)
				cConteudo;//............................04-Conteúdo
				}))
aNrReg[8]++
nSomaTOT++

//.....................................................Registrar em 9900 reg 9990
REGISTRO :='9900'
cConteudo:='9990'//.................................02-Bloco a ser Totalizado-9990-ENCERRAMENTO
cConteudo+='|'+AllTrim(str(1,10))//.................03-QTD_LIN_9 (quandidade registros Bloco 9) + 1 (Este Registro)
cConteudo+='|'//.......................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'J'+REGISTRO,;//........03-Chave Acesso (Colocado J na frente da chave para ordenar a impressao)
				cConteudo;//............................04-Conteúdo
				}))

//.....................................................Registrar em 9900 reg 9999
REGISTRO :='9900'
cConteudo:='9999'//.................................02-Bloco a ser Totalizado-9999-ENCERRAMENTO
cConteudo+='|'+AllTrim(str(1,10))//.................03-QTD_LIN_9 (quandidade registros Bloco 9) + 1 (Este Registro)
cConteudo+='|'//.......................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'J'+REGISTRO,;//........03-Chave Acesso (Colocado J na frente da chave para ordenar a impressao)
				cConteudo;//............................04-Conteúdo
				}))


//.....................................................................ENCERRA BLOCO 9
REGISTRO :='9990'
cConteudo:=AllTrim(str(aNrReg[8]+4,10))//.............02-QTD_LIN_9 (quandidade registros Bloco 9)
cConteudo+='|'//.......................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'J'+REGISTRO,;//........03-Chave Acesso
				cConteudo;//............................04-Conteúdo
				}))

nSomaTOT++

//..................................................Encerramento Arquivo - 9999 - Nr Registros
REGISTRO:='9999'
cConteudo:=AllTrim(str(nSomaTOT+3,10))//...02-QTD_LIN (Qtdade Reg.Arquivos)
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'X'+REGISTRO,;//........03-Chave Acesso
				cConteudo;//............................04-Conteúdo
				}))

return NIL

*-------------------------------------------------------------------------------------------*
static function SPEDSOMA(pEmpresa,pCodReg,pNrReg)//
*-------------------------------------------------------------------------------------------*
select SPEDAICM //str(SC_EMPRESA,3)+SC_TIPO+SC_PERIODO................SOMA REGISTROS
REGISTRO:='SOMA'
if !dbseek(str(pEmpresa,3)+REGISTRO+pCodReg+'**')
	SPEDAICM->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
					REGISTRO,;//............................02-Codigo.Registro=SOMAtorio
					pCodReg+'**',;//........................03-Registro (PERIODO)
					0.00;//.................................04-SC_VLR_02
					}))
end
replace SC_VLR_02 with SC_VLR_02+pNrReg
select SPEDBAS
return NIL

//------------------------------------------------------EOF----------------------------------------
