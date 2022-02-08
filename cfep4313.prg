*-----------------------------------------------------------------------------*
static                aVariav := {''}
*-----------------------------------------------------------------------------*
#xtranslate cListSCTRL   => aVariav\[  1 \]

#include 'RCB.CH'
*-----------------------------------------------------------------------------*
	function CFEP4313()	// <MENU>-Impressao de Inventario							*
*-----------------------------------------------------------------------------*
private VM_PERIO
private VM_GRFIN
private VM_GRINI

pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'R->GRUPOS',;
				'R->SALDOS',;
				'R->PROD'})
	return NIL
end
dbsetorder(4);DbGoTop()
dbgobottom();VM_GRFIN:=PR_CODGR
DbGoTop();   VM_GRINI:=PR_CODGR
VM_PERIO  :=left(dtos(bom(PARAMETRO->PA_DATA)-1),6)
cListSCTRL:='E'

pb_box(16,30,,,,'Informe dados da Listagem')
@17,32 say 'Grupo Inicial......' get VM_GRINI   pict masc(13) valid fn_codigo(@VM_GRINI,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRINI,6)))},,{1,2}})
@18,32 say 'Grupo Fim..........' get VM_GRFIN   pict masc(13) valid fn_codigo(@VM_GRFIN,{'GRUPOS',{||GRUPOS->(dbseek(str(VM_GRFIN,6)))},,{1,2}}).and.VM_GRINI<=VM_GRFIN
@19,32 say 'Periodo............' get VM_PERIO   pict mPER when pb_msg('Busca saldo do arquivo de saldo referene ao utimo da do mes')
@21,32 say '[T]odos ou [E]xcluir Prod s/Controle?';
											get cListSCTRL pict mUUU valid cListSCTRL$'TE' when pb_msg('Listar [T]odos os produtos ou [E]xcluir os que nao tem Controle de Estoque')
read
if if(lastkey()#K_ESC,pb_ligaimp(RST),.F.)
	private  VM_TOT  :=0,;
				LAR     :=80,;
				PAGINA  :=2
	dbseek(str(VM_GRINI,6),.T.)
	fn_cabec()
	VM_GRINI:=0
	while !eof().AND.PR_CODGR<=VM_GRFIN
		CFEP43131()
		pb_brake()
	end
	?replicate('-',LAR)
	?padr('Total do inventario',65,'.')+transform(VM_TOT,masc(2))
	?replicate('-',LAR)
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
static function CFEP43131() // Impressao
*-----------------------------------------------------------------------------*
local TOT:={0,0}
fn_pagina()
if VM_GRINI#PR_CODGR
	if left(str(VM_GRINI,6),2)#left(str(PR_CODGR,6),2)
		?INEGR+fn_impgrp(left(str(PR_CODGR,6),2))+CNEGR
	end
	fn_pagina()
	if left(str(VM_GRINI,6),4)#left(str(PR_CODGR,6),4)
		?INEGR+fn_impgrp(left(str(PR_CODGR,6),4))+CNEGR
	end
	fn_pagina()
	if left(str(VM_GRINI,6),4)#left(str(PR_CODGR,6),4).or.right(str(PR_CODGR,6),2)#'00'
		?INEGR+fn_impgrp(str(PR_CODGR,6))+CNEGR
	end
	VM_GRINI:=PR_CODGR
end
if cListSCTRL=='T'.OR.PR_CTRL=='S'
	TOT:=BuscaSaldo(PR_CODPR,VM_PERIO)
end
if TOT[1]#0
	? I15CPP+padr(pb_zer(PR_CODPR,L_P)+chr(45)+PR_DESCR,60)+chr(32)+C15CPP
	??PR_UND
	??transform(TOT[1],mI122)
	??transform(round(pb_divzero(TOT[2],TOT[1]),2),masc(25))
	??transform(TOT[2],masc(2))
	VM_TOT+=TOT[2]
end
return NIL

*-----------------------------------------------------------------------------*
	static function BuscaSaldo(P1,P2)
*-----------------------------------------------------------------------------*
local TOT1:={0,0}
salvabd(SALVA)
select('SALDOS')
if dbseek(str(1,2)+P2+str(P1,L_P))
	TOT1[1]:=SA_QTD
	TOT1[2]:=SA_VLR
elseif P2==left(dtos(PARAMETRO->PA_DATA),6)
	TOT1[1]:=PROD->PR_QTATU
	TOT1[2]:=PROD->PR_VLATU
end
salvabd(RESTAURA)
return (TOT1)

*-----------------------------------------------------------------------------*
	static function fn_Pagina()
*-----------------------------------------------------------------------------*
if prow()>58
	PAGINA++
	?
	?padr('a transportar',65,'.')+transform(VM_TOT,masc(2))
	eject
	fn_cabec()
end
return NIL

*-----------------------------------------------------------------------------*
	static function fn_cabec()
*-----------------------------------------------------------------------------*
?C15CPP+INEGR+padc('LIVRO DE REGISTRO DE INVENTARIO',LAR)
?padc(trim(VM_EMPR),LAR)+CNEGR
?padc('Estoques existentes em '+substr(VM_PERIO,5,2)+'/'+left(VM_PERIO,4),LAR)
?replicate('-',LAR-10)+' Folha:'+str(PAGINA,3)
?
? I15CPP+padr(padr('Codigo',L_P)+chr(45)+'Descricao',61)+C15CPP
??'Unid'+space(8)+'Qtdade Pco(M)Unit   Pco(M) Total'
?replicate('-',LAR)
if VM_TOT>0
	?padr('De transporte',65,'.')+transform(VM_TOT,masc(2))
	?
end
return NIL
*-------------------------------------EOF-----------------------------------------