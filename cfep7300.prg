*--------------------------------------------------------------------*
* CFEP7300.PRG  -  Copia Seguranca do Sistema								*
*--------------------------------------------------------------------*
#include 'RCB.CH'
function CFEP7300()
/*
pb_lin4("Copia de Seguranca do Sistema",ProcName())
VM_DRIVE="A"
pb_box(20,28)
@21,30 say "Informe o drive Destino :" get VM_DRIVE pict "!" valid VM_DRIVE$"AB"
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn(),.F.)
	set cursor ON
	clear
	?"COPIA DE SEGURANCA"
	?
	?"Coloque o Disco de COPIA no drive "+VM_DRIVE+": e press <ENTER>"
	inkey(0)
	?
	VM_X="COPY *.DBF "+VM_DRIVE+":"
	run &VM_X
	pb_msg("Pressione <ENTER>",0)
	set cursor OFF
end
*/
return NIL
