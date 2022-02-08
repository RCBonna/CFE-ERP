*-----------------------------------------------------------------------------*
function CFEP1430()	//	Emissao Imediata de Cheques									*
*-----------------------------------------------------------------------------*

#include 'RCB.CH'

local GETLIST := {},VM_FL:=.F.

if pb_ligaimp(IESP1)
	if select('LAYOUT') == 0
		if !abre({'C->CAIXAMB','R->LAYOUT'})
			return NIL
		end
		VM_FL:=.T.
	end
	fn_codly()  // Seleciona LAYOUT
	fn_chtes()  // Teste Impressao
	VM_PORTA=space(40)
	VM_VALOR=0
	VM_DATA =date()
	while lastkey() # K_ESC
		pb_box(17,10)
		@18,11 say "Portador..:" get VM_PORTA picture masc(1)
		@19,11 say "Valor.....:" get VM_VALOR picture masc(5) valid VM_VALOR>0
		@20,11 say "Dt.Emissao:" get VM_DATA  picture masc(7)
		@21,11 say "Nr.Cheque.:" get VM_NRCHE picture masc(9) valid VM_NRCHE>0
		read
		setcolor(VM_CORPAD)
		if if(lastkey()#K_ESC,pb_sn("Confirma Dados ?"),.F.)
			VLR:=transform(VM_VALOR,"@E **,***,***,***.**")
			EXT:=upper(pb_extenso(VM_VALOR))
			EXT+=replicate("*",120-len(EXT))
			EXT=left(EXT,56)+chr(141)+chr(10)+chr(13)+chr(10)+right(EXT,65)
			POR=upper(VM_PORTA)
			D  :=str(day(VM_DATA),2)
			M  :=pb_mesext(VM_DATA,"C")
			A  :=str(year(VM_DATA)-1900,2)
			fn_chimp()
			GRAV_BCO(LAYOUT->LY_BANCO,VM_DATA,VM_NRCHE,'Pago ch '+alltrim(str(VM_NRCHE,6))+' '+VM_PORTA,-VM_VALOR,'EM')
		end
	end
	for VM_X:=1 to 30
		?
	next
	pb_deslimp(CESP1)
end
if VM_FL
	dbclosearea()
end
return NIL
