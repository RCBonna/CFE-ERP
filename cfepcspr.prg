*-----------------------------------------------------------------------------*
function CFEPCSPR()	//	Consulta Prod & Fornecedor										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'C->CODTR',;
				'C->GRUPOS',;
				'C->PROD',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->PROFOR'})
	return NIL
end

select('PROD')
ordem CODIGO
select('PROFOR')
set relation to str(PF_CODPR,L_P) into PROD,;
				 to str(PF_CODFO,5)   into CLIENTE
while .T.
	scroll(6,1,21,78)
	VM_CODPR:=0
	@06,02 say 'Produto....:' get VM_CODPR picture masc(21) valid fn_codpr(@VM_CODPR,78)
	read
	if lastkey()#K_ESC
		cfepcsprV(VM_CODPR)
	else
		exit
	end
end
dbcloseall()
return NIL
*-----------------------------------------------------------------------------*

function CFEPCSPRV(P1) // Rotina de Inclus„o
local DET:={}
local X
local Y
ordem PROFOR
dbseek(str(P1,L_P),.T.)
while !eof().and.P1==PF_CODPR
	VM_CODFO:=PF_CODFO
	X       :=0
	while !eof().and.VM_CODFO==PF_CODFO
		X++
		if X==1
			aadd(DET,{str(VM_CODFO,5)+chr(45)+CLIENTE->CL_RAZAO,;//1
						 ctod('') , 0.00,space(20),;					//2/3/4
						 ctod('') , 0.00,space(20),;					//5/6/7
						 ctod('') , 0.00,space(20);					//8/9/10
						 })
			Y:=len(DET)
		end
		DET[Y, X*3-1]:=PF_DATA
		DET[Y, X*3  ]:=PF_PRECO
		DET[Y, X*3+1]:=PF_OBS
		if X==3
			X:=0
			dbseek(str(P1,L_P)+str(VM_CODFO+1,5),.T.)
		else
			dbskip()
		end
	end
end
if len(DET)>0
	set century OFF // data com ano 4 digitos

	//		pb_msg('Selecione um item e press <Enter> ou <ESC> para sair.',NIL,.F.)
	X:=abrowse(7,0,22,79,;
					DET,;
					{'Fornecedor', 'Data-0','Preco-0','OBS-0','Data-1','Preco-1','OBS-1','Data-2','Preco-2','OBS-2'},;
					{          25,       8 ,       12,     15,      8 ,       12,     15,      8 ,       12,     15},;
					{     masc(1),     mDT2, masc(25),masc(1),    mDT2, masc(25),masc(1),    mDT2, masc(25),masc(1)})


	set century ON // data com ano 4 digitos
else
	alert('Produto nao tem fornecedor cadastrado')
end
return NIL
*-----------------------------------------------------------------------------*
