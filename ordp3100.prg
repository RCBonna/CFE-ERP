*-----------------------------------------------------------------------------*
function ORDP3100() // LISTAGEM OS/OP														*
*-----------------------------------------------------------------------------*
#include 'RCB.CH'

pb_lin4(_MSG_,ProcName())

if !abre({	'E->CLIENTE',;
				'E->PROD',;
				'E->PARAMORD',;
				'E->MECMAQ',;
				'E->EQUIDES',;
				'E->ATIVIDAD',;
				'E->MOVORDEM',;
				'E->ORDEM'})
	return NIL
end
PROD->(dbsetorder(2))
MOVORDEM->(dbsetorder(3))

VM_CODOR :=0
VM_FLNOME:='N'
VM_VICMS :=0.00
VM_VIPI  :=0.00
VM_VDESC :=0.00
VM_VACRE :=0.00
pb_box(14,20,,,,'Selecao')
@15,22 say padr('Listar <N>=Nome A=Atividade',26,'.')          get VM_FLNOME pict masc(01) valid VM_FLNOME$'NA'
@16,22 say padr('C¢d.Ordem '+trim(PARAMORD->PA_DESCR3),26,'.') get VM_CODOR  pict masc(19) valid fn_ordem(@VM_CODOR,.F.)

@18,22 say padr('Vlr Desconto', 26,'.') get VM_VDESC pict mI102 valid VM_VICMS>=0 when (VM_VDESC:=ORDEM->OR_VDESC)>=0
@19,22 say padr('Vlr Acrescimo',26,'.') get VM_VACRE pict mI102 valid VM_VICMS>=0 when (VM_VACRE:=ORDEM->OR_VACRE)>=0
@20,22 say padr('Vlr ICMS',     26,'.') get VM_VICMS pict mI102 valid VM_VICMS>=0 when (VM_VICMS:=ORDEM->OR_VICMS)>=0
@21,22 say padr('Vlr IPI',      26,'.') get VM_VIPI  pict mI102 valid VM_VIPI >=0 when (VM_VIPI :=ORDEM->OR_VIPI)>=0
read
if lastkey()#K_ESC
	if pb_ligaimp(C15CPP)
		CLIENTE->(dbseek(str(ORDEM->OR_CODCL,5)))
		EQUIDES->(dbseek(ORDEM->OR_CODED))
		VM_REL:='Lista '+trim(PARAMORD->PA_DESCR3)+' N.'+pb_zer(VM_CODOR,6)
		VM_LAR:=78
		VM_PAG:= 0
		replace  OR_VDESC with VM_VDESC,;
					OR_VACRE with VM_VACRE,;
					OR_VICMS with VM_VICMS,;
					OR_VIPI  with VM_VIPI
		dbskip(0)
		ORDP310I(VM_CODOR)
		pb_deslimp()
	end
end
dbcloseall()
return NIL

*-----------------------------------------------------------------------------*
function ORDP310I(VM_CODOR)
*-----------------------------------------------------------------------------*
local TOT:={0,0}
VM_PAG   :=0
select MOVORDEM
ordem ORDEMG
dbseek(str(VM_CODOR,6),.T.)
while !eof().and.VM_CODOR==MOVORDEM->IT_CODOR
	VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP3101',VM_LAR)
	ATIVIDAD->(dbseek(str(MOVORDEM->IT_CODAT,2)))
	? dtoc(MOVORDEM->IT_DTLCT)+space(1)
	if MOVORDEM->IT_TIPO==1	// Produtos
		PROD->(dbseek(str(MOVORDEM->IT_CODPR,L_P)))
		??padr(pb_zer(MOVORDEM->IT_CODPR,L_P)+chr(45)+PROD->PR_DESCR,42)
	else
		MECMAQ->(dbseek(str(MOVORDEM->IT_CODPR,2)))
		if VM_FLNOME=='N'
			??padr(str(MOVORDEM->IT_CODPR,L_P)+chr(45)+MECMAQ->MM_NOME,42)
		else
			??padr(str(MOVORDEM->IT_CODPR,L_P)+chr(45)+ATIVIDAD->AT_DESCR,42)
		end
	end
	??transform(IT_QTD,masc(6))
	??transform(IT_VLRRE,masc(2))
	TOT[MOVORDEM->IT_TIPO]+=MOVORDEM->IT_VLRRE
	pb_brake()
end
VM_PAG:=pb_pagina(VM_SISTEMA,VM_EMPR,ProcName(),VM_REL,VM_PAG,'ORDP3101',VM_LAR)
?replicate('-',VM_LAR)
?padr('Total dos Produtos',   62,'.')+transform(TOT[1],masc(2))
?padr('Total dos Servicos',   62,'.')+transform(TOT[2],masc(2))
if ORDEM->OR_VDESC>0
	?padr('Total Desconto',    62,'.')+transform(ORDEM->OR_VDESC,masc(2))
end
if ORDEM->OR_VACRE>0
	?padr('Total Acrescimo',   62,'.')+transform(ORDEM->OR_VACRE,masc(2))
end
if ORDEM->OR_VICMS>0
	?padr('Valor I.C.M.S',    62,'.')+transform(ORDEM->OR_VICMS,masc(2))
end
if ORDEM->OR_VIPI>0
	?padr('Valor IPI',        62,'.')+transform(ORDEM->OR_VIPI,masc(2))
end
?padr('T o t a l   G e r a l',62,'.')+transform(TOT[1]+TOT[2]+ORDEM->OR_VACRE+ORDEM->OR_VIPI+ORDEM->OR_VICMS-ORDEM->OR_VDESC,masc(2))
?replicate('-',VM_LAR)
eject
select ORDEM

return NIL

*----------------------------------------------------------------------------*
function ORDP3101()
*-----------------------------------------------------------------------------*
local X
local OBS:=array(5)
? 'Nr.Solic.Clien:'+ORDEM->OR_NRCLI+space(2)
??'Dt Entrada '+dtoc(ORDEM->OR_DTENT)+space(4)
??'Dt Saida '   +dtoc(ORDEM->OR_DTSAI)
?padr('Cliente',15,'.')      +pb_zer(ORDEM->OR_CODCL,6)+chr(45)+CLIENTE->CL_RAZAO
?padr('Endereco',15,'.')     +trim(CLIENTE->CL_ENDER)
?padr('Bairro/Fone',15,'.')  +CLIENTE->CL_BAIRRO+space(2)+CLIENTE->CL_FONE+space(2)
??
?padr(trim(PARAMORD->PA_DESCR2),15,'.')+ORDEM->OR_CODED+chr(45)+EQUIDES->ED_DESCR
?space(16)+chr(15)+EQUIDES->ED_OBS+chr(18)
for X:=1 to 5
	OBS[X]:=substr(ORDEM->OR_OBS,X*60-59,60)
end
?padr('OBS',15,'.')+OBS[1]
for X:=2 to 5
	if !empty(OBS[X])
		?space(15)+OBS[X]
	end
end
?padc(if(ORDEM->OR_FLAG,'Fechada','Aberta'),VM_LAR,'-')
?
? padc('DATA',11)
??padr('Produtos/Servicos',39)
??padl('Qtdade',12)
??padl('Valor',15)
?replicate('-',VM_LAR)
return NIL
*--------------------------------------------------------------EOF---------------*
