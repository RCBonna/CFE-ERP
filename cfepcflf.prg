*-----------------------------------------------------------------------------*
function CFEPCFLF()	//	Cupom Fiscal - Leitura Fiscal
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

if !abre({'C->PARAMETRO'})
	return NIL
end
pb_lin4(_MSG_,ProcName())
if CUPOMFISCAL()
	VM_DATA:={bom(PARAMETRO->PA_DATA),eom(PARAMETRO->PA_DATA)}
	pb_box(18,24,,,,'Selecao')
	@19,26 say 'Data Inicial:' get VM_DATA[1] pict mDT
	@20,26 say 'Data Final..:' get VM_DATA[2] pict mDT valid VM_DATA[2]>=VM_DATA[1]
	read
	if lastkey()#K_ESC
		if pb_sn('Enviar comando para Impressora Fiscal;RELATORIO MEMORIA FISCAL ?')
			VM_DATA[1]:=pb_zer(day(VM_DATA[1]),2)+pb_zer(month(VM_DATA[1]),2)+right(pb_zer(year(VM_DATA[1]),4),2)
			VM_DATA[2]:=pb_zer(day(VM_DATA[2]),2)+pb_zer(month(VM_DATA[2]),2)+right(pb_zer(year(VM_DATA[2]),4),2)
			imprfisc("08|"+VM_DATA[1]+"|"+VM_DATA[2]+"|I|")
		end
	end
end
dbcloseall()
return NIL
