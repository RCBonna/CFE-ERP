*-----------------------------------------------------------------------------*
function CFEP4312(VM_P1)	//	<MENU>-Listagem Posicao Atual Estoque				*
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
pb_box(18,20,,,,'Sele‡Æo')
VM_FLAG:='N'
VM_CTB :={0,99,0,0}
VM_P1  :=1
@19,22 say 'A Preco (1=Medio 2=Venda).' get VM_P1      pict mI1  valid VM_P1>0.and.VM_P1<3
@20,22 say 'Listar Produtos Zerados ?.' get VM_FLAG    pict mUUU valid VM_FLAG$'SN'
@21,22 say 'Tipo Inicial..............' get VM_CTB[1]  pict mI2  valid VM_CTB[1]>=0
@21,60 say 'Final:'                     get VM_CTB[2]  pict mI2  valid VM_CTB[1]<=VM_CTB[2]
read
if if(lastkey()#27,pb_ligaimp(I15CPP),.F.)
	ordem TIPO
	set relation to str(PR_CODGR,6) into GRUPOS
	DbGoTop()
	VM_FLAG  :=(VM_FLAG=='S') // lista produtos com saldo zero
	VM_TOT   := array(4)
	VM_TIPOS :=restarray('ESTOQUE.ARR')
	VM_LAR   := 133
	VM_PAG   := 0
	VM_REL   := 'Posicao Atual do Estoque a '+if(VM_P1=1,'Custo MEDIO','Preco VENDA')
	VM_TOT[1]:=0
	dbseek(str(VM_CTB[1],2),.T.)
	while !eof()
		VM_CTB[3]:=PR_CTB
		VM_PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
		VM_CTB[4]:=ascan(VM_TIPOS,{|DET|DET[1]==VM_CTB[3]})
		VM_FLAGCB:=.T.
		VM_TOT[2]:=0
		while !eof().and.PR_CTB==VM_CTB[3]
			VM_PAG  := pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4311A',VM_LAR)
			VM_QTATU:=PR_QTATU
			if if(VM_FLAG,.T.,VM_QTATU#0.00)
				if VM_FLAGCB
					?INEGR+pb_zer(VM_CTB[3],2)+"-"+if(VM_CTB[4]>0,VM_TIPOS[VM_CTB[4],2],'Nao Cadastrado')+CNEGR
					VM_FLAGCB:=.F.
				end
				?  space(4)+padr(pb_zer(PR_CODPR,L_P)+'-'+PR_DESCR,48)
				?? space(1)+PR_UND+space(1)
				?? PR_LOCAL
				?? transform(VM_QTATU,masc(5))+space(1)
				if VM_P1==1 // pco medio
					?? transform(pb_divzero(PR_VLATU,PR_QTATU),masc(25))
					?? space(2)+transform(PR_VLATU,masc(2))+space(1)
					VM_TOT[2]+=PR_VLATU
				else // venda
					?? transform(PR_VLVEN,masc(25))
					?? space(2)+transform(PR_VLVEN*VM_QTATU,masc(2))+space(1)
					VM_TOT[2]+=(PR_VLVEN*VM_QTATU)
				end
				?? transform(PR_VLCOM,masc(2))+space(1)
				?? dtoc(PR_DTCOM)
			end
			pb_brake()
		end	
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP4312A',VM_LAR)
		if VM_TOT[2]>0
			?space(31)+padr('TOTAL DO TIPO',61,'.')+transform(VM_TOT[2],masc(2))
			?
			VM_TOT[1]+=VM_TOT[2]
		end
	end
	?replicate('-',VM_LAR)
	?space(31)+padr('TOTAL GERAL',61,'.')+transform(VM_TOT[1],masc(2))
	?replicate('-',VM_LAR)
	? 'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
	set relation to
end
dbcloseall()
return NIL

function CFEP4312A()
?  space(4)+padr('Produto',49)+'Und.  local  Qtdade.Est.'+space(4)
?? 'Vlr.Unitario'+space(5)+'Vlr.Total  Vlr.Ult.Compra Ult.Com.'
?  replicate('-',VM_LAR)
return NIL
*----------------------------------------EOF--------------------------------*
