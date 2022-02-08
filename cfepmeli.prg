*-----------------------------------------------------------------------------*
function CFEPMELI()	//	Limpa Movimentacao do Estoque
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
  
local X
local Contador

if !xxsenha(ProcName(),'Limpar Movimento Estoque')
	dbcloseall()
	return NIL
end
setcolor(VM_CORPAD)

pb_lin4(_MSG_,ProcName())

if !abre({	'R->PARAMETRO',;
				'E->SALDOS',;
				'E->MOVEST'})
	return NIL
end
VM_ANO:=year(boy( PARAMETRO->PA_DATA )-1 )
X:=16
pb_box(X++,18,,,,'Selecione')
@X++,20 say 'Eliminar Dados do Estoque <= Ano' get VM_ANO pict mI4 valid VM_ANO<year(PARAMETRO->PA_DATA)
read
setcolor(VM_CORPAD)
if if(lastkey()#K_ESC,pb_sn('Esta rotina elimina dados de movimento de estoque;do ano informado para traz.;Tambem elimina saldo de estoque'),.F.)
	select MOVEST
	ORDEM DTCOD
	DbGoTop()
	Contador:=0
	while !eof().and.YEAR(ME_DATA)<=VM_ANO
		Contador++
		@X,20 say 'Movimento Estoque: '+dtoc(ME_DATA)+' > '+str(Contador,7)+ ' deletados'
		delete
		skip
	end

	X++
	select SALDOS
	DbGoTop()
	Contador:=0
	while !eof().and.str(1,2)+left(SA_PERIOD,4)<=str(1,2)+str(VM_ANO,4)
		Contador++
		@X,20 say 'Saldos de Estoque: '+SA_PERIOD+'     > '+str(Contador,7)+ ' deletados'
		delete
		skip
	end
	Alert('Limpeza Concluida;Faca reordenacao do sistema;para melhor performance')
end
dbcloseall()

return NIL
//-----------------------------------------EOF-------------------------------------------------
