*-----------------------------------------------------------------------------*
function CFEP4314()		//	<MENU>-Listagem Posicao Atual Estoque-por subgrupo	*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_FLAG

pb_lin4(_MSG_,ProcName())

if !abre({	'R->GRUPOS',;
				'R->PARAMETRO',;
				'R->PROD';
			})
	return NIL
end
pb_box(19,20)
VM_CODGR1:=GRUPOS->GE_CODGR
VM_CODGR2:=GRUPOS->GE_CODGR
@20,22 say 'Selecione Grupo INICIAL:' get VM_CODGR1 picture masc(13) valid fn_codigo(@VM_CODGR1,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_CODGR1,6)))},,{2,1}})
@21,38 say 'FINAL..:'                 get VM_CODGR2 picture masc(13) valid fn_codigo(@VM_CODGR2,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_CODGR2,6)))},,{2,1}})
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	dbclearindex()
	FILTRO:='filprod().and.PROD->PR_CODGR>=VM_CODGR1.and.PROD->PR_CODGR<=VM_CODGR2'
	tone(800,2)
	if !pb_sn('Listar TODOS os TIPOS de PRODUTO ?')
		VM_CTB:=0
		while !fn_codar(@VM_CTB,'ESTOQUE.ARR')
		end
		FILTRO+='.and.PROD->PR_CTB==VM_CTB'
	end
	pb_msg('Gerando Indice Temporario, Aguarde...',NIL,.F.)

	set filter to &FILTRO
	Index on substr(str(PR_CODGR,6),3,2)+upper(PR_DESCR) to TMP
	SET OPTIMIZE   	ON		// otimização de filtros (SET FILTER TO)
	DbGoTop()
	VM_LAR  := 133
	VM_PAG  := 0
	VM_REL  := 'Lista de Preco VENDA (por SUBGRUPO)'
	VM_TOT  :={0,0}
	pb_msg('Imprimindo, aguarde... <ESC> cancela.',NIL,.F.)
	VM_GRUPO:=''
	while !eof()
		VM_PAG := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4314A',VM_LAR)
		if VM_GRUPO#substr(str(PR_CODGR,6),3,2)
			?
			VM_GRUPO:=substr(str(PR_CODGR,6),3,2)
			GRUPOS->(dbseek(str(PROD->PR_CODGR,6)))
			? padc(VM_GRUPO+chr(45)+trim(GRUPOS->GE_DESCR),VM_LAR,'.')
			?
		end
		VM_QTATU:=PR_QTATU
		GRUPOS->(dbseek(left(str(PROD->PR_CODGR,6),2)+'0000'))
		?  transform(PR_CODGR,masc(13))+space(1)
		?? left(lower(GRUPOS->GE_DESCR),18)+space(1)
		?? padr(pb_zer(PR_CODPR,L_P)+chr(45)+PR_DESCR,48)+space(1)
		?? PR_UND+space(1)
		?? PR_LOCAL
		?? transform(VM_QTATU,masc(6))
		?? transform(PR_VLVEN,masc(2))
		?? transform(PR_VLVEN+PR_VLVEN*PARAMETRO->PA_DESCV/100,masc(2))
		pb_brake()
	end	
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4314A',VM_LAR)
	?replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	set relation to
end
dbclearfil()
dbcloseall()
ferase('TMP.NTX')
return NIL

*--------------------------------------------------------------------------*
function CFEP4314A()
? 'Grupo'+space(23)
?? padr('Produto',49)+'Und.'+space(2)
?? 'Local'+space(3)
?? 'Qt.Est.'+space(6)
?? 'Vlr.Vista'+space(6)
?? 'Vlr.Prazo'
?  replicate('-',VM_LAR)
return NIL
*--------------------------------------EOF--------------------------------*