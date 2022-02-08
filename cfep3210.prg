*-----------------------------------------------------------------------------*
 function CFEP3210() // Recebimento de Duplicatas										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
if !abre({	'C->PARAMETRO',;
				'C->BANCO',;
				'R->CTACTB',;
				'C->CLIENTE',;
				'C->CLIOBS',;
				'C->VENDEDOR',;
				'C->CAIXACG',;
				'C->CAIXAMB',;
				'C->DPCLI',;
				'C->HISCLI',;
				'C->EXCESSAO',;
				'C->DIARIO'})
	return NIL
end
select('CTACTB')
          VM_CTAS:=array(9,6)
aeval(    VM_CTAS,{|DET|afill(DET,0)})
dbeval({||VM_CTAS[CC_TPCFO,CC_SEQUE+1]:=CC_CONTA},{||CC_TPMOV=='S'.and.CC_TPEST==0.and.CC_SEQUE<6})
close

select('DPCLI');dbsetorder(5)
VM_DATA:=PARAMETRO->PA_DATA

while .T.
	pb_tela()
	pb_lin4(_MSG_,ProcName())
	VM_CODIG:=0
	scroll(06,01,21,78)
	@06,02 say padr('Cliente',16,'.') get VM_CODIG picture masc(04) valid fn_codigo(@VM_CODIG,{'CLIENTE',{||CLIENTE->(dbseek(str(VM_CODIG,5)))},{||CFEP3100T(.T.)},{2,1,8,7}})
	read
	if lastkey()#K_ESC
		VM_IND:=max(CLIENTE->CL_ATIVID,1)
		CFEP2211(VM_CODIG,'CLI')
	else
		exit
	end
	dbrunlock()
end
dbcommitall()
dbskip(0)
dbcloseall()
return NIL
*---------------------------------------------EOF--------------------------