*-----------------------------------------------------------------------------*
function CFEP4311(VM_P1)	//	<MENU>-Listagem Posicao Atual Estoque				*
*						1-Pco.Medio																	*
*						2-Pco.Venda																	*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_FLAG
pb_lin4(_MSG_,ProcName())
if !abre({	'R->GRUPOS',;
				'R->PARAMETRO',;
				'R->PROD'})
	return NIL
end
pb_box(16,20,,,,'Sele‡Æo')
VM_FLAG:='N'
VM_CTB :='N'
VM_P1  :=1
VM_ORDE:='C' 
cCST   :='   '
@17,22 say 'A Preco (1=Medio 2=Venda).' get VM_P1   pict mI1  valid VM_P1>0.and.VM_P1<3
@18,22 say 'Ordem <C>odigo <A>lfabet. ' get VM_ORDE pict mUUU valid VM_ORDE$'CA'
@19,22 say 'Listar Produtos Zerados ? ' get VM_FLAG pict mUUU valid VM_FLAG$'SN'
@20,22 say 'Selecionar Tipo Produto ? ' get VM_CTB  pict mUUU valid VM_CTB$'SN'
@21,22 say 'Selec. Excluir CST SAIDA? ' get cCST    pict mUUU
read
if lastkey()#27
	if VM_ORDE == 'A'
		ordem GRUALF
	end
	if VM_CTB=='S'
		VM_CTB:=0
		while !fn_codar(@VM_CTB,'ESTOQUE.ARR');end
		dbsetfilter({||PROD->PR_CTB==VM_CTB.and.filprod()})
	end
	if VM_CTB=='N'.and.cCST#'   '
		dbsetfilter({||PROD->PR_CODCOS#cCST})
	end
	if pb_ligaimp(I15CPP)
		set relation to str(PR_CODGR,6) into GRUPOS
		DbGoTop()
		VM_FLAG=(VM_FLAG=='S') // lista produtos com saldo zero
		VM_TOT   := array(4)
		VM_LAR   := 133
		VM_PAG   := 0
		VM_REL   := 'Posicao Atual do Estoque a '+if(VM_P1=1,'Custo MEDIO','Preco VENDA')
		VM_TOT[1]:=0
		while !eof()
			VM_PAG   := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
			VM_GRUPO :=left(str(PR_CODGR,6),2)
			VM_TOT[2]:=0
			?INEGR+fn_impgrp(VM_GRUPO)+CNEGR
			while !eof().and.left(str(PR_CODGR,6),2)==VM_GRUPO
				VM_PAG   := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
				VM_SUBGR :=left(str(PR_CODGR,6),4)
				VM_TOT[3]:=0
				?INEGR+fn_impgrp(VM_SUBGR)+CNEGR
				while !eof().and.left(str(PR_CODGR,6),4)==VM_SUBGR
					VM_PAG  := pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
					VM_SUBSB:= str(PR_CODGR,6)
					if right(VM_SUBSB,2) # '00'
						?INEGR+fn_impgrp(VM_SUBSB)+CNEGR
					end
					VM_TOT[4]:=0
					?
					while !eof().and.str(PR_CODGR,6)==VM_SUBSB
						VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
						VM_QTATU:=PR_QTATU
						if if(VM_FLAG,.T.,VM_QTATU#0.00)
							?  space(4)+padr(pb_zer(PR_CODPR,L_P)+'-'+PR_DESCR,48)
							?? space(1)+PR_UND+space(1)
							?? PROD->PR_CODCOE+'-'+PROD->PR_CODCOS
							?? transform(VM_QTATU,masc(5))+space(1)
							if VM_P1==1 // pco medio
								?? transform(pb_divzero(PR_VLATU,PR_QTATU),masc(25))
								?? space(2)+transform(PR_VLATU,masc(2))+space(3)
								VM_TOT[4]+=PR_VLATU
							else // venda
								?? transform(PR_VLVEN,masc(25))
								?? space(2)+transform(PR_VLVEN*VM_QTATU,masc(2))+space(3)
								VM_TOT[4]+=(PR_VLVEN*VM_QTATU)
							end
							?? transform(PR_VLCOM,masc(25))+space(1)
							?? transform(PR_DTCOM,masc(34))
						end
						pb_brake()
					end
					?
					if right(VM_SUBSB,2) # '00'
						?space(31)+padr('TOTAL SUB-SUB-GRUPO',61,'.')+transform(VM_TOT[4],masc(2))
						?
					end
					VM_TOT[3]+=VM_TOT[4]
				end
				VM_PAG:=pb_pagina(VM_SISTEMA, VM_EMPR, ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
				?space(31)+padr('TOTAL SUB-GRUPO',61,'.')+transform(VM_TOT[3],masc(2))
				?
				VM_TOT[2]+=VM_TOT[3]
			end
			VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
			?space(31)+padr('TOTAL GRUPO',61,'.')+transform(VM_TOT[2],masc(2))
			?
			VM_TOT[1]+=VM_TOT[2]
		end	
		?replicate('-',VM_LAR)
		?space(31)+padr('TOTAL GERAL',61,'.')+transform(VM_TOT[1],masc(2))
		?replicate('-',VM_LAR)
		? 'Impresso as '+time()
		eject
		pb_deslimp(C15CPP)
		set relation to
	end
	dbclearfil()
end
dbcloseall()
return NIL

function CFEP4311A()
?  space(4)+padr('Produto',49)+'Und. CST E/S Qtdade.Est.'+space(4)
?? 'Vlr.Unitario'+space(5)+'Vlr.Total  Vlr.Ult.Compra DtUlt.Com'
?  replicate('-',VM_LAR)
return NIL
*---------------------------------------------------------------------------eof
