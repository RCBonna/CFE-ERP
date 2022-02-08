*-----------------------------------------------------------------------------*
 function CFEP2210()	// Pagamentos de Duplicatas dos Fornecedores
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->PARAMETRO'	,;
				'C->PARALINH'	,;
				'C->CTACTB'		,;
				'C->BANCO'		,;
				'C->CAIXACG'	,;
				'C->CLIENTE'	,;
				'C->CLIOBS'		,;
				'C->VENDEDOR'	,;
				'C->DPFOR'		,;
				'C->HISFOR'		,;
				'C->CAIXAMB'	,;
				'R->LAYOUT'		,;
				'C->DIARIO'		,;
				'C->CTADET'		})
	return NIL
end

select('CTACTB')
VM_CTAS:=array(9,7)
aeval(VM_CTAS,{|DET|afill(DET,0)})
dbeval(	{||VM_CTAS[CC_TPCFO,CC_SEQUE+1]:=CC_CONTA},;
			{||CC_TPMOV=='E'.and.CC_TPEST==0.and.CC_SEQUE<=7})
close

select('DPFOR')
dbsetorder(5)
VM_DATA:=PARAMETRO->PA_DATA

while .T.
	pb_tela()
	pb_lin4(_MSG_,ProcName())
	VM_CODIG:=0
	salvacor(SALVA)
	scroll(06,01,21,78)
	@06,02 say padr('Fornecedor',12,'.') get VM_CODIG picture mI5 valid fn_codigo(@VM_CODIG,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODIG,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
	read
	if lastkey()#K_ESC
		VM_IND:=max(CLIENTE->CL_ATIVID,1)
		CFEP2211(VM_CODIG,'FOR') // edita + atualiza 
	else
		exit
	end
	dbrunlock()
	salvacor(RESTAURA)
end
// dbcommitall()
dbcloseall()
return NIL
*----------------------------------------------------------Pgto Clientes/Fornec
