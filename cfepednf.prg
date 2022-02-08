*-----------------------------------------------------------------------------*
function CFEPEDNF()	//	Edita Nota Fiscal													*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local VM_LIN
local OPC
local X1
local X:=1
local Y:=1

pb_lin4(_MSG_,ProcName())
if !xxsenha(ProcName(),'Editar Nota Fiscal')
	return NIL
end
setcolor(VM_CORPAD)
pb_tela()
pb_lin4(_MSG_,ProcName())
scroll(6,1,21,78,0)

VM_VETOR:={{;
				'',;//..........................1,1=Nome
				padr('Nota Fiscal',20),;//......1,2=Descricao
				01,;//..........................1,3=Num Fileiras
				05,;//..........................1,4=Num Linhas
				01,;//..........................1,5=Dist Horizontal
				01,;//..........................1,6=Dist Vertical
				132,;//.........................1,7=Tamanho
				'N ';//.........................1,8=Normal/Comprimido
			 },;
			 {};//..................<<<<Lay-Out>>>>
		  }

ARQUIVOS:={}
OPC:=fn_arqs('NFS') // Seleciona e Inclui ARQUIVOS
return NIL
*-----------------------------------------------------------------------------*
