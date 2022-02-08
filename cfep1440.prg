*-----------------------------------------------------------------------------*
function CFEP1440()	//	Emissao Dvs. Cheques mesmo VALOR								*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_PORTA:=space(40)
VM_VALOR:=0
VM_NRCHE:=0
VM_DATA :=date()
VM_QTCHQ:=0
pb_box(16,10)
@17,11 say "Portador..:" get VM_PORTA picture masc(1)
@18,11 say "Valor.....:" get VM_VALOR picture masc(5) valid VM_VALOR>0
@19,11 say "Nr.Cheques:" get VM_QTCHQ picture masc(3) valid VM_QTCHQ>0
@20,11 say "Dt.Emissao:" get VM_DATA  picture masc(7)
@21,11 say "Cheque ini:" get VM_NRCHE picture masc(3) valid VM_NRCHE>0
read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	if !abre({'R->LAYOUT'})
		return NIL
	end
	if pb_ligaimp(IESP1)
		fn_codly()  // Seleciona LAYOUT
		fn_chtes()  // Teste Impressao
		VLR:=transform(VM_VALOR,"@E **,***,***,***.**")
		EXT:=upper(pb_extenso(VM_VALOR))
		EXT+=replicate("*",120-len(EXT))
		EXT:=left(EXT,56)+chr(141)+chr(10)+chr(13)+chr(10)+right(EXT,65)
		POR:=upper(VM_PORTA)
		D  :=str(day(VM_DATA),2)
		M  :=pb_mesext(VM_DATA,"C")
		A  :=str(year(VM_DATA)-1900,2)
		for X:=1 to VM_QTCHQ
			fn_chimp()  // Impressao Cheques
			GRAV_BCO(LAYOUT->LY_BANCO,VM_DATA,VM_NRCHE,'Pago ch '+alltrim(str(VM_NRCHE,6))+' '+VM_PORTA,-VM_VALOR,'EM')
			VM_NRCHE++
		next
		for VM_X:=1 to 30
			?
		next
		pb_deslimp(CESP1)
	end
	dbcloseall()
end
return NIL
