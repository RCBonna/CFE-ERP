//-----------------------------------------------------------------------------*
  function CFEP5204() // REimpressao notas fiscal
//-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_SERIE:=space(3)
local VM_NRNF :=0
dbsetorder(5)
pb_box(15,02,,,,'Selecao de Re-Impressao de NF')
@16,04 say 'Serie :'     get VM_SERIE pict masc(01)
@16,30 say 'Numero NF :' get VM_NRNF  pict masc(19) valid pb_ifcod2(str(VM_NRNF,6)+VM_SERIE,NIL,.T.,5)
read
if lastkey()#K_ESC
	if !PC_FLCAN
		VM_NOMEC :=CLIENTE->CL_RAZAO
		@17,04 say 'Data Emissao: '+transform(PC_DTEMI,masc(07))
		@18,04 say 'Cliente.....: '+pb_zer(PC_CODCL,5)+CHR(45)
		@18,27 get VM_NOMEC pict masc(01) when 'CLIENTE NOMINAL'$CLIENTE->CL_RAZAO
		@19,04 say 'Total NF....: '+transform(PC_TOTAL,masc(2))
		read
		inkey(2)
		CFEP5204X()
	else
		alert('NF esta Cancelada')
	end
end
dbsetorder(2)
DbGoTop()
return NIL

*--------------------------------------------------------------------------*
function CFEP5204X() // REimpressao notas fiscal
*--------------------------------------------------------------------------*
VM_ULTPD  := PC_PEDID
VM_SERIE  := PC_SERIE
VM_NSU    := PC_NSU
VM_BCO    := 0
VM_DET    :={}
VM_ICMS   :={}
VM_ICMT   :={}
I_TRANS   :={}
pb_tela()
pb_lin4('Atualiza‡„o de Pedidos',ProcName())
keyboard chr(0)
setcolor(VM_CORPAD)
CFEP5104(.F.) // mostar pedido
if lastkey()==K_ESC
	return NIL
end
if !reclock()
	return NIL
end
	VM_NOMNF:=VM_NOMEC    //CLIENTE->CL_RAZAO
	pb_box(16)
	VM_AVALIS:=0
	VM_FAT   :={}
	VM_AVAL  :={0,space(45),space(45),space(18)}
	if PARAMETRO->PA_AVALIS.and.PC_FATUR>0 // Parcelado
		VM_ULTNF:=CLIENTE->(recno())
		@17,1 say 'Informe C¢digo do Avalista (0-Sem)...:' get VM_AVALIS picture masc(4) valid if(VM_AVALIS#0,fn_codigo(@VM_AVALIS,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_AVALIS,5)))},{||CFEP3100T(.T.)},{2,1,8,7}}),.T.)
		read
		VM_AVAL[1]:=VM_AVALIS
		if VM_AVALIS>0
			VM_AVAL[2]:=CLIENTE->CL_RAZAO
			VM_AVAL[3]:=CLIENTE->CL_ENDER
			VM_AVAL[4]:=padr(transform(CLIENTE->CL_CGC,masc(if(len(trim(CLIENTE->CL_CGC))>12,18,17))),18)
		end
		CLIENTE->(DbGoTo(VM_ULTNF))
	end
	VM_REGIS :=recno()
	I_TRANS  :=CFEPTRANR('S')
	OPC      :=.F.
	VM_ULTNF :=PC_NRNF
	VM_ULTDP :=PC_NRDPL
	VM_OBS   :=PC_OBSER
	VM_PARCE :=PC_FATUR
	@18,1 say 'Serie da Nota Fiscal.................: '+VM_SERIE
	@19,1 say 'N£mero da Nota Fiscal a ser Impressa.: '+str(PC_NRNF,6)
	setcolor(VM_CORPAD)
	DbGoTo(VM_REGIS)
	if lastkey()#K_ESC
		if pb_sn('RE-Imprimir a NOTA FISCAL ?')
			VENDEDOR->(dbseek(str(PEDCAB->PC_VEND,3)))
			VM_FAT:=fn_retparc(VM_ULTPD,VM_PARCE,VM_ULTDP)
			
//			salvabd(SALVA)
//			select('PEDPARC')
//			if dbseek(str(VM_ULTPD,6))
//				for X:=1 to VM_PARCE
//					aadd(VM_FAT,{	VM_ULTDP+X,;
//										ctod(substr(PP_PARCE,X*20-19, 8)),;
//										val( substr(PP_PARCE,X*20-11,11))/100})
//				next
//			end
//			salvabd(RESTAURA)
			
			CFEPIMNF() // rot impressao
		end
	end

select('PEDCAB')
dbunlockall()
DbGoTop()
if eof().or.bof()
	keyboard '0'
end
setcolor(VM_CORPAD)
return NIL
