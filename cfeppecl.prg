*-----------------------------------------------------------------------------*
function CFEPPECL(P1)	//	Pesquisa Cadastro de Clientes									*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
pb_tela()
pb_lin4(_MSG_,ProcName())
if !abre({	'R->PARAMETRO',;
				'C->DPCLI',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CLIENTE'})
	return NIL
end
VM_CODIG:=0
while lastkey()#K_ESC
	scroll(6,1,21,78,0)
	@06,02 say 'C¢digo......:' get VM_CODIG pict masc(04) valid fn_codigo(@VM_CODIG,{'CLIENTE',{||dbseek(str(VM_CODIG,5))},{||NIL},{2,1}})
	read
	if lastkey()#K_ESC
		fn_conspc()
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function FN_CONSPC()	//	Pesquisa Cadastro de Clientes									*
local TF:=savescreen()
salvabd(SALVA)
select('CLIENTE')
VM_DTSPC:=CL_DTSPC
VM_DTCSP:=date()
VM_CODIG:=CL_CODCL
pb_box(07,00,17,79)
@08,02 say 'Nome Cliente: '+CL_RAZAO
@09,02 say 'Dt Nasciment: '+transform(CL_DTNAS,masc(7))
@10,02 say 'Nome Pai/Mae: ' + CL_FILIAC
@11,02 say 'CPF.........: ' + CL_CGC
@14,30 say 'Valor Regist:'+transform(CL_VLRSPC,masc(25))
@14,02 say 'Dt Reg SPC..:'  get VM_DTSPC pict masc(7) valid fn_cliobs(VM_CODIG,VM_DTSPC)
@15,02 say 'Dt Cons SPC.:'  get VM_DTCSP pict masc(7)
read
if lastkey()#K_ESC
	if reclock()
		replace CL_DTSPC with VM_DTSPC,CL_DTCSP with VM_DTCSP
		dbrunlock(recno())
		// dbcommitall()
	end	
end
restscreen(,,,,TF)
salvabd(RESTAURA)
return NIL
