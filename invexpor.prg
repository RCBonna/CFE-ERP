*-----------------------------------------------------------------------------*
function INVEXPOR(P1)	//	Exportar Inventario
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local ArqTemp:=''
local X
local Canal
local Buffer
private TipoMov :=if(P1==1,'I','P')
private Extensao:=if(P1==1,'INV','PED')

if !abre({	'R->PARAMETRO',;
				'E->INVENT'})
	return NIL
end
ordem CODIGO
if TipoMov=='P'
	ordem CODIGOP
end
dbgobottom()
VM_CODIN1:=IN_CODIN
VM_SEQ1  :=1
VM_CODEMP:=val(PARAMETRO->PA_INSCR)
SALVACOR
if VM_CODEMP<1.or.VM_CODEMP>99
	alert('Empresa nao configurada;Corretamente')
	dbcloseall()
	return NIL
end
X:=18
pb_box(X++,10,,,,'Exportar '+if(TipoMov=='I','Inventario','Pedidos'))
pb_lin4(_MSG_,ProcName())
@X  ,12 say 'Codigo.:' get VM_CODIN1 pict mI4
if TipoMov=='I'
	@X++,25 say '/'     get VM_SEQ1   pict mI2
end
@X  ,12 say 'Gerando ' get ArqTemp   pict mUUU when (ArqTemp:='..\ENVIA\'+pb_zer(VM_CODEMP,2)+pb_zer(VM_CODIN1,4)+pb_zer(VM_SEQ1,2)+'.'+Extensao)>''
read
RESTAURACOR
if lastkey()#K_ESC
	inkey(3)
	NrReg:=0
	Canal:=fcreate(ArqTemp)
	Buffer:='Inicio Arquivo |'+dtos(date())+CRLF
	fwrite(Canal,Buffer)
	select INVENT
	dbseek(str(VM_CODIN1,4)+str(VM_SEQ1,2),.T.)
	while !eof().and.IN_CODIN==VM_CODIN1.and.IN_SEQ==VM_SEQ1
		NrReg++
		pb_msg('Exportando..'+pb_zer(IN_CODPR,13))
		Buffer:=Extensao+'|'
		Buffer+=pb_zer(VM_CODEMP,3)   +'|'
		Buffer+=pb_zer(IN_CODIN ,3)   +'|'
		Buffer+=pb_zer(IN_SEQ   ,2)   +'|'
		Buffer+=dtos(IN_DATA)         +'|'
		Buffer+=pb_zer(IN_CODPR,13)   +'|'
		Buffer+=pb_zer(IN_QTDE*100,15)+'|'
		Buffer+=pb_zer(NrReg,5)+CRLF
		fwrite(Canal,Buffer)
		pb_brake()
	end
	Buffer:='Fim Arquivo'+CRLF
	fwrite(Canal,Buffer)
	fclose(Canal)
	if NrReg<1
		alert('Nao encontrado registros para este Codigo')
		FileDelete(ArqTemp+'.*')
	end
end
dbcloseall()
return NIL
