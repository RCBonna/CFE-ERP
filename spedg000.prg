static aVariav := {'',0,.T.,0,'','','0',{},{},0,'',''}
 //.................1.2..3..4..5..6..7..8..9.10.11.12
*-----------------------------------------------------------------------------*
#xtranslate nCGC			=> aVariav\[  1 \]
#xtranslate cValor		=> aVariav\[  2 \]
#xtranslate lRT			=> aVariav\[  3 \]
#xtranslate nX				=> aVariav\[  4 \]
#xtranslate cRT			=> aVariav\[  5 \]
#xtranslate cKey			=> aVariav\[  6 \]
#xtranslate cTPEnv		=> aVariav\[  7 \]
#xtranslate oNF			=> aVariav\[  8 \]
#xtranslate aNF			=> aVariav\[  9 \]
#xtranslate nZ				=> aVariav\[ 10 \]
#xtranslate REGISTRO		=> aVariav\[ 11 \]
#xtranslate cConteudo	=> aVariav\[ 12 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------------------*
function SPEDG000(pEmpresa,pData)//G?CONTROLE DO CR?DITO DE ICMS DO ATIVO PERMANENTE CIAP
*-----------------------------------------------------------------------------------------*

REGISTRO:='G001'
cConteudo:='1'//....................................bloco tem dados
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//...................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+REGISTRO,;//............03-Chave Acesso
				cConteudo;//............................04-Conte?do
				}))
aNrReg[5]++

//..................................................Encerramento Bloco H
REGISTRO:='G990'
aNrReg[5]++//.......................................somar antes de gera o registro
cConteudo:=AllTrim(str(aNrReg[5],10))//.............02-QTD_LIN_G (quandidade registros Bloco G)
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//...................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+REGISTRO,;//............03-Chave Acesso
				cConteudo;//............................04-Conte?do
				}))
return NIL
//---------------------------------------------------EOF---------------------
