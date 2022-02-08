*-----------------------------------------------------------------------------*
function INVELIM(P1)	//	Eliminar Dados Inventario
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local ArqTemp:=''
local X
local NrReg:=0
local Canal
local Buffer
private TipoMov:=if(P1==1,'I','P')

if !abre({'E->INVENT'})
	return NIL
end

ordem CODIGO
if TipoMov=='P'
	ordem CODIGOP
end
dbgobottom()

VM_CODIN1:=IN_CODIN
VM_CODIN1:=0
VM_SEQ1  :=1
X:=19
pb_box(X++,10,,,,'Excluir '+if(TipoMov=='I','Inventario','Pedidos'))
pb_lin4(_MSG_,ProcName())
@X  ,12 say 'Codigo.:' get VM_CODIN1 pict mI4
if TipoMov=='I'
	@X++,25 say '/'     get VM_SEQ1   pict mI2
end
read
if if(lastkey()#K_ESC,pb_sn('Confirma Eliminacao?'),.F.)
	select INVENT
	dbseek(str(VM_CODIN1,4)+str(VM_SEQ1,2),.T.)
	while !eof().and.IN_CODIN==VM_CODIN1.and.IN_SEQ==VM_SEQ1
		NrReg++
		pb_msg('Eliminando..'+pb_zer(IN_CODPR,13))
		dbdelete()
		pb_brake()
	end
	alert('Eliminacao concluida;'+str(NrReg,5)+' Registros foram Eliminados')
end
dbcloseall()
return NIL
