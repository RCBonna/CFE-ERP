*---------------------------------------------------------------------------*
function SISPMSGE() // EDITAR MENSAGENS
*---------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

private ARQUIVOS:={},X:=1,OPC:=0,TIPO:='MSG'
private DIRETORI:="..\ENVIA\"
aeval(directory(DIRETORI+'*.'+TIPO,'D'),{|ELEM|aadd(ARQUIVOS,{ELEM[1],X++})})

@14,59 say '[Arquivos Dispon¡veis]' color 'R/W'
aadd(ARQUIVOS,{'Novo Arquivo',0})
while OPC==0
	OPC  :=abrowse(15,59,22,79,ARQUIVOS,{'Nome Arquivo','Sq'},;
	       {12,2},{masc(1),masc(11)})
	if OPC==len(ARQUIVOS)
		fn_edita(TIPO,OPC)
	end
end
if OPC>0
	pb_msg('F10 - Grava e Sai    F9 - Sai sem gravar')
	set cursor ON
	set function 10 to chr(K_CTRL_END)
	set function  9 to chr(K_ESC)
	VM_TXT:=memoread(DIRETORI+ARQUIVOS[OPC,1])
	VM_TXT:=memoedit(VM_TXT,6,1,21,78)
	memowrit(DIRETORI+ARQUIVOS[OPC,1],VM_TXT)
	set cursor OFF
end
return NIL
