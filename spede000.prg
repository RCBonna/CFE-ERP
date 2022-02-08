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
#xtranslate vVLRSaldo	=> aVariav\[  8 \]
#xtranslate aNF			=> aVariav\[  9 \]
#xtranslate nZ				=> aVariav\[ 10 \]
#xtranslate REGISTRO		=> aVariav\[ 11 \]
#xtranslate cConteudo	=> aVariav\[ 12 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------*
function SPEDE000(pEmpresa,pData)//APURAÇÃO DO ICMS E DO IPI
*-----------------------------------------------------------------------*

REGISTRO:='E001'
cConteudo:='0'//....................................Bloco contem tem dados (0=Sim/1=Não)
cConteudo+='|'//....................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(AddRec(30,{pEmpresa,;//...................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'-'+REGISTRO,;//........03-Chave Acesso
				cConteudo;//............................04-Conteúdo
				}))
aNrReg[4]++

REGISTRO:='E100'
cConteudo:=    SONUMEROS(dtoc(pData[1]))//...........02-Data Inicial
cConteudo+='|'+SONUMEROS(dtoc(pData[2]))//...........03-Data Final
cConteudo+='|'//........................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
				REGISTRO,;//............................02-Codigo.Registro
				str(pEmpresa,3)+'-'+REGISTRO,;//........03-Chave Acesso
				cConteudo;//............................04-Conteúdo
				}))
aNrReg[4]++

select SPEDAICM
if dbseek(str(pEmpresa,3)+'E110'+left(dtos(pData[1]),6))
	
	vVLRSaldo:=(SC_VLR_02+SC_VLR_03+SC_VLR_04+SC_VLR_05)-(SC_VLR_06+SC_VLR_07+SC_VLR_08+SC_VLR_09)
	if vVLRSaldo>0
		replace 	SC_VLR_11 with vVLRSaldo,;
					SC_VLR_14 with 0
	elseif vVLRSaldo<0
		replace  SC_VLR_11 with 0,;
					SC_VLR_14 with abs(vVLRSaldo)
	end

/* CAMPO=11=VL_SLD_APURADO
	o valor informado deve ser preenchido com base na expressão: soma do total de débitos
	(VL_TOT_DEBITOS) com total de ajustes (VL_AJ_DEBITOS +VL_TOT_AJ_DEBITOS) com total de estorno de crédito
	(VL_ESTORNOS_CRED) menos a soma do total de créditos (VL_TOT_CREDITOS) com total de ajuste de créditos
	(VL_,AJ_CREDITOS + VL_TOT_AJ_CREDITOS) com total de estorno de débito (VL_ESTORNOS_DEB) com saldo
	credor do período anterior (VL_SLD_CREDOR_ANT).
	Se o valor da expressão for maior ou igual a “0” (zero), então este valor deve ser informado neste campo
	e o campo 14 (VL_SLD_CREDOR_TRANSPORTAR) deve ser igual a “0” (zero).
	Se o valor da expressão for menor que “0” (zero), então este campo deve ser preenchido com “0” (zero) e o valor absoluto
	da expressão deve ser informado no campo VL_SLD_CREDOR_TRANSPORTAR.
*/
	REGISTRO:='E110'
	cConteudo:=    AllTrim(transform(SC_VLR_02,mI132))//.02-VL_TOT_DEBITOS
	cConteudo+='|'+AllTrim(transform(SC_VLR_03,mI132))//.03-VL_AJ_DEBITOS
	cConteudo+='|'+AllTrim(transform(SC_VLR_04,mI132))//.04-VL_TOT_AJ_DEBITOS
	cConteudo+='|'+AllTrim(transform(SC_VLR_05,mI132))//.05-VL_ESTORNOS_CRED
	cConteudo+='|'+AllTrim(transform(SC_VLR_06,mI132))//.06-VL_TOT_CREDITOS
	cConteudo+='|'+AllTrim(transform(SC_VLR_07,mI132))//.07-VL_AJ_CREDITOS
	cConteudo+='|'+AllTrim(transform(SC_VLR_08,mI132))//.08-VL_TOT_AJ_CREDITOS
	cConteudo+='|'+AllTrim(transform(SC_VLR_09,mI132))//.09-VL_ESTORNOS_DEB
	cConteudo+='|'+AllTrim(transform(SC_VLR_10,mI132))//.10-VL_SLD_CREDOR_ANT
	cConteudo+='|'+AllTrim(transform(SC_VLR_11,mI132))//.11-VL_SLD_APURADO
	cConteudo+='|'+AllTrim(transform(SC_VLR_12,mI132))//.12-VL_TOT_DED
	cConteudo+='|'+AllTrim(transform(SC_VLR_13,mI132))//.13-VL_ICMS_RECOLHER
	cConteudo+='|'+AllTrim(transform(SC_VLR_14,mI132))//.14-VL_SLD_CREDOR_TRANSPORTAR
	cConteudo+='|'+AllTrim(transform(SC_VLR_15,mI132))//.15-DEB_ESP
	cConteudo+='|'//........................................Finalizar
	*----------------------------------------------------------------------Gravar
	SPEDBAS->(	AddRec(30,{pEmpresa,;//.................01-Codigo.Empresa
					REGISTRO,;//............................02-Codigo.Registro
					str(pEmpresa,3)+'-'+REGISTRO,;//........03-Chave Acesso
					cConteudo;//............................04-Conteúdo
					}))
	aNrReg[4]++
end
//..................................................Encerramento Bloco E
REGISTRO:='E990'
aNrReg[4]++//...........................................Somar antes de gera o registro
cConteudo:=AllTrim(str(aNrReg[4],10))//.................02-QTD_LIN_C (quandidade registros Bloco E)
cConteudo+='|'//...........................................Finalizar
*----------------------------------------------------------------------Gravar
SPEDBAS->(	AddRec(30,{pEmpresa,;//.....................01-Codigo.Empresa
				REGISTRO,;//................................02-Codigo.Registro
				str(pEmpresa,3)+'-'+REGISTRO,;//............03-Chave Acesso
				cConteudo;//................................04-Conteúdo
				}))
return NIL
//-----------------------------------------------------EOF--------------------------------
