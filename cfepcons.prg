*-----------------------------------------------------------------------------*
function CFEPCONS()	// Consultas														*
*						F3=1=Fornecedores															*
*						F4=2=Clientes																*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

local VM_TIPO:={'CLIENTE','CLIENTE','PROD'}
local P1:=if(lastkey()==K_F3,1,if(lastkey()==K_F4,2,3))
local VM_CODIG
local VM_VALOR1
local VM_VALOR2
local VM_TF:=savescreen()
if !Used() // tem DBF usado
	if !abre({'R->PARAMETRO','R->CLIENTE'})
		return NIL
	end
	if P1==1
		abre({'R->DPFOR'})
		dbsetorder(5)
		set relation to str(DP_CODFO,5) into CLIENTE
	elseif P1==2
		abre({'R->DPCLI'})
		dbsetorder(5)
		set relation to str(DR_CODCL,5) into CLIENTE
	else
		abre({'R->GRUPOS'})
		abre({'R->PROD'})
	end
else
	pb_msg('Consultas a '+VM_TIPO[P1]+' somente no menu.',2,.T.)
	return NIL
end

while .T.
	pb_tela()
	pb_lin4('Consultas a '+VM_TIPO[P1],ProcName())
	VM_CODIG:=0
	salvacor(SALVA)
	scroll(06,01,11,78)
	if P1<3
		select(VM_TIPO[P1])
		@06,02 say padr(VM_TIPO[P1],16,'.')  get VM_CODIG picture masc(04) valid fn_codigo(@VM_CODIG,{VM_TIPO[P1],{||dbseek(str(VM_CODIG,5))},{||NIL},{2,1,8,41}})
		read
		if lastkey()#K_ESC
			if P1==1
				Select('DPFOR')
			else
				Select('DPCLI')
			end
			fn_consdpl(VM_CODIG)
		else
			exit
		end
	else
		keyboard chr(K_ENTER)
		@06,22 say padr(VM_TIPO[P1],16,'.') get VM_CODIG picture masc(21) valid fn_codpr(@VM_CODIG,78)
		read
		if lastkey()==K_ESC
			exit
		end
	end
	salvacor(RESTAURA)
end
restscreen(,,,,VM_TF)
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
	function FN_CONSDPL(pCodCli)
*-----------------------------------------------------------------------------*
local VM_VALOR1:=0
local VM_VALOR2:=0
local VM_DET   :=fn_rtdpls(pCodCli) // CFEP2211.PRG
if len(VM_DET)>0
	aeval(VM_DET,{|DET1|VM_VALOR1+=DET1[4]})
	aeval(VM_DET,{|DET1|VM_VALOR2+=if(DET1[2]<PARAMETRO->PA_DATA,DET1[4],0)})
	salvacor(SALVA)
	pb_box(7,49,11,79,'W+/BR')
	@08,50 say 'Vlr Devido :'+transform(VM_VALOR1,masc(2))
	@09,50 say 'Vlr Atraso :'+transform(VM_VALOR2,masc(2))
	@10,50 say 'Vlr Vencid :'+transform(VM_VALOR1-VM_VALOR2,masc(2))
	salvacor(RESTAURA)
	while fn_msdpl(VM_DET)>0
	end
end
return NIL
*--------------------------------------[EOF]---------------------------------------*
