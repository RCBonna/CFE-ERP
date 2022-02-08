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
*-----------------------------------------------------------------------*
function SPED1000(pEmpresa,pData)
*-----------------------------------------------------------------------*

REGISTRO:='1001'
cConteudo:='1'//....................................Bloco NAO tem dados
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//...................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'I'+REGISTRO,;//........03-Chave Acesso (para ordenar foi colocado I na frente da gravacao do registro)
				cConteudo;//............................04-Conteúdo
				}))
aNrReg[7]++

//..................................................Encerramento Bloco H
REGISTRO:='1990'
aNrReg[7]++//.......................................Somar antes de gera o registro
cConteudo:=AllTrim(str(aNrReg[7],10))//.............02-QTD_LIN_1 (quandidade registros Bloco 1)
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//...................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'I'+REGISTRO,;//........03-Chave Acesso (para ordenar foi colocado I na frente da gravacao do registro)
				cConteudo;//............................04-Conteúdo
				}))
return NIL
//---------------------------------------------------EOF----------------------------------------
