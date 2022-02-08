#include 'RCB.CH'
*-----------------------------------------------------------------------------*
 function CFEPVEBD(VM_FAT)	//	Impressao/Atualizacao da NF							*
*-----------------------------------------------------------------------------*
local OPC,VM_REGIS:=recno(),RT,X
private VM_ULTNF
private VM_NSU

VM_NOMNF :=CLIENTE->CL_RAZAO
VM_AVALIS:=0
VM_BCO   :=1
VM_AVAL  :={0,space(45),space(45),space(18)}
I_TRANS  :={}
pb_box(16,,,,,'Impressao da NF')
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
VM_SERIE:='1  ' // padrao
VM_VARAMB:=upper(getenv('CFE'))
if '//SERIE'$VM_VARAMB // PARA PEDIR SERIE
	VM_SERIE:=space(3)
end
if '//SERIE:'$VM_VARAMB // PARA PEDIR SERIE
	VM_SERIE:=padr(substr(VM_VARAMB,at('SERIE:',VM_VARAMB)+6),3)
end
pb_msg('Digite a s‚rie/n£mero da Nota Fiscal',NIL,.F.)

OPC=.F.
VM_ULTNF :=PC_PEDID
VM_NSU   :=PC_NSU
VM_ULTNF :=fn_psnf('VBA')
@18,1 say 'C¢digo do Banco de Recebimento.:' get VM_BCO   pict masc(11) valid fn_codigo(@VM_BCO,{'BANCO',{||BANCO->(dbseek(str(VM_BCO,2)))},{||CFEP1500T(.T.)},{2,1}})
@20,1 say 'Serie da Nota Fiscal...........:' get VM_SERIE pict masc(01) valid VM_SERIE+'ú'$'   ú'+SCOLD+'ú'.or.fn_codigo(@VM_SERIE,{'CTRNF',{||CTRNF->(dbseek(VM_SERIE))},{||CFEPATNFT(.T.)},{2,1,3,4}})
read
VM_ULTNF :=fn_psnf(VM_SERIE)
select('PEDCAB')
ordem NNFSER
while dbseek(str(VM_ULTNF,6)+VM_SERIE)
	VM_ULTNF :=fn_psnf(VM_SERIE)
	? VM_ULTNF
	inkey(0)
end
ordem GPEDIDO
@21,1 say 'Nro Nota Fiscal a ser Impressa.: '+str(VM_ULTNF,6)
read
setcolor(VM_CORPAD)
DbGoTo(VM_REGIS)
if lastkey()#K_ESC.and.VM_ULTNF>0
	RT :=empty(VM_SERIE).or.file(alltrim(VM_SERIE)+'.NFS')
	OPC:=.T.
	if RT
		X:=1
		if VM_SERIE#SCOLD
			if pb_sn('Imprimir a NOTA FISCAL ?')
				I_TRANS:=CFEPTRANL()
				I_TRANS:=CFEPTRANE(I_TRANS,.T.)
				CFEPTRANG('S',I_TRANS)
				aeval(VM_FAT,{|DET|DET[1]:=VM_ULTNF*100+X++})
				OPC:=CFEPIMNF() // rotina de impressao
			else
				OPC:=.F.
			end
		end
	end
	if if(!OPC,pb_sn('Atualizar Pedido ?'),.T.)
		pb_msg('Atualizando Base de dados. Aguarde...',NIL,.F.)
		aeval(VM_DET,{|DET|DET[6]:=0.00}) // limpar desconto indiv
		CFEP520G() // Atualiza
		// dbcommitall()
	end
	if !OPC
		select('CTRNF')
		if CTRNF->(RecLock())
			CTRNF->NF_SITUA:='L'
		end
	end
end
select('PEDCAB')
dbunlockall()
DbGoTop()
setcolor(VM_CORPAD)
keyboard 'S'
return NIL
*---------------------------------EOF// end file //
