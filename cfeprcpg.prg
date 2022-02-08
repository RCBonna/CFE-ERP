*-----------------------------------------------------------------------------*
function CFEPRCPG(VM_FL1,VM_FL2) // VALORES RECEBIDOS
*						VM_FL1========RESUMO[.F.]												*
*						VM_FL1========GERAL [.T.]												*
*								VM_FL2==CLIENTES='CL'											*
*								VM_FL2==FORNECEDORES='FO'										*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'
local CPO:={{'R->PARAMETRO','R->CLIENTE',	'R->DPFOR',	'R->HISFOR'},;
			   {'R->PARAMETRO','R->CLIENTE',	'R->DPCLI',	'R->HISCLI'}}

VM_REL:='Valores '+if(VM_FL2='FO','Pagos','Recebidos')+' no periodo '
pb_lin4(VM_REL,ProcName())

if !abre(if(VM_FL2='FO',CPO[1],CPO[2]))
	return NIL
end

private VM_DT:={PARAMETRO->PA_DATA-1,PARAMETRO->PA_DATA-1},;
		VM_CPO :='CLIENTE',;
		VM_FILT:=if(VM_FL2='CL','FILDPCLI()','FILDPFOR()'),;
		FORNEC :=0
pb_box(17,20)
@18,22 say padr('Cod.Emitente',21,'.') get FORNEC   pict masc(4) valid if(FORNEC>0,fn_codigo(@FORNEC,{VM_CPO,{||CLIENTE->(dbseek(str(FORNEC,5)))},NIL,{2,1}}),.T.)
@20,22 say 'Informe data Inical..'     get VM_DT[1] pict masc(7) valid VM_DT[1]<=PARAMETRO->PA_DATA
@21,35 say 'Final...'                  get VM_DT[2] pict masc(7) valid VM_DT[2]<=PARAMETRO->PA_DATA.and.VM_DT[1]<=VM_DT[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(I15CPP),.F.)
	VM_REL+= dtoc(VM_DT[1])+' a '+dtoc(VM_DT[2])
	VM_PAG:=   0
	VM_LAR:= 132
	VM_TOT:= array(2,3)
	set filter to 	fieldget(5)>=VM_DT[1].and.;
						fieldget(5)<=VM_DT[2].and.;
						(&VM_FILT).and.;
						if(FORNEC>0,fieldget(1)==FORNEC,.T.)
	DbGoTop()
	afill(VM_TOT[2],0)
	FLAG:=VM_FL1
	while !eof()
		VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRCPGA',VM_LAR)
		VM_CODIG:=fieldget(1)
		salvabd(SALVA)
		select CLIENTE
		dbseek(str(VM_CODIG,5))
		? pb_zer(VM_CODIG,5)+chr(45)
		??fieldget(2)
		salvabd(RESTAURA)
		afill(VM_TOT[1],0)
		while !eof().and.fieldget(1)==VM_CODIG
			if VM_FL1 // resumo
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRCPGA',VM_LAR)
				? space(39)
				??transform(fieldget(2),masc(16))+space(02)
				??transform(fieldget(7),masc(02))
				??transform(fieldget(8),masc(02))
				??transform(fieldget(9),masc(02))+space(2)
				??transform(fieldget(3),mDT)+space(2)
				??transform(fieldget(4),mDT)+space(2)
				??transform(fieldget(5),mDT)
			end
			VM_TOT[1,1]+=fieldget(7)
			VM_TOT[1,2]+=fieldget(8)
			VM_TOT[1,3]+=fieldget(9)
			pb_brake()
		end
		VM_PAG=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEPRCPGA',VM_LAR)
		if VM_FL1
			?space(6)+padr('Total do Cliente',45,'.')
		end
		??transform(VM_TOT[1,1],masc(2))
		??transform(VM_TOT[1,2],masc(2))
		??transform(VM_TOT[1,3],masc(2))
		if VM_FL1
			?
		end
		VM_TOT[2,1]+=VM_TOT[1,1]
		VM_TOT[2,2]+=VM_TOT[1,2]
		VM_TOT[2,3]+=VM_TOT[1,3]
	end
	if FORNEC=0
		?replicate('-',VM_LAR)
		? space(6)+padr('TOTAL GERAL',45,'.')
		??transform(VM_TOT[2,1],masc(2))
		??transform(VM_TOT[2,2],masc(2))
		??transform(VM_TOT[2,3],masc(2))
	end
	?replicate('-',VM_LAR)
	?'Impresso as '+time()
	eject
	pb_deslimp(C15CPP)
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEPRCPGA(P1)
? padr('Codigo '+VM_CPO,51)
??padl('Vlr '+if(VM_CPO='CLIENTE','Recebidos','Pagos'),15)
??padl('Juros',15)
??padl('Descontos',15)
if FLAG
	??space(1)+padc('Data Emis',12)+padc('Data Venc',12)+padc('Data Pgto',12)
end
?replicate('-',VM_LAR)
return NIL
*-----------------------------------------------------------------------------*