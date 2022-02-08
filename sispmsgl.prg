*---------------------------------------------------------------------------*
function SISPMSGL() // LER MENSAGENS
*---------------------------------------------------------------------------*
#include 'RCB.CH'

pb_tela()
pb_lin4(_MSG_,ProcName())

private ARQUIVOS:={},X:=1,OPC:=0,TIPO:='MSG'
private DIRETORI:="..\RECEBE\",VM_TXT
aeval(directory(DIRETORI+'*.'+TIPO,'D'),{|ELEM|aadd(ARQUIVOS,{ELEM[1],X++})})
if len(ARQUIVOS)=0
	alert('Nao ha arquivos a serem lidos em ..\RECEBE\')
	return NIL
end

@14,59 say '[Arquivos Dispon¡veis]' color 'R/W'
while OPC==0
	OPC  :=abrowse(15,59,22,79,ARQUIVOS,{'Nome Arquivo','Sq'},;
	       {12,2},{masc(1),masc(11)})
end
if OPC>0
	pb_msg('F10-Grava e Sai    F9-Sai sem gravar  F8-Imprime')
	set cursor ON
	set function 10 to chr(K_CTRL_END)
	set function  9 to chr(K_ESC)
	setkey(K_F8,{||imprimemsg()})			// F8-imprime msg
	VM_TXT:=memoread(DIRETORI+ARQUIVOS[OPC,1])
	VM_TXT:=memoedit(VM_TXT,6,1,21,78)
	memowrit(DIRETORI+ARQUIVOS[OPC,1],VM_TXT)
	set cursor OFF
	setkey(K_F8,{||NIL})			// F8-desliga
end
return NIL

static function IMPRIMEMSG()
local X,Y
if pb_ligaimp()
	X:=mlcount(VM_TXT,78)
	for Y:=1 to X
		?memoline(VM_TXT,78,X)
	end
	pb_deslimp()
end
return NIL
