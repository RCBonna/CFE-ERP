*-----------------------------------------------------------------------------*
 function CFEP6400() // Listagem NF de Entrada											*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

VM_CPO:={'S','','',0,0,0,0}
//        1  2  3  4 5 6 7

VM_REL:='N.F./Entrada'
pb_lin4(padc(VM_REL,36),ProcName())
if !abre({	'R->PARAMETRO',;
				'R->CLIENTE',;
				'R->PROD',;
				'R->ENTCAB',;
				'R->ENTDET'})
	return NIL
end
select('PROD');dbsetorder(2)
select('ENTCAB');dbsetorder(2)	// Entrada Cabec
set relation to str(EC_CODFO,5) into CLIENTE

VM_CPO[2]:=ctod('01/'+pb_zer(month(PARAMETRO->PA_DATA),2)+'/'+pb_zer(year(PARAMETRO->PA_DATA)-1900,2))
VM_CPO[3]:=PARAMETRO->PA_DATA

pb_box(17,35)
@18,37 say '[A]nalitico [S]intetico:'  get VM_CPO[1] pict masc(1) valid VM_CPO[1]$'AS'
@20,37 say padr('Data Inicial',24)+':' get VM_CPO[2] pict masc(7)
@21,57 say 'ate.:'                     get VM_CPO[3] pict masc(7) valid VM_CPO[3]>=VM_CPO[2]
read
if if(lastkey()#K_ESC,pb_ligaimp(C15CPP),.F.)
	VM_LAR:=80
	VM_PAG:=0
	VM_REL+='('+dtoc(VM_CPO[2])+'-'+dtoc(VM_CPO[3])+')'
	dbseek(dtos(VM_CPO[2]),.T.)
	while !eof().and.EC_DTENT<=VM_CPO[3]
		CFEP6401()
	end
	if VM_CPO[5]+VM_CPO[6]+VM_CPO[7]>0
		? replicate('-',VM_LAR)
		? space(9)+'Total'+replicate('.',16)
		??transform(VM_CPO[5],masc(2))
		??transform(VM_CPO[6],masc(2))
		??transform(VM_CPO[7],masc(2))
		?replicate('-',VM_LAR)
	end
	eject
	pb_deslimp()
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function CFEP6401()
VM_CPO[4]:=EC_DTENT
VM_PAG   :=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6400A',VM_LAR)
?
?INEGR+dtoc(VM_CPO[4])+CNEGR
while !eof().and.VM_CPO[4]==EC_DTENT
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6400A',VM_LAR)
	VM_CODFO:=EC_CODFO
	? pb_zer(EC_DOCTO,8)+space(1)
	??I15CPP+pb_zer(EC_CODFO,5)+'-'+left(CLIENTE->CL_RAZAO,30)+C15CPP
	??transform(ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS,masc(2))
	??transform(EC_ICMSV,masc(2))
	??transform(EC_IPI,  masc(2))
	??str(EC_FATUR,3)
	VM_CPO[5]+=ENTCAB->EC_TOTAL-ENTCAB->EC_DESC+ENTCAB->EC_ACESS
	VM_CPO[6]+=EC_ICMSV
	VM_CPO[7]+=EC_IPI
	if VM_CPO[1]='A'
		VM_PEDID:=EC_DOCTO
		select('ENTDET')
		dbseek(str(VM_PEDID,8),.T.)
		while !eof().and.VM_PEDID==ED_DOCTO
			if ED_CODFO==VM_CODFO
				VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'CFEP6400A',VM_LAR)
				PROD->(dbseek(str(ENTDET->ED_CODPR,L_P)))
				? I15CPP
				??space(34)+pb_zer(ED_ORDEM,3)
				??space(01)+padl(pb_zer(ED_CODPR,L_P)+'-'+PROD->PR_DESCR,38)
				??space(01)+transform(ED_QTDE,masc(6))
				??space(01)+transform(ED_VALOR,masc(2))
				??C15CPP
			end
			dbskip()
		end
		?
	end
	select('ENTCAB')
	pb_brake()
end
return NIL

*-----------------------------------------------------------------------------*
function CFEP6400A()
*-----------------------------------------------------------------------------*
? 'Document Fornecedor'+space(18)
??'Total NF'+space(5)+'Total ICMS'+space(6)
??'Total IPI'+space(1)+'Fat'
?replicate('-',VM_LAR)
return NIL
*---------------------------------------------------------EOF-----------------*
