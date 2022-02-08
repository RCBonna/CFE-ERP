*-----------------------------------------------------------------------------*
function CFEP43CO()	//	Produtos Estoque Zerado											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())
if !abre({'R->PARAMETRO','R->PEDCAB','R->PEDDET','R->ENTCAB','R->ENTDET','R->PROD'})
	return NIL
end
VM_PROD :=0
VM_DTINI:=ctod('01/'+pb_zer(month(PARAMETRO->PA_DATA),2)+'/'+pb_zer(year(PARAMETRO->PA_DATA)-1900,2))
VM_DTFIM:=ctod('01/'+pb_zer(month(PARAMETRO->PA_DATA),2)+'/'+pb_zer(year(PARAMETRO->PA_DATA)-1900,2))

pb_box(14,20,,,,'Sele‡Æo')
@15,22 say 'Produto ' get VM_PROD  picture masc(21) valid fn_codpr(@VM_PROD,77)
@17,22 say 'Periodo '
@17,33 get VM_DTINI picture masc(7)
@17,46 get VM_DTFIM picture masc(7) valid VM_DTFIM>=VM_DTINI

@19,22 say '            ENTRADA           SAIDA'
@20,22 say 'Qtdade:'
@21,22 say 'Valor :'

read
setcolor(VM_CORPAD)
if lastkey()#K_ESC
	VM_LAR:= 132
	TOTAL :={{0,0},{0,0}}

	pb_msg('Processando entradas...',nil,.f.)
	select('ENTCAB')
	dbsetorder(2)
	DbGoTop()
	dbseek(dtos(VM_DTINI),.T.)
	while !eof().and.EC_DTENT<=VM_DTFIM
		select('ENTDET')
		dbseek(str(ENTCAB->EC_DOCTO,8),.T.)
		while !eof().and.ED_DOCTO==ENTCAB->EC_DOCTO
			if ED_CODPR==VM_PROD
				TOTAL[1,1]+=ED_QTDE
				TOTAL[1,2]+=ED_VALOR
			end
			dbskip()
		end
		select('ENTCAB')
		dbskip()
	end									
	
	pb_msg('Processando saidas...',nil,.f.)
	select('PEDCAB')
	dbsetorder(4)
	DbGoTop()
	dbseek(dtos(VM_DTINI),.T.)
	while !eof().and.PC_DTEMI<=VM_DTFIM
		select('PEDDET')
		dbseek(str(PEDCAB->PC_PEDID,6),.T.)
		while !eof().and.PD_PEDID==PEDCAB->PC_PEDID
			if PD_CODPR==VM_PROD
				TOTAL[2,1]+=PD_QTDE
				TOTAL[2,2]+=round(PD_VALOR*PD_QTDE,2)-PD_DESCV
			end
			dbskip()
		end
		select('PEDCAB')
		dbskip()
	end
	@20,32 say transform(TOTAL[1,1],masc(25))
	@20,47 say transform(TOTAL[2,1],masc(25))
	@21,32 say transform(TOTAL[1,2],masc(25))
	@21,47 say transform(TOTAL[2,2],masc(25))
	pb_msg('Press <ENTER> para continuar.',0,.f.)
end
dbcloseall()
return NIL
